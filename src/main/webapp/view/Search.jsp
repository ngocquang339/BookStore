<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả tìm kiếm</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/search.css">

    <style>
        .product-card {
            position: relative; /* Needed to position the badge */
            transition: transform 0.2s;
        }
        
        /* Style for the Hidden Badge */
        .badge-hidden {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: #dc3545; /* Red color */
            color: white;
            font-size: 12px;
            font-weight: bold;
            padding: 5px 10px;
            border-radius: 4px;
            z-index: 10;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        /* Dim the card slightly if it is hidden */
        .card-inactive {
            opacity: 0.75;
            border: 1px dashed #999 !important; /* Dashed border to indicate 'draft/hidden' status */
            background-color: #f8f9fa;
        }
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
            <div style="margin-left: auto;">
                <a href="${pageContext.request.contextPath}/home" style="text-decoration: none; color: #333; font-weight: bold;">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại trang chủ
                </a>
            </div>
        </div>
    </header>

    <main class="container">
        
        <div class="search-container">
            <form action="search" method="get">
                <input type="text" name="txt" value="${txtS}" placeholder="Nhập tên sách, tác giả bạn muốn tìm...">
                <button type="submit">Tìm kiếm</button>
            </form>
        </div>

        <h3 style="border-bottom: 2px solid #C92127; padding-bottom: 10px; display: inline-block;">
            Kết quả cho từ khóa: <span style="color: #C92127">"${txtS}"</span>
        </h3>

        <c:if test="${empty listBooks}">
            <div class="empty-message">
                <i class="fa-regular fa-face-frown-open" style="font-size: 60px; color: #ccc; margin-bottom: 20px;"></i>
                <p>Rất tiếc, chúng tôi không tìm thấy cuốn sách nào khớp với yêu cầu của bạn.</p>
            </div>
        </c:if>

        <div class="product-list">
            <c:forEach items="${listBooks}" var="b">
                <div class="product-card ${!b.active ? 'card-inactive' : ''}">
                    
                    <c:if test="${!b.active}">
                        <div class="badge-hidden">
                            <i class="fa-solid fa-eye-slash"></i> Hidden
                        </div>
                    </c:if>

                    <a href="detail?pid=${b.id}" style="text-decoration: none; color: inherit;">
                        <img src="${pageContext.request.contextPath}/assets/image/books/${b.imageUrl}" alt="${b.title}">
                        <h4>${b.title}</h4>
                        <p style="color: #666; font-size: 14px;">${b.author}</p>
                        <p style="color: #C92127; font-weight: bold; font-size: 18px;">
                            <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </p>
                    </a>
                </div>
            </c:forEach>
        </div>

    </main>

</body>
</html>