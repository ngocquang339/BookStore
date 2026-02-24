<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập nhật trạng thái đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">
    <div class="container mt-5" style="max-width: 500px;">
        <div class="card shadow">
            <div class="card-header bg-primary text-white text-center">
                <h4 class="mb-0 fw-bold">Cập nhật đơn hàng #${order.id}</h4>
            </div>
            <div class="card-body">
                <form action="edit-status" method="post">
                    <input type="hidden" name="orderId" value="${order.id}">
                    
                    <div class="mb-4">
                        <label class="form-label fw-bold">Trạng thái hiện tại của đơn hàng:</label>
                        <select name="newStatus" class="form-select form-select-lg">
                            <option value="1" ${order.status == 1 ? 'selected' : ''}>Chờ xử lý</option>
                            <option value="2" ${order.status == 2 ? 'selected' : ''}>Đang giao</option>
                            <option value="3" ${order.status == 3 ? 'selected' : ''}>Hoàn thành</option>
                            <option value="4" ${order.status == 4 ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <a href="dashboard" class="btn btn-outline-secondary">
                            <i class="fa-solid fa-arrow-left"></i> Quay lại
                        </a>
                        <button type="submit" class="btn btn-success px-4">
                            <i class="fa-solid fa-floppy-disk"></i> Lưu thay đổi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>