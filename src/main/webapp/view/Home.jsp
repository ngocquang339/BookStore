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
                        <c:if test="${sessionScope.user == null}">
                           <a href="${pageContext.request.contextPath}/login" class="account-link">
                               <span>Đăng nhập</span>
                           </a>
                        </c:if>
                        <c:if test="${sessionScope.user != null}">
                            <span style="color: #C92127; font-weight: bold;">${sessionScope.user.username}</span>
                            <small><a href="${pageContext.request.contextPath}/update-profile">Hồ sơ</a></small>
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
        <p>Khu vực hiển thị danh sách sản phẩm...</p>
        
        <c:if test="${sessionScope.user != null}">
            <div style="background: #e1f7d5; padding: 10px; margin-top: 10px; border-radius: 5px;">
                Chào mừng <b>${sessionScope.user.username}</b> đã quay trở lại!
            </div>
        </c:if>
    </main>

</body>
</html>