<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hỗ trợ khách hàng</title>
    <style>
        body { font-family: sans-serif; padding: 20px; background: #f4f6f9; }
        .container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { color: #C92127; border-bottom: 2px solid #ddd; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background: #333; color: white; }
        .info-link { color: #007bff; text-decoration: none; font-weight: bold; }
        .status-active { color: green; font-weight: bold; }
        .status-blocked { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Danh sách Khách hàng (Staff Support)</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên khách hàng</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Địa chỉ</th>
                    <th>Trạng thái</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${listCustomers}" var="u">
                    <tr>
                        <td>${u.id}</td>
                        <td>
                            ${u.fullname}<br>
                            <small style="color: #666">(@${u.username})</small>
                        </td>
                        <td><a href="mailto:${u.email}" class="info-link">${u.email}</a></td>
                        <td style="color: #C92127; font-weight: bold;">${u.phone_number}</td>
                        <td>${u.address}</td>
                        <td>
                            <c:if test="${u.status == 1}"><span class="status-active">Hoạt động</span></c:if>
                            <c:if test="${u.status == 0}"><span class="status-blocked">Đã khóa</span></c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>