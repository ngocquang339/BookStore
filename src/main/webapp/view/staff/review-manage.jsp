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
                    <a href="${pageContext.request.contextPath}/home"
                        style="color: #4da6ff; text-decoration: none; font-size: 16px; font-weight: bold;">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại Trang chủ
                    </a>
                </div>
                <h2>Quản lý Đánh giá (Review Management)</h2>
                <div
                    style="margin-bottom: 20px; background: #fff3cd; padding: 15px; border-radius: 5px; border: 1px solid #ffeeba;">
                    <form action="${pageContext.request.contextPath}/staff/reviews" method="get"
                        style="display: flex; gap: 10px; align-items: center;">
                        <label style="color: white;">Lọc theo đánh giá: </label>
                        <select name="star" style="padding: 5px;">
                            <option value="all" ${selectedStar=='all' ? 'selected' : '' }>-- Tất cả số sao --</option>
                            <option value="5" ${selectedStar=='5' ? 'selected' : '' }>5 Sao</option>
                            <option value="4" ${selectedStar=='4' ? 'selected' : '' }>4 Sao</option>
                            <option value="3" ${selectedStar=='3' ? 'selected' : '' }>3 Sao</option>
                            <option value="2" ${selectedStar=='2' ? 'selected' : '' }>2 Sao</option>
                            <option value="1" ${selectedStar=='1' ? 'selected' : '' }>1 Sao</option>
                        </select>
                        <button type="submit"
                            style="background: #28a745; color: white; border: none; padding: 6px 15px; cursor: pointer;">Lọc</button>
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
                            <tr style="color: white; text-align: center; border-bottom: 1px solid #444;">
                                <td style="padding: 15px;">${r.reviewId}</td>

                                <td style="font-weight: bold; color: #4da6ff;">@${r.username}</td>

                                <td style="text-align: left;">${r.bookTitle}</td>

                                <td style="color: gold; font-size: 16px;">
                                    ${r.rating} <i class="fa-solid fa-star"></i>
                                </td>

                                <td style="text-align: left; font-style: italic;">"${r.comment}"</td>
                                <td>${r.createAt}</td>

                                <td>
                                    <a href="#" class="btn-call"
                                        style="background: #007bff; padding: 6px 12px; color: white; text-decoration: none; border-radius: 4px; font-size: 13px;">
                                        <i class="fa-solid fa-reply"></i> Phản hồi
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty listReviews}">
                            <tr>
                                <td colspan="7" style="text-align: center; color: #bbb; padding: 30px;">
                                    <i class="fa-regular fa-face-frown"
                                        style="font-size: 24px; margin-bottom: 10px; display: block;"></i>
                                    Chưa có đánh giá nào phù hợp với bộ lọc.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <c:if test="${empty listReviews}">
                    <p style="text-align: center; color: #666; margin-top: 20px;">Chưa có đánh giá nào.</p>
                </c:if>
            </div>
        </body>

        </html>