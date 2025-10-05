package com.attendance.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.attendance.util.DBUtil;

@WebServlet("/AttendanceServlet")
public class AttendanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String dateStr = request.getParameter("date");
        String[] userIds = request.getParameterValues("userId");
        
        if (dateStr == null || dateStr.isEmpty()) {
            dateStr = LocalDate.now().toString();
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            
            if (userIds == null || userIds.length == 0) {
                request.setAttribute("message", "No users selected for attendance.");
                request.setAttribute("messageType", "error");
                request.getRequestDispatcher("attendance.jsp").forward(request, response);
                return;
            }
            
            // Delete existing attendance records for this date before inserting new ones
            String deleteSql = "DELETE FROM attendance WHERE date = ?";
            pstmt = conn.prepareStatement(deleteSql);
            pstmt.setString(1, dateStr);
            pstmt.executeUpdate();
            pstmt.close();
            
            // Insert new attendance records
            String insertSql = "INSERT INTO attendance (user_id, date, status) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(insertSql);
            
            int successCount = 0;
            for (String userId : userIds) {
                String status = request.getParameter("status_" + userId);
                
                if (status == null || status.isEmpty()) {
                    status = "Present"; // Default status
                }
                
                pstmt.setInt(1, Integer.parseInt(userId));
                pstmt.setString(2, dateStr);
                pstmt.setString(3, status);
                pstmt.addBatch();
                successCount++;
            }
            
            pstmt.executeBatch();
            
            request.setAttribute("message", "Attendance recorded successfully for " + successCount + " user(s).");
            request.setAttribute("messageType", "success");
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Error recording attendance: " + e.getMessage());
            request.setAttribute("messageType", "error");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("message", "Invalid user ID format: " + e.getMessage());
            request.setAttribute("messageType", "error");
        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        request.getRequestDispatcher("attendance.jsp").forward(request, response);
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("attendance.jsp").forward(request, response);
    }
}