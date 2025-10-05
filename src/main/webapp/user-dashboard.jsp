<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - Attendance System</title>
    <link rel="stylesheet" href="css/style.css">
    <!-- FullCalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.css" rel="stylesheet">
    <style>
        /* Minimal styles to match admin dashboard */
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg,#667eea 0%,#764ba2 100%); color:#2d3748; }
        .container { max-width: 1100px; margin: 40px auto; background:white; padding:20px; border-radius:10px; }
        .top { display:flex; justify-content:space-between; align-items:center; }
        .stat { background:#f7fafc; padding:20px; border-radius:8px; margin-top:20px; }
        table { width:100%; border-collapse:collapse; margin-top:10px; }
        th,td { padding:10px; border-bottom:1px solid #e2e8f0; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Message banners -->
        <c:if test="${not empty error}">
            <div class="message error-message"><c:out value="${error}"/></div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="message success-message"><c:out value="${success}"/></div>
        </c:if>

        <div class="top">
            <h2>Welcome, <%= username %></h2>
            <a href="<%= request.getContextPath() %>/logout">Logout</a>
        </div>

        <div class="stat">
            <h3>Your Attendance</h3>
            <p>Attendance Percentage: <strong><%= String.format("%.2f", request.getAttribute("attendancePercent") != null ? (Double)request.getAttribute("attendancePercent") : 0.0) %>%</strong></p>
        </div>

        <div class="stat">
            <h3>Recent Attendance</h3>
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        java.util.List recs = (java.util.List) request.getAttribute("recentAttendance");
                        if (recs != null && !recs.isEmpty()) {
                            for (Object o : recs) {
                                com.attendance.model.AttendanceRecord r = (com.attendance.model.AttendanceRecord) o;
                    %>
                    <tr>
                        <td><%= r.getDate() %></td>
                        <td><%= r.getStatus() %></td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr><td colspan="2">No attendance records found.</td></tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>

        <div class="stat" style="margin-top:20px;">
            <h3>Attendance Calendar (this month)</h3>
            <div id="attendanceCalendar" data-events='<%= request.getAttribute("userEventsJson") != null ? request.getAttribute("userEventsJson") : "[]" %>'></div>
            <div id="calendarNoData" style="display:none;color:#6b7280;margin-top:10px">No attendance events to display for this month.</div>
        </div>
    </div>
    <!-- FullCalendar JS -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.js"></script>
    <script>
        (function(){
            try {
                const calendarEl = document.getElementById('attendanceCalendar');
                const eventsJson = calendarEl.getAttribute('data-events') || '[]';
                let events = [];
                try { events = JSON.parse(eventsJson); } catch(e){ events = []; }
                if (!events || events.length === 0) {
                    calendarEl.style.display = 'none';
                    document.getElementById('calendarNoData').style.display = '';
                    return;
                }

                const calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'dayGridMonth',
                    height: 'auto',
                    events: events,
                    headerToolbar: { left: 'prev,next today', center: 'title', right: 'dayGridMonth,dayGridWeek' }
                });
                calendar.render();
            } catch (e) { console.error('Calendar init error', e); }
        })();
    </script>
</body>
</html>
