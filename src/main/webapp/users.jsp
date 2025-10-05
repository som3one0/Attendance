<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.attendance.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Attendance System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            font-size: 28px;
            font-weight: 600;
        }

        .btn-back {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 10px 20px;
            border: 2px solid white;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-back:hover {
            background: white;
            color: #667eea;
        }

        .content {
            padding: 30px;
        }

        .add-user-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
            border: 2px solid #e9ecef;
        }

        .add-user-section h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 22px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-group input,
        .form-group select {
            padding: 12px;
            border: 2px solid #dee2e6;
            border-radius: 5px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s ease;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .users-table-section {
            background: white;
        }

        .users-table-section h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 22px;
        }

        .table-wrapper {
            overflow-x: auto;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        thead th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        tbody tr {
            border-bottom: 1px solid #e9ecef;
            transition: background 0.2s ease;
        }

        tbody tr:hover {
            background: #f8f9fa;
        }

        tbody td {
            padding: 15px;
            color: #555;
            font-size: 14px;
        }

        .role-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .role-admin {
            background: #dc3545;
            color: white;
        }

        .role-teacher {
            background: #007bff;
            color: white;
        }

        .role-student {
            background: #28a745;
            color: white;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-action {
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-edit {
            background: #ffc107;
            color: #333;
        }

        .btn-edit:hover {
            background: #ffb300;
            transform: translateY(-2px);
        }

        .btn-delete {
            background: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background: #c82333;
            transform: translateY(-2px);
        }

        .no-users {
            text-align: center;
            padding: 40px;
            color: #999;
            font-size: 16px;
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .table-wrapper {
                overflow-x: scroll;
            }

            table {
                min-width: 800px;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>👥 User Management</h1>
            <a href="admin-dashboard.jsp" class="btn-back">← Back to Dashboard</a>
        </div>

        <div class="content">
            <!-- Message banners -->
            <c:if test="${not empty error}">
                <div class="message error-message"><c:out value="${error}"/></div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="message success-message"><c:out value="${success}"/></div>
            </c:if>
            <!-- Add User Form Section -->
            <div class="add-user-section">
                <h2>➕ Add New User</h2>
                <form action="UserServlet" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="name">Full Name *</label>
                            <input type="text" id="name" name="name" required placeholder="Enter full name">
                        </div>
                        <div class="form-group">
                            <label for="username">Username *</label>
                            <input type="text" id="username" name="username" required placeholder="Enter username">
                        </div>
                        <div class="form-group">
                            <label for="password">Password *</label>
                            <input type="password" id="password" name="password" required placeholder="Enter password">
                        </div>
                        <div class="form-group">
                            <label for="role">Role *</label>
                            <select id="role" name="role" required>
                                <option value="">Select Role</option>
                                <option value="student">Student</option>
                                <option value="teacher">Teacher</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="department">Department *</label>
                            <input type="text" id="department" name="department" required placeholder="Enter department">
                        </div>
                    </div>
                    <button type="submit" class="btn-submit">Add User</button>
                </form>
            </div>

            <!-- Users Table Section -->
            <div class="users-table-section">
                <h2>📋 All Users</h2>
                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Name</th>
                                <th>Username</th>
                                <th>Role</th>
                                <th>Department</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // Retrieve users list from request attribute
                                List<User> users = (List<User>) request.getAttribute("users");
                                
                                if (users != null && !users.isEmpty()) {
                                    for (User user : users) {
                                        String roleClass = "role-" + user.getRole().toLowerCase();
                            %>
                            <tr>
                                <td><%= user.getUserId() %></td>
                                <td><%= user.getName() %></td>
                                <td><%= user.getUsername() %></td>
                                <td><span class="role-badge <%= roleClass %>"><%= user.getRole() %></span></td>
                                <td><%= user.getDepartment() %></td>
                                <td>
                                    <div class="action-buttons">
                                        <form action="UserServlet" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="edit">
                                            <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                            <button type="submit" class="btn-action btn-edit">Edit</button>
                                        </form>
                                        <form action="UserServlet" method="post" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this user?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                            <button type="submit" class="btn-action btn-delete">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="6" class="no-users">No users found. Add users using the form above.</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
