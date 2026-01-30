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
                    /* Specific styles for User Table inputs */
                    .role-select,
                    .status-select {
                        padding: 5px;
                        border-radius: 4px;
                        border: 1px solid #ced4da;
                        font-size: 13px;
                    }

                    .btn-save-row {
                        background-color: #28a745;
                        color: white;
                        border: none;
                        padding: 6px 10px;
                        border-radius: 4px;
                        cursor: pointer;
                        margin-left: 5px;
                    }

                    .btn-save-row:hover {
                        background-color: #218838;
                    }

                    .role-badge {
                        padding: 4px 8px;
                        border-radius: 12px;
                        font-size: 11px;
                        font-weight: bold;
                        text-transform: uppercase;
                    }

                    .role-1 {
                        background: #dc3545;
                        color: white;
                    }

                    /* Admin - Red */
                    .role-2 {
                        background: #0d6efd;
                        color: white;
                    }

                    /* Customer - Blue */
                    .role-4 {
                        background: #ffc107;
                        color: black;
                    }

                    /* Warehouse - Yellow */

                    /* Add this inside the <style> block */
                    .status-banned {
                        background-color: #f8d7da;
                        color: #721c24;
                        border-color: #f5c6cb;
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
                    </div>

                    <div class="table-responsive">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>User Info</th>
                                    <th>Contact</th>
                                    <th>Joined Date</th>
                                    <th>Role & Status</th>
                                    <th>Action</th>
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
                                            <fmt:formatDate value="${u.createAt}" pattern="MMM dd, yyyy" />
                                        </td>

                                        <form action="${pageContext.request.contextPath}/admin/users" method="post">
                                            <input type="hidden" name="userId" value="${u.id}">

                                            <td>
                                                <select name="role" class="role-select">
                                                    <option value="1" ${u.role==1 ? 'selected' : '' }>Admin</option>
                                                    <option value="4" ${u.role==4 ? 'selected' : '' }>Warehouse</option>
                                                    <option value="2" ${u.role==2 ? 'selected' : '' }>Customer</option>
                                                </select>

                                                <select name="status"
                                                    class="status-select ${u.status == 0 ? 'status-banned' : ''}">
                                                    <option value="1" ${u.status==1 ? 'selected' : '' }>Active</option>
                                                    <option value="0" ${u.status==0 ? 'selected' : '' }>Banned</option>
                                                </select>
                                            </td>

                                            <td>
                                                <button type="submit" class="btn-save-row" title="Save Changes">
                                                    <i class="fa-solid fa-check"></i>
                                                </button>
                                            </td>
                                        </form>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

            </body>

            </html>