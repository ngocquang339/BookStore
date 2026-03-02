<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đánh giá</title>
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
        
        <h2><i class="fa-solid fa-comments"></i> Quản lý Đánh giá (Review Management)</h2>
        
        <div class="filter-box">
            <form action="${pageContext.request.contextPath}/staff/reviews" method="get" class="filter-form">
                <strong class="filter-label"><i class="fa-solid fa-filter"></i> Lọc theo đánh giá:</strong>
                <select name="star" class="filter-select">
                    <option value="">-- Tất cả số sao --</option>
                    <option value="5" ${selectedStar==5 ? 'selected' : '' }>⭐⭐⭐⭐⭐ (5 Sao)</option>
                    <option value="4" ${selectedStar==4 ? 'selected' : '' }>⭐⭐⭐⭐ (4 Sao)</option>
                    <option value="3" ${selectedStar==3 ? 'selected' : '' }>⭐⭐⭐ (3 Sao)</option>
                    <option value="2" ${selectedStar==2 ? 'selected' : '' }>⭐⭐ (2 Sao)</option>
                    <option value="1" ${selectedStar==1 ? 'selected' : '' }>⭐ (1 Sao - Cần xử lý)</option>
                </select>
                <button type="submit" class="btn-filter">Lọc</button>
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
                            <a href="https://mail.google.com/mail/?view=cm&fs=1&to=${r.email}" target="_blank" class="btn-mail">
                                <i class="fa-solid fa-reply"></i> Phản hồi
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <c:if test="${empty listReviews}">
            <p class="empty-msg">Chưa có đánh giá nào.</p>
        </c:if>
    </div>
</body>
</html>
