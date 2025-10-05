<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Attendance System</title>
    <link rel="stylesheet" href="css/style.css">
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
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 250px;
            background: #2c3e50;
            color: white;
            padding: 20px 0;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar-header {
            padding: 0 20px 30px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-header h2 {
            font-size: 24px;
            color: #3498db;
        }

        .sidebar-menu {
            list-style: none;
            padding: 20px 0;
        }

        .sidebar-menu li {
            margin: 5px 0;
        }

        .sidebar-menu a {
            display: block;
            padding: 15px 20px;
            color: #ecf0f1;
            text-decoration: none;
            transition: all 0.3s;
        }

        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background: #34495e;
            border-left: 4px solid #3498db;
            padding-left: 16px;
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
            padding: 30px;
        }

        .welcome-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .welcome-section h1 {
            color: #2c3e50;
            font-size: 32px;
            margin-bottom: 10px;
        }

        .welcome-section p {
            color: #7f8c8d;
            font-size: 16px;
        }

        /* Stats Cards */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card.blue {
            border-left: 5px solid #3498db;
        }

        .stat-card.green {
            border-left: 5px solid #2ecc71;
        }

        .stat-card.red {
            border-left: 5px solid #e74c3c;
        }

        .stat-card h3 {
            color: #7f8c8d;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 10px;
            text-transform: uppercase;
        }

        .stat-card .stat-value {
            font-size: 36px;
            font-weight: bold;
            color: #2c3e50;
        }

        /* Action Buttons */
        .actions-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .actions-section h2 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 24px;
        }

        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .action-btn {
            padding: 15px 25px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .action-btn.primary {
            background: #3498db;
            color: white;
        }

        .action-btn.primary:hover {
            background: #2980b9;
            transform: scale(1.05);
        }

        .action-btn.success {
            background: #2ecc71;
            color: white;
        }

        .action-btn.success:hover {
            background: #27ae60;
            transform: scale(1.05);
        }

        .action-btn.info {
            background: #9b59b6;
            color: white;
        }

        .action-btn.info:hover {
            background: #8e44ad;
            transform: scale(1.05);
        }

        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
            }

            .stats-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>Attendance System</h2>
            </div>
            <ul class="sidebar-menu">
                <li><a href="#" class="active">Dashboard</a></li>
                <li><a href="#">Users</a></li>
                <li><a href="#">Attendance</a></li>
                <li><a href="#">Reports</a></li>
                <li><a href="logout">Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Welcome Section -->
            <div class="welcome-section">
                <h1>Welcome, Admin!</h1>
                <p>Here's an overview of today's attendance</p>
            </div>

            <!-- Stats Cards -->
            <div class="stats-container">
                <div class="stat-card blue">
                    <h3>Total Users</h3>
                    <div class="stat-value">150</div>
                </div>
                <div class="stat-card green">
                    <h3>Attendance Today</h3>
                    <div class="stat-value">125</div>
                </div>
                <div class="stat-card red">
                    <h3>Absentees</h3>
                    <div class="stat-value">25</div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="actions-section">
                <h2>Quick Actions</h2>
                <div class="action-buttons">
                    <a href="#" class="action-btn primary">Manage Users</a>
                    <a href="#" class="action-btn success">Mark Attendance</a>
                    <a href="#" class="action-btn info">View Reports</a>
                </div>
            </div>
        </main>
    </div>
</body>
</html>