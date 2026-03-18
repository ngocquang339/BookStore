<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Duyệt Đơn Nhập Hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-dark text-white d-flex justify-content-between">
            <h4 class="mb-0">Chi tiết đơn nhập #PO-${order.purchaseOrderId}</h4>
            <span class="badge bg-warning text-dark">Chờ Duyệt (Pending)</span>
        </div>
        <div class="card-body">
            <div class="row mb-4">
                <div class="col-md-6">
                    <p><strong>Nhà cung cấp:</strong> ${order.supplierName}</p>
                    <p><strong>Người tạo:</strong> ${order.createdByName}</p>
                </div>
                <div class="col-md-6 text-end">
                    <p><strong>Ngày tạo:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></p>
                </div>
            </div>

            <table class="table table-bordered">
                <thead class="table-secondary">
                    <tr>
                        <th>Tên Sách</th>
                        <th class="text-center">Số lượng</th>
                        <th class="text-end">Giá nhập</th>
                        <th class="text-end">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${items}">
                        <tr>
                            <td>${item.book.title}</td>
                            <td class="text-center">${item.expectedQuantity}</td>
                            <td class="text-end"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫"/></td>
                            <td class="text-end">
                                <fmt:formatNumber value="${item.expectedQuantity * item.price}" type="currency" currencySymbol="₫"/>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <th colspan="3" class="text-end">Tổng cộng:</th>
                        <th class="text-end text-danger h5">
                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                        </th>
                    </tr>
                </tfoot>
            </table>
        </div>
        <div class="card-footer text-end">
            <a href="view-po" class="btn btn-secondary">Quay lại</a>
            
            <%-- Only show Approve button if status is 0 --%>
            <c:if test="${order.status == 0}">
                <form action="approve-po" method="POST" style="display:inline;">
                    <input type="hidden" name="poId" value="${order.purchaseOrderId}">
                    <button type="submit" class="btn btn-primary" onclick="return confirm('Bạn có chắc chắn muốn duyệt đơn này?')">
                        Phê Duyệt Đơn Hàng
                    </button>
                </form>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>