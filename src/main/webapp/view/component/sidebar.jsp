<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<% 
    String currentPath = request.getServletPath(); 
%>

<div class="sidebar-wrapper"> 
    <div class="user-info-box">
        <div class="avatar-container">
            <img src="https://ui-avatars.com/api/?name=${sessionScope.user.username}&background=ddd&color=555&size=128&bold=true" 
                 alt="Avatar" class="avatar-img">
        </div>
        
        <div class="user-display-name">${sessionScope.user.username}</div>
        
        <div class="membership-badge">
            ${sessionScope.user.role == 1 ? "Admin" : "Thành viên Bạc"}
        </div>
        
        <div class="f-point">F-Point tích lũy: 0</div>
        <div class="upgrade-note">Thêm 30.000 để nâng hạng Vàng</div>
    </div>

    <div class="sidebar-menu">
        
        <div style="font-weight: bold; color: #C92127; padding: 10px 15px; display: flex; align-items: center; gap: 10px;">
            <i class="fa-regular fa-user"></i> Tài khoản
        </div>

        <a href="${pageContext.request.contextPath}/update-profile" 
           class="menu-item <%= currentPath.contains("UserProfile") || currentPath.contains("update-profile") ? "active" : "" %>">
            <span style="margin-left: 30px;">Hồ sơ cá nhân</span>
        </a>

        <a href="#" class="menu-item"> <span style="margin-left: 30px;">Sổ địa chỉ</span>
        </a>

        <a href="${pageContext.request.contextPath}/change-password" 
           class="menu-item <%= currentPath.contains("changePassword") || currentPath.contains("change-password") ? "active" : "" %>">
            <span style="margin-left: 30px;">Đổi mật khẩu</span>
        </a>

        <hr style="margin: 10px 0; border-top: 1px solid #eee;">

        <a href="${pageContext.request.contextPath}/orders" 
           class="menu-item <%= currentPath.contains("Order") || currentPath.contains("orders") ? "active" : "" %>">
            <i class="fa-solid fa-receipt"></i> Đơn hàng của tôi
        </a>
        
        <a href="#" class="menu-item">
            <i class="fa-solid fa-ticket"></i> Ví Voucher <span style="background:red; color:white; font-size:10px; padding: 2px 5px; border-radius:10px; margin-left:5px;">18</span>
        </a>

        <a href="${pageContext.request.contextPath}/logout" class="menu-item" style="color: #666;">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</div>