<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Admin Dashboard - BookStore</title>

                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css?v=2">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/admin-dashboard-stats.css?v=2">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                

            </head>

            <body>

                <header class="main-header">
                    <div class="container">
                        <div class="logo">
                            <a href="${pageContext.request.contextPath}/home">
                                <span style="color: #C92127; font-weight: 900; font-size: 28px;">BOOK</span>STORE
                            </a>
                            <span style="color: white; margin-left: 10px; font-weight: 300;">| ADMIN PANEL</span>
                        </div>
                        <div class="header-icons">
                            <span style="color: white; margin-right: 15px;">
                                <i class="fa-solid fa-user-shield"></i> Welcome, ${sessionScope.user.fullname}
                            </span>
                            <a href="${pageContext.request.contextPath}/logout"
                                style="color: #ffcccc; text-decoration: none;">
                                <i class="fa-solid fa-right-from-bracket"></i> Logout
                            </a>
                        </div>
                    </div>
                </header>

                <main class="dashboard-container">
                    <div class="dashboard-header">
                        <h1><i class="fa-solid fa-gauge-high"></i> Dashboard Overview</h1>
                        <a href="${pageContext.request.contextPath}/home" class="btn-back">
                            <i class="fa-solid fa-house"></i> Back to Shop
                        </a>
                    </div>

                    <div class="stats-grid">
                        <div class="stat-card" style="border-left-color: #198754;">
                            <div class="stat-icon" style="color: #198754;"><i class="fa-solid fa-sack-dollar"></i></div>
                            <div class="stat-info">
                                <h3>
                                    <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="đ"
                                        maxFractionDigits="0" />
                                </h3>
                                <p>Total Revenue</p>
                            </div>
                        </div>

                        <div class="stat-card" style="border-left-color: #0d6efd;">
                            <div class="stat-icon" style="color: #0d6efd;"><i class="fa-solid fa-cart-shopping"></i>
                            </div>
                            <div class="stat-info">
                                <h3>${totalOrders}</h3>
                                <p>Total Orders</p>
                            </div>
                        </div>

                        <div class="stat-card" style="border-left-color: #ffc107;">
                            <div class="stat-icon" style="color: #ffc107;"><i class="fa-solid fa-book"></i></div>
                            <div class="stat-info">
                                <h3>${totalBooks}</h3>
                                <p>Books Managed</p>
                            </div>
                        </div>

                        <div class="stat-card" style="border-left-color: #6c757d;">
                            <div class="stat-icon" style="color: #6c757d;"><i class="fa-solid fa-users"></i></div>
                            <div class="stat-info">
                                <h3>${totalCustomers}</h3>
                                <p>Customers</p>
                            </div>
                        </div>
                    </div>
                    <div class="card-grid">
                        <a href="${pageContext.request.contextPath}/admin/product/list" class="admin-card">
                            <i class="fa-solid fa-book"></i>
                            <h3>Product Manager</h3>
                            <p>Add, Edit, or Hide books</p>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/order" class="admin-card">
                            <i class="fa-solid fa-list-check"></i>
                            <h3>Orders</h3>
                            <p>View and process customer orders</p>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/users" class="admin-card">
                            <i class="fa-solid fa-users"></i>
                            <h3>Users</h3>
                            <p>Manage accounts and roles</p>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/reports" class="admin-card">
                            <i class="fa-solid fa-chart-simple"></i>
                            <h3>Reports</h3>
                            <p>Sales statistics</p>
                        </a>
                    </div>
                </main>

            </body>

            </html>