<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Manage Return Requests</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* A simple, clean table style for your dashboard */
        .admin-table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .admin-table th, .admin-table td { padding: 12px 15px; border-bottom: 1px solid #eee; text-align: left; }
        .admin-table th { background-color: #f8f9fa; font-weight: bold; color: #333; }
        .badge { padding: 5px 10px; border-radius: 12px; font-size: 0.85em; font-weight: bold; color: white; }
        .badge-pending { background-color: #ffc107; color: #000; }
        .badge-approved { background-color: #198754; }
        .badge-rejected { background-color: #dc3545; }
        .badge-action { background-color: #0dcaf0; color: #000; }
        .btn-review { background: #0d6efd; color: white; padding: 6px 12px; text-decoration: none; border-radius: 4px; font-size: 0.9em; white-space: nowrap;}
    </style>
</head>
<body style="background-color: #f4f6f9; font-family: Arial, sans-serif; padding: 20px;">

    <%-- Don't forget your global header/notifications if you have them! --%>

    <h2><i class="fa-solid fa-rotate-left"></i> Customer Return Requests</h2>

    <table class="admin-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Order #</th>
                <th>Customer</th>
                <th>Book Details</th>
                <th>Reason</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${returnList}" var="r">
                <tr>
                    <td>#${r.returnId}</td>
                    <td><a href="${pageContext.request.contextPath}/admin/order/detail?id=${r.orderId}">${r.orderId}</a></td>
                    <td>${r.customerName}</td>
                    <td>
                        <strong>${r.bookTitle}</strong><br>
                        <span style="color: #666; font-size: 0.85em;">Qty: ${r.quantity} | Pref: ${r.refundPreference}</span>
                    </td>
                    <td style="max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${r.customerReason}">
                        ${r.customerReason}
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${r.status == 1}"><span class="badge badge-pending">Pending Review</span></c:when>
                            <c:when test="${r.status == 2}"><span class="badge badge-action">Action Required</span></c:when>
                            <c:when test="${r.status == 3}"><span class="badge badge-approved">Approved (Awaiting Item)</span></c:when>
                            <c:when test="${r.status == 4 || r.status == 6}"><span class="badge badge-rejected">Rejected</span></c:when>
                            <c:otherwise><span class="badge" style="background: #6c757d;">Unknown</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/returns/review?id=${r.returnId}" class="btn-review">
                            Review <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </td>
                </tr>
            </c:forEach>
            
            <c:if test="${empty returnList}">
                <tr><td colspan="7" style="text-align: center; color: #888;">No return requests found.</td></tr>
            </c:if>
        </tbody>
    </table>

</body>
</html>