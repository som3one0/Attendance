
10px 16px;background:#2563eb;color:#fff;border:0;border-radius:6px;cursor:pointer}
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Login</h2>

        <!-- Map URL params to variables so JSTL conditionals can use 'error' and 'success' -->
        <c:if test="${not empty param.error}">
            <c:set var="error" value="${param.error}" />
        </c:if>
        <c:if test="${not empty param.message}">
            <c:set var="success" value="${param.message}" />
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert-error">
                <c:choose>
                    <c:when test="${error == 'invalid_credentials'}">Invalid login: username or password is incorrect.</c:when>
                    <c:when test="${error == 'empty_fields'}">Please provide both username and password.</c:when>
                    <c:when test="${error == 'database_error'}">A database error occurred. Please try again later.</c:when>
                    <c:otherwise><c:out value="${error}"/></c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert-success">
                <c:choose>
                    <c:when test="${success == 'logged_out'}">You have been logged out successfully.</c:when>
                    <c:otherwise><c:out value="${success}"/></c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input id="username" name="username" type="text" required placeholder="Enter username" />
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input id="password" name="password" type="password" required placeholder="Enter password" />
            </div>
            <div style="text-align:right">
                <button type="submit">Login</button>
            </div>
        </form>
    </div>
</body>
</html>
