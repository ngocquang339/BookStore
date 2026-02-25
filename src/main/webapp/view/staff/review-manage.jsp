<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Quản lý Đánh giá</title>
            <style>
                body {
                    font-family: sans-serif;
                    padding: 20px;
                    background: #f4f6f9;
                }

                .container {
                    background: white;
                    padding: 20px;
                    border-radius: 8px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }

                h2 {
                    color: #C92127;
                    border-bottom: 2px solid #ddd;
                    padding-bottom: 10px;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }

                th,
                td {
                    border: 1px solid #ddd;
                    padding: 10px;
                    text-align: left;
                }

                th {
                    background: #333;
                    color: white;
                }

                .btn-delete {
                    background: red;
                    color: white;
                    padding: 5px 10px;
                    text-decoration: none;
                    border-radius: 4px;
                    font-size: 12px;
                }

                .star {
                    color: gold;
                    font-weight: bold;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div style="margin-bottom: 20px;">
    <a href="${pageContext.request.contextPath}/home" style="color: #4da6ff; text-decoration: none; font-size: 16px; font-weight: bold;">
        <i class="fa-solid fa-arrow-left"></i> Quay lại Trang chủ
    </a>
</div>
                <h2>Quản lý Đánh giá (Review Management)</h2>
                <div
                    style="margin-bottom: 20px; background: #fff3cd; padding: 15px; border-radius: 5px; border: 1px solid #ffeeba;">
                    <form action="${pageContext.request.contextPath}/staff/reviews" method="get"
                        style="display: flex; align-items: center; gap: 10px;">
                        <strong style="color: #856404;"><i class="fa-solid fa-filter"></i> Lọc theo đánh giá:</strong>
                        <select name="star" style="padding: 5px; border-radius: 4px; border: 1px solid #ccc;">
                            <option value="">-- Tất cả số sao --</option>
                            <option value="5" ${selectedStar==5 ? 'selected' : '' }>⭐⭐⭐⭐⭐ (5 Sao)</option>
                            <option value="4" ${selectedStar==4 ? 'selected' : '' }>⭐⭐⭐⭐ (4 Sao)</option>
                            <option value="3" ${selectedStar==3 ? 'selected' : '' }>⭐⭐⭐ (3 Sao)</option>
                            <option value="2" ${selectedStar==2 ? 'selected' : '' }>⭐⭐ (2 Sao)</option>
                            <option value="1" ${selectedStar==1 ? 'selected' : '' }>⭐ (1 Sao - Cần xử lý)</option>
                        </select>
                        <button type="submit"
                            style="background: #28a745; color: white; border: none; padding: 6px 15px; border-radius: 4px; cursor: pointer;">Lọc</button>
                    </form>
                </div>
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
                                    <a href="${pageContext.request.contextPath}/staff/delete-review?id=${r.reviewId}"
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