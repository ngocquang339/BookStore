<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sale Dashboard - BookStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .table-hover tbody tr:hover { background-color: #f1f1f1; }
    </style>
</head>
<body>
    <div class="container-fluid mt-4 px-4">
        
        <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-dark fw-bold d-flex align-items-center gap-2">
                <i class="fa-solid fa-house"></i> Back to Shop
            </a>
            <h2 class="text-primary m-0 fw-bold">BẢNG QUẢN LÝ ĐƠN HÀNG (SALE STAFF)</h2>
            <div style="width: 140px;"></div> </div>
        
        <div class="row mb-3">
            <div class="col-md-4">
                <div class="input-group">
                    <input type="text" class="form-control" placeholder="Nhập SĐT khách cần hỗ trợ...">
                    <button class="btn btn-primary"><i class="fa-solid fa-search"></i> Tìm kiếm</button>
                </div>
            </div>
        </div>

        <div class="table-responsive bg-white shadow-sm rounded border">
            <table class="table table-bordered table-hover align-middle mb-0">
                <thead class="table-dark text-center">
                    <tr>
                        <th>ID</th>
                        <th>Ngày đặt</th>
                        <th>Khách hàng</th>
                        <th>SĐT / Địa chỉ</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái (Xử lý)</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${orders}" var="o">
                        <tr>
                            <td class="text-center fw-bold">#${o.id}</td>

                            <td class="text-center text-muted">
                                <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>

                            <td class="fw-bold text-secondary text-center">${o.userName}</td>

                            <td>
                                <span class="fw-bold text-dark"><i class="fa-solid fa-phone fa-sm me-1"></i> ${o.phoneNumber}</span><br>
                                <small class="text-muted"><i class="fa-solid fa-location-dot fa-sm me-1"></i> ${o.shippingAddress}</small>
                            </td>

                            <td class="fw-bold text-danger text-end pe-3">
                                <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="đ"/>
                            </td>
                            
                            <td>
                                <form action="${pageContext.request.contextPath}/dashboard" method="post" class="d-flex align-items-center justify-content-center gap-2 mb-0">
                                    <input type="hidden" name="orderId" value="${o.id}">
                                    
                                    <input type="hidden" name="currentTab" value="${currentStatus}">
                                    
                                    <select name="newStatus" class="form-select form-select-sm" style="width: 140px; font-weight: 500;">
                                        <option value="1" class="text-warning fw-bold" ${o.status == 1 ? 'selected' : ''}>Chờ xử lý</option>
                                        <option value="2" class="text-primary fw-bold" ${o.status == 2 ? 'selected' : ''}>Đang giao</option>
                                        <option value="3" class="text-success fw-bold" ${o.status == 3 ? 'selected' : ''}>Hoàn thành</option>
                                        <option value="4" class="text-danger fw-bold" ${o.status == 4 ? 'selected' : ''}>Đã hủy</option>
                                    </select>
                                    
                                    <button type="submit" class="btn btn-primary btn-sm" title="Lưu thay đổi">
                                        <i class="fa-solid fa-floppy-disk"></i> Lưu
                                    </button>
                                </form>
                            </td>

                            <td class="text-center">
                                <a href="order-detail?id=${o.id}" class="btn btn-sm btn-outline-secondary">
                                    <i class="fa-solid fa-circle-info"></i> Chi tiết
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="7" class="text-center py-4 text-muted">
                                Không có đơn hàng nào để hiển thị.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>