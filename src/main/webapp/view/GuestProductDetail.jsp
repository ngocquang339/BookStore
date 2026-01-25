<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${book.title} - Chi tiết sản phẩm</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/guest-detail.css">
</head>

<body>
    <header class="main-header">
        <div class="container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/home">
                    <span style="color: #C92127; font-weight: 900; font-size: 28px;">BOOK</span>STORE
                </a>
            </div>
             <div style="margin-left: auto;">
                <a href="javascript:history.back()" style="text-decoration: none; color: #333;">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại
                </a>
            </div>
        </div>
    </header>

    <main class="container">
        <div class="detail-container">
            <div class="detail-left">
                <img src="${empty book.imageUrl ? 'https://via.placeholder.com/300x450' : pageContext.request.contextPath.concat('/assets/image/books/').concat(book.imageUrl)}" 
                     alt="${book.title}">
            </div>

            <div class="detail-right">
                <h1 class="book-title-large">${book.title}</h1>
                <div class="book-meta">
                    Tác giả: <strong>${book.author}</strong> | Mã sách: #${book.id}
                </div>

                <div class="book-price-large">
                    <fmt:formatNumber value="${book.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                </div>

                <div>
                    <c:choose>
                        <c:when test="${book.stockQuantity > 0}">
                            <span class="stock-status in-stock">
                                <i class="fa-solid fa-check"></i> Còn hàng
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="stock-status out-stock">
                                <i class="fa-solid fa-xmark"></i> Hết hàng
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:if test="${book.stockQuantity > 0}">
                    <a href="add-to-cart?id=${book.id}&quantity=1" class="btn-add-cart-large">
                        <i class="fa-solid fa-cart-shopping"></i> Thêm vào giỏ
                    </a>
                </c:if>

                <div class="description-box">
                    <h3>Giới thiệu nội dung:</h3>
                    <p>${empty book.description ? 'Đang cập nhật nội dung...' : book.description}</p>
                </div>
            </div>
        </div>
    </main>
</body>
</html>