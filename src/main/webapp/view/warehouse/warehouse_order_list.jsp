<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đơn hàng xuất kho</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body { background-color: #f8f9fa; }
        
        .card-custom {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            border: none;
            padding: 20px;
        }
        
        .customer-info-box {
            background-color: #f8f9fa;
            border-left: 4px solid #0d6efd;
            padding: 15px;
            border-radius: 5px;
        }
        
        .table th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 0.4px;
            color: #495057;
        }
        .table-hover tbody tr:hover {
            background-color: #f1f3f5;
        }
    </style>
</head>
<body>

<div class="container-fluid px-4 mt-4 mb-5">
    
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <strong><i class="fa-solid fa-triangle-exclamation"></i> Lỗi!</strong> ${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <strong><i class="fa-solid fa-circle-check"></i> Thành công!</strong> ${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <h3 class="mb-4 fw-bold">Quản Lý Xuất Kho & Đơn Hàng</h3>

    <div class="card card-custom mb-4">
        <form action="${pageContext.request.contextPath}/warehouse/orders" method="GET" class="row g-3 align-items-end">
            <div class="col-md-4">
                <label class="form-label fw-bold text-secondary">Tên Khách Hàng</label>
                <input type="text" name="search" class="form-control" value="${currentSearch}" placeholder="Nhập tên khách hàng...">
            </div>
            <div class="col-md-3">
                <label class="form-label fw-bold text-secondary">Trạng thái đơn hàng</label>
                <select name="status" class="form-select">
                    <option value="0">Tất cả</option>
                    <option value="2" ${currentStatus == 2 ? 'selected' : ''}>Processing (Chờ lấy hàng)</option>
                    <option value="3" ${currentStatus == 3 ? 'selected' : ''}>Packed (Đã đóng gói)</option>
                    <option value="4" ${currentStatus == 4 ? 'selected' : ''}>Shipping (Đang giao)</option>
                    <option value="5" ${currentStatus == 5 ? 'selected' : ''}>Delivered (Đã giao)</option>
                    <option value="6" ${currentStatus == 6 ? 'selected' : ''}>Cancelled (Đã hủy)</option>
                </select>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary w-100 shadow-sm"><i class="fa-solid fa-filter"></i> Lọc dữ liệu</button>
            </div>
        </form>
    </div>

    <div class="card card-custom">
        <div class="table-responsive">
            <table id="orderTable" class="table table-hover align-middle table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Mã ĐH</th>
                        <th>Khách Hàng</th>
                        <th>Ngày Đặt</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th class="text-center">Hành Động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${orderList}">
                        <tr>
                            <td class="fw-bold text-primary">#${o.order_id}</td>
                            <td>${o.fullname}</td>
                            <td><fmt:formatDate value="${o.order_date}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td class="fw-bold text-danger"><fmt:formatNumber value="${o.total_amount}" type="currency" currencySymbol="VNĐ"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${o.status == 2}"><span class="badge bg-warning text-dark"><i class="fa-solid fa-spinner fa-spin-pulse"></i> Processing</span></c:when>
                                    <c:when test="${o.status == 3}"><span class="badge bg-info text-dark"><i class="fa-solid fa-box-open"></i> Packed</span></c:when>
                                    <c:when test="${o.status == 4}"><span class="badge bg-primary"><i class="fa-solid fa-truck-fast"></i> Shipping</span></c:when>
                                    <c:when test="${o.status == 5}"><span class="badge bg-success"><i class="fa-solid fa-check-double"></i> Delivered</span></c:when>
                                    <c:when test="${o.status == 6}"><span class="badge bg-danger"><i class="fa-solid fa-ban"></i> Cancelled</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">Pending</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <div class="d-flex justify-content-center align-items-center gap-2">
                                    <a href="${pageContext.request.contextPath}/warehouse/orders?viewId=${o.order_id}&viewStatus=${o.status}&search=${currentSearch}&status=${currentStatus}" 
                                       class="btn btn-sm btn-outline-primary shadow-sm text-nowrap">
                                        <i class="fa-solid fa-eye"></i> View
                                    </a>
                                    
                                    <c:if test="${o.status == 3}">
                                        <form action="${pageContext.request.contextPath}/warehouse/orders" method="POST" class="m-0">
                                            <input type="hidden" name="action" value="ship">
                                            <input type="hidden" name="orderId" value="${o.order_id}">
                                            <button type="submit" class="btn btn-sm btn-primary shadow-sm text-nowrap" onclick="return confirm('Xác nhận xuất kho cho đơn hàng này?');">
                                                <i class="fa-solid fa-truck-fast"></i> Ship Order
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</div>

<c:if test="${not empty orderDetails}">
    <div class="modal fade shadow" id="orderDetailModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title fw-bold">
                        <i class="fa-solid fa-file-invoice"></i> Chi Tiết Đơn Hàng #${selectedOrderId}
                    </h5>
                    <a href="${pageContext.request.contextPath}/warehouse/orders?search=${currentSearch}&status=${currentStatus}" class="btn-close btn-close-white"></a>
                </div>
                
                <div class="modal-body p-4">
                    <div class="customer-info-box mb-4">
                        <h6 class="fw-bold mb-3 text-primary"><i class="fa-solid fa-user"></i> Thông tin nhận hàng</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Khách hàng:</strong> ${orderInfo.fullname}</p>
                                <p class="mb-1"><strong>Điện thoại:</strong> ${orderInfo.phone}</p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Ngày đặt:</strong> <fmt:formatDate value="${orderInfo.order_date}" pattern="dd/MM/yyyy HH:mm"/></p>
                                <p class="mb-1"><strong>Địa chỉ:</strong> ${orderInfo.address}</p>
                            </div>
                        </div>
                    </div>

                    <h6 class="fw-bold mb-3"><i class="fa-solid fa-list"></i> Danh Sách Sách Trong Đơn:</h6>
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped align-middle mt-2">
                            <thead class="table-light text-center">
                                <tr>
                                    <th>STT</th>
                                    <th class="text-start">Tên Sách</th>
                                    <th>Số Lượng</th>
                                    <th>Đơn Giá</th>
                                    <th>Thành Tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="totalModalMoney" value="0"/>
                                <c:forEach var="item" items="${orderDetails}" varStatus="loop">
                                    <tr>
                                        <td class="text-center">${loop.index + 1}</td>
                                        <td class="fw-bold">${item.title}</td>
                                        <td class="text-center">${item.quantity}</td>
                                        <td class="text-end"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="VNĐ"/></td>
                                        <td class="text-end fw-bold text-success">
                                            <fmt:formatNumber value="${item.quantity * item.price}" type="currency" currencySymbol="VNĐ"/>
                                        </td>
                                    </tr>
                                    <c:set var="totalModalMoney" value="${totalModalMoney + (item.quantity * item.price)}" />
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="d-flex justify-content-end mt-3 border-top pt-3">
                        <h5 class="mb-0">Tổng thanh toán: 
                            <span class="text-danger fw-bold ms-2">
                                <fmt:formatNumber value="${totalModalMoney}" type="currency" currencySymbol="VNĐ"/>
                            </span>
                        </h5>
                    </div>
                </div>
                
                <div class="modal-footer bg-light">
                    <a href="${pageContext.request.contextPath}/warehouse/orders?search=${currentSearch}&status=${currentStatus}" class="btn btn-secondary">Đóng</a>
                    
                    <c:if test="${selectedOrderStatus == 2 || selectedOrderStatus == 3}">
                         <form action="${pageContext.request.contextPath}/warehouse/orders" method="POST" class="d-inline m-0">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="orderId" value="${selectedOrderId}">
                            <button type="submit" class="btn btn-danger" onclick="return confirm('Báo lỗi/Hủy đơn hàng này?');">
                                <i class="fa-solid fa-ban"></i> Báo lỗi (Cancel)
                            </button>
                        </form>
                    </c:if>

                    <c:if test="${selectedOrderStatus == 2}">
                        <a href="${pageContext.request.contextPath}/warehouse/picking?orderId=${selectedOrderId}" class="btn btn-success">
                            <i class="fa-solid fa-boxes-packing"></i> Start Picking
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</c:if>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function () {
        $('#orderTable').DataTable({
            "language": { "url": "//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json" },
            "order": [[ 2, "desc" ]]
        });

        <c:if test="${not empty orderDetails}">
            var myModal = new bootstrap.Modal(document.getElementById('orderDetailModal'), {
                keyboard: false,
                backdrop: 'static'
            });
            myModal.show();
        </c:if>
    });
</script>
</body>
</html>