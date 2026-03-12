<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Chi tiết Khách hàng - BookStore</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        </head>

        <body style="background-color: #f4f6f9;">
            <jsp:include page="../component/header.jsp" />

            <div class="container py-5">
                <a href="#" onclick="history.back(); return false;"
                    class="btn btn-outline-secondary mb-4 rounded-pill text-light">
                    <i class="fa-solid fa-arrow-left me-2"></i> Quay lại trang trước
                </a>

                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="card shadow-sm border-0 rounded-4">
                            <div class="card-header bg-danger text-white p-4 rounded-top-4 d-flex align-items-center">
                                <div class="bg-white text-danger rounded-circle d-flex justify-content-center align-items-center me-3"
                                    style="width: 60px; height: 60px; font-size: 24px;">
                                    <i class="fa-solid fa-user-check"></i>
                                </div>
                                <div>
                                    <h3 class="mb-0 fw-bold">
                                        <c:out value="${customer.fullname}" />
                                    </h3>
                                    <span class="badge bg-light text-danger mt-1">ID Khách hàng: #${customer.id}</span>
                                </div>
                            </div>

                            <div class="card-body p-5">
                                <h5 class="fw-bold mb-4 border-bottom pb-2 text-muted">Thông tin liên lạc & Giao hàng
                                </h5>

                                <div class="row mb-3">
                                    <div class="col-sm-4 text-muted fw-medium"><i
                                            class="fa-regular fa-id-badge me-2"></i> Tên đăng nhập:</div>
                                    <div class="col-sm-8 fw-bold text-dark">@
                                        <c:out value="${customer.username}" />
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-sm-4 text-muted fw-medium"><i class="fa-solid fa-envelope me-2"></i>
                                        Email:</div>
                                    <div class="col-sm-8 text-primary">
                                        <c:out value="${customer.email}" />
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-sm-4 text-muted fw-medium"><i class="fa-solid fa-phone me-2"></i> Số
                                        điện thoại:</div>
                                    <div class="col-sm-8">
                                        <c:choose>
                                            <c:when test="${not empty customer.phone_number}">
                                                <c:out value="${customer.phone_number}" />
                                            </c:when>
                                            <c:otherwise><span class="fst-italic text-muted">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-sm-4 text-muted fw-medium"><i
                                            class="fa-solid fa-location-dot me-2"></i> Địa chỉ:</div>
                                    <div class="col-sm-8">
                                        <c:choose>
                                            <c:when test="${not empty customer.address}">
                                                <c:out value="${customer.address}" />
                                            </c:when>
                                            <c:otherwise><span class="fst-italic text-muted">Chưa cập nhật</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="row mb-4">
                                    <div class="col-sm-4 text-muted fw-medium"><i
                                            class="fa-solid fa-shield-halved me-2"></i> Trạng thái tài khoản:</div>
                                    <div class="col-sm-8">
                                        <c:choose>
                                            <c:when test="${customer.status == 1}"><span
                                                    class="badge bg-success px-3 py-2">Đang hoạt động</span></c:when>
                                            <c:otherwise><span class="badge bg-danger px-3 py-2">Đã bị khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4 pt-3 border-top">
                                    <a href="https://mail.google.com/mail/?view=cm&fs=1&to=${customer.email}"
                                        target="_blank" class="btn btn-danger px-4">
                                        <i class="fa-regular fa-paper-plane me-2"></i> Gửi Email hỗ trợ
                                    </a>
                                </div> -->

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="../component/footer.jsp" />
        </body>

        </html>