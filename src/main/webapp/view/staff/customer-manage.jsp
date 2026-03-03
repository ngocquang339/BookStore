<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hỗ trợ Khách hàng - BookStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .brand-color { color: #C92127; }
        .bg-brand { background-color: #C92127; color: white; }
        .btn-brand { background-color: #C92127; color: white; transition: 0.3s; }
        .btn-brand:hover { background-color: #a31a1f; color: white; }
        .card { border-radius: 12px; }
        .table th { background-color: #f8f9fa; color: #555; font-weight: 600; text-transform: uppercase; font-size: 13px; letter-spacing: 0.5px;}
        .avatar-circle { width: 40px; height: 40px; background-color: #e9ecef; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; color: #6c757d; }
    </style>
</head>
<body>
    <div class="container-fluid py-4 px-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold brand-color mb-1"><i class="fa-solid fa-users-viewfinder me-2"></i>Hỗ trợ Khách hàng</h2>
                <p class="text-muted mb-0">Tra cứu thông tin liên hệ và giải quyết khiếu nại</p>
            </div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary rounded-pill px-4">
                <i class="fa-solid fa-arrow-left me-2"></i>Về Trang chủ
            </a>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-body p-4">
                <form action="${pageContext.request.contextPath}/staff/customers" method="get" class="row g-3 mb-4">
                    <div class="col-md-6 col-lg-5">
                        <div class="input-group">
                            <span class="input-group-text bg-white text-muted border-end-0"><i class="fa-solid fa-magnifying-glass"></i></span>
                            <input type="text" name="keyword" value="<c:out value='${keyword}' />" class="form-control border-start-0 ps-0" placeholder="Nhập tên, email hoặc SĐT...">
                            <button type="submit" class="btn btn-brand px-4">Tìm kiếm</button>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <a href="${pageContext.request.contextPath}/staff/customers" class="btn btn-light border w-100">Làm mới</a>
                    </div>
                </form>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-3">Khách hàng</th>
                                <th>Thông tin liên lạc</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-end pe-3">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${listCustomers}" var="u">
                                <tr>
                                    <td class="ps-3">
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-circle me-3"><i class="fa-regular fa-user"></i></div>
                                            <div>
                                                <div class="fw-bold text-dark"><c:out value="${u.fullname}" /></div>
                                                <div class="text-muted" style="font-size: 13px;">@<c:out value="${u.username}" /></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="text-dark"><i class="fa-solid fa-envelope text-muted me-2"></i><c:out value="${u.email}" /></div>
                                        <div class="mt-1" style="font-size: 14px;">
                                            <c:choose>
                                                <c:when test="${not empty u.phone_number}">
                                                    <i class="fa-solid fa-phone text-muted me-2"></i><c:out value="${u.phone_number}" />
                                                </c:when>
                                                <c:otherwise><span class="text-muted fst-italic">Chưa có SĐT</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${u.status == 1}"><span class="badge bg-success rounded-pill px-3 py-2 fw-normal"><i class="fa-solid fa-check me-1"></i> Hoạt động</span></c:when>
                                            <c:otherwise><span class="badge bg-danger rounded-pill px-3 py-2 fw-normal"><i class="fa-solid fa-lock me-1"></i> Đã khóa</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-3">
                                        <a href="https://mail.google.com/mail/?view=cm&fs=1&to=${u.email}" target="_blank" class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                            <i class="fa-regular fa-paper-plane me-1"></i> Gửi Mail
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listCustomers}">
                                <tr><td colspan="4" class="text-center py-5 text-muted"><i class="fa-solid fa-box-open fs-1 mb-3"></i><br>Không tìm thấy khách hàng nào.</td></tr>
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