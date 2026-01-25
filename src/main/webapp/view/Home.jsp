<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        /* CSS cho Admin Overlay (Nếu chưa có trong file css) */
        .admin-overlay {
            background-color: #333; color: white; padding: 10px 20px;
            display: flex; justify-content: space-between; align-items: center;
            font-size: 14px;
        }
        .admin-btn {
            color: #fff; background: #C92127; padding: 5px 15px; 
            text-decoration: none; border-radius: 4px; font-weight: bold;
        }
        .admin-active { margin-top: 0; }
    </style>
</head>

<body class="${sessionScope.user != null && sessionScope.user.role == 1 ? 'admin-active' : ''}">

    <%-- 1. HIỂN THỊ CHẾ ĐỘ ADMIN (Nếu là Role 1) --%>
    <c:if test="${sessionScope.user != null && sessionScope.user.role == 1}">
        <div class="admin-overlay">
            <div class="admin-welcome">
                <i class="fa-solid fa-screwdriver-wrench"></i> &nbsp;
                <strong>Chế độ Quản trị viên</strong> &nbsp;|&nbsp;
                Xin chào, ${sessionScope.user.username} </div>
            <%-- Đảm bảo bạn đã tạo AdminServlet map với /admin/dashboard --%>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-btn">
                Vào trang quản lý <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>
    </c:if>

    <%-- 2. HIỂN THỊ THÔNG BÁO (Thêm vào giỏ hàng thành công/thất bại) --%>
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show" role="alert" 
             style="position: fixed; top: 60px; right: 20px; z-index: 9999; min-width: 300px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
            <i class="fa-solid fa-bell"></i> 
            <strong>Thông báo:</strong> ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <%-- Xóa session ngay để không hiện lại khi F5 --%>
        <c:remove var="message" scope="session" />
        <c:remove var="messageType" scope="session" />
    </c:if>

    <header class="main-header">
        <div class="container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
                    <span style="color: #C92127; font-weight: 900; font-size: 28px;">BOOK</span><span style="color: #333; font-weight: 900; font-size: 28px;">STORE</span>
                </a>
            </div>

            <div class="search-box">
                <form action="search" method="get" style="display: flex; width: 100%; position: relative;">
                    <input type="text" name="txt" placeholder="Tìm kiếm sách, tác giả..." value="${searchKeyword}">
                    <button type="submit" style="position: absolute; right: 0; top: 0; bottom: 0; background: #C92127; border: none; color: white; padding: 0 15px; border-radius: 0 4px 4px 0;">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </form>
            </div>

            <div class="header-icons">
                <div class="icon-item">
                    <i class="fa-regular fa-bell"></i>
                    <span>Thông báo</span>
                </div>

                <a href="${pageContext.request.contextPath}/cart" class="icon-item" style="text-decoration: none; color: inherit;">
                    <i class="fa-solid fa-cart-shopping"></i>
                    <span>Giỏ hàng (${sessionScope.cart != null ? sessionScope.cart.size() : 0})</span>
                </a>

                <div class="icon-item user-account">
                    <i class="fa-regular fa-user"></i>
                    <div class="account-info">
                        <span class="account-label">Tài khoản</span>
                    </div>

                    <div class="dropdown-content">
                        <c:if test="${sessionScope.user == null}">
                            <a href="${pageContext.request.contextPath}/login" class="btn-login">Đăng nhập</a>
                            <a href="${pageContext.request.contextPath}/register" class="btn-register">Đăng ký</a>
                        </c:if>
                        <c:if test="${sessionScope.user != null}">
                            <span class="user-name" style="font-weight: bold; color: #C92127; padding: 0 10px;">
                                ${sessionScope.user.username}
                            </span>
                            <hr>
                            <a href="${pageContext.request.contextPath}/update-profile">Hồ sơ của tôi</a>
                            <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <section class="banner-section container">
         </section>

    <main class="main-content container">
        
        <%-- TRƯỜNG HỢP 1: ĐANG TÌM KIẾM (Có listBooks từ SearchServlet) --%>
        <c:if test="${not empty listBooks}">
            <h2 style="margin-top: 20px; border-left: 4px solid #C92127; padding-left: 10px;">Kết quả tìm kiếm: "${searchKeyword}"</h2>
            <div class="book-list">
                <c:forEach items="${listBooks}" var="b">
                    <div class="book-card">
                        <div class="book-image">
                            <img src="${pageContext.request.contextPath}/assets/image/books/${b.imageUrl}" 
                                 alt="${b.title}" onerror="this.src='https://placehold.co/200x300?text=No+Image'">
                        </div>
                        <div class="book-info">
                            <h3 class="book-title">${b.title}</h3>
                            <p class="book-author">${b.author}</p>
                            <div class="book-price">
                                <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </div>
                            <a href="${pageContext.request.contextPath}/add-to-cart?id=${b.id}" class="btn-buy">
                                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <%-- TRƯỜNG HỢP 2: TRANG CHỦ MẶC ĐỊNH (Dùng randomBooks từ HomeServlet) --%>
        <c:if test="${empty listBooks}">
            <h2 style="margin-top: 20px; border-left: 4px solid #C92127; padding-left: 10px;">Sách Mới Nổi Bật</h2>
            
            <div class="book-list">
                <%-- QUAN TRỌNG: Sửa 'newBooks' thành 'randomBooks' để khớp với Servlet --%>
                <c:forEach items="${newBooks}" var="b">
                    <div class="book-card">
                        <div class="book-image">
                            <img src="${pageContext.request.contextPath}/assets/image/books/${b.imageUrl}" 
                                 alt="${b.title}" onerror="this.src='https://placehold.co/200x300?text=No+Image'">
                        </div>
                        
                        <div class="book-info">
                            <h3 class="book-title">${b.title}</h3>
                            <p class="book-author">${b.author}</p>
                            
                            <div class="book-price">
                                <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </div>
                            
                            <a href="${pageContext.request.contextPath}/add-to-cart?id=${b.id}" class="btn-buy">
                                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
