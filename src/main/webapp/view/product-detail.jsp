<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${book.title} - BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product-detail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* CSS for the Admin Internal Data Box */
        .admin-inspector {
            background-color: #fff3cd; /* Yellow warning color */
            border: 1px solid #ffeeba;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            color: #856404;
        }
        .admin-inspector h4 { margin-top: 0; display: flex; align-items: center; gap: 10px; }
        .edit-btn {
            background-color: #ffc107;
            color: #000;
            padding: 5px 10px;
            text-decoration: none;
            font-size: 14px;
            border-radius: 4px;
            font-weight: bold;
        }
        .edit-btn:hover { background-color: #e0a800; }
    </style>
</head>
<body>

    <header class="main-header">
        <div class="container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/home">
                    <span style="color: #C92127; font-weight: 900; font-size: 28px;">BOOK</span>STORE
                </a>
            </div>
            <a href="home" style="color: #333; text-decoration: none;">
                <i class="fa-solid fa-arrow-left"></i> Tiếp tục mua sắm
            </a>
        </div>
    </header>

    <main class="container" style="margin-top: 30px;">
        <div class="product-detail-container" style="display: flex; gap: 40px;">
            
            <div class="product-image" style="flex: 1;">
                <img src="${pageContext.request.contextPath}/assets/image/${book.image}" 
                     alt="${book.title}" style="width: 100%; max-width: 400px; border: 1px solid #ddd;">
            </div>

            <div class="product-info" style="flex: 1.5;">
                
                <c:if test="${sessionScope.user != null && sessionScope.user.role == 1}">
                    <div class="admin-inspector">
                        <h4>
                            <i class="fa-solid fa-user-secret"></i> Internal Data (Admin Only)
                            <a href="${pageContext.request.contextPath}/admin/product/edit?id=${book.id}" class="edit-btn">
                                <i class="fa-solid fa-pen"></i> Quick Edit
                            </a>
                        </h4>
                        <ul>
                            <li><strong>Import Price:</strong> $${book.importPrice}</li>
                            <li><strong>Publisher:</strong> ${book.publisher} (Proxy for Supplier)</li>
                            <li><strong>Stock Status:</strong> ${book.stockQuantity} units left</li>
                            <li><strong>Visibility:</strong> ${book.active ? 'Public' : 'Hidden'}</li>
                        </ul>
                    </div>
                </c:if>
                <h1 style="font-size: 28px; margin-bottom: 10px;">${book.title}</h1>
                <p style="color: #666;">Tác giả: <strong>${book.author}</strong></p>
                
                <h2 style="color: #C92127; font-size: 32px; margin: 20px 0;">
                    $${book.price}
                </h2>

                <p class="description" style="line-height: 1.6; color: #555;">
                    ${book.description}
                </p>

                <div class="actions" style="margin-top: 30px;">
                    <c:choose>
                        
                        <%-- Case 1: Out of Stock (Guest) --%>
                        <c:when test="${book.stockQuantity <= 0 && (sessionScope.user == null || sessionScope.user.role != 1)}">
                            <button disabled style="background: #ccc; cursor: not-allowed; padding: 15px 30px; border: none; font-size: 16px;">
                                Tạm hết hàng (Out of Stock)
                            </button>
                        </c:when>

                        <%-- Case 2: Out of Stock but user is ADMIN (Happy Case 2) --%>
                        <c:when test="${book.stockQuantity <= 0 && sessionScope.user.role == 1}">
                            <button style="background: #007bff; color: white; padding: 15px 30px; border: none; cursor: pointer;">
                                Test Add to Cart (Admin Mode)
                            </button>
                            <span style="color: red; font-size: 12px; display: block; margin-top: 5px;">
                                *Stock is 0, but visible for testing
                            </span>
                        </c:when>

                        <%-- Case 3: In Stock (Normal) --%>
                        <c:otherwise>
                            <form action="cart" method="post">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="id" value="${book.id}">
                                <input type="number" name="quantity" value="1" min="1" max="${book.stockQuantity}" style="padding: 10px; width: 60px;">
                                <button type="submit" style="background: #C92127; color: white; padding: 15px 30px; border: none; cursor: pointer; font-weight: bold;">
                                    <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
                                </button>
                            </form>
                        </c:otherwise>

                    </c:choose>
                </div>
            </div>
        </div>
    </main>

</body>
</html>