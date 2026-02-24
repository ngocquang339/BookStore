<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập nhật trạng thái đơn hàng #${order.id}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
    </style>
</head>
<body>
    <div class="container mt-5">
        
        <h3 class="mb-4 text-primary fw-bold text-center border-bottom pb-3">
            <i class="fa-solid fa-pen-to-square"></i> CẬP NHẬT TRẠNG THÁI ĐƠN HÀNG
        </h3>

        <div class="table-responsive bg-white shadow-sm rounded border mb-5">
            <form action="edit-status" method="post" class="m-0">
                <input type="hidden" name="orderId" value="${order.id}">
                
                <table class="table table-bordered align-middle mb-0">
                    <thead class="table-dark text-center">
                        <tr>
                            <th>ID</th>
                            <th>Ngày đặt</th>
                            <th>Khách hàng</th>
                            <th>SĐT / Địa chỉ</th>
                            <th>Tổng tiền</th>
                            <th style="width: 180px;">Cập nhật trạng thái</th>
                            <th style="width: 180px;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="text-center fw-bold">#${order.id}</td>
                            
                            <td class="text-center text-muted">
                                <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            
                            <td class="fw-bold text-secondary text-center">${order.userName}</td>
                            
                            <td>
                                <span class="fw-bold text-dark"><i class="fa-solid fa-phone fa-sm me-1"></i> ${order.phoneNumber}</span><br>
                                <small class="text-muted"><i class="fa-solid fa-location-dot fa-sm me-1"></i> ${order.shippingAddress}</small>
                            </td>
                            
                            <td class="fw-bold text-danger text-end pe-3">
                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="đ"/>
                            </td>
                            
                            <td class="text-center px-2">
                                <select name="newStatus" class="form-select border-primary fw-bold text-dark shadow-sm">
                                    <option value="1" ${order.status == 1 ? 'selected' : ''}>Chờ xử lý</option>
                                    <option value="2" ${order.status == 2 ? 'selected' : ''}>Đang giao</option>
                                    <option value="3" ${order.status == 3 ? 'selected' : ''}>Hoàn thành</option>
                                    <option value="4" ${order.status == 4 ? 'selected' : ''}>Đã hủy</option>
                                </select>
                            </td>

                            <td class="text-center">
                                <div class="d-flex justify-content-center gap-2">
                                    <a href="dashboard" class="btn btn-outline-secondary" title="Quay lại">
                                        <i class="fa-solid fa-arrow-left"></i>
                                    </a>
                                    <button type="submit" class="btn btn-success shadow-sm" title="Lưu thay đổi">
                                        <i class="fa-solid fa-floppy-disk"></i> Lưu
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>