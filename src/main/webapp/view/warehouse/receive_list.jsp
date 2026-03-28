<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác Nhận Nhập Kho</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: Arial, sans-serif; }
        .card { border: none; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05); }
        .table th { background-color: #f1f4f8; }
    </style>
</head>
<body>

<div class="container-fluid mt-4 mb-5 px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary m-0">
            <i class="fas fa-clipboard-check"></i> Xác Nhận Hàng PO #${poId}
        </h2>
        <div>
            <a href="${pageContext.request.contextPath}/warehouse/view-po" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/warehouse/receive-goods" method="post" id="receiveForm">
        <input type="hidden" name="poId" value="${poId}">
        
        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4 text-center">
                                <input class="form-check-input" type="checkbox" id="checkAll">
                            </th>
                            <th>Mã Sách</th>
                            <th>Tiêu Đề</th>
                            <th>Tác Giả</th>
                            <th>Nhà Cung Cấp</th>
                            <th class="text-center">S.Lượng Dự Kiến</th>
                            <th class="text-end pe-4">Đơn Giá</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${receiveList}" var="item">
                            <tr>
                                <td class="ps-4 text-center">
                                    <input class="form-check-input item-checkbox" type="checkbox" name="selectedBooks" value="${item.book.id}">
                                </td>
                                <td class="fw-bold">${item.book.id}</td>
                                <td>${item.book.title}</td>
                                <td>${item.book.author}</td>
                                <td>${item.book.supplier}</td>
                                
                                <td class="text-center text-success fw-bold">+${item.expectedQuantity}</td>
                                <td class="text-end pe-4">
                                    <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty receiveList}">
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">Không có chi tiết đơn hàng!</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <div class="card-footer bg-white text-end py-3">
                <button type="submit" class="btn btn-success px-4" id="confirmBtn" disabled>
                    <i class="fas fa-check-circle"></i> Confirm Receive
                </button>
            </div>
        </div>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const checkAll = document.getElementById('checkAll');
        const itemCheckboxes = document.querySelectorAll('.item-checkbox');
        const confirmBtn = document.getElementById('confirmBtn');

        function toggleConfirmButton() {
            // Nút mở nếu có ít nhất 1 checkbox được tick
            const anyChecked = Array.from(itemCheckboxes).some(cb => cb.checked);
            confirmBtn.disabled = !anyChecked;
        }

        if(checkAll) {
            checkAll.addEventListener('change', function() {
                itemCheckboxes.forEach(cb => cb.checked = checkAll.checked);
                toggleConfirmButton();
            });
        }

        itemCheckboxes.forEach(cb => {
            cb.addEventListener('change', function() {
                if (!this.checked) checkAll.checked = false;
                
                const allChecked = Array.from(itemCheckboxes).every(c => c.checked);
                if (allChecked) checkAll.checked = true;

                toggleConfirmButton();
            });
        });
    });
</script>

</body>
</html>