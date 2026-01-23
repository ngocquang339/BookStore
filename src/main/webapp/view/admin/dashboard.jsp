<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - BookStore</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
    
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
                <a href="${pageContext.request.contextPath}/logout" style="color: #ffcccc; text-decoration: none;">
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

        <div class="card-grid">
            <a href="#" class="admin-card">
                <i class="fa-solid fa-book"></i>
                <h3>Product Manager</h3>
                <p>Add, Edit, or Hide books</p>
            </a>

            <a href="#" class="admin-card">
                <i class="fa-solid fa-list-check"></i>
                <h3>Orders</h3>
                <p>View and process customer orders</p>
            </a>

            <a href="#" class="admin-card">
                <i class="fa-solid fa-users"></i>
                <h3>Users</h3>
                <p>Manage accounts and roles</p>
            </a>

            <a href="#" class="admin-card">
                <i class="fa-solid fa-chart-line"></i>
                <h3>Reports</h3>
                <p>Sales statistics and revenue</p>
            </a>
        </div>
    </main>

</body>
</html>