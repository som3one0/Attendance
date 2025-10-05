<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String userRole = (String) session.getAttribute("userRole");
    if (!"admin".equals(userRole)) {
        response.sendRedirect("user-dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Attendance System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="futuristic-bg">
    <!-- Sidebar -->
    <div class="sidebar-neon">
        <div class="sidebar-logo">
            <h2 class="digital-font">ADMIN PANEL</h2>
        </div>
        <nav class="sidebar-nav">
            <a href="admin-dashboard.jsp" class="sidebar-link active">
                <span class="icon">🏠</span>
                <span>Dashboard</span>
            </a>
            <a href="users.jsp" class="sidebar-link">
                <span class="icon">👥</span>
                <span>Users</span>
            </a>
            <a href="departments.jsp" class="sidebar-link">
                <span class="icon">🏢</span>
                <span>Departments</span>
            </a>
            <a href="reports.jsp" class="sidebar-link">
                <span class="icon">📊</span>
                <span>Reports</span>
            </a>
            <a href="logout" class="sidebar-link">
                <span class="icon">🚪</span>
                <span>Logout</span>
            </a>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="main-wrapper">
        <!-- Top Bar -->
        <header class="topbar-neon">
            <h1 class="digital-font topbar-title">COMMAND CENTER</h1>
            <div class="topbar-actions">
                <button class="notification-btn">
                    <span class="icon">🔔</span>
                    <span class="badge">3</span>
                </button>
                <div class="user-dropdown">
                    <button class="user-btn">
                        <span class="icon">👤</span>
                        <span><%= session.getAttribute("userName") %></span>
                        <span class="dropdown-arrow">▼</span>
                    </button>
                </div>
            </div>
        </header>

        <!-- Summary Cards -->
        <div class="dashboard-grid">
            <div class="neon-card present-card">
                <div class="card-header">
                    <span class="card-icon">✓</span>
                    <span class="card-label digital-font">PRESENT</span>
                </div>
                <div class="card-value" id="presentCount">0</div>
                <div class="card-footer">Today's Attendance</div>
            </div>

            <div class="neon-card absent-card">
                <div class="card-header">
                    <span class="card-icon">✗</span>
                    <span class="card-label digital-font">ABSENT</span>
                </div>
                <div class="card-value" id="absentCount">0</div>
                <div class="card-footer">Marked Absent</div>
            </div>

            <div class="neon-card leave-card">
                <div class="card-header">
                    <span class="card-icon">☰</span>
                    <span class="card-label digital-font">ON LEAVE</span>
                </div>
                <div class="card-value" id="leaveCount">0</div>
                <div class="card-footer">Approved Leaves</div>
            </div>
        </div>

        <!-- Chart Container -->
        <div class="chart-container-neon">
            <div class="chart-header">
                <h3 class="digital-font">ATTENDANCE ANALYTICS</h3>
                <div class="chart-controls">
                    <button class="chart-btn">7D</button>
                    <button class="chart-btn active">30D</button>
                    <button class="chart-btn">90D</button>
                </div>
            </div>
            <div class="chart-wrapper">
                <canvas id="attendanceChart"></canvas>
                <div id="chartNoData" style="display:none;" class="no-data-message">
                    NO DATA AVAILABLE
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Fetch summary data
        (async function() {
            try {
                const res = await fetch('api/attendance/summary?date=' + new Date().toISOString().split('T')[0]);
                const data = await res.json();
                if (data.status === 'success') {
                    document.getElementById('presentCount').textContent = data.present || 0;
                    document.getElementById('absentCount').textContent = data.absent || 0;
                    document.getElementById('leaveCount').textContent = data.leave || 0;
                }
            } catch (e) {
                console.error('Failed to fetch summary', e);
            }
        })();

        // Chart data
        (async function() {
            try {
                const res = await fetch('api/attendance/chart?days=30');
                const data = await res.json();
                const ctx = document.getElementById('attendanceChart').getContext('2d');
                
                if (!data.dates || data.dates.length === 0) {
                    document.getElementById('chartNoData').style.display = 'flex';
                    return;
                }
                
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.dates,
                        datasets: [{
                            label: 'Present',
                            data: data.counts,
                            backgroundColor: 'rgba(0, 255, 255, 0.6)',
                            borderColor: 'rgba(0, 255, 255, 1)',
                            borderWidth: 2
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                labels: {
                                    color: '#00ffff',
                                    font: { family: 'monospace' }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: { color: '#00ffff' },
                                grid: { color: 'rgba(0, 255, 255, 0.1)' }
                            },
                            x: {
                                ticks: { color: '#00ffff' },
                                grid: { color: 'rgba(0, 255, 255, 0.1)' }
                            }
                        }
                    }
                });
            } catch (e) {
                console.error('Failed to fetch chart data', e);
                document.getElementById('chartNoData').style.display = 'flex';
            }
        })();
    </script>
</body>
</html>       min-height: 100vh;
        }
        
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        
        /* Sidebar Styles */
        .sidebar {
            width: 250px;
            background: #2d3748;
            color: white;
            padding: 20px 0;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            transition: transform 0.3s ease;
        }
        
        .sidebar-header {
            padding: 0 20px 20px;
            border-bottom: 1px solid #4a5568;
        }
        
        .sidebar-header h2 {
            font-size: 1.5rem;
            color: #667eea;
        }
        
        .sidebar-menu {
            list-style: none;
            margin-top: 20px;
        }
        
        .sidebar-menu li {
            margin: 5px 0;
        }
        
        .sidebar-menu a {
            display: block;
            padding: 12px 20px;
            color: #e2e8f0;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background: #667eea;
            border-left: 4px solid #764ba2;
        }
        
        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 250px;
            padding: 30px;
        }
        
        .top-bar {
            background: white;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .welcome-message {
            font-size: 1.5rem;
            color: #2d3748;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            background: #667eea;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
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
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }
        
        .stat-card.blue {
            border-top: 4px solid #667eea;
        }
        
        .stat-card.green {
            border-top: 4px solid #48bb78;
        }
        
        .stat-card.red {
            border-top: 4px solid #f56565;
        }
        
        .stat-title {
            color: #718096;
            font-size: 0.9rem;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .stat-value {
            font-size: 2.5rem;
            font-weight: bold;
            color: #2d3748;
        }
        
        .stat-icon {
            font-size: 2rem;
            margin-top: 10px;
        }
        
        /* Actions Section */
        .actions-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .section-title {
            font-size: 1.3rem;
            color: #2d3748;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-primary:hover {
            background: #5a67d8;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        .btn-success {
            background: #48bb78;
            color: white;
        }
        
        .btn-success:hover {
            background: #38a169;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(72, 187, 120, 0.4);
        }
        
        .btn-warning {
            background: #ed8936;
            color: white;
        }
        
        .btn-warning:hover {
            background: #dd6b20;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(237, 137, 54, 0.4);
        }
        
        .btn-danger {
            background: #f56565;
            color: white;
        }
        
        .btn-danger:hover {
            background: #e53e3e;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(245, 101, 101, 0.4);
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                z-index: 1000;
            }
            
            .sidebar.active {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .stats-container {
                grid-template-columns: 1fr;
            }
            
            .top-bar {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>📊 Admin Panel</h2>
            </div>
            <nav>
                <ul class="sidebar-menu">
                    <li><a href="admin-dashboard.jsp" class="active">📈 Dashboard</a></li>
                    <li><a href="#users">👥 Users</a></li>
                    <li><a href="#attendance">✓ Attendance</a></li>
                    <li><a href="#reports">📄 Reports</a></li>
                    <li><a href="<%= request.getContextPath() %>/logout">🚪 Logout</a></li>
                </ul>
            </nav>
        </aside>
        
        <!-- Main Content -->
        <main class="main-content">
            <!-- Top Bar -->
                <!-- Message banners -->
                <c:if test="${not empty error}">
                    <div class="message error-message"><c:out value="${error}"/></div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="message success-message"><c:out value="${success}"/></div>
                </c:if>
            <div class="top-bar">
                <div class="welcome-message">
                    Welcome back, <strong><%= username %></strong>!
                </div>
                <div class="user-info">
                    <div class="user-avatar"><%= username.substring(0,1).toUpperCase() %></div>
                    <span><%= username %></span>
                </div>
            </div>
            
            <!-- Stats Cards -->
            <div class="stats-container">
                <div class="stat-card blue">
                    <div class="stat-title">Total Users</div>
                        <div class="stat-value"><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : "0" %></div>
                    <div class="stat-icon">👥</div>
                </div>
                
                <div class="stat-card green">
                    <div class="stat-title">Attendance Today</div>
                        <div class="stat-value"><%= request.getAttribute("presentToday") != null ? request.getAttribute("presentToday") : "0" %></div>
                    <div class="stat-icon">✓</div>
                </div>
                
                <div class="stat-card red">
                    <div class="stat-title">Absentees</div>
                        <div class="stat-value"><%= request.getAttribute("absentees") != null ? request.getAttribute("absentees") : "0" %></div>
                    <div class="stat-icon">✗</div>
                </div>
            </div>
            
            <!-- Attendance trend chart -->
          <div id="adminChartContainer" class="card" style="margin-top:20px; background:white; padding:20px; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.06);"
              data-dates="<%= request.getAttribute("last7DatesJson") != null ? request.getAttribute("last7DatesJson") : "[]" %>"
              data-counts="<%= request.getAttribute("last7CountsJson") != null ? request.getAttribute("last7CountsJson") : "[]" %>">
                <h3 style="margin-top:0">Attendance (last 7 days)</h3>
                <canvas id="adminAttendanceChart" aria-label="Attendance last 7 days" role="img"></canvas>
                <div id="adminChartNoData" style="display:none;color:#6b7280;margin-top:10px">No attendance data for the last 7 days.</div>
            </div>
            
            <!-- Quick Actions -->
            <div class="actions-section">
                <h2 class="section-title">Quick Actions</h2>
                <div class="action-buttons">
                    <button class="btn btn-primary" onclick="alert('Add User functionality')">➕ Add User</button>
                    <button class="btn btn-success" onclick="alert('Mark Attendance functionality')">✓ Mark Attendance</button>
                    <button class="btn btn-warning" onclick="alert('Generate Report functionality')">📊 Generate Report</button>
                    <button class="btn btn-danger" onclick="alert('View Absentees functionality')">👀 View Absentees</button>
                </div>
            </div>
        </main>
    </div>
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        (function(){
            try {
                const container = document.getElementById('adminChartContainer');
                const datesJson = container.getAttribute('data-dates') || '[]';
                const countsJson = container.getAttribute('data-counts') || '[]';
                let dates = [];
                let counts = [];
                try { dates = JSON.parse(datesJson); } catch(e){ dates = []; }
                try { counts = JSON.parse(countsJson); } catch(e){ counts = []; }
                const canvas = document.getElementById('adminAttendanceChart');
                const ctx = canvas.getContext('2d');
                if (!dates || dates.length === 0) {
                    canvas.style.display = 'none';
                    document.getElementById('adminChartNoData').style.display = '';
                    return;
                }
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: dates,
                        datasets: [{ label: 'Present', data: counts, backgroundColor: '#60a5fa' }]
                    },
                    options: { responsive: true, scales: { y: { beginAtZero: true } } }
                });
            } catch (e) { console.error(e); }
        })();
    </script>
</body>
</html>
