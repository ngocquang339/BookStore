<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đánh giá</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* CSS đơn giản cho bảng */
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #f4f4f4; }
        .btn-delete { color: white; background: red; padding: 5px 10px; text-decoration: none; border-radius: 4px; }
    </style>
</head>
<body>

    <div class="container">
        <h2><i class="fa-solid fa-comments"></i> Quản lý Bình luận & Đánh giá</h2>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Khách hàng</th>
                    <th>Sách</th>
                    <th>Điểm</th>
                    <th>Nội dung</th>
                    <th>Ngày đăng</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${listReviews}" var="r">
                    <tr>
                        <td>${r.id}</td>
                        <td style="font-weight: bold; color: #007bff;">${r.userName}</td>
                        <td>${r.bookTitle}</td>
                        <td>
                            <span style="color: gold;">
                                <c:forEach begin="1" end="${r.rating}">★</c:forEach>
                            </span> 
                            (${r.rating})
                        </td>
                        <td>${r.comment}</td>
                        <td>${r.createAt}</td>
                        <td>
                            <a href="delete-review?id=${r.id}" 
                               class="btn-delete"
                               onclick="return confirm('Bạn có chắc muốn xóa bình luận này?');">
                                <i class="fa-solid fa-trash"></i> Xóa
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <c:if test="${empty listReviews}">
            <p style="text-align: center; margin-top: 20px;">Chưa có đánh giá nào.</p>
        </c:if>
    </div>

</body>
</html>