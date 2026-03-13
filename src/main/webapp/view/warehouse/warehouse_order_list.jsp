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
                    body {
                        background-color: #f8f9fa;
                    }

                    .table-container {
                        background: white;
                        padding: 20px;
                        border-radius: 8px;
                        box-shadow: 0 0 15px rgba(0, 0, 0, 0.05);
                    }
                </style>
            </head>

            <body>

                <div class="container-fluid px-4 mt-4 mb-5">

                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                            <strong><i class="fa-solid fa-triangle-exclamation"></i> Lỗi!</strong>
                            ${sessionScope.errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="errorMessage" scope="session" />
                    </c:if>
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                            <strong><i class="fa-solid fa-circle-check"></i> Thành công!</strong>
                            ${sessionScope.successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <c:remove var="successMessage" scope="session" />
                    </c:if>

                    <h3 class="mb-4">Quản Lý Xuất Kho & Đơn Hàng</h3>

                    <div class="table-container mb-4">
                        <form action="${pageContext.request.contextPath}/warehouse/orders" method="GET"
                            class="row g-3 align-items-end">
                            <div class="col-md-4">
                                <label class="form-label">Tên Khách Hàng</label>
                                <input type="text" name="search" class="form-control" value="${currentSearch}"
                                    placeholder="Nhập tên khách hàng...">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Trạng thái đơn hàng</label>
                                <select name="status" class="form-select">
                                    <option value="0">Tất cả</option>
                                    <option value="2" ${currentStatus==2 ? 'selected' : '' }>Processing (Chờ lấy hàng)
                                    </option>
                                    <option value="3" ${currentStatus==3 ? 'selected' : '' }>Packed (Đã đóng gói)
                                    </option>
                                    <option value="4" ${currentStatus==4 ? 'selected' : '' }>Shipping (Đang giao)
                                    </option>
                                    <option value="5" ${currentStatus==5 ? 'selected' : '' }>Delivered (Đã giao)
                                    </option>
                                    <option value="6" ${currentStatus==6 ? 'selected' : '' }>Cancelled (Đã hủy)</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100"><i class="fa-solid fa-filter"></i>
                                    Lọc dữ liệu</button>
                            </div>
                        </form>
                    </div>

                    <div class="table-container">
                        <table id="orderTable" class="table table-hover table-bordered">
                            <thead class="table-light">
                                <tr>
                                    <th>Mã ĐH</th>
                                    <th>Khách Hàng</th>
                                    <th>Ngày Đặt</th>
                                    <th>Tổng Tiền</th>
                                    <th>Trạng Thái</th>
                                    <th>Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="o" items="${orderList}">
                                    <tr>
                                        <td class="fw-bold text-primary">#${o.order_id}</td>
                                        <td>${o.fullname}</td>
                                        <td>
                                            <fmt:formatDate value="${o.order_date}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${o.total_amount}" type="currency"
                                                currencySymbol="VNĐ" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${o.status == 2}"><span
                                                        class="badge bg-warning text-dark">Processing</span></c:when>
                                                <c:when test="${o.status == 3}"><span
                                                        class="badge bg-info text-dark">Packed</span></c:when>
                                                <c:when test="${o.status == 4}"><span
                                                        class="badge bg-primary">Shipping</span></c:when>
                                                <c:when test="${o.status == 5}"><span
                                                        class="badge bg-success">Delivered</span></c:when>
                                                <c:when test="${o.status == 6}"><span
                                                        class="badge bg-danger">Cancelled</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary">Pending</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/warehouse/orders?viewId=${o.order_id}&viewStatus=${o.status}&search=${currentSearch}&status=${currentStatus}"
                                                class="btn btn-sm btn-outline-secondary">
                                                <i class="fa-solid fa-eye"></i> View
                                            </a>

                                            <c:if test="${o.status == 3}">
                                                <form action="${pageContext.request.contextPath}/warehouse/orders"
                                                    method="POST" class="d-inline">
                                                    <input type="hidden" name="action" value="ship">
                                                    <input type="hidden" name="orderId" value="${o.order_id}">
                                                    <button type="submit" class="btn btn-sm btn-primary"
                                                        onclick="return confirm('Xác nhận xuất kho cho đơn hàng này?');">
                                                        <i class="fa-solid fa-truck-fast"></i> Ship Order
                                                    </button>
                                                </form>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                </div>

                <c:if test="${not empty orderDetails}">
                    <div class="modal fade" id="orderDetailModal" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header bg-dark text-white">
                                    <h5 class="modal-title">Chi Tiết Đơn Hàng #${selectedOrderId}</h5>
                                    <a href="${pageContext.request.contextPath}/warehouse/orders?search=${currentSearch}&status=${currentStatus}"
                                        class="btn-close btn-close-white"></a>
                                </div>
                                <div class="modal-body">
                                    <h6>Danh Sách Sách Trong Đơn:</h6>
                                    <table class="table table-bordered mt-3">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Tên Sách</th>
                                                <th>Số Lượng</th>
                                                <th>Giá Tiền</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${orderDetails}">
                                                <tr>
                                                    <td>${item.title}</td>
                                                    <td>${item.quantity}</td>
                                                    <td>
                                                        <fmt:formatNumber value="${item.price}" type="currency"
                                                            currencySymbol="VNĐ" />
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="modal-footer">
                                    <c:if test="${selectedOrderStatus == 2}">
                                        <a href="${pageContext.request.contextPath}/warehouse/picking?orderId=${selectedOrderId}"
                                            class="btn btn-success">
                                            <i class="fa-solid fa-boxes-packing"></i> Start Picking
                                        </a>
                                    </c:if>

                                    <c:if test="${selectedOrderStatus == 2 || selectedOrderStatus == 3}">
                                        <form action="${pageContext.request.contextPath}/warehouse/orders" method="POST"
                                            class="d-inline">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="orderId" value="${selectedOrderId}">
                                            <button type="submit" class="btn btn-danger"
                                                onclick="return confirm('Báo lỗi/Hủy đơn hàng này?');">
                                                <i class="fa-solid fa-ban"></i> Báo lỗi (Cancel)
                                            </button>
                                        </form>
                                    </c:if>

                                    <a href="${pageContext.request.contextPath}/warehouse/orders?search=${currentSearch}&status=${currentStatus}"
                                        class="btn btn-secondary">Đóng</a>
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
                            "order": [[2, "desc"]] // Sort theo ngày đặt mặc định
                        });

                        // Tự động mở Modal nếu có dữ liệu từ Server trả về
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