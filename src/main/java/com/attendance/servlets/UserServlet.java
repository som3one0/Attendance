package com.attendance.servlets;

import com.attendance.model.User;
import com.attendance.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/user")
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User loggedInUser = (User) session.getAttribute("user");
        if (!"admin".equals(loggedInUser.getRole())) {
            response.sendRedirect("attendance.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("edit".equals(action)) {
            showEditForm(request, response);
        } else {
            listUsers(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if admin is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User loggedInUser = (User) session.getAttribute("user");
        if (!"admin".equals(loggedInUser.getRole())) {
            response.sendRedirect("attendance.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "add":
                    addUser(request, response);
                    break;
                case "update":
                    updateUser(request, response);
                    break;
                case "delete":
                    deleteUser(request, response);
                    break;
                default:
                    listUsers(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error occurred", e);
        }
    }

    // List all users
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<User> users = new ArrayList<>();
        String errorMessage = null;
        
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM users ORDER BY id";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    users.add(user);
                }
            }
        } catch (SQLException e) {
            errorMessage = "Error loading users: " + e.getMessage();
            e.printStackTrace();
        }
        
        request.setAttribute("users", users);
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
        }
        request.getRequestDispatcher("users.jsp").forward(request, response);
    }

    // Show edit form for a user
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int userId = Integer.parseInt(request.getParameter("id"));
        User user = null;
        String errorMessage = null;
        
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM users WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        user = new User();
                        user.setId(rs.getInt("id"));
                        user.setUsername(rs.getString("username"));
                        user.setPassword(rs.getString("password"));
                        user.setRole(rs.getString("role"));
                        user.setName(rs.getString("name"));
                        user.setEmail(rs.getString("email"));
                    }
                }
            }
        } catch (SQLException e) {
            errorMessage = "Error loading user: " + e.getMessage();
            e.printStackTrace();
        }
        
        if (user == null) {
            request.setAttribute("errorMessage", "User not found");
            listUsers(request, response);
            return;
        }
        
        request.setAttribute("user", user);
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
        }
        request.getRequestDispatcher("users.jsp").forward(request, response);
    }

    // Add a new user
    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        
        // Validate inputs
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            role == null || role.trim().isEmpty() ||
            name == null || name.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All required fields must be filled");
            listUsers(request, response);
            return;
        }
        
        try (Connection conn = DBUtil.getConnection()) {
            // Check if username already exists
            String checkSql = "SELECT COUNT(*) FROM users WHERE username = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, username);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        request.setAttribute("errorMessage", "Username already exists");
                        listUsers(request, response);
                        return;
                    }
                }
            }
            
            // Insert new user
            String sql = "INSERT INTO users (username, password, role, name, email) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, password);
                stmt.setString(3, role);
                stmt.setString(4, name);
                stmt.setString(5, email);
                
                int rowsInserted = stmt.executeUpdate();
                
                if (rowsInserted > 0) {
                    request.setAttribute("successMessage", "User added successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to add user");
                }
            }
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            e.printStackTrace();
        }
        
        listUsers(request, response);
    }

    // Update an existing user
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        
        // Validate inputs
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            role == null || role.trim().isEmpty() ||
            name == null || name.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All required fields must be filled");
            listUsers(request, response);
            return;
        }
        
        try (Connection conn = DBUtil.getConnection()) {
            // Check if username already exists for a different user
            String checkSql = "SELECT COUNT(*) FROM users WHERE username = ? AND id != ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, username);
                checkStmt.setInt(2, id);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        request.setAttribute("errorMessage", "Username already exists");
                        listUsers(request, response);
                        return;
                    }
                }
            }
            
            // Update user
            String sql = "UPDATE users SET username = ?, password = ?, role = ?, name = ?, email = ? WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, password);
                stmt.setString(3, role);
                stmt.setString(4, name);
                stmt.setString(5, email);
                stmt.setInt(6, id);
                
                int rowsUpdated = stmt.executeUpdate();
                
                if (rowsUpdated > 0) {
                    request.setAttribute("successMessage", "User updated successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to update user");
                }
            }
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            e.printStackTrace();
        }
        
        listUsers(request, response);
    }

    // Delete a user
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        try (Connection conn = DBUtil.getConnection()) {
            // Check if user exists
            String checkSql = "SELECT COUNT(*) FROM users WHERE id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, id);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) == 0) {
                        request.setAttribute("errorMessage", "User not found");
                        listUsers(request, response);
                        return;
                    }
                }
            }
            
            // Delete user
            String sql = "DELETE FROM users WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, id);
                
                int rowsDeleted = stmt.executeUpdate();
                
                if (rowsDeleted > 0) {
                    request.setAttribute("successMessage", "User deleted successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete user");
                }
            }
        } catch (SQLException e) {
            // Check if it's a foreign key constraint violation
            if (e.getMessage().contains("foreign key constraint")) {
                request.setAttribute("errorMessage", "Cannot delete user: User has associated records");
            } else {
                request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            }
            e.printStackTrace();
        }
        
        listUsers(request, response);
    }
}