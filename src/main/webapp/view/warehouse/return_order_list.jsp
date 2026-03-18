<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <title>Quản lý Đơn Trả Hàng - Warehouse</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

                        .badge-7 {
                            background-color: #6c757d;
                        }

                        /* Requested */
                        .badge-8 {
                            background-color: #fd7e14;
                        }

                        /* Approved */
                        .badge-9 {
                            background-color: #0dcaf0;
                        }

                        /* Received/Inspecting */
                        .badge-10 {
                            background-color: #198754;
                        }

                        /* Completed */
                        .status-dot {
                            height: 10px;
                            width: 10px;
                            border-radius: 50%;
                            display: inline-block;
                            margin-right: 5px;
                        }
                    </style>
                </head>

                <body>
                    <div class="position-relative mb-4">

                        <!-- Nút bên trái -->
                        <div class="position-absolute start-0 top-50 translate-middle-y">
                            <a href="dashboard" class="btn btn-outline-secondary">
                                <i class="fa-solid fa-arrow-left me-1"></i> Dashboard
                            </a>
                        </div>

                        <!-- Title ở giữa -->
                        <div class="text-center">
                            <h2 class="text-dark mb-0">
                                <i class="fas fa-undo me-2"></i>
                                Danh Sách Đơn Trả Hàng
                            </h2>
                        </div>

                    </div>

                    <div class="card p-3 mb-4">
                        <form method="GET" action="returns" class="row g-3">
                            <div class="col-md-4">
                                <div class="input-group">
                                    <span class="input-group-text bg-white"><i
                                            class="fas fa-search text-muted"></i></span>
                                    <input type="text" name="searchName" class="form-control"
                                        placeholder="Tìm tên khách hàng..." value="${param.searchName}">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <select name="statusFilter" class="form-select">
                                    <option value="0">Tất cả trạng thái trả hàng</option>
                                    <option value="7" ${param.statusFilter=='7' ? 'selected' : '' }> Return Requested</option>
                                    <option value="8" ${param.statusFilter=='8' ? 'selected' : '' }> Return Approved</option>
                                    <option value="9" ${param.statusFilter=='9' ? 'selected' : '' }> Received / Inspecting</option>
                                    <option value="10" ${param.statusFilter=='10' ? 'selected' : '' }> Return Completed</option>
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
                                        <th>Tổng tiền hoàn</th>
                                        <th>Trạng thái</th>
                                        <th class="text-center">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${returnList}" var="o">
                                        <tr>
                                            <td class="ps-3 fw-bold text-primary">#${o.order_id}</td>
                                            <td>${o.order_date}</td>
                                            <td>${o.fullname}</td>
                                            <td>
                                                <fmt:formatNumber value="${o.total_amount}" type="currency"
                                                    currencySymbol="đ" />
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${o.status == 7}"><span class="badge badge-7">Return
                                                            Requested</span></c:when>
                                                    <c:when test="${o.status == 8}"><span class="badge badge-8">Return
                                                            Approved</span></c:when>
                                                    <c:when test="${o.status == 9}"><span class="badge badge-9">Received
                                                            / Inspecting</span>
                                                    </c:when>
                                                    <c:when test="${o.status == 10}"><span class="badge badge-10">Return
                                                            Completed</span></c:when>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="btn-group">
                                                    <a href="returns?viewId=${o.order_id}&searchName=${param.searchName}&statusFilter=${param.statusFilter}"
                                                        class="btn btn-sm btn-outline-info">
                                                        <i class="fas fa-eye"></i> Chi tiết
                                                    </a>

                                                    <c:if test="${o.status == 8 || o.status == 9}">
                                                        <a href="return-process?orderId=${o.order_id}"
                                                            class="btn btn-sm btn-warning">
                                                            <i class="fas fa-clipboard-check"></i> Kiểm hàng
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty returnList}">
                                        <tr>
                                            <td colspan="6" class="text-center py-4 text-muted">Không tìm thấy đơn
                                                hàng hoàn trả nào.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    </div>

                    <c:if test="${not empty selectedOrder}">
                        <div class="modal fade show" id="orderDetailModal" tabindex="-1"
                            style="display: block; background: rgba(0,0,0,0.5);">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header bg-light">
                                        <h5 class="modal-title">Chi tiết đơn trả hàng #${selectedOrder.order_id}</h5>
                                        <a href="returns" class="btn-close"></a>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <h6>Thông tin khách hàng:</h6>
                                                <p class="mb-1 text-muted">Họ tên:
                                                    <strong>${selectedOrder.fullname}</strong>
                                                </p>
                                                <p class="mb-1 text-muted">Ngày đặt: ${selectedOrder.order_date}</p>
                                            </div>
                                            <div class="col-md-6 text-end">
                                                <h6>Trạng thái hiện tại:</h6>
                                                <span class="badge bg-secondary p-2">Status
                                                    ${selectedOrder.status}</span>
                                            </div>
                                        </div>
                                        <table class="table table-bordered">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Sách</th>
                                                    <th class="text-center">Số lượng trả</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${details}" var="item">
                                                    <tr>
                                                        <td>${item.title}</td>
                                                        <td class="text-center">${item.quantity}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="modal-footer">
                                        <a href="returns" class="btn btn-secondary">Đóng</a>
                                        <c:if test="${selectedOrder.status == 8 || selectedOrder.status == 9}">
                                            <a href="return-process?orderId=${selectedOrder.order_id}"
                                                class="btn btn-primary">Bắt đầu kiểm hàng ngay</a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>