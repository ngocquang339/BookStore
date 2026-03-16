<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Bình luận của tôi - BookStore</title>

                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

                <style>
                    .comment-card {
                        background: #fff;
                        border-radius: 8px;
                        border: 1px solid #e0e0e0;
                        padding: 20px;
                        margin-bottom: 20px;
                        transition: transform 0.2s, box-shadow 0.2s;
                    }

                    .comment-card:hover {
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                    }

                    .book-title-link {
                        color: #C92127;
                        font-weight: bold;
                        font-size: 16px;
                        text-decoration: none;
                        transition: color 0.2s;
                    }

                    .book-title-link:hover {
                        color: #a01a1f;
                        text-decoration: underline;
                    }

                    .star-rating {
                        color: #f5a623;
                        font-size: 14px;
                    }

                    .comment-date {
                        font-size: 13px;
                        color: #888;
                    }

                    .comment-content {
                        font-size: 14.5px;
                        color: #444;
                        line-height: 1.5;
                        background: #f9f9f9;
                        padding: 15px;
                        border-radius: 8px;
                        border-left: 3px solid #C92127;
                        margin-top: 15px;
                    }

                    .empty-state {
                        text-align: center;
                        padding: 60px 20px;
                        background: #fff;
                        border-radius: 8px;
                        border: 1px dashed #ddd;
                    }

                    /* Tuỳ chỉnh màu phân trang Bootstrap cho trùng màu Brand */
                    .pagination .page-link {
                        color: #C92127;
                    }

                    .pagination .page-item.active .page-link {
                        background-color: #C92127 !important;
                        border-color: #C92127 !important;
                        color: white !important;
                    }

                    .pagination .page-link:hover {
                        color: #a01a1f;
                        background-color: #f8f9fa;
                    }
                </style>
            </head>

            <body>

                <jsp:include page="component/header.jsp" />

                <c:if test="${not empty sessionScope.mess}">
                    <div class="toast-message ${sessionScope.status == 'success' ? 'toast-success' : 'toast-error'}"
                        id="toastMsg">
                        <i class="fa-solid ${sessionScope.status == 'success' ? 'fa-circle-check' : 'fa-circle-exclamation'}"
                            style="font-size: 24px;"></i>
                        <div>
                            <h6 style="margin:0; font-weight:bold;">Thông báo</h6>
                            <p style="margin:0; font-size:13px;">${sessionScope.mess}</p>
                        </div>
                    </div>
                    <c:remove var="mess" scope="session" />
                    <c:remove var="status" scope="session" />
                </c:if>

                <div class="container profile-container">
                    <div class="row">

                        <div class="col-md-3">
                            <jsp:include page="component/sidebar.jsp" />
                        </div>

                        <div class="col-md-9">
                            <div class="main-profile-content">

                                <div class="page-header">
                                    <h5>Bình luận của tôi</h5>
                                    <p style="font-size: 13px; color: #666; margin:0;">Quản lý toàn bộ lịch sử đánh giá
                                        và thảo luận của bạn</p>
                                </div>

                                <c:choose>
                                    <c:when test="${empty myComments}">
                                        <div class="empty-state mt-3">
                                            <i class="fa-regular fa-comment-dots text-muted mb-3"
                                                style="font-size: 50px; opacity: 0.5;"></i>
                                            <h6 class="text-muted fw-bold">Bạn chưa để lại bình luận nào</h6>
                                            <p class="text-muted mb-4" style="font-size: 14px;">Hãy chia sẻ cảm nhận của
                                                bạn về những cuốn sách đã đọc nhé!</p>
                                            <a href="${pageContext.request.contextPath}/home"
                                                class="btn text-white fw-bold"
                                                style="background-color: #C92127; padding: 8px 25px; border-radius: 4px; text-decoration: none;">
                                                ĐI TÌM SÁCH NGAY
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="mt-4">
                                            <c:forEach var="c" items="${myComments}">
                                                <div class="comment-card">
                                                    <div class="d-flex justify-content-between align-items-start">
                                                        <div>
                                                            <div class="mb-1">
                                                                <span class="badge bg-light text-dark border me-2">Sản
                                                                    phẩm</span>
                                                                <a href="${pageContext.request.contextPath}/detail?pid=${c.bookId}"
                                                                    class="book-title-link">
                                                                    ${c.bookTitle}
                                                                </a>
                                                            </div>
                                                            <div class="star-rating mb-1">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <c:choose>
                                                                        <c:when test="${i <= c.rating}"><i
                                                                                class="fa-solid fa-star"></i></c:when>
                                                                        <c:otherwise><i class="fa-regular fa-star"
                                                                                style="color: #ddd;"></i></c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                                <span class="ms-2 text-dark fw-bold"
                                                                    style="font-size: 13px;">${c.rating}/5 sao</span>
                                                            </div>
                                                            <div class="comment-date">
                                                                <i class="fa-regular fa-clock me-1"></i>Đăng vào ngày:
                                                                <fmt:formatDate value="${c.createAt}"
                                                                    pattern="dd/MM/yyyy HH:mm" />
                                                            </div>
                                                        </div>

                                                        <a href="${pageContext.request.contextPath}/detail?pid=${c.bookId}#review-section"
                                                            class="btn btn-sm btn-outline-secondary"
                                                            title="Xem trên trang sản phẩm">
                                                            <i class="fa-solid fa-arrow-up-right-from-square"></i> Xem
                                                        </a>
                                                    </div>

                                                    <div class="comment-content">
                                                        <i class="fa-solid fa-quote-left text-muted me-2"
                                                            style="opacity: 0.3;"></i>
                                                        <c:out value="${c.comment}" />
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>

                                        <c:if test="${totalPages > 1}">
                                            <nav aria-label="Page navigation" class="mt-4">
                                                <ul class="pagination justify-content-center">

                                                    <c:if test="${currentPage > 1}">
                                                        <li class="page-item">
                                                            <a class="page-link"
                                                                href="${pageContext.request.contextPath}/my-comments?page=${currentPage - 1}"
                                                                style="color: #C92127;">&laquo; Trước</a>
                                                        </li>
                                                    </c:if>

                                                    <%-- Các số trang (1, 2, 3...) --%>
                                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                                <a class="page-link"
                                                                    href="${pageContext.request.contextPath}/my-comments?page=${i}">
                                                                    ${i}
                                                                </a>
                                                            </li>
                                                        </c:forEach>

                                                        <c:if test="${currentPage < totalPages}">
                                                            <li class="page-item">
                                                                <a class="page-link"
                                                                    href="${pageContext.request.contextPath}/my-comments?page=${currentPage + 1}"
                                                                    style="color: #C92127;">Sau &raquo;</a>
                                                            </li>
                                                        </c:if>

                                                </ul>
                                            </nav>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                        </div>

                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    setTimeout(function () {
                        let toast = document.getElementById('toastMsg');
                        if (toast) toast.style.display = 'none';
                    }, 4000);
                </script>
            </body>

            </html>