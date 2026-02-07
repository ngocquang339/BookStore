<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ của ${sessionScope.user.username} - BookStore</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>

<body>
    
    <%-- 1. HEADER (Copy từ trang khác sang hoặc dùng include) --%>
    <header class="main-header">
        <div class="container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
                    <span style="color: #C92127; font-weight: 900; font-size: 28px;">BOOK</span><span style="color: #333; font-weight: 900; font-size: 28px;">STORE</span>
                </a>
            </div>
            <a href="${pageContext.request.contextPath}/home" style="color: #333; text-decoration: none; font-weight: 500;">
                <i class="fa-solid fa-arrow-left"></i> Quay lại trang chủ
            </a>
        </div>
    </header>

    <%-- CHECK SESSION --%>
    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>

    <%-- 2. MAIN CONTENT --%>
    <div class="profile-wrapper">
        
        <%-- CỘT TRÁI: SIDEBAR --%>
        <div class="profile-sidebar">
            <div class="avatar-container">
                <%-- Ảnh đại diện mặc định --%>
                <img src="https://ui-avatars.com/api/?name=${sessionScope.user.username}&background=ffebee&color=C92127&size=128" 
                     alt="Avatar" class="avatar-img">
            </div>
            
            <div class="user-display-name">${sessionScope.user.username}</div>
            <div class="user-role">
                ${sessionScope.user.role == 1 ? "Quản trị viên" : "Khách hàng thân thiết"}
            </div>

            <div class="sidebar-menu">
                <a href="#" class="menu-item active">
                    <i class="fa-regular fa-id-card"></i> Thông tin tài khoản
                </a>
                <a href="#" class="menu-item">
                    <i class="fa-solid fa-clock-rotate-left"></i> Lịch sử đơn hàng
                </a>
                <a href="#" class="menu-item">
                    <i class="fa-solid fa-key"></i> Đổi mật khẩu
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="menu-item" style="color: #d63031;">
                    <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                </a>
            </div>
        </div>

        <%-- CỘT PHẢI: FORM EDIT --%>
        <div class="profile-content">
            <div class="content-header">
                <h2>Cài đặt thông tin</h2>
                <span style="font-size: 13px; color: #888;">Quản lý thông tin hồ sơ để bảo mật tài khoản</span>
            </div>

            <%-- Thông báo lỗi/thành công --%>
            <c:if test="${not empty message}">
                <div style="padding: 10px; background: #e8f5e9; color: #2e7d32; border-radius: 6px; margin-bottom: 20px; font-size: 14px;">
                    <i class="fa-solid fa-check-circle"></i> ${message}
                </div>
                <c:remove var="message" scope="session"/>
            </c:if>

            <form action="${pageContext.request.contextPath}/update-profile" method="post">
                <div class="form-grid">
                    
                    <%-- Username (Thường không cho sửa, nên để readonly) --%>
                    <div class="form-group">
                        <label>Tên đăng nhập</label>
                        <input type="text" name="username" value="${sessionScope.user.username}" readonly title="Không thể thay đổi tên đăng nhập">
                    </div>

                    <%-- Email --%>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" value="${sessionScope.user.email}" required>
                    </div>

                    <%-- Phone Number --%>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input type="text" name="phone_number" value="${sessionScope.user.phone_number}" placeholder="Chưa cập nhật">
                    </div>

                    <%-- Fullname (Thêm trường này nếu DB có) --%>
                    <div class="form-group">
                        <label>Họ và tên</label>
                        <input type="text" name="fullname" value="${sessionScope.user.fullname}" placeholder="Chưa cập nhật">
                    </div>

                    <%-- Address (Chiếm 2 cột) --%>
                    <div class="form-group full-width">
                        <label>Địa chỉ nhận hàng</label>
                        <input type="text" name="address" value="${sessionScope.user.address}" placeholder="Nhập địa chỉ của bạn...">
                    </div>
                </div>

                <div style="margin-top: 20px; overflow: hidden;">
                    <button type="submit" class="btn-save">
                        <i class="fa-regular fa-floppy-disk"></i> Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>

</body>
</html>