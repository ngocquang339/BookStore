<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <title>User Management</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/manage-orders.css?v=2.0">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <style>
                    /* Badges for displaying Roles nicely */
                    .role-badge {
                        padding: 5px 10px;
                        border-radius: 15px;
                        font-size: 12px;
                        font-weight: bold;
                        color: white;
                        display: inline-block;
                    }

                    .role-1 {
                        background-color: #dc3545;
                    }

                    /* Admin - Red */
                    .role-4 {
                        background-color: #ffc107;
                        color: black;
                    }

                    /* Warehouse - Yellow */
                    .role-2 {
                        background-color: #0d6efd;
                    }

                    /* Customer - Blue */

                    .status-active {
                        color: #198754;
                        font-weight: bold;
                    }

                    .status-banned {
                        color: #dc3545;
                        font-weight: bold;
                    }

                    .btn-add-user {
                        background-color: #28a745;
                        color: white;
                        padding: 10px 15px;
                        text-decoration: none;
                        border-radius: 4px;
                        font-weight: bold;
                    }

                    .btn-add-user:hover {
                        background-color: #218838;
                    }

                    .btn-action {
                        display: inline-block;
                        padding: 5px 10px;
                        border-radius: 4px;
                        color: white;
                        text-decoration: none;
                        margin-left: 10px;
                        font-size: 12px;
                    }

                    .btn-ban {
                        background-color: #dc3545;
                    }

                    /* Red Lock Button */
                    .btn-ban:hover {
                        background-color: #bb2d3b;
                    }

                    .btn-activate {
                        background-color: #28a745;
                    }

                    /* Green Unlock Button */
                    .btn-activate:hover {
                        background-color: #218838;
                    }
                </style>
            </head>

            <body>

                <div class="page-container">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">
                        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
                    </a>

                    <div class="header-actions">
                        <h1><i class="fa-solid fa-users"></i> User Management</h1>
                        <a href="${pageContext.request.contextPath}/admin/users/add" class="btn-add-user">
                            <i class="fa-solid fa-plus"></i> Create New User
                        </a>
                    </div>

                    <div class="table-responsive">
                        <div class="filter-bar"
                            style="display:flex; gap:10px; margin-bottom: 20px; align-items:center;">
                            <div style="position: relative;">
                                <i class="fa-solid fa-magnifying-glass"
                                    style="position: absolute; left: 10px; top: 12px; color: #aaa;"></i>
                                <input type="text" id="userSearch" class="search-input"
                                    placeholder="Search name or email..." onkeyup="filterUsers()"
                                    style="padding-left: 30px; width: 250px; height: 40px; border: 1px solid #ddd; border-radius: 4px;">
                            </div>

                            <select id="roleFilter" class="filter-select" onchange="filterUsers()"
                                style="height: 40px; border: 1px solid #ddd; border-radius: 4px; padding: 0 10px;">
                                <option value="all">All Roles</option>
                                <option value="admin">Admin</option>
                                <option value="customer">Customer</option>
                                <option value="employee">Employee</option>
                                <option value="warehouse">Warehouse</option>
                            </select>
                        </div>
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th onclick="sortTable(0)" style="width: 5%;">ID</th>

                                    <th onclick="sortTable(1)" style="width: 20%;">User Info</th>

                                    <th onclick="sortTable(2)" style="width: 25%;">Contact</th>

                                    <th onclick="sortTable(3)" style="width: 10%;">Role</th>

                                    <th onclick="sortTable(4)" style="width: 15%;">Status</th>

                                    <th onclick="sortTable(5)" style="width: 15%;">Joined Date</th>

                                    
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${listUsers}" var="u">
                                    <tr>
                                        <td>#${u.id}</td>
                                        <td>
                                            <strong>${u.username}</strong><br>
                                            <span style="color:#666; font-size:13px;">${u.fullname}</span>
                                        </td>
                                        <td>
                                            ${u.email}<br>
                                            <small>${u.phone_number}</small>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${u.role == 1}"><span
                                                        class="role-badge role-1">Admin</span></c:when>
                                                <c:when test="${u.role == 4}"><span
                                                        class="role-badge role-4">Warehouse</span></c:when>
                                                <c:otherwise><span class="role-badge role-2">Customer</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${u.status == 1}">
                                                    <span class="status-active"><i class="fa-solid fa-check-circle"></i>
                                                        Active</span>

                                                    <c:if test="${u.id != sessionScope.user.id}">
                                                        <a href="${pageContext.request.contextPath}/admin/users/ban?id=${u.id}&status=1"
                                                            class="btn-action btn-ban" title="Ban User"
                                                            onclick="return confirm('Are you sure you want to BAN this user?');">
                                                            <i class="fa-solid fa-lock"></i>
                                                        </a>
                                                    </c:if>

                                                    <c:if test="${u.id == sessionScope.user.id}">
                                                        <span
                                                            style="color:#ccc; font-size:11px; margin-left:5px;">(You)</span>
                                                    </c:if>

                                                </c:when>

                                                <c:otherwise>
                                                    <span class="status-banned"><i class="fa-solid fa-ban"></i>
                                                        Banned</span>

                                                    <a href="${pageContext.request.contextPath}/admin/users/ban?id=${u.id}&status=0"
                                                        class="btn-action btn-activate" title="Activate User">
                                                        <i class="fa-solid fa-lock-open"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <fmt:formatDate value="${u.createAt}" pattern="MMM dd, yyyy" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <script>
                    function filterUsers() {
                        let input = document.getElementById("userSearch").value.toLowerCase();
                        let roleFilter = document.getElementById("roleFilter").value.toLowerCase();

                        let table = document.querySelector(".admin-table");
                        let tr = table.getElementsByTagName("tr");

                        for (let i = 1; i < tr.length; i++) {
                            let showRow = true;

                            // --- DEFINE COLUMNS (Check these numbers!) ---
                            let nameCell = tr[i].getElementsByTagName("td")[1];  // Index 1 = Full Name
                            let emailCell = tr[i].getElementsByTagName("td")[2]; // Index 2 = Email (New!)
                            let roleCell = tr[i].getElementsByTagName("td")[3];  // Index 3 = Role

                            if (nameCell && emailCell && roleCell) {
                                let nameText = nameCell.innerText.toLowerCase();
                                let emailText = emailCell.innerText.toLowerCase();
                                let roleText = roleCell.innerText.toLowerCase();

                                // A. Check Keyword (Match Name OR Email)
                                // Logic: If input exists, but is NOT in Name AND NOT in Email, then hide.
                                if (input && nameText.indexOf(input) === -1 && emailText.indexOf(input) === -1) {
                                    showRow = false;
                                }

                                // B. Check Role
                                if (roleFilter !== 'all' && roleText.indexOf(roleFilter) === -1) {
                                    showRow = false;
                                }
                            }

                            tr[i].style.display = showRow ? "" : "none";
                        }
                    }
                    function sortTable(n) {
                        var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
                        table = document.querySelector(".admin-table");
                        switching = true;
                        dir = "asc";

                        while (switching) {
                            switching = false;
                            rows = table.rows;

                            // Loop through all table rows (start at 1 to skip header)
                            for (i = 1; i < (rows.length - 1); i++) {
                                shouldSwitch = false;

                                x = rows[i].getElementsByTagName("TD")[n];
                                y = rows[i + 1].getElementsByTagName("TD")[n];

                                // 1. GET TEXT CONTENT
                                var xContent = x.innerText.toLowerCase().trim();
                                var yContent = y.innerText.toLowerCase().trim();

                                // 2. DETECT DATA TYPE

                                // A. Check if ID (Remove '#')
                                var xNum = parseFloat(xContent.replace("#", "").replace(/[^0-9.-]+/g, ""));
                                var yNum = parseFloat(yContent.replace("#", "").replace(/[^0-9.-]+/g, ""));

                                // B. Check if Date (Vietnamese "thg" format)
                                // Simple hack: If column index is 5 (Joined Date), treat as text for now 
                                // OR use a specific parser if you need strict date sorting later.

                                var isNumeric = !isNaN(xNum) && !isNaN(yNum) && xContent.length < 10; // Simple check for IDs

                                // 3. COMPARE
                                if (dir == "asc") {
                                    if (isNumeric) {
                                        if (xNum > yNum) { shouldSwitch = true; break; }
                                    } else {
                                        if (xContent > yContent) { shouldSwitch = true; break; }
                                    }
                                } else if (dir == "desc") {
                                    if (isNumeric) {
                                        if (xNum < yNum) { shouldSwitch = true; break; }
                                    } else {
                                        if (xContent < yContent) { shouldSwitch = true; break; }
                                    }
                                }
                            }

                            if (shouldSwitch) {
                                rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                                switching = true;
                                switchcount++;
                            } else {
                                if (switchcount == 0 && dir == "asc") {
                                    dir = "desc";
                                    switching = true;
                                }
                            }
                        }
                    }
                </script>

            </body>

            </html>