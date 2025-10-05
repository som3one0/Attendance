<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Department Management - Attendance System</title>
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
            max-width: 1000px;
            margin: 0 auto;
        }

        .header {
            background: white;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            color: #333;
            font-size: 28px;
        }

        .back-btn {
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
        }

        .back-btn:hover {
            background: #5568d3;
        }

        .content-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 20px;
        }

        /* Add Department Form */
        .add-form {
            margin-bottom: 30px;
        }

        .add-form h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 22px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }

        .btn-submit {
            background: #667eea;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-submit:hover {
            background: #5568d3;
        }

        /* Department List */
        .department-list h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 22px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #f8f9fa;
        }

        th {
            padding: 15px;
            text-align: left;
            color: #555;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
            color: #333;
        }

        tbody tr:hover {
            background: #f8f9fa;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .btn-edit, .btn-delete {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }

        .btn-edit {
            background: #ffc107;
            color: #333;
        }

        .btn-edit:hover {
            background: #e0a800;
        }

        .btn-delete {
            background: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background: #c82333;
        }

        .no-departments {
            text-align: center;
            padding: 30px;
            color: #999;
            font-size: 16px;
        }

        /* Messages */
        .message {
            padding: 12px 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .header h1 {
                font-size: 24px;
            }

            table {
                font-size: 14px;
            }

            th, td {
                padding: 10px;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn-edit, .btn-delete {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>Department Management</h1>
            <a href="admin-dashboard.jsp" class="back-btn">← Back to Dashboard</a>
        </div>

        <!-- Messages (scriptlet-compatible and JSTL) -->
        <c:if test="${not empty success}">
            <div class="message success-message"><c:out value="${success}"/></div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message error-message"><c:out value="${error}"/></div>
        </c:if>
        <% String successMessage = (String) request.getAttribute("successMessage");
        if (successMessage != null) { %>
            <div class="message success-message">
                <%= successMessage %>
            </div>
        <% } %>

        <% String errorMessage = (String) request.getAttribute("errorMessage");
           if (errorMessage != null) { %>
            <div class="message error-message">
                <%= errorMessage %>
            </div>
        <% } %>

        <!-- Add Department Form -->
        <div class="content-card add-form">
            <h2>Add New Department</h2>
            <form action="departments" method="post">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="dept_name">Department Name:</label>
                    <input type="text" id="dept_name" name="dept_name" required placeholder="Enter department name">
                </div>

                <button type="submit" class="btn-submit">Add Department</button>
            </form>
        </div>

        <!-- Department List -->
        <div class="content-card department-list">
            <h2>All Departments</h2>
            <table>
                <thead>
                    <tr>
                        <th>Department ID</th>
                        <th>Department Name</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    List departments = (List) request.getAttribute("departments");
                    if (departments != null && !departments.isEmpty()) {
                        for (Object obj : departments) {
                            // Placeholder for Department object - will work with servlet/database integration
                            // For now, this is ready for data binding
                    %>
                    <!-- Department rows will be populated here when connected to servlet -->
                    <% 
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="3" class="no-departments">No departments found. Add departments using the form above.</td>
                    </tr>
                    <% } %>
                    
                    <!-- Sample rows for demonstration (remove when connected to database) -->
                    <tr>
                        <td>1</td>
                        <td>Computer Science</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-edit" onclick="editDepartment(1)">Edit</button>
                                <button class="btn-delete" onclick="confirmDelete(1)">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>Mechanical Engineering</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-edit" onclick="editDepartment(2)">Edit</button>
                                <button class="btn-delete" onclick="confirmDelete(2)">Delete</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td>Electrical Engineering</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-edit" onclick="editDepartment(3)">Edit</button>
                                <button class="btn-delete" onclick="confirmDelete(3)">Delete</button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function editDepartment(deptId) {
            // Placeholder function for edit functionality
            // Will be implemented with servlet integration
            alert('Edit functionality will be implemented with DepartmentServlet');
            // Future implementation:
            // window.location.href = 'departments?action=edit&id=' + deptId;
        }

        function confirmDelete(deptId) {
            // Placeholder function for delete functionality
            if (confirm('Are you sure you want to delete this department?')) {
                alert('Delete functionality will be implemented with DepartmentServlet');
                // Future implementation:
                // window.location.href = 'departments?action=delete&id=' + deptId;
            }
        }
    </script>
</body>
</html>