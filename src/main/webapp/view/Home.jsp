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

        <body class="${sessionScope.user != null && sessionScope.user.role == 1 ? 'admin-active' : ''}">

            <c:if test="${sessionScope.user != null && sessionScope.user.role == 1}">
                <div class="admin-overlay">
                    <div class="admin-welcome">
                        <i class="fa-solid fa-screwdriver-wrench"></i> &nbsp;
                        <strong>Chế độ Quản trị viên</strong> &nbsp;|&nbsp;
                        Xin chào, ${sessionScope.user.fullname}
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-btn">
                        Vào trang quản lý <i class="fa-solid fa-arrow-right"></i>
                    </a>
                </div>
            </c:if>
            <header class="main-header">
                <div class="container">

                    <div class="logo">
                        <a href="${pageContext.request.contextPath}/home">
                            <span style="color: #C92127; font-weight: 900; font-size: 28px;">BOOK</span>STORE
                        </a>
                    </div>

                    <div class="search-box">
                        <form action="search" method="get" style="display: flex; width: 100%;">
                            <input type="text" name="txt" placeholder="Tìm kiếm sách, tác giả..."
                                value="${searchKeyword}">
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
                                    <span
                                        style="color: #C92127; font-weight: bold;">${sessionScope.user.username}</span>
                                    <small><a href="${pageContext.request.contextPath}/logout">Đăng xuất</a></small>
                                </c:if>
                            </div>
                        </div>

                    </div>
                </div>
            </header>

            <main class="main-content container">

                <c:if test="${not empty searchKeyword}">
                    <h2>Kết quả tìm kiếm cho: "${searchKeyword}"</h2>
                    <div class="product-grid">
                        <c:forEach items="${listBooks}" var="b">
                            <div class="product-card">
                                <a href="detail?id=${b.id}">
                                    <img src="${pageContext.request.contextPath}/assets/image/${b.image}"
                                        alt="${b.title}">
                                </a>

                                <c:if test="${!b.active && sessionScope.user.role == 1}">
                                    <span class="badge-hidden">[HIDDEN]</span>
                                </c:if>

                                <h3><a href="detail?id=${b.id}">${b.title}</a></h3>
                                <p>${b.price} USD</p>
                            </div>
                        </c:forEach>
                    </div>
                    <hr>
                </c:if>

                <h2 style="margin-top: 20px;">Sách Mới (New Arrivals)</h2>
                <div class="product-grid" style="display: flex; gap: 20px;">
                    <c:forEach items="${newBooks}" var="b">
                        <div class="product-card">
                            <a href="detail?id=${b.id}">
                                <img src="${pageContext.request.contextPath}/assets/image/${b.image}" width="150px">
                            </a>
                            <h3><a href="detail?id=${b.id}">${b.title}</a></h3>
                            <p style="color: #C92127; font-weight: bold;">$${b.price}</p>
                        </div>
                    </c:forEach>
                </div>

                <h2 style="margin-top: 40px;">Sách Bán Chạy (Best Sellers)</h2>
                <div class="product-grid" style="display: flex; gap: 20px;">
                    <c:forEach items="${bestBooks}" var="b">
                        <div class="product-card">
                            <a href="detail?id=${b.id}">
                                <img src="${pageContext.request.contextPath}/assets/image/${b.image}" width="150px">
                            </a>
                            <h3><a href="detail?id=${b.id}">${b.title}</a></h3>
                            <p style="color: #C92127; font-weight: bold;">$${b.price}</p>
                        </div>
                    </c:forEach>
                </div>

            </main>

        </body>

        </html>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
                <a href="${pageContext.request.contextPath}/home">
                    <span style="color: #C92127; font-weight: 900; font-size: 28px;">BOOK</span>STORE
                </a>
            </div>

            <div class="search-box">
                <input type="text" placeholder="Tìm kiếm sách, tác giả...">
                <button><i class="fa-solid fa-magnifying-glass"></i></button>
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
        <span class="account-label">Tài khoản</span>
    </div>

    <div class="dropdown-content">
        <c:if test="${sessionScope.user == null}">
            <a href="${pageContext.request.contextPath}/login" class="btn-login">Đăng nhập</a>
            <a href="${pageContext.request.contextPath}/register" class="btn-register">Đăng ký</a>
        </c:if>
        <c:if test="${sessionScope.user != null}">
            <span class="user-name">${sessionScope.user.username}</span>
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
        <div class="banner-top">
            <div class="banner-left">
                <img src="${pageContext.request.contextPath}/assets/image/Banner/Screenshot 2026-01-19 150229.png" alt="Banner Chính">
            </div>
            <div class="banner-right">
                <img src="https://cdn0.fahasa.com/media/wysiwyg/Thang-01-2024/VPP_T124_392x156.jpg" alt="Banner Phụ 1">
                <img src="https://cdn0.fahasa.com/media/wysiwyg/Thang-01-2024/Manga_T124_392x156.jpg" alt="Banner Phụ 2">
            </div>
        </div>

        <div class="banner-bottom">
<img src="https://cdn0.fahasa.com/media/wysiwyg/Thang-01-2024/TanViet_T124_Banner_Small_310x210.jpg" alt="Small 1">
            <img src="https://cdn0.fahasa.com/media/wysiwyg/Thang-01-2024/DinhTi_T124_Banner_Small_310x210.jpg" alt="Small 2">
            <img src="https://cdn0.fahasa.com/media/wysiwyg/Thang-01-2024/ZenBooks_T124_Banner_Small_310x210.jpg" alt="Small 3">
            <img src="https://cdn0.fahasa.com/media/wysiwyg/Thang-01-2024/McBooks_T124_Banner_Small_310x210.jpg" alt="Small 4">
        </div>
    </section>

    <main class="main-content container">
        <h2 style="margin-top: 20px; border-left: 4px solid #C92127; padding-left: 10px;">Sách Mới Nổi Bật</h2>
        
        <div class="book-list">
            
            <c:forEach items="${randomBooks}" var="b">
                <div class="book-card">
                    <div class="book-image">
                        <img src="${pageContext.request.contextPath}/assets/image/books/${b.imageUrl}" alt="${b.title}">
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

        <c:if test="${sessionScope.user != null}">...</c:if>
    </main>

</body>
</html>
