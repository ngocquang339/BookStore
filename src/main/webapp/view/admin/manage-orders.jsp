<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Order Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/manage-orders.css?v=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <div class="page-container">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">
            <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
        </a>

        <div class="header-actions">
            <h1><i class="fa-solid fa-cart-shopping"></i> Order Management</h1>
        </div>

        <c:choose>
            <c:when test="${empty listOrders}">
                <div class="empty-state">
                    <i class="fa-solid fa-box-open"></i>
                    <p>No orders found yet.</p>
                    <small>When customers checkout, their orders will appear here.</small>
                </div>
            </c:when>
            
            <c:otherwise>
                <div class="table-responsive">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Customer</th>
                                <th>Date</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${listOrders}" var="o">
                                <tr>
                                    <td>#${o.id}</td>
                                    <td>
                                        <strong>${o.userName}</strong><br>
                                        <span style="font-size: 0.9em; color: #666;">${o.phoneNumber}</span>
                                    </td>
                                    <td><fmt:formatDate value="${o.orderDate}" pattern="MMM dd, yyyy HH:mm"/></td>
                                    <td style="font-weight: bold; color: #C92127;">
                                        <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="đ"/>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.status == 1}"><span class="status-badge status-1">Pending</span></c:when>
                                            <c:when test="${o.status == 2}"><span class="status-badge status-2">Shipping</span></c:when>
                                            <c:when test="${o.status == 3}"><span class="status-badge status-3">Completed</span></c:when>
                                            <c:when test="${o.status == 4}"><span class="status-badge status-4">Cancelled</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/order/detail?id=${o.id}" class="btn-view">
                                            <i class="fa-solid fa-eye"></i> View
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>

    </div>

</body>
</html>