<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý Đơn Trả Hàng - Warehouse</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f4f7f6;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        .table thead {
            background-color: #e9ecef;
        }
    </style>
</head>

<body>
    <div class="container-fluid py-4">
        <div class="position-relative mb-4">
            <div class="position-absolute start-0 top-50 translate-middle-y">
                <a href="dashboard" class="btn btn-outline-secondary">
                    <i class="fa-solid fa-arrow-left me-1"></i> Dashboard
                </a>
            </div>
            <div class="text-center">
                <h2 class="text-dark mb-0">
                    <i class="fas fa-undo me-2"></i> Danh Sách Đơn Trả Hàng
                </h2>
            </div>
        </div>

        <div class="card p-3 mb-4">
            <form method="GET" action="returns" class="row g-3">
                <div class="col-md-4">
                    <div class="input-group">
                        <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                        <input type="text" name="searchName" class="form-control" placeholder="Tìm tên khách hàng..." value="${param.searchName}">
                    </div>
                </div>
                <div class="col-md-3">
                    <select name="statusFilter" class="form-select">
                        <option value="0">Tất cả trạng thái trả hàng</option>
                        <option value="1" ${param.statusFilter=='1' ? 'selected' : '' }> Pending Review</option>
                        <option value="2" ${param.statusFilter=='2' ? 'selected' : '' }> Action Required</option>
                        <option value="3" ${param.statusFilter=='3' ? 'selected' : '' }> Approved (Awaiting Item)</option>
                        <option value="4" ${param.statusFilter=='4' ? 'selected' : '' }> Failed QC</option>
                        <option value="5" ${param.statusFilter=='5' ? 'selected' : '' }> Refunded (Item Returned)</option>
                        <option value="6" ${param.statusFilter=='6' ? 'selected' : '' }> Rejected Upfront</option>
                        <option value="7" ${param.statusFilter=='7' ? 'selected' : '' }> Refunded (Customer Keeps Item)</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">Lọc dữ liệu</button>
                </div>
                <div class="col-md-2">
                    <a href="returns" class="btn btn-outline-secondary w-100">Làm mới</a>
                </div>
            </form>
        </div>

        <div class="card shadow-sm">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th class="ps-3">Mã đơn</th>
                            <th>Ngày yêu cầu</th>
                            <th>Khách hàng</th>
                            <th>Chi tiết sách</th>
                            <th>Trạng thái</th>
                            <th class="text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${returnList}" var="r">
                            <tr>
                                <td class="ps-3 fw-bold text-primary">#${r.orderId}</td>
                                <td><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                                <td>${r.customerName}</td>
                                <td>
                                    <strong>${r.bookTitle}</strong><br>
                                    <span class="text-muted" style="font-size: 0.85em;">SL: ${r.quantity} | Nhận: ${r.returnMethod}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${r.status == 1}"><span class="badge bg-warning text-dark">Pending Review</span></c:when>
                                        <c:when test="${r.status == 2}"><span class="badge bg-info text-dark">Action Required</span></c:when>
                                        <c:when test="${r.status == 3}"><span class="badge bg-primary">Approved (Awaiting Item)</span></c:when>
                                        <c:when test="${r.status == 4}"><span class="badge bg-danger">Failed QC</span></c:when>
                                        <c:when test="${r.status == 5}"><span class="badge bg-success">Refunded (Returned)</span></c:when>
                                        <c:when test="${r.status == 6}"><span class="badge bg-danger">Rejected Upfront</span></c:when>
                                        <c:when test="${r.status == 7}"><span class="badge bg-success">Refunded (Keeps Item)</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">Unknown</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <div class="btn-group">
                                        <a href="returns?viewId=${r.orderId}&searchName=${param.searchName}&statusFilter=${param.statusFilter}" class="btn btn-sm btn-outline-info">
                                            <i class="fas fa-eye"></i> Chi tiết
                                        </a>

                                        <c:if test="${r.status == 3}">
                                            <a href="return-process?orderId=${r.orderId}" class="btn btn-sm btn-warning">
                                                <i class="fas fa-clipboard-check"></i> Kiểm hàng
                                            </a>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty returnList}">
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">Không tìm thấy đơn hàng hoàn trả nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <c:if test="${not empty selectedOrder}">
        <div class="modal fade show" id="orderDetailModal" tabindex="-1" style="display: block; background: rgba(0,0,0,0.5);">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-light">
                        <h5 class="modal-title">Chi tiết đơn trả hàng #${selectedOrder.orderId}</h5>
                        <a href="returns" class="btn-close"></a>
                    </div>
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h6>Thông tin khách hàng:</h6>
                                <p class="mb-1 text-muted">Họ tên: <strong>${selectedOrder.customerName}</strong></p>
                                <p class="mb-1 text-muted">Ngày yêu cầu: <fmt:formatDate value="${selectedOrder.createdAt}" pattern="dd/MM/yyyy HH:mm" /></p>
                            </div>
                            <div class="col-md-6 text-end">
                                <h6>Trạng thái hiện tại:</h6>
                                <c:choose>
                                    <c:when test="${selectedOrder.status == 1}"><span class="badge bg-warning text-dark p-2">Pending Review</span></c:when>
                                    <c:when test="${selectedOrder.status == 2}"><span class="badge bg-info text-dark p-2">Action Required</span></c:when>
                                    <c:when test="${selectedOrder.status == 3}"><span class="badge bg-primary p-2">Approved (Awaiting Item)</span></c:when>
                                    <c:when test="${selectedOrder.status == 4}"><span class="badge bg-danger p-2">Failed QC</span></c:when>
                                    <c:when test="${selectedOrder.status == 5}"><span class="badge bg-success p-2">Refunded (Returned)</span></c:when>
                                    <c:when test="${selectedOrder.status == 6}"><span class="badge bg-danger p-2">Rejected Upfront</span></c:when>
                                    <c:when test="${selectedOrder.status == 7}"><span class="badge bg-success p-2">Refunded (Keeps Item)</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary p-2">Status: ${selectedOrder.status}</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <table class="table table-bordered">
                            <thead class="table-light">
                                <tr>
                                    <th>Tên sách trả</th>
                                    <th class="text-center">Số lượng</th>
                                    <th>Lý do</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${details}" var="item">
                                    <tr>
                                        <td>${item.bookTitle}</td>
                                        <td class="text-center text-danger fw-bold">${item.quantity}</td>
                                        <td>${item.customerReason}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <a href="returns" class="btn btn-secondary">Đóng</a>
                        <c:if test="${selectedOrder.status == 3}">
                            <a href="return-process?orderId=${selectedOrder.orderId}" class="btn btn-primary">Bắt đầu kiểm hàng ngay</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>