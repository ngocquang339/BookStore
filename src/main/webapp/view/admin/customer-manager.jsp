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
        .btn-call { display: inline-block; padding: 5px 10px; background: #28a745; color: white; text-decoration: none; border-radius: 4px; font-size: 12px; }
    </style>
</head>
<body>

    <div class="container">
        <h2><i class="fa-solid fa-users"></i> Hỗ trợ Khách hàng</h2>
        <p>Danh sách thông tin liên hệ để xác nhận đơn hàng hoặc giải quyết khiếu nại.</p>
        
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
                            <strong>${u.fullname != null ? u.fullname : u.username}</strong><br>
                            <small style="color: #888;">@${u.username}</small>
                        </td>
                        <td>
                            <div class="contact-info">
                                <i class="fa-solid fa-envelope"></i> ${u.email} <br>
                                <c:if test="${not empty u.phone_number}">
                                    <i class="fa-solid fa-phone"></i> 
                                    <span style="color: #C92127; font-weight: bold;">${u.phone_number}</span>
                                </c:if>
                                <c:if test="${empty u.phone_number}">
                                    <span style="color: #999;">(Chưa có SĐT)</span>
                                </c:if>
                            </div>
                        </td>
                        <td>
                            ${u.address != null ? u.address : '<span style="color:#999">Chưa cập nhật</span>'}
                        </td>
                        <td>
                            <c:if test="${u.status == 1}">
                                <span class="status-active"><i class="fa-solid fa-check-circle"></i> Hoạt động</span>
                            </c:if>
                            <c:if test="${u.status == 0}">
                                <span class="status-block"><i class="fa-solid fa-ban"></i> Bị khóa</span>
                            </c:if>
                        </td>
                        <td>
                            <a href="mailto:${u.email}" class="btn-call" style="background: #007bff;">
                                <i class="fa-solid fa-paper-plane"></i> Gửi Mail
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <c:if test="${empty listCustomers}">
            <div style="text-align: center; margin-top: 30px; color: #666;">
                Chưa có khách hàng nào trong hệ thống.
            </div>
        </c:if>
    </div>

</body>
</html>