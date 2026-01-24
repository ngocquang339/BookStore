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
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

    <%-- ========================================== --%>
    <%-- KHỐI HIỂN THỊ THÔNG BÁO (FLASH MESSAGE)    --%>
    <%-- ========================================== --%>
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show" role="alert" 
             style="position: fixed; top: 20px; right: 20px; z-index: 9999; min-width: 320px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
            
            <i class="fa-solid fa-bell"></i> 
            <strong>Thông báo:</strong> ${sessionScope.message}
            
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>

        <%-- QUAN TRỌNG: Xóa session ngay sau khi hiển thị để không hiện lại khi F5 --%>
        <c:remove var="message" scope="session" />
        <c:remove var="messageType" scope="session" />
    </c:if>
    <%-- ========================================== --%>


    <header class="main-header">
        <div class="container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
                    <span style="color: #C92127; font-weight: 900; font-size: 28px;">BOOK</span>
                    <span style="color: #333; font-weight: 900; font-size: 28px;">STORE</span>
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

                <a href="${pageContext.request.contextPath}/cart" class="icon-item" style="text-decoration: none; color: inherit;">
                    <i class="fa-solid fa-cart-shopping"></i>
                    <span>Giỏ hàng (${sessionScope.cart != null ? sessionScope.cart.size() : 0})</span>
                </a>

                <div class="icon-item user-account">
                    <i class="fa-regular fa-user"></i>
                    <div class="account-info">
                        <c:if test="${sessionScope.user == null}">
                           <a href="${pageContext.request.contextPath}/login" style="text-decoration: none; color: inherit;">
                                <span>Tài khoản</span>
                           </a>
                        </c:if>
                        <c:if test="${sessionScope.user != null}">
                            <span style="color: #C92127; font-weight: bold;">${sessionScope.user.username}</span>
                            <small><a href="${pageContext.request.contextPath}/logout" style="text-decoration: none; color: #555;">Đăng xuất</a></small>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <section class="banner-section container">
        </section>

    <main class="main-content container">
        <h2 style="margin-top: 20px; border-left: 4px solid #C92127; padding-left: 10px;">Sách Mới Nổi Bật</h2>
        
        <div class="book-list">
            <c:forEach items="${randomBooks}" var="b">
                <div class="book-card">
                    <div class="book-image">
                        <img src="${pageContext.request.contextPath}/assets/image/books/${b.imageUrl}" 
                             alt="${b.title}"
                             onerror="this.src='https://placehold.co/200x300?text=No+Image'">
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
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
