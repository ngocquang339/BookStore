<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Duyệt Đơn Nhập Hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">
    <div class="container mt-4">
        <h2 class="mb-4"><i class="fas fa-clipboard-check"></i> Phê Duyệt Đơn Nhập Hàng</h2>

        <c:if test="${not empty sessionScope.successMsg}">
            <div class="alert alert-success">${sessionScope.successMsg}</div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="alert alert-danger">${sessionScope.errorMsg}</div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="card mb-4">
            <div class="card-body">
                <form action="po" method="get" class="d-flex gap-3">
                    <select name="status" class="form-select w-25">
                        <option value="-1" ${currentStatus == -1 ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="0" ${currentStatus == 0 ? 'selected' : ''}>Chờ duyệt (Pending)</option>
                        <option value="1" ${currentStatus == 1 ? 'selected' : ''}>Đã duyệt (Approved)</option>
                        <option value="2" ${currentStatus == 2 ? 'selected' : ''}>Đã nhập kho (Received)</option>
                        <option value="3" ${currentStatus == 3 ? 'selected' : ''}>Đã hủy (Cancelled)</option>
                    </select>
                    <button type="submit" class="btn btn-primary">Lọc</button>
                </form>
            </div>
        </div>

        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>Mã PO</th>
                            <th>Nhà Cung Cấp</th>
                            <th>Người tạo</th>
                            <th>Ngày tạo</th>
                            <th>Tổng tiền</th>
                            <th>Trạng Thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${poList}" var="po">
                            <tr>
                                <td><b>#PO-${po.purchaseOrderId}</b></td>
                                <td>${po.supplierName}</td>
                                <td>${po.createdByName}</td>
                                <td><fmt:formatDate value="${po.orderDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                <td class="text-danger fw-bold">
                                    <fmt:formatNumber value="${po.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${po.status == 0}"><span class="badge bg-warning text-dark">Pending</span></c:when>
                                        <c:when test="${po.status == 1}"><span class="badge bg-info text-dark">Approved</span></c:when>
                                        <c:when test="${po.status == 2}"><span class="badge bg-success">Received</span></c:when>
                                        <c:when test="${po.status == 3}"><span class="badge bg-danger">Cancelled</span></c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="po/review?id=${po.purchaseOrderId}" class="btn btn-sm btn-primary">Xem / Duyệt</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty poList}">
                            <tr><td colspan="7" class="text-center py-4">Không có dữ liệu</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>