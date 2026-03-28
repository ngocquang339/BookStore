<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Chi tiết Đơn Nhập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-4 mb-5">
        <a href="${pageContext.request.contextPath}/admin/po" class="btn btn-secondary mb-3">&larr; Quay lại danh sách</a>
        
        <div class="card shadow-sm">
            <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                <h4 class="mb-0">Chi tiết PO #${po.purchaseOrderId}</h4>
                <c:choose>
                    <c:when test="${po.status == 0}"><span class="badge bg-warning text-dark fs-6">Chờ duyệt (Pending)</span></c:when>
                    <c:when test="${po.status == 1}"><span class="badge bg-info text-dark fs-6">Đã duyệt (Approved)</span></c:when>
                    <c:when test="${po.status == 2}"><span class="badge bg-success fs-6">Đã nhập kho (Received)</span></c:when>
                    <c:when test="${po.status == 3}"><span class="badge bg-danger fs-6">Đã từ chối (Cancelled)</span></c:when>
                </c:choose>
            </div>
            <div class="card-body">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <p><b>Nhà cung cấp:</b> ${po.supplierName}</p>
                        <p><b>Người tạo (Kho):</b> ${po.createdByName}</p>
                        <p><b>Ghi chú của kho:</b> ${empty po.statusNote ? 'Không có' : po.statusNote}</p>
                    </div>
                    <div class="col-md-6 text-end">
                        <h5 class="text-muted">Tổng tiền duyệt mua:</h5>
                        <h2 class="text-danger fw-bold"><fmt:formatNumber value="${po.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></h2>
                    </div>
                </div>

                <h5>Danh sách sách cần nhập</h5>
                <table class="table table-bordered">
                    <thead class="table-light">
                        <tr>
                            <th>Tên Sách</th>
                            <th class="text-center">Số lượng</th>
                            <th class="text-end">Đơn giá nhập</th>
                            <th class="text-end">Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${details}" var="d">
                            <tr>
                                <td>${d.book.title}</td>
                                <td class="text-center">${d.expectedQuantity}</td>
                                <td class="text-end"><fmt:formatNumber value="${d.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                <td class="text-end"><fmt:formatNumber value="${d.expectedQuantity * d.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${po.status == 0}">
                    <hr>
                    <div class="d-flex justify-content-end gap-3 mt-4">
                        <button type="button" class="btn btn-danger btn-lg px-4" data-bs-toggle="modal" data-bs-target="#rejectModal">
                            <i class="fas fa-times"></i> Từ chối
                        </button>
                        
                        <form action="${pageContext.request.contextPath}/admin/po/review" method="post">
                            <input type="hidden" name="poId" value="${po.purchaseOrderId}">
                            <input type="hidden" name="action" value="approve">
                            <button type="submit" class="btn btn-success btn-lg px-4" onclick="return confirm('Bạn có chắc chắn muốn duyệt đơn nhập hàng này trị giá ${po.totalAmount} VNĐ?');">
                                <i class="fas fa-check"></i> Duyệt Đơn Này
                            </button>
                        </form>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/po/review" method="post">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">Từ chối Đơn Nhập Hàng</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="poId" value="${po.purchaseOrderId}">
                        <input type="hidden" name="action" value="reject">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Lý do từ chối gửi cho kho:</label>
                            <textarea name="rejectReason" class="form-control" rows="3" required placeholder="VD: Giá nhập quá cao, ngân sách không đủ..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">Xác nhận Từ chối</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>