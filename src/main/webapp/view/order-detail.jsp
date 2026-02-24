<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng #${order.id}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .book-img { width: 60px; height: 80px; object-fit: cover; }
    </style>
</head>
<body>
    <div class="container mt-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <a href="dashboard" class="btn btn-outline-secondary">
                <i class="fa-solid fa-arrow-left"></i> Quay lại Dashboard
            </a>
            <h3 class="text-primary fw-bold mb-0">CHI TIẾT ĐƠN HÀNG #${order.id}</h3>
            <div style="width: 150px;"></div>
        </div>

        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-header bg-dark text-white fw-bold">
                        <i class="fa-solid fa-user me-2"></i> Thông tin giao hàng
                    </div>
                    <div class="card-body">
                        <p><strong>Khách hàng:</strong> ${order.userName}</p>
                        <p><strong>Số điện thoại:</strong> ${order.phoneNumber}</p>
                        <p><strong>Địa chỉ:</strong> ${order.shippingAddress}</p>
                        <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></p>
                        <p class="mb-0"><strong>Trạng thái:</strong> 
                            <c:choose>
                                <c:when test="${order.status == 1}"><span class="badge bg-warning text-dark">Chờ xử lý</span></c:when>
                                <c:when test="${order.status == 2}"><span class="badge bg-primary">Đang giao</span></c:when>
                                <c:when test="${order.status == 3}"><span class="badge bg-success">Hoàn thành</span></c:when>
                                <c:when test="${order.status == 4}"><span class="badge bg-danger">Đã hủy</span></c:when>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </div>

            <div class="col-md-8 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-header bg-dark text-white fw-bold">
                        <i class="fa-solid fa-box-open me-2"></i> Sản phẩm đã đặt
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th class="text-center">Đơn giá</th>
                                        <th class="text-center">Số lượng</th>
                                        <th class="text-end pe-3">Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listDetails}" var="item">
                                        <tr>
                                            <td>
    <div class="d-flex align-items-center">
        <img src="${pageContext.request.contextPath}/assets/image/books/${item.book.imageUrl}" alt="book" class="book-img me-3 border rounded">
        <span class="fw-bold">${item.book.title}</span>
    </div>
</td>
                                            <td class="text-center text-muted">
                                                <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="đ"/>
                                            </td>
                                            <td class="text-center fw-bold">x${item.quantity}</td>
                                            <td class="text-end fw-bold text-danger pe-3">
                                                <fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="đ"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot class="table-light">
                                    <tr>
                                        <td colspan="3" class="text-end fw-bold fs-5">Tổng cộng:</td>
                                        <td class="text-end fw-bold fs-5 text-danger pe-3">
                                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="đ"/>
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>