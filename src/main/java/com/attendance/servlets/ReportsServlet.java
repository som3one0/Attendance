package com.attendance.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.attendance.model.AttendanceRecord;
import com.attendance.model.DBUtil;

@WebServlet("/reports")
public class ReportsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/index.html");
            return;
        }

        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String department = request.getParameter("department");
        String user = request.getParameter("user");
        String export = request.getParameter("export");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<AttendanceRecord> records = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();

            StringBuilder sql = new StringBuilder();
            sql.append("SELECT a.user_id, u.username, COALESCE(u.department, '') AS department, a.date, a.status ");
            sql.append("FROM attendance a JOIN users u ON a.user_id = u.id WHERE 1=1");

            List<Object> params = new ArrayList<>();
            if (fromDate != null && !fromDate.isEmpty()) {
                sql.append(" AND a.date >= ?");
                params.add(fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                sql.append(" AND a.date <= ?");
                params.add(toDate);
            }
            if (department != null && !department.isEmpty()) {
                sql.append(" AND u.department = ?");
                params.add(department);
            }
            if (user != null && !user.isEmpty()) {
                sql.append(" AND u.username = ?");
                params.add(user);
            }

            sql.append(" ORDER BY a.date DESC, u.username ASC");

            pstmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            rs = pstmt.executeQuery();
            while (rs.next()) {
                AttendanceRecord r = new AttendanceRecord();
                r.setUserId(rs.getInt("user_id"));
                r.setUsername(rs.getString("username"));
                r.setDepartment(rs.getString("department"));
                r.setDate(rs.getString("date"));
                r.setStatus(rs.getString("status"));
                records.add(r);
            }

            if ("csv".equalsIgnoreCase(export)) {
                // Export CSV
                response.setContentType("text/csv");
                String filename = "attendance-report.csv";
                response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
                try (PrintWriter out = response.getWriter()) {
                    out.println("Username,Department,Date,Status");
                    for (AttendanceRecord rec : records) {
                        out.println(escapeCsv(rec.getUsername()) + "," + escapeCsv(rec.getDepartment()) + "," + escapeCsv(rec.getDate()) + "," + escapeCsv(rec.getStatus()));
                    }
                }
                return;
            }

            // Forward to JSP with attribute
            request.setAttribute("attendanceRecords", records);
            request.getRequestDispatcher("/reports.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to load reports: " + e.getMessage());
            request.getRequestDispatcher("/reports.jsp").forward(request, response);
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

    private String escapeCsv(String s) {
        if (s == null) return "";
        String out = s.replace("\"", "\"\"");
        if (out.contains(",") || out.contains("\n") || out.contains("\"")) {
            return "\"" + out + "\"";
        }
        return out;
    }
}
