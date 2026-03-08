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
                body {
                    background-color: #f4f6f9;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }

                .brand-color {
                    color: #C92127;
                }

                .btn-brand {
                    background-color: #C92127;
                    color: white;
                    transition: 0.3s;
                }

                .btn-brand:hover {
                    background-color: #a31a1f;
                    color: white;
                }

                .card {
                    border-radius: 12px;
                }

                .table th {
                    background-color: #f8f9fa;
                    color: #555;
                    font-weight: 600;
                    text-transform: uppercase;
                    font-size: 13px;
                    letter-spacing: 0.5px;
                }

                .text-warning {
                    color: #ffc107 !important;
                }

                /* Màu vàng chuẩn cho Sao */
                .comment-cell {
                    max-width: 300px;
                    white-space: normal;
                }
            </style>
        </head>

        <body>
            <div class="container-fluid py-4 px-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="fw-bold brand-color mb-1"><i class="fa-regular fa-comments me-2"></i>Quản lý Đánh giá
                        </h2>
                        <p class="text-muted mb-0">Theo dõi và phản hồi trải nghiệm của khách hàng</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/home"
                        class="btn btn-outline-secondary rounded-pill px-4">
                        <i class="fa-solid fa-arrow-left me-2"></i>Về Trang chủ
                    </a>
                </div>

                <div class="card shadow-sm border-0">
                    <div class="card-body p-4">
                        <div class="row mb-4 bg-light p-3 rounded-3 align-items-center mx-0">
                            <div class="col-auto">
                                <strong class="text-dark"><i class="fa-solid fa-filter me-2 brand-color"></i>Lọc theo
                                    sao:</strong>
                            </div>
                            <div class="col-md-4 col-sm-6">
                                <form action="${pageContext.request.contextPath}/staff/reviews" method="get"
                                    class="d-flex gap-2">
                                    <select name="star" class="form-select form-select-sm shadow-none border-secondary">
                                        <option value="">-- Tất cả số sao --</option>
                                        <option value="5" ${selectedStar=='5' ? 'selected' : '' }>⭐⭐⭐⭐⭐ (5 Sao)</option>
                                        <option value="4" ${selectedStar=='4' ? 'selected' : '' }>⭐⭐⭐⭐ (4 Sao)</option>
                                        <option value="3" ${selectedStar=='3' ? 'selected' : '' }>⭐⭐⭐ (3 Sao)</option>
                                        <option value="2" ${selectedStar=='2' ? 'selected' : '' }>⭐⭐ (2 Sao)</option>
                                        <option value="1" ${selectedStar=='1' ? 'selected' : '' }>⭐ (1 Sao - Cần xử lý)
                                        </option>
                                    </select>
                                    <button type="submit" class="btn btn-sm btn-brand px-3">Lọc</button>
                                </form>
                            </div>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-4" style="width: 140px;">
                                            <div class="dropdown">
                                                <span class="dropdown-toggle text-dark" role="button"
                                                    data-bs-toggle="dropdown" aria-expanded="false"
                                                    style="cursor: pointer;">
                                                    SỐ COMMENT
                                                </span>
                                                <ul class="dropdown-menu shadow border-0"
                                                    style="min-width: 250px; max-height: 300px; overflow-y: auto;">
                                                    <li>
                                                        <h6 class="dropdown-header">Chuyển nhanh tới comment:</h6>
                                                    </li>
                                                    <c:forEach items="${listReviews}" var="rv">
                                                        <li><a class="dropdown-item py-2"
                                                                href="#comment-${rv.reviewId}">
                                                                <span
                                                                    class="badge bg-secondary me-2">#${rv.reviewId}</span>
                                                                của <strong>${rv.username}</strong>
                                                            </a></li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </th>
                                        <th>Khách hàng</th>
                                        <th>Sản phẩm</th>
                                        <th class="text-center">Đánh giá</th>
                                        <th>Nội dung</th>
                                        <th>Ngày đăng</th>
                                        <th class="text-end pe-4">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listReviews}" var="r">
                                        <tr id="comment-${r.reviewId}">

                                            <td class="ps-4 align-middle text-muted fw-bold">#${r.reviewId}</td>

                                            <td class="align-middle">
                                                <a href="${pageContext.request.contextPath}/staff/customer-detail?id=${r.userId}"
                                                    class="text-decoration-none d-inline-block"
                                                    title="Xem hồ sơ khách hàng này">
                                                    <div class="fw-bold text-dark hover-brand"
                                                        style="transition: 0.2s;">
                                                        <i class="fa-regular fa-circle-user text-muted me-2"></i>
                                                        <c:out value="${r.username}" />
                                                    </div>
                                                </a>
                                            </td>

                                            <td class="align-middle" style="max-width: 250px;">
                                                <a href="${pageContext.request.contextPath}/detail?pid=${r.bookId}"
                                                    target="_blank" class="text-decoration-none d-block">
                                                    <span class="text-primary fw-medium" style="transition: 0.2s;"><i
                                                            class="fa-solid fa-book-open text-muted me-2"></i>
                                                        <c:out value="${r.bookTitle}" />
                                                    </span>
                                                </a>
                                            </td>

                                            <td class="text-center fs-5 text-warning align-middle">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i
                                                        class="fa-star ${i <= r.rating ? 'fa-solid' : 'fa-regular text-muted'}"></i>
                                                </c:forEach>
                                            </td>

                                            <td class="comment-cell align-middle" style="max-width: 300px;">
                                                <div class="text-dark fst-italic mb-1">"
                                                    <c:out value="${r.comment}" />"
                                                </div>

                                                <c:if test="${not empty r.staffReply}">
                                                    <div class="p-2 mt-2 bg-light rounded border-start border-3 border-danger"
                                                        style="font-size: 13px;">
                                                        <strong class="text-danger">↳ Phản hồi của Shop:</strong><br>
                                                        <c:out value="${r.staffReply}" />
                                                    </div>
                                                </c:if>
                                            </td>

                                            <td class="text-muted align-middle" style="font-size: 14px;">
                                                <i class="fa-regular fa-calendar me-1"></i> ${r.createAt}
                                            </td>

                                            <td class="text-end pe-4 align-middle">
                                                <div class="d-flex flex-column align-items-end gap-2">
                                                    <button type="button"
                                                        class="btn btn-sm btn-outline-danger rounded-pill px-3 w-100"
                                                        data-bs-toggle="modal" data-bs-target="#replyModal"
                                                        data-id="${r.reviewId}"
                                                        data-user="<c:out value='${r.username}' />"
                                                        data-comment="<c:out value='${r.comment}' />"
                                                        onclick="setReplyData(this)">
                                                        <i class="fa-solid fa-reply me-1"></i> Trả lời
                                                    </button>

                                                    <a href="${pageContext.request.contextPath}/staff/delete-review?id=${r.reviewId}"
                                                        class="btn btn-sm btn-outline-secondary rounded-pill px-3 w-100"
                                                        onclick="return confirm('Bạn có chắc chắn muốn XÓA VĨNH VIỄN bình luận tiêu cực này không?');">
                                                        <i class="fa-solid fa-trash-can me-1"></i> Xóa
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty listReviews}">
                                        <tr>
                                            <td colspan="7" class="text-center py-5 text-muted"><i
                                                    class="fa-regular fa-comments fs-1 mb-3 text-light"></i><br>Chưa có
                                                đánh giá nào phù hợp.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="replyModal" tabindex="-1" aria-labelledby="replyModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header bg-danger text-white">
                            <h5 class="modal-title" id="replyModalLabel"><i class="fa-solid fa-reply me-2"></i>Phản hồi
                                đánh giá</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                aria-label="Close"></button>
                        </div>
                        <form action="${pageContext.request.contextPath}/staff/reviews" method="post">
                            <div class="modal-body">
                                <input type="hidden" id="modalReviewId" name="reviewId">

                                <div class="mb-3">
                                    <label class="form-label text-muted small">Khách hàng: <strong id="modalUsername"
                                            class="text-dark"></strong></label>
                                    <div class="p-3 bg-light rounded fst-italic border" id="modalComment"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="replyText" class="form-label fw-bold">Nhập câu trả lời của Shop:</label>
                                    <textarea class="form-control shadow-none border-secondary" id="replyText"
                                        name="replyText" rows="4" placeholder="Cảm ơn bạn đã mua hàng..."
                                        required></textarea>
                                </div>
                            </div>
                            <div class="modal-footer bg-light">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                                <button type="submit" class="btn btn-danger"><i
                                        class="fa-solid fa-paper-plane me-1"></i> Gửi phản hồi</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <script>
                function setReplyData(btn) {
                    // Rút xuất dữ liệu từ các thẻ data-* của nút vừa bấm
                    let id = btn.getAttribute('data-id');
                    let username = btn.getAttribute('data-user');
                    let comment = btn.getAttribute('data-comment');

                    // Gắn vào Popup Modal
                    document.getElementById('modalReviewId').value = id;
                    document.getElementById('modalUsername').innerText = username;
                    document.getElementById('modalComment').innerText = '"' + comment + '"';
                }
            </script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>