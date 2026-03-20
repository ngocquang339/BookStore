<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
            <span style="margin-left: 20px;"><i class="fa-regular fa-address-card fa-fw me-1"></i> Hồ sơ cá nhân</span>
        </a>

        <a href="${pageContext.request.contextPath}/address" 
           class="menu-item <%= currentPath.contains("address") ? "active" : "" %>"> 
            <span style="margin-left: 20px;"><i class="fa-solid fa-location-dot fa-fw me-1"></i> Sổ địa chỉ</span>
        </a>

        <a href="${pageContext.request.contextPath}/change-password" 
           class="menu-item <%= currentPath.contains("ChangePassword") || currentPath.contains("change-password") ? "active" : "" %>">
            <span style="margin-left: 20px;"><i class="fa-solid fa-lock fa-fw me-1"></i> Đổi mật khẩu</span>
        </a>

        <hr style="margin: 10px 0; border-top: 1px solid #eee;">

        <a href="${pageContext.request.contextPath}/my-orders" 
        class="menu-item <%= currentPath.toLowerCase().contains("order") ? "active" : "" %>">
            <i class="fa-solid fa-receipt"></i> Đơn hàng của tôi
        </a>
        
        <a href="${pageContext.request.contextPath}/user/voucher-wallet" 
           class="menu-item <%= currentPath.contains("voucher") ? "active" : "" %>">
            <i class="fa-solid fa-ticket"></i> Ví Voucher <span style="background:red; color:white; font-size:10px; padding: 2px 5px; border-radius:10px; margin-left:5px;">18</span>
        </a>

        <a href="${pageContext.request.contextPath}/my-collections" 
           class="menu-item <%= currentPath.contains("collection") ? "active" : "" %>">
            <i class="fa-solid fa-bookmark"></i> Bộ sưu tập của tôi <span style="background:red; color:white; font-size:10px; padding: 2px 5px; border-radius:10px; margin-left:5px;">18</span>
        </a>

        <a href="${pageContext.request.contextPath}/support" 
           class="menu-item <%= currentPath.contains("support") ? "active" : "" %>">
            <i class="fa-solid fa-headset"></i> Trung tâm Hỗ trợ
        </a>

        <a href="${pageContext.request.contextPath}/notifications" 
           class="menu-item <%= currentPath.contains("notifications") ? "active" : "" %>">
            <i class="fa-regular fa-bell"></i> Thông báo của tôi
        </a>
        
        <a href="${pageContext.request.contextPath}/my-comments" 
           class="menu-item <%= currentPath.contains("my-comments") ? "active" : "" %>">
            <i class="fa-regular fa-comment-dots"></i> Bình luận của tôi
        </a>

        <a href="${pageContext.request.contextPath}/my-wallet" 
           class="menu-item <%= currentPath.contains("my-wallet") ? "active" : "" %>">
            <%-- Icon luôn màu xám như các mục khác --%>
            <i class="fa-solid fa-wallet text-secondary"></i> Ví BookStore 
            
            <%-- Cục đỏ hiển thị số dư --%>
            <span style="background: #C92127; color: white; font-size: 11px; padding: 2px 6px; border-radius: 10px; margin-left: auto; font-weight: bold;">
                <c:choose>
                    <%-- Nếu có số dư > 0 thì format hiển thị --%>
                    <c:when test="${sessionScope.user.walletBalance != null && sessionScope.user.walletBalance > 0}">
                        <fmt:formatNumber value="${sessionScope.user.walletBalance}" pattern="#,###"/>đ
                    </c:when>
                    <%-- Nếu rỗng hoặc = 0 thì in cứng 0đ --%>
                    <c:otherwise>0đ</c:otherwise>
                </c:choose>
            </span>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="menu-item" style="color: #666;">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> Đăng xuất
        </a>
    </div>
</div>