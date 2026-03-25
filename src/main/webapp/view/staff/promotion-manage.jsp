<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Khuyến Mãi - Staff Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f4f6f9; }
        .main-content { padding: 20px; }
        .white-box { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

    <%-- <jsp:include page="staff-header.jsp" /> --%>

    <div class="container-fluid main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-danger fw-bold"><i class="fa-solid fa-bolt me-2"></i>QUẢN LÝ FLASH SALE</h2>
            <button type="button" class="btn btn-danger fw-bold" data-bs-toggle="modal" data-bs-target="#createPromoModal">
                <i class="fa-solid fa-plus me-1"></i> Tạo Đợt Sale Mới
            </button>
        </div>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-check-circle me-2"></i>${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>
        
        <div class="white-box">
            <table class="table table-hover align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Tên Chương Trình</th>
                        <th>Giảm Giá</th>
                        <th>Thời Gian Bắt Đầu</th>
                        <th>Thời Gian Kết Thúc</th>
                        <th>Trạng Thái</th>
                        <th>Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty listPromos}">
                            <tr><td colspan="7" class="text-center py-4 text-muted">Chưa có chương trình khuyến mãi nào!</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${listPromos}" var="p">
                                <tr>
                                    <td><strong>#${p.promoId}</strong></td>
                                    <td class="fw-bold text-primary">${p.promoName}</td>
                                    <td><span class="badge bg-danger fs-6">-${p.discountPercent}%</span></td>
                                    <td><fmt:formatDate value="${p.startDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                    <td><fmt:formatDate value="${p.endDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.active}"><span class="badge bg-success">Đang kích hoạt</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary">Đã tắt</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/staff/promo-books?id=${p.promoId}" class="btn btn-sm btn-outline-primary">
                                            <i class="fa-solid fa-book-open"></i> Thêm Sách
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal fade" id="createPromoModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-bolt me-2"></i>Tạo Chương Trình Flash Sale</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/staff/promotions" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="create">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Tên chương trình:</label>
                            <input type="text" name="promoName" class="form-control" placeholder="Ví dụ: Siêu Sale 8/3..." required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Mức giảm giá (%):</label>
                            <input type="number" name="discountPercent" class="form-control" min="1" max="100" placeholder="50" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Thời gian Bắt đầu:</label>
                            <input type="datetime-local" name="startDate" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Thời gian Kết thúc:</label>
                            <input type="datetime-local" name="endDate" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy bỏ</button>
                        <button type="submit" class="btn btn-danger fw-bold">Tạo ngay</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>