<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách Khách hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
</head>
<body>
    <div class="container">
        <div>
            <a href="${pageContext.request.contextPath}/home" class="btn-back">
                <i class="fa-solid fa-arrow-left"></i> Quay lại Trang chủ
            </a>
        </div>
        
        <h2><i class="fa-solid fa-users"></i> Hỗ trợ Khách hàng</h2>
        <p>Danh sách thông tin liên hệ để xác nhận đơn hàng hoặc giải quyết khiếu nại.</p>

        <div class="search-box">
            <form action="${pageContext.request.contextPath}/staff/customers" method="get" class="search-form">
                <input type="text" name="keyword" value="${keyword}" placeholder="Nhập tên hoặc email/sđt..." class="search-input">
                <button type="submit" class="btn-search">
                    <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
                </button>
                <a href="${pageContext.request.contextPath}/staff/customers" class="btn-reset">Làm mới</a>
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Họ và Tên</th>
                    <th>Thông tin liên hệ</th>
                    <th>Địa chỉ giao hàng</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${listCustomers}" var="u">
                    <tr>
                        <td>${u.id}</td>
                        <td>
                            <strong>${u.fullname}</strong><br>
                            <small style="color: #888;">@${u.username}</small>
                        </td>
                        <td>
                            <div class="contact-info">
                                <i class="fa-solid fa-envelope"></i> ${u.email} <br>
                                <c:choose>
                                    <c:when test="${not empty u.phone_number}">
                                        <span style="color: #333;"><i class="fa-solid fa-phone"></i> ${u.phone_number}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #999;">(Chưa có SĐT)</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty u.address}">${u.address}</c:when>
                                <c:otherwise><span style="color:#999">Chưa cập nhật</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${u.status == 1}">
                                    <span class="status-active"><i class="fa-solid fa-check-circle"></i> Hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-block"><i class="fa-solid fa-times-circle"></i> Đã khóa</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="https://mail.google.com/mail/?view=cm&fs=1&to=${u.email}" target="_blank" class="btn-mail">
                                <i class="fa-solid fa-paper-plane"></i> Gửi Mail
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>