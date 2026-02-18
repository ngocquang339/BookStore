<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đánh giá</title>
    <style>
        body { font-family: sans-serif; padding: 20px; background: #f4f6f9; }
        .container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        h2 { color: #C92127; border-bottom: 2px solid #ddd; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background: #333; color: white; }
        .btn-delete { background: red; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px; font-size: 12px; }
        .star { color: gold; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Quản lý Đánh giá (Review Management)</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Khách hàng</th>
                    <th>Sách</th>
                    <th>Điểm</th>
                    <th>Nội dung bình luận</th>
                    <th>Ngày đăng</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${listReviews}" var="r">
                    <tr>
                        <td>${r.reviewId}</td>
                        <td><strong>${r.username}</strong></td>
                        <td>${r.bookTitle}</td>
                        <td class="star">${r.rating} ★</td>
                        <td>${r.comment}</td>
                        <td>${r.createAt}</td>
                        <td>
                            <a href="delete-review?id=${r.reviewId}" 
                               class="btn-delete"
                               onclick="return confirm('Bạn có chắc muốn xóa bình luận này?');">
                               Xóa
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <c:if test="${empty listReviews}">
            <p style="text-align: center; color: #666; margin-top: 20px;">Chưa có đánh giá nào.</p>
        </c:if>
    </div>
</body>
</html>