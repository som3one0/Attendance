<%@ page language="java" contenteditable="application/x-httpd-php" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance Reports - Cyberpunk Style</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* Cyberpunk neon styles */
        .cyber-reports-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        .neon-glass-card {
            background: rgba(10, 10, 30, 0.7);
            border: 2px solid #00ffff;
            border-radius: 15px;
            padding: 30px;
            margin: 20px 0;
            box-shadow: 0 0 30px rgba(0, 255, 255, 0.5),
                        inset 0 0 20px rgba(0, 255, 255, 0.1);
            backdrop-filter: blur(10px);
        }

        .neon-title {
            font-size: 2.5em;
            text-align: center;
            color: #00ffff;
            text-shadow: 0 0 10px #00ffff,
                         0 0 20px #00ffff,
                         0 0 30px #00ffff;
            margin-bottom: 30px;
            font-family: 'Orbitron', monospace;
            letter-spacing: 3px;
        }

        .filter-section {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 25px;
            padding: 20px;
            background: rgba(20, 20, 50, 0.6);
            border: 1px solid #ff00ff;
            border-radius: 10px;
        }

        .filter-input {
            flex: 1;
            min-width: 200px;
            padding: 12px;
            background: rgba(0, 0, 0, 0.8);
            border: 2px solid #00ffff;
            border-radius: 5px;
            color: #00ffff;
            font-family: 'Courier New', monospace;
        }

        .filter-input:focus {
            outline: none;
            box-shadow: 0 0 15px #00ffff;
        }

        .neon-button {
            padding: 12px 30px;
            background: rgba(0, 255, 255, 0.2);
            border: 2px solid #00ffff;
            border-radius: 5px;
            color: #00ffff;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .neon-button:hover {
            background: rgba(0, 255, 255, 0.4);
            box-shadow: 0 0 20px #00ffff;
            transform: translateY(-2px);
        }

        .records-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
        }

        .records-table thead {
            background: rgba(0, 255, 255, 0.2);
        }

        .records-table th {
            padding: 15px;
            text-align: left;
            color: #00ffff;
            border: 1px solid #00ffff;
            font-family: 'Orbitron', monospace;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .records-table td {
            padding: 15px;
            border: 1px solid rgba(0, 255, 255, 0.3);
            color: #00ffff;
        }

        /* Zebra stripe rows with neon effect */
        .records-table tbody tr:nth-child(odd) {
            background: rgba(255, 0, 255, 0.1);
        }

        .records-table tbody tr:nth-child(even) {
            background: rgba(0, 255, 255, 0.1);
        }

        .records-table tbody tr:hover {
            background: rgba(0, 255, 255, 0.3);
            box-shadow: 0 0 15px rgba(0, 255, 255, 0.5);
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #ff00ff;
            font-size: 1.5em;
            text-shadow: 0 0 10px #ff00ff;
        }

        /* Digital-style time display using CSS */
        .digital-time::before {
            content: attr(data-time);
            font-family: 'Courier New', monospace;
            font-size: 1.2em;
            color: #00ffff;
            text-shadow: 0 0 10px #00ffff;
        }
    </style>
</head>
<body>
    <div class="cyber-reports-container">
        <h1 class="neon-title">◢ ATTENDANCE RECORDS ◣</h1>
        
        <div class="neon-glass-card">
            <!-- Filter Section -->
            <form method="get" action="reports" class="filter-section">
                <input type="text" name="username" placeholder="USERNAME" 
                       value="${param.username}" class="filter-input">
                <input type="text" name="department" placeholder="DEPARTMENT" 
                       value="${param.department}" class="filter-input">
                <input type="date" name="startDate" 
                       value="${param.startDate}" class="filter-input">
                <input type="date" name="endDate" 
                       value="${param.endDate}" class="filter-input">
                <button type="submit" class="neon-button">⚡ FILTER</button>
                <button type="button" onclick="window.location.href='reports'" 
                        class="neon-button">↻ RESET</button>
            </form>

            <!-- Records Table -->
            <c:choose>
                <c:when test="${not empty records}">
                    <table class="records-table">
                        <thead>
                            <tr>
                                <th>USERNAME</th>
                                <th>DEPARTMENT</th>
                                <th>DATE</th>
                                <th>STATUS</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${records}" var="record">
                                <tr>
                                    <td><c:out value="${record.username}"/></td>
                                    <td><c:out value="${record.department}"/></td>
                                    <td><c:out value="${record.date}"/></td>
                                    <td><c:out value="${record.status}"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        ⚠ NO ATTENDANCE RECORDS FOUND ⚠<br>
                        Please apply filters or check your database.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>--card);padding:20px;border-radius:8px;box-shadow:0 1px 3px rgba(0,0,0,.1);margin-bottom:20px}
        .filters{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:15px;margin-bottom:15px}
        .form-group{display:flex;flex-direction:column}
        label{font-size:14px;font-weight:500;margin-bottom:5px;color:#374151}
        input,select{padding:8px 12px;border:1px solid #d1d5db;border-radius:6px;font-size:14px}
        .btn{padding:10px 20px;border:none;border-radius:6px;font-size:14px;font-weight:500;cursor:pointer;transition:all .2s}
        .btn-primary{background:var(--accent);color:#fff}
        .btn-primary:hover{background:#1d4ed8}
        .btn-secondary{background:#6b7280;color:#fff}
        .btn-secondary:hover{background:#4b5563}
        .actions{display:flex;gap:10px;margin-top:15px}
        table{width:100%;border-collapse:collapse}
        thead{background:#f9fafb}
        th{padding:12px;text-align:left;font-weight:600;font-size:13px;color:#374151;border-bottom:2px solid #e5e7eb}
        td{padding:12px;font-size:14px;color:#111;border-bottom:1px solid #e5e7eb}
        tbody tr:hover{background:#f9fafb}
        .no-data{text-align:center;padding:40px;color:var(--muted);font-style:italic}
    </style>
</head>
<body>
    <header>
        <h1>Attendance Reports</h1>
    </header>
    
    <div class="container" id="reportsContainer"
         data-last7-dates="<%= request.getAttribute("last7DatesJson") != null ? request.getAttribute("last7DatesJson") : "[]" %>"
         data-last7-counts="<%= request.getAttribute("last7CountsJson") != null ? request.getAttribute("last7CountsJson") : "[]" %>">
        <div class="card" style="margin-bottom:18px;">
            <h2 style="margin-top:0">Attendance Trend (last 7 days)</h2>
            <canvas id="reportsAttendanceChart" style="max-height:300px"></canvas>
            <div id="reportsChartNoData" style="display:none;color:#6b7280;margin-top:10px">No attendance trend data available.</div>
        </div>
        <div class="card">
            <h2 style="margin-top:0">Filter Reports</h2>
            <form method="get" action="reports">
                <div class="filters">
                    <div class="form-group">
                        <label for="fromDate">From Date</label>
                        <input type="date" id="fromDate" name="fromDate" value="${param.fromDate}">
                    </div>
                    <div class="form-group">
                        <label for="toDate">To Date</label>
                        <input type="date" id="toDate" name="toDate" value="${param.toDate}">
                    </div>
                    <div class="form-group">
                        <label for="department">Department</label>
                        <input type="text" id="department" name="department" placeholder="Enter department" value="${param.department}">
                    </div>
                    <div class="form-group">
                        <label for="user">Username</label>
                        <input type="text" id="user" name="user" placeholder="Enter username" value="${param.user}">
                    </div>
                </div>
                <div class="actions">
                    <button type="submit" class="btn btn-primary">Apply Filters</button>
                    <a href="reports?export=csv&fromDate=${param.fromDate}&toDate=${param.toDate}&department=${param.department}&user=${param.user}" class="btn btn-secondary">Export to CSV</a>
                </div>
            </form>
        </div>
        
        <div class="card">
            <h2 style="margin-top:0">Attendance Records</h2>
            <c:choose>
                <c:when test="${not empty attendanceRecords}">
                    <table>
                        <thead>
                            <tr>
                                <th>Username</th>
                                <th>Department</th>
                                <th>Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="record" items="${attendanceRecords}">
                                <tr>
                                    <td><c:out value="${record.username}"/></td>
                                    <td><c:out value="${record.department}"/></td>
                                    <td><c:out value="${record.date}"/></td>
                                    <td><c:out value="${record.status}"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-data">No attendance records found. Please apply filters or check your database.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>ted);margin-bottom:6px}
        input[type=date],select{padding:8px 10px;border:1px solid #e6e9ef;border-radius:6px;background:#fff}
        .actions{display:flex;gap:8px;align-items:center;margin-left:auto}
        .btn{background:var(--accent);color:#fff;padding:8px 12px;border-radius:8px;border:0;cursor:pointer}
        .btn.secondary{background:#111827;color:#fff;opacity:0.9}
        .filters-row{display:flex;align-items:center;width:100%}
        .table-wrap{margin-top:16px;overflow-x:auto}
        table{width:100%;border-collapse:collapse;min-width:760px}
        th,td{padding:10px 12px;border-bottom:1px solid #eef2f6;text-align:left}
        th{background:linear-gradient(180deg,#fbfdff,#f3f6fb);font-weight:600;color:#0f172a}
        tbody tr:hover{background:#fbfbff}
        .empty{padding:28px;text-align:center;color:var(--muted)}
        @media (max-width:640px){
            .controls{flex-direction:column}
            .actions{margin-left:0}
        }
    </style>
</head>
<body>
<div class="container">
    <div class="card">
        <h1>Attendance Reports</h1>

        <!-- Filter form: ready to submit to a servlet. Adjust action URL to your servlet path. -->
        <form id="filterForm" class="filters-row" method="get" action="/reports">
            <div class="controls" style="flex:1">
                <div class="control">
                    <label for="fromDate">From</label>
                    <input id="fromDate" name="fromDate" type="date" />
                </div>
            </div>

            <div class="controls" style="flex:1">
                <div class="control">
                    <label for="toDate">To</label>
                    <input id="toDate" name="toDate" type="date" />
                </div>
            </div>

            <div class="controls" style="flex:1">
                <div class="control">
                    <label for="departmentSelect">Department</label>
                    <select id="departmentSelect" name="department">
                        <option value="">All Departments</option>
                        <!--
                            Optional server-side population:
                            In your servlet, set request attribute "departments" to a List<String>
                            then render options here. Example using scriptlet (if desired):
                            <% List<String> depts = (List<String>) request.getAttribute("departments");
                               if(depts!=null){ for(String d:depts){ %>
                               <option value="<%=d%>"><%=d%></option>
                            <% }} %>
                        -->
                    </select>
                </div>
            </div>

            <div class="controls" style="flex:1">
                <div class="control">
                    <label for="userSelect">User</label>
                    <select id="userSelect" name="user">
                        <option value="">All Users</option>
                        <!-- Optional server-side population like departments -->
                    </select>
                </div>
            </div>

            <div class="actions">
                <button type="button" id="applyClient" class="btn secondary" title="Filter client-side">Filter</button>
                <button type="submit" class="btn" title="Submit filters to server">Apply (server)</button>
                <button type="button" id="exportCsv" class="btn" title="Export visible rows to CSV">Export CSV</button>
            </div>
        </form>

        <div class="table-wrap">
            <table id="attendanceTable" aria-describedby="tableDesc">
                <thead>
                    <tr>
                        <th>Username</th>
                        <th>Department</th>
                        <th>Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Example rows: replace or let servlet populate `attendanceRecords` attribute (List<YourBean>) -->
                    <!-- Server-side JSP example (scriptlet) to add rows when integrating with servlet:
                         <% List<AttendanceRecord> recs = (List<AttendanceRecord>) request.getAttribute("attendanceRecords");
                            if(recs!=null){
                                for(AttendanceRecord r: recs){ %>
                                  <tr data-username="<%=r.getUsername()%>" data-department="<%=r.getDepartment()%>" data-date="<%=r.getDate()%>">
                                    <td><%=r.getUsername()%></td>
                                    <td><%=r.getDepartment()%></td>
                                    <td><%=r.getDate()%></td>
                                    <td><%=r.getStatus()%></td>
                                  </tr>
                         <%     }
                            }
                         -->

                    <!-- Client-side demo rows (leave or remove when server provides rows) -->
                    <tr data-username="jdoe" data-department="Engineering" data-date="2025-10-01">
                        <td>jdoe</td>
                        <td>Engineering</td>
                        <td>2025-10-01</td>
                        <td>Present</td>
                    </tr>
                    <tr data-username="asmith" data-department="HR" data-date="2025-10-01">
                        <td>asmith</td>
                        <td>HR</td>
                        <td>2025-10-01</td>
                        <td>Absent</td>
                    </tr>
                    <tr data-username="mjane" data-department="Engineering" data-date="2025-10-02">
                        <td>mjane</td>
                        <td>Engineering</td>
                        <td>2025-10-02</td>
                        <td>Present</td>
                    </tr>
                </tbody>
            </table>
            <div id="noResults" class="empty" style="display:none">No records match the selected filters.</div>
        </div>
    </div>
</div>

<script>
    // Configuration: adjust if your servlet paths differ
    const config = {
        departmentsEndpoint: '/api/departments', // optional endpoint returning JSON array of strings
        usersEndpoint: '/api/users',             // optional endpoint returning JSON array of strings
        fetchRecordsEndpoint: '/reports?json=true' // optional endpoint for JSON records
    };

    // Helper: parse YYYY-MM-DD -> Date
    function parseYMD(s){ if(!s) return null; const parts=s.split('-'); return new Date(parts[0], parts[1]-1, parts[2]); }

    // Populate selects from API if available (non-blocking)
    async function tryPopulateSelects(){
        try{
            const dResp = await fetch(config.departmentsEndpoint);
            if(dResp.ok){
                const ds = await dResp.json();
                const sel = document.getElementById('departmentSelect');
                ds.forEach(d=>{ const o=document.createElement('option'); o.value=d; o.textContent=d; sel.appendChild(o); });
            }
        }catch(e){ /* ignore if endpoint not available */ }

        try{
            const uResp = await fetch(config.usersEndpoint);
            if(uResp.ok){
                const us = await uResp.json();
                const sel = document.getElementById('userSelect');
                us.forEach(u=>{ const o=document.createElement('option'); o.value=u; o.textContent=u; sel.appendChild(o); });
            }
        }catch(e){ /* ignore */ }
    }

    // Client-side filtering of the table rows
    function applyClientFilters(){
        const from = document.getElementById('fromDate').value;
        const to = document.getElementById('toDate').value;
        const dept = document.getElementById('departmentSelect').value;
        const user = document.getElementById('userSelect').value;

        const fromD = parseYMD(from);
        const toD = parseYMD(to);

        const tbody = document.querySelector('#attendanceTable tbody');
        let visible = 0;
        Array.from(tbody.rows).forEach(row=>{
            const rDate = row.getAttribute('data-date');
            const rDept = row.getAttribute('data-department') || '';
            const rUser = row.getAttribute('data-username') || '';

            let show = true;
            if(fromD){ const d = parseYMD(rDate); if(!d || d < fromD) show=false; }
            if(toD){ const d = parseYMD(rDate); if(!d || d > toD) show=false; }
            if(dept && dept!=='') show = show && (rDept === dept);
            if(user && user!=='') show = show && (rUser === user);

            row.style.display = show ? '' : 'none';
            if(show) visible++;
        });

        document.getElementById('noResults').style.display = visible ? 'none' : '';
    }

    // Export visible rows to CSV
    function exportVisibleToCsv(){
        const table = document.getElementById('attendanceTable');
        const rows = Array.from(table.querySelectorAll('tbody tr')).filter(r=>r.style.display !== 'none');
        if(rows.length === 0){ alert('No rows to export'); return; }

        const cols = ['Username','Department','Date','Status'];
        const csv = [cols.join(',')];

        rows.forEach(r=>{
            const cells = Array.from(r.cells).map(td=> '"'+ (td.textContent || '').replace(/"/g,'""') +'"');
            csv.push(cells.join(','));
        });

        const blob = new Blob([csv.join('\n')], {type:'text/csv;charset=utf-8;'});
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        const now = new Date().toISOString().slice(0,10);
        a.download = `attendance-report-${now}.csv`;
        document.body.appendChild(a);
        a.click();
        a.remove();
        URL.revokeObjectURL(url);
    }

    // Wire up events
    document.addEventListener('DOMContentLoaded', ()=>{
        tryPopulateSelects();

        document.getElementById('applyClient').addEventListener('click', (e)=>{
            e.preventDefault();
            applyClientFilters();
        });

        // Also apply filters when selects or dates change (small debounce)
        let t;
        Array.from([document.getElementById('fromDate'), document.getElementById('toDate'), document.getElementById('departmentSelect'), document.getElementById('userSelect')]).forEach(el=>{
            el.addEventListener('input', ()=>{ clearTimeout(t); t = setTimeout(applyClientFilters, 150); });
        });

        document.getElementById('exportCsv').addEventListener('click', exportVisibleToCsv);

        // If your backend can return JSON rows, you could fetch and render them here.
        // Example (uncomment if backend supports it):
        // fetch(config.fetchRecordsEndpoint).then(r=>r.json()).then(renderRecords).catch(()=>{});
    });

    // Optional helper to render records returned by server (JSON array of {username,department,date,status})
    function renderRecords(records){
        const tbody = document.querySelector('#attendanceTable tbody');
        tbody.innerHTML = '';
        records.forEach(r=>{
            const tr = document.createElement('tr');
            tr.setAttribute('data-username', r.username);
            tr.setAttribute('data-department', r.department);
            tr.setAttribute('data-date', r.date);
            tr.innerHTML = `<td>${escapeHtml(r.username)}</td><td>${escapeHtml(r.department)}</td><td>${escapeHtml(r.date)}</td><td>${escapeHtml(r.status)}</td>`;
            tbody.appendChild(tr);
        });
    }

    function escapeHtml(s){ return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    (function(){
        try {
            const container = document.getElementById('reportsContainer');
            const dates = JSON.parse(container.getAttribute('data-last7-dates') || '[]');
            const counts = JSON.parse(container.getAttribute('data-last7-counts') || '[]');
            const canvas = document.getElementById('reportsAttendanceChart');
            if (!dates || dates.length === 0) {
                canvas.style.display = 'none';
                document.getElementById('reportsChartNoData').style.display = '';
                return;
            }
            const ctx = canvas.getContext('2d');
            new Chart(ctx, { type:'bar', data:{ labels: dates, datasets:[{ label:'Present', data: counts, backgroundColor:'#60a5fa' }] }, options:{ responsive:true } });
        } catch(e){ console.warn('No chart data or error rendering chart', e); }
    })();
</script>

</body>
</html>
