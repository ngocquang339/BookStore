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
        .book-img { width: 60px; height: 80px; object-fit: cover; border-radius: 4px; }
        
        /* CSS ẢO DIỆU CHO CHỨC NĂNG IN (PRINT INVOICE) */
        @media print {
            body { background-color: white; padding: 0; margin: 0; }
            .d-print-none { display: none !important; } /* Ẩn các nút bấm và form ghi chú khi in */
            .card { border: none !important; box-shadow: none !important; }
            .card-header { background-color: white !important; color: black !important; border-bottom: 2px solid black; }
            .container { max-width: 100% !important; margin: 0 !important; }
            .print-full-width { width: 100% !important; flex: 0 0 100% !important; max-width: 100% !important; }
        }
    </style>
</head>
<body>
    <div class="container mt-4 mb-5">
        
        <div class="d-flex justify-content-between align-items-center mb-4 d-print-none border-bottom pb-3">
            <a href="${pageContext.request.contextPath}/orders-management" class="btn btn-outline-secondary fw-bold shadow-sm">
                <i class=\"fa-solid fa-arrow-left\"></i> Quay lại Dashboard
            </a>
            
            <h3 class="text-primary fw-bold mb-0 text-center text-uppercase">
                <i class="fa-solid fa-file-invoice"></i> CHI TIẾT ĐƠN HÀNG #${order.id}
            </h3>
            
            <button onclick="window.print()" class="btn btn-dark shadow-sm fw-bold">
                <i class="fa-solid fa-print"></i> In phiếu giao hàng
            </button>
        </div>

        <div class="row">
            <div class="col-md-4 mb-4 print-full-width">
                
                <div class="card shadow-sm mb-4 border-0">
                    <div class="card-header bg-dark text-white fw-bold">
                        <i class="fa-solid fa-truck-fast me-2"></i> Thông tin giao hàng
                    </div>
                    <div class="card-body bg-white">
                        <p><strong>Khách hàng:</strong> ${order.userName}</p>
                        <p><strong>Số điện thoại:</strong> ${order.phoneNumber}</p>
                        <p><strong>Địa chỉ:</strong> ${order.shippingAddress}</p>
                        <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></p>
                        <p class="mb-0"><strong>Trạng thái:</strong> 
                            <c:choose>
                                <c:when test="${order.status == 1}"><span class="badge bg-warning text-dark px-2 py-1">Chờ xử lý</span></c:when>
                                <c:when test="${order.status == 2}"><span class="badge bg-primary px-2 py-1">Đang xử lí</span></c:when>
                                <c:when test="${order.status == 3}"><span class="badge bg-info px-2 py-1 text-dark">Đang giao</span></c:when>
                                <c:when test="${order.status == 4}"><span class="badge bg-success px-2 py-1">Hoàn thành</span></c:when>
                                <c:when test="${order.status == 5}"><span class="badge bg-danger px-2 py-1">Đã hủy</span></c:when>
                            </c:choose>
                        </p>
                    </div>
                </div>

                <div class="card shadow-sm border-warning d-print-none">
                    <div class="card-header bg-warning text-dark fw-bold">
                        <i class="fa-solid fa-user-pen me-2"></i> Ghi chú nội bộ (Staff)
                    </div>
                    <div class="card-body bg-light">
                        <form action="order-detail" method="POST">
                            <input type="hidden" name="orderId" value="${order.id}">
                            <textarea name="staffNote" class="form-control mb-3" rows="3" placeholder="Ghi chú về đơn hàng này (Khách hàng sẽ không thấy)...">${order.staffNote}</textarea>
                            <button type="submit" class="btn btn-warning w-100 fw-bold">
                                <i class="fa-solid fa-floppy-disk"></i> Lưu ghi chú
                            </button>
                        </form>
                    </div>
                </div>

            </div>

            <div class="col-md-8 mb-4 print-full-width">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-dark text-white fw-bold">
                        <i class="fa-solid fa-box-open me-2"></i> Sản phẩm đã đặt
                    </div>
                    <div class="card-body p-0 bg-white">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light text-center">
                                    <tr>
                                        <th class="text-start ps-3">Sản phẩm</th>
                                        <th>Đơn giá</th>
                                        <th>Số lượng</th>
                                        <th class="text-end pe-3">Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listDetails}" var="item">
                                        <tr>
                                            <td class="ps-3">
                                                <div class="d-flex align-items-center">
                                                    <img src="${pageContext.request.contextPath}/${item.book.imageUrl}" 
                                                         class="book-img me-3 border shadow-sm d-print-none" 
                                                         alt="${item.book.title}"
                                                         onerror="this.src='https://placehold.co/60x80?text=No+Image'">
                                                    <h6 class="mb-0 fw-bold text-dark">${item.book.title}</h6>
                                                </div>
                                            </td>
                                            <td class="text-center text-muted">
                                                <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="đ"/>
                                            </td>
                                            <td class="text-center fw-bold text-primary">x${item.quantity}</td>
                                            <td class="text-end fw-bold text-danger pe-3">
                                                <fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="đ"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot class="table-light">
                                    <tr>
                                        <td colspan="3" class="text-end fw-bold fs-5 pt-3">Tổng cộng:</td>
                                        <td class="text-end fw-bold fs-5 text-danger pe-3 pt-3">
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>