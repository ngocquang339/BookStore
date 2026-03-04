<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đánh giá - BookStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .brand-color { color: #C92127; }
        .btn-brand { background-color: #C92127; color: white; transition: 0.3s; }
        .btn-brand:hover { background-color: #a31a1f; color: white; }
        .card { border-radius: 12px; }
        .table th { background-color: #f8f9fa; color: #555; font-weight: 600; text-transform: uppercase; font-size: 13px; letter-spacing: 0.5px;}
        .text-warning { color: #ffc107 !important; } /* Màu vàng chuẩn cho Sao */
        .comment-cell { max-width: 300px; white-space: normal; }
    </style>
</head>
<body>
    <div class="container-fluid py-4 px-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold brand-color mb-1"><i class="fa-regular fa-comments me-2"></i>Quản lý Đánh giá</h2>
                <p class="text-muted mb-0">Theo dõi và phản hồi trải nghiệm của khách hàng</p>
            </div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary rounded-pill px-4">
                <i class="fa-solid fa-arrow-left me-2"></i>Về Trang chủ
            </a>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-body p-4">
                <div class="row mb-4 bg-light p-3 rounded-3 align-items-center mx-0">
                    <div class="col-auto">
                        <strong class="text-dark"><i class="fa-solid fa-filter me-2 brand-color"></i>Lọc theo sao:</strong>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        <form action="${pageContext.request.contextPath}/staff/reviews" method="get" class="d-flex gap-2">
                            <select name="star" class="form-select form-select-sm shadow-none border-secondary">
                                <option value="">-- Tất cả số sao --</option>
                                <option value="5" ${selectedStar == '5' ? 'selected' : ''}>⭐⭐⭐⭐⭐ (5 Sao)</option>
                                <option value="4" ${selectedStar == '4' ? 'selected' : ''}>⭐⭐⭐⭐ (4 Sao)</option>
                                <option value="3" ${selectedStar == '3' ? 'selected' : ''}>⭐⭐⭐ (3 Sao)</option>
                                <option value="2" ${selectedStar == '2' ? 'selected' : ''}>⭐⭐ (2 Sao)</option>
                                <option value="1" ${selectedStar == '1' ? 'selected' : ''}>⭐ (1 Sao - Cần xử lý)</option>
                            </select>
                            <button type="submit" class="btn btn-sm btn-brand px-3">Lọc</button>
                        </form>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-3 text-center">ID</th>
                                <th>Khách hàng</th>
                                <th>Sản phẩm</th>
                                <th class="text-center">Đánh giá</th>
                                <th>Nội dung</th>
                                <th>Ngày đăng</th>
                                <th class="text-end pe-3">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${listReviews}" var="r">
                                <tr>
                                    <td class="ps-3 text-center text-muted fw-bold">#${r.reviewId}</td>
                                    <td>
                                        <div class="fw-bold text-dark"><i class="fa-regular fa-circle-user text-muted me-2"></i><c:out value="${r.username}" /></div>
                                    </td>
                                    <td>
                                        <span class="text-primary fw-medium"><i class="fa-solid fa-book-open text-muted me-2"></i><c:out value="${r.bookTitle}" /></span>
                                    </td>
                                    <td class="text-center fs-5 text-warning">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fa-star ${i <= r.rating ? 'fa-solid' : 'fa-regular text-muted'}"></i>
                                        </c:forEach>
                                    </td>
                                    <td class="comment-cell">
                                        <span class="text-dark fst-italic">"<c:out value="${r.comment}" />"</span>
                                    </td>
                                    <td class="text-muted" style="font-size: 14px;">
                                        <i class="fa-regular fa-calendar me-1"></i> ${r.createAt}
                                    </td>
                                    <td class="text-end pe-3">
                                        <a href="https://mail.google.com/mail/?view=cm&fs=1&to=${r.email}" target="_blank" class="btn btn-sm btn-outline-danger rounded-pill px-3">
                                            <i class="fa-solid fa-reply me-1"></i> Phản hồi
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listReviews}">
                                <tr><td colspan="7" class="text-center py-5 text-muted"><i class="fa-regular fa-comments fs-1 mb-3 text-light"></i><br>Chưa có đánh giá nào phù hợp.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>