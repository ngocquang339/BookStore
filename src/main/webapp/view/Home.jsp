<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

    <header class="main-header">
        <div class="container">
            
            <div class="logo">
                <a href="${pageContext.request.contextPath}/search">
                    <span style="color: #C92127; font-weight: 900; font-size: 28px;">BOOK</span>STORE
                </a>
            </div>

            <div class="search-box">
                <form action="${pageContext.request.contextPath}/search" method="get">
                    <input type="text" name="txt" value="${txtS}" placeholder="Tìm kiếm sách, tác giả...">
                    <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
                </form>
            </div>

            <div class="header-icons">
                <div class="icon-item">
                    <i class="fa-regular fa-bell"></i>
                    <span>Thông báo</span>
                </div>

                <div class="icon-item">
                    <i class="fa-solid fa-cart-shopping"></i>
                    <span>Giỏ hàng</span>
                </div>

                <div class="icon-item user-account">
                    <i class="fa-regular fa-user"></i>
                    <div class="account-info">
                        <c:if test="${sessionScope.user == null}">
                           <a href="${pageContext.request.contextPath}/login" class="account-link">
                                <span>Tài khoản</span>
                           </a>
                        </c:if>

                        <c:if test="${sessionScope.user != null}">
                            <span style="color: #C92127; font-weight: bold;">${sessionScope.user.username}</span>
                            <small><a href="${pageContext.request.contextPath}/logout">Đăng xuất</a></small>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <main class="main-content container">
        
        <c:if test="${sessionScope.user != null}">
            <div style="background: #e1f7d5; padding: 10px; margin-top: 10px; border-radius: 5px;">
                Chào mừng <b>${sessionScope.user.username}</b> đã quay trở lại!
            </div>
        </c:if>

        <h2 style="margin-top: 20px;">Danh sách Sách</h2>
        
        <c:if test="${empty listBooks}">
            <p style="text-align: center; color: gray; margin-top: 20px;">
                Chưa có sản phẩm nào hoặc không tìm thấy kết quả! <br> 
                <a href="${pageContext.request.contextPath}/search">Xem tất cả sách</a>
            </p>
        </c:if>

        <div class="product-list">
            <c:forEach items="${listBooks}" var="b">
                <div class="product-card">
                    <img src="${empty b.imageUrl ? 'https://via.placeholder.com/200x300' : b.imageUrl}" alt="${b.title}">
                    
                    <h3>${b.title}</h3>
                    <p style="font-size: 13px; color: #666;">${b.author}</p>
                    
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 10px;">
                        <span style="color: #C92127; font-weight: bold; font-size: 18px;">${b.price} đ</span>
                        
                        <c:choose>
                            <c:when test="${b.stockQuantity == 0}">
                                <span style="font-size: 12px; color: red; border: 1px solid red; padding: 2px 5px; border-radius: 4px;">Hết hàng</span>
                            </c:when>
                            <c:otherwise>
                                <span style="font-size: 12px; color: green;"><i class="fa-solid fa-check"></i> Còn hàng</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <a href="detail?pid=${b.id}" style="display: block; margin-top: 10px; color: #007bff; text-decoration: none;">Xem chi tiết</a>
                </div>
            </c:forEach>
        </div>

    </main>

</body>
</html>