<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách Khách hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { font-family: sans-serif; background-color: #f9f9f9; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { color: #333; border-bottom: 2px solid #C92127; padding-bottom: 10px; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f4f4f4; font-weight: bold; }
        tr:hover { background-color: #f1f1f1; }
        
        .status-active { color: green; font-weight: bold; }
        .status-block { color: red; font-weight: bold; }
        
        .contact-info { font-size: 14px; color: #555; }
        .btn-call { display: inline-block; padding: 5px 10px; color: white; text-decoration: none; border-radius: 4px; font-size: 12px; margin-bottom: 5px; width: 85px; text-align: center; }
        
        /* CSS cho thanh tìm kiếm */
        .search-box { margin-bottom: 20px; background: #f4f4f4; padding: 15px; border-radius: 5px; border: 1px solid #ddd; }
        .search-input { flex: 1; padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        .btn-search { background: #C92127; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; }
        .btn-reset { background: #6c757d; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="container">
        <h2><i class="fa-solid fa-users"></i> Hỗ trợ Khách hàng</h2>
        <p>Danh sách thông tin liên hệ để xác nhận đơn hàng hoặc giải quyết khiếu nại.</p>

        <div class="search-box">
            <form action="${pageContext.request.contextPath}/staff/customers" method="get" style="display: flex; gap: 10px;">
                <input type="text" name="keyword" value="${keyword}" placeholder="Nhập tên hoặc email/sđt..." class="search-input">
                <button type="submit" class="btn-search">
                    <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
                </button>
                <a href="${pageContext.request.contextPath}/staff/customers" class="btn-reset">
                    Làm mới
                </a>
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
                                <c:when test="${not empty u.address}">
                                    ${u.address}
                                </c:when>
                                <c:otherwise>
                                    <span style="color:#999">Chưa cập nhật</span>
                                </c:otherwise>
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
                            <a href="mailto:${u.email}" class="btn-call" style="background: #007bff;">
                                <i class="fa-solid fa-paper-plane"></i> Gửi Mail
                            </a><br>
                            
                            <c:choose>
                                <c:when test="${u.status == 1}">
                                    <a href="${pageContext.request.contextPath}/staff/customers?action=toggleStatus&id=${u.id}&status=${u.status}" 
                                       class="btn-call" style="background: #dc3545;"
                                       onclick="return confirm('Khóa tài khoản khách hàng này?');">
                                        <i class="fa-solid fa-lock"></i> Khóa
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/staff/customers?action=toggleStatus&id=${u.id}&status=${u.status}" 
                                       class="btn-call" style="background: #28a745;"
                                       onclick="return confirm('Mở khóa cho khách hàng này?');">
                                        <i class="fa-solid fa-unlock"></i> Mở khóa
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>