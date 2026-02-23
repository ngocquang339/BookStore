<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <title>User Management</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/manage-orders.css">
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
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>User Info</th>
                                    <th>Contact</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Joined Date</th>
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

            </body>

            </html>