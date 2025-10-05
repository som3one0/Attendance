package com.attendance.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.attendance.model.DBUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form parameters from index.html
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("index.jsp?error=empty_fields");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            // Query to validate user credentials
            String sql = "SELECT user_id, username, role FROM users WHERE username = ? AND password = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // Login successful
                int userId = rs.getInt("user_id");
                String userRole = rs.getString("role");
                
                // Create session and store user information
                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);
                session.setAttribute("username", username);
                session.setAttribute("role", userRole);
                
                // Redirect based on role
                if ("admin".equalsIgnoreCase(userRole)) {
                    response.sendRedirect("dashboard?view=admin");
                } else {
                    response.sendRedirect("dashboard?view=user");
                }
            } else {
                // Login failed
                response.sendRedirect("index.jsp?error=invalid_credentials");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=database_error");
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to POST
        response.sendRedirect("index.html");
    }
}