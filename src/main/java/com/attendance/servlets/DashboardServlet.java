package com.attendance.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.attendance.model.DBUtil;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/index.html");
            return;
        }

        String role = (String) session.getAttribute("role");
        int userId = (int) session.getAttribute("userId");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();

            // Total users
            pstmt = conn.prepareStatement("SELECT COUNT(*) AS total FROM users");
            rs = pstmt.executeQuery();
            int totalUsers = 0;
            if (rs.next()) totalUsers = rs.getInt("total");
            rs.close();
            pstmt.close();

            // Today's attendance count
            pstmt = conn.prepareStatement("SELECT COUNT(*) AS present_count FROM attendance WHERE date = CURDATE() AND status = 'Present'");
            rs = pstmt.executeQuery();
            int presentToday = 0;
            if (rs.next()) presentToday = rs.getInt("present_count");
            rs.close();
            pstmt.close();

            // Absentees = totalUsers - presentToday (simple calculation)
            int absentees = Math.max(0, totalUsers - presentToday);

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("presentToday", presentToday);
            request.setAttribute("absentees", absentees);

            // Last 7 days attendance counts for Chart.js
            pstmt = conn.prepareStatement("SELECT date, SUM(status = 'Present') AS present_count FROM attendance WHERE date >= CURDATE() - INTERVAL 6 DAY GROUP BY date ORDER BY date ASC");
            rs = pstmt.executeQuery();
            List<String> last7Dates = new ArrayList<>();
            List<Integer> last7Counts = new ArrayList<>();
            while (rs.next()) {
                last7Dates.add(rs.getString("date"));
                last7Counts.add(rs.getInt("present_count"));
            }
            rs.close();
            pstmt.close();

            // Build JSON strings for easy use in JSP JS
            StringBuilder datesJson = new StringBuilder();
            StringBuilder countsJson = new StringBuilder();
            datesJson.append("[");
            countsJson.append("[");
            for (int i = 0; i < last7Dates.size(); i++) {
                if (i > 0) { datesJson.append(","); countsJson.append(","); }
                datesJson.append('"').append(last7Dates.get(i)).append('"');
                countsJson.append(last7Counts.get(i));
            }
            datesJson.append("]");
            countsJson.append("]");

            request.setAttribute("last7DatesJson", datesJson.toString());
            request.setAttribute("last7CountsJson", countsJson.toString());

            if ("admin".equalsIgnoreCase(role)) {
                request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
            } else {
                // user-specific stats: attendance percentage and recent records

                // Calculate total days recorded for the user and present days
                pstmt = conn.prepareStatement("SELECT COUNT(*) AS total_days, SUM(status = 'Present') AS present_days FROM attendance WHERE user_id = ?");
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                int totalDays = 0;
                int presentDays = 0;
                if (rs.next()) {
                    totalDays = rs.getInt("total_days");
                    presentDays = rs.getInt("present_days");
                }
                rs.close();
                pstmt.close();

                double attendancePercent = totalDays == 0 ? 0.0 : (presentDays * 100.0) / totalDays;
                request.setAttribute("attendancePercent", attendancePercent);

                // Recent attendance list (last 10 records)
                // Recent attendance list (last 10 records) as List<AttendanceRecord>
                pstmt = conn.prepareStatement("SELECT date, status FROM attendance WHERE user_id = ? ORDER BY date DESC LIMIT 10");
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                List<com.attendance.model.AttendanceRecord> recentList = new ArrayList<>();
                while (rs.next()) {
                    com.attendance.model.AttendanceRecord rec = new com.attendance.model.AttendanceRecord();
                    rec.setDate(rs.getString("date"));
                    rec.setStatus(rs.getString("status"));
                    recentList.add(rec);
                }
                rs.close();
                pstmt.close();
                request.setAttribute("recentAttendance", recentList);

                // User events for FullCalendar for current month
                pstmt = conn.prepareStatement("SELECT date, status FROM attendance WHERE user_id = ? AND date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') AND date <= LAST_DAY(CURDATE())");
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                List<Map<String, Object>> events = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> ev = new HashMap<>();
                    String d = rs.getString("date");
                    String status = rs.getString("status");
                    ev.put("title", status);
                    ev.put("start", d);
                    // color mapping
                    String color = "#10b981"; // green for present
                    if ("Absent".equalsIgnoreCase(status)) color = "#ef4444"; // red
                    else if ("Leave".equalsIgnoreCase(status)) color = "#f59e0b"; // amber
                    ev.put("color", color);
                    events.add(ev);
                }
                rs.close();
                pstmt.close();

                // Build JSON for events
                StringBuilder eventsJson = new StringBuilder();
                eventsJson.append("[");
                for (int i = 0; i < events.size(); i++) {
                    if (i > 0) eventsJson.append(",");
                    Map<String, Object> ev = events.get(i);
                    eventsJson.append("{");
                    eventsJson.append("\"title\":\"").append(ev.get("title")).append("\"");
                    eventsJson.append(",\"start\":\"").append(ev.get("start")).append("\"");
                    eventsJson.append(",\"color\":\"").append(ev.get("color")).append("\"");
                    eventsJson.append("}");
                }
                eventsJson.append("]");
                request.setAttribute("userEventsJson", eventsJson.toString());

                // Forward to user dashboard
                request.getRequestDispatcher("/user-dashboard.jsp").forward(request, response);
                // Note: rs will be closed when connection is closed later
                return;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to load dashboard: " + e.getMessage());
            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
            return;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
