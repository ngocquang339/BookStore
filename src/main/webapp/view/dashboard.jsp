<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sale Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid mt-4">
        <h2 class="text-primary text-center">BẢNG QUẢN LÝ ĐƠN HÀNG (SALE STAFF)</h2>
        
        <div class="row mb-3">
            <div class="col-md-4">
                <input type="text" class="form-control" placeholder="Nhập SĐT khách cần hỗ trợ...">
            </div>
            <div class="col-md-2">
                <button class="btn btn-primary">Tìm kiếm</button>
            </div>
        </div>

        <table class="table table-bordered table-hover">
            <thead class="table-dark">
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
            <td>#${o.id}</td>

            <td>
                <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
            </td>

            <td>${o.userName}</td>

            <td>
                ${o.phoneNumber}<br>
                <small class="text-muted">${o.shippingAddress}</small>
            </td>

            <td class="fw-bold text-danger">
                <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="đ"/>
            </td>
            
            <td>
                <form action="${pageContext.request.contextPath}/sale/dashboard" method="post" class="d-flex">
                    <input type="hidden" name="orderId" value="${o.id}">
                    <input type="hidden" name="newStatus" id="statusInput_${o.id}">
                    
                    <select class="form-select form-select-sm" 
                            onchange="this.form.newStatus.value=this.value; this.form.submit()">
                        <option value="1" ${o.status == 1 ? 'selected' : ''} class="text-warning">Chờ xử lý</option>
                        <option value="2" ${o.status == 2 ? 'selected' : ''} class="text-info">Đang giao</option>
                        <option value="3" ${o.status == 3 ? 'selected' : ''} class="text-success">Hoàn thành</option>
                        <option value="4" ${o.status == 4 ? 'selected' : ''} class="text-danger">Đã hủy</option>
                    </select>
                </form>
            </td>

            <td>
                <a href="#" class="btn btn-sm btn-outline-dark">Chi tiết</a>
            </td>
        </tr>
    </c:forEach>
</tbody>
        </table>
    </div>
</body>
</html>