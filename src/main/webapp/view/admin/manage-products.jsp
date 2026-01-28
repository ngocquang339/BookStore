<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <title>Product Manager</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/manage-products.css?v=2">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            </head>

            <body>

                <div class="page-container">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">
                        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
                    </a>

                    <div class="header-actions">
                        <h1><i class="fa-solid fa-box-open"></i> Product Management</h1>
                        <a href="${pageContext.request.contextPath}/admin/product/add" class="btn-add-new">
                            <i class="fa-solid fa-plus"></i> Add New Book
                        </a>
                    </div>

                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th style="width: 50px;">ID</th>
                                <th style="width: 80px;">Image</th>
                                <th>Book Details</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Status</th>
                                <th style="width: 180px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${listBooks}" var="b">
                                <tr class="${!b.active ? 'row-hidden' : ''}">
                                    <td>${b.id}</td>
                                    <td>
                                        <div
                                            style="width: 50px; height: 75px; overflow: hidden; border-radius: 4px; border: 1px solid #eee;">
                                            <img class="table-img" src="${pageContext.request.contextPath}/assets/image/books/${b.imageUrl}"
                                                alt="${b.title}" style="width: 100%; height: 100%; object-fit: cover;"
                                                onerror="this.onerror=null; this.src='https://placehold.co/50x75?text=No+Image';">
                                        </div>
                                    </td>
                                    <td>
                                        <div style="font-weight: bold; font-size: 1.1em; color: #333;">${b.title}</div>
                                        <div style="color: #666; font-size: 0.9em;"><i class="fa-solid fa-user-pen"></i>
                                            ${b.author}</div>
                                    </td>
                                    <td>
                                        <strong style="color: #C92127;">
                                            <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="$" />
                                        </strong>
                                    </td>
                                    <td>
                                        <span class="${b.stockQuantity <= 5 ? 'stock-warning' : ''}">
                                            ${b.stockQuantity}
                                        </span>
                                    </td>
                                    <td>
                                        <c:if test="${b.active}">
                                            <span class="status-active"><i class="fa-solid fa-check"></i> Active</span>
                                        </c:if>
                                        <c:if test="${!b.active}">
                                            <span class="status-hidden"><i class="fa-solid fa-eye-slash"></i>
                                                Hidden</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <a href="edit?id=${b.id}" class="btn-sm btn-edit">
                                            <i class="fa-solid fa-pen"></i> Edit
                                        </a>
                                        <a href="delete?id=${b.id}" class="btn-sm btn-delete"
                                            onclick="return confirm('Are you sure you want to soft-delete this book? It will be hidden from guests.');">
                                            <i class="fa-solid fa-trash"></i> Delete
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

            </body>

            </html>