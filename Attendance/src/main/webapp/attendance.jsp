<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mark Attendance</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; }
        .back-link { display: inline-block; margin-bottom: 20px; color: white; text-decoration: none; font-size: 16px; padding: 10px 20px; background: rgba(255, 255, 255, 0.2); border-radius: 8px; transition: all 0.3s; }
        .back-link:hover { background: rgba(255, 255, 255, 0.3); }
        .header { background: white; border-radius: 15px; padding: 30px; margin-bottom: 30px; box-shadow: 0 5px 20px rgba(0,0,0,0.1); }
        .header h1 { color: #2c3e50; font-size: 32px; margin-bottom: 10px; }
        .header p { color: #7f8c8d; font-size: 16px; }
        .header .date-display { margin-top: 15px; padding: 10px 20px; background: #ecf0f1; border-radius: 8px; display: inline-block; color: #2c3e50; font-weight: 600; }
        .message-container { margin-bottom: 20px; }
        .message { padding: 15px 20px; border-radius: 8px; margin-bottom: 10px; display: none; }
        .message.success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; display: block; }
        .message.error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; display: block; }
        .attendance-card { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 5px 20px rgba(0,0,0,0.1); }
        .attendance-card h2 { color: #2c3e50; font-size: 24px; margin-bottom: 20px; }
        .attendance-table-container { overflow-x: auto; margin-bottom: 20px; }
        .attendance-table { width: 100%; border-collapse: collapse; min-width: 600px; }
        .attendance-table thead { background: #34495e; color: white; }
        .attendance-table th { padding: 15px; text-align: left; font-weight: 600; font-size: 14px; text-transform: uppercase; }
        .attendance-table tbody tr { border-bottom: 1px solid #ecf0f1; transition: background 0.3s; }
        .attendance-table tbody tr:hover { background: #f8f9fa; }
        .attendance-table td { padding: 15px; color: #2c3e50; }
        .attendance-table td.user-name { font-weight: 600; }
        .attendance-table td.department { color: #7f8c8d; }
        .status-select { padding: 8px 15px; border: 2px solid #ecf0f1; border-radius: 6px; font-size: 14px; color: #2c3e50; background: white; cursor: pointer; transition: all 0.3s; min-width: 120px; }
        .status-select:focus { outline: none; border-color: #3498db; }
        .button-section { display: flex; gap: 15px; justify-content: flex-end; margin-top: 20px; }
        .btn { padding: 12px 30px; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.3s; text-decoration: none; display: inline-block; }
        .btn-primary { background: #3498db; color: white; }
        .btn-primary:hover { background: #2980b9; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3); }
        .btn-secondary { background: #95a5a6; color: white; }
        .btn-secondary:hover { background: #7f8c8d; }
        @media (max-width: 768px) {
            body { padding: 10px; }
            .header h1 { font-size: 24px; }
            .attendance-card { padding: 20px; }
            .attendance-table th, .attendance-table td { padding: 10px; font-size: 12px; }
            .button-section { flex-direction: column; }
            .btn { width: 100%; }
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="admin-dashboard.jsp" class="back-link">← Back to Dashboard</a>

        <div class="header">
            <h1>Mark Attendance</h1>
            <p>Select attendance status for each user</p>
            <div class="date-display"><span id="currentDate"></span></div>
        </div>

        <div class="message-container" id="messageContainer"></div>

        <div class="attendance-card">
            <h2>User Attendance List</h2>
            <form action="MarkAttendanceServlet" method="post" id="attendanceForm">
                <div class="attendance-table-container">
                    <table class="attendance-table">
                        <thead>
                            <tr>
                                <th>S.No</th>
                                <th>Name</th>
                                <th>Department</th>
                                <th>Attendance Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td class="user-name">John Doe</td>
                                <td class="department">Computer Science</td>
                                <td>
                                    <select name="attendance_1" class="status-select">
                                        <option value="present" selected>Present</option>
                                        <option value="absent">Absent</option>
                                        <option value="leave">Leave</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td class="user-name">Jane Smith</td>
                                <td class="department">Information Technology</td>
                                <td>
                                    <select name="attendance_2" class="status-select">
                                        <option value="present" selected>Present</option>
                                        <option value="absent">Absent</option>
                                        <option value="leave">Leave</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td class="user-name">Mike Johnson</td>
                                <td class="department">Electronics</td>
                                <td>
                                    <select name="attendance_3" class="status-select">
                                        <option value="present" selected>Present</option>
                                        <option value="absent">Absent</option>
                                        <option value="leave">Leave</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>4</td>
                                <td class="user-name">Emily Davis</td>
                                <td class="department">Mechanical</td>
                                <td>
                                    <select name="attendance_4" class="status-select">
                                        <option value="present" selected>Present</option>
                                        <option value="absent">Absent</option>
                                        <option value="leave">Leave</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>5</td>
                                <td class="user-name">Robert Brown</td>
                                <td class="department">Civil Engineering</td>
                                <td>
                                    <select name="attendance_5" class="status-select">
                                        <option value="present" selected>Present</option>
                                        <option value="absent">Absent</option>
                                        <option value="leave">Leave</option>
                                    </select>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="button-section">
                    <button type="reset" class="btn btn-secondary">Reset</button>
                    <button type="submit" class="btn btn-primary">Submit Attendance</button>
                </div>
            </form>
        </div>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const dateDisplay = document.getElementById('currentDate');
            const today = new Date();
            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
            dateDisplay.textContent = today.toLocaleDateString('en-US', options);
        });
    </script>
</body>
</html>
                    <table class="attendance-table">
                        <thead>
                            <tr>
                                <th>S.No</th>
                                <th>Name</th>
                                <th>Department</th>
                                <th>Attendance Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td class="user-name">John Doe</td>
                                <td class="department">Computer Science</td>
                                <td>
                                    <select name="attendance_1" class="status-select">
                                        <option value="present" selected>Present</option>
                                        <option value="absent">Absent</option>
                                        <option value="leave">Leave</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td class="user-name">Jane Smith</td>
                                <td class="department">Information Technology</td>
                                <td>
                                    <select name="attendance_2" class="status-select">
                                        <option value="present" selected>Present</option>
                                        <option value="absent">Absent</option>
                                        <option value="leave">Leave</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td class="user-name">Mike Johnson</td>
                                <td class="department">Electronics</td>
                                <td>
                                    <select name="attendance_3" class="status-select">
                                        <option value="present" selected>Present</option>
                                        <option value="absent">Absent</option>
                                        <option value="leave">Leave</option>
                                    </select>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="button-section">
                    <button type="reset" class="btn btn-secondary">Reset</button>
                    <button type="submit" class="btn btn-primary">Submit Attendance</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const dateDisplay = document.getElementById('currentDate');
            const today = new Date();
            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
            dateDisplay.textContent = today.toLocaleDateString('en-US', options);
        });
    </script>
</body>
</html>