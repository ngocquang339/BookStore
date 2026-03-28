<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <title>Thực hiện Lấy Hàng (Picking)</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <style>
                    body {
                        background-color: #f8f9fa;
                    }

                    .card-custom {
                        border-radius: 10px;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                        border: none;
                    }

                    .checkbox-lg {
                        width: 20px;
                        height: 20px;
                        cursor: pointer;
                    }

                    .row-picked {
                        background-color: #d1e7dd !important;
                        transition: background-color 0.3s;
                    }
                </style>
            </head>

            <body>

                <div class="container mt-5">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold"><i class="fa-solid fa-boxes-packing text-primary"></i> Danh Sách Lấy Hàng
                            (Picking List)</h3>
                        <a href="${pageContext.request.contextPath}/warehouse/orders" class="btn btn-outline-secondary">
                            <i class="fa-solid fa-arrow-left"></i> Quay lại
                        </a>
                    </div>

                    <div class="card card-custom mb-4">
                        <div class="card-body bg-white rounded">
                            <h5 class="card-title text-primary border-bottom pb-2">Đơn hàng #${orderId}</h5>
                            <div class="row mt-3">
                                <div class="col-md-6">
                                    <p class="mb-1"><strong>Khách hàng:</strong> ${orderInfo.fullname}</p>
                                    <p class="mb-1"><strong>Điện thoại:</strong> ${orderInfo.phone}</p>
                                </div>
                                <div class="col-md-6">
                                    <p class="mb-1"><strong>Địa chỉ giao:</strong> ${orderInfo.address}</p>
                                    <p class="mb-1"><strong>Ngày đặt:</strong>
                                        <fmt:formatDate value="${orderInfo.order_date}" pattern="dd/MM/yyyy HH:mm" />
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/warehouse/picking"
                        onsubmit="return validatePickingForm()">
                        <input type="hidden" name="orderId" value="${orderId}">

                        <div class="card card-custom">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle table-bordered mb-0">
                                    <thead class="table-dark">
                                        <tr>
                                            <th class="text-center">STT</th>
                                            <th>Tên Sách</th>
                                            <th class="text-center">Vị trí kho</th>
                                            <th class="text-center">Số Lượng Cần Lấy</th>
                                            <th class="text-center">
                                                <input type="checkbox" id="checkAll"
                                                    class="form-check-input checkbox-lg">
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${pickingItems}" varStatus="loop">
                                            <tr class="item-row">
                                                <td class="text-center fw-bold text-secondary">${loop.index + 1}</td>

                                                <td class="fw-bold">${item.title}</td>

                                                <td class="text-center">
                                                    <span class="badge bg-info text-dark">
                                                        ${item.location_code}
                                                    </span>
                                                </td>

                                                <td class="text-center fs-5 fw-bold text-danger">
                                                    ${item.quantity}
                                                </td>

                                                <td class="text-center">
                                                    <input type="checkbox"
                                                        class="form-check-input checkbox-lg pick-checkbox"
                                                        onchange="toggleRowBackground(this)">
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div class="card-footer bg-white d-flex justify-content-end p-3 border-top">
                                <div class="me-4 d-flex align-items-center">
                                    <span class="fw-bold text-secondary me-2">Tiến độ:</span>
                                    <span id="progressText" class="badge bg-secondary fs-6">0 /
                                        ${pickingItems.size()}</span>
                                </div>

                                <button type="submit" class="btn btn-success btn-lg px-4 shadow-sm" id="btnConfirm">
                                    <i class="fa-solid fa-check-double"></i> Xác nhận và đóng gói
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <script>
                    // Hàm đổi màu dòng khi được tick và cập nhật tiến độ
                    function toggleRowBackground(checkbox) {
                        const row = checkbox.closest('tr');

                        checkbox.checked
                            ? row.classList.add('row-picked')
                            : row.classList.remove('row-picked');

                        updateProgress();
                    }

                    // Hàm cập nhật chữ Tiến độ (VD: 2/3)
                    function updateProgress() {
                        var total = document.querySelectorAll('.pick-checkbox').length;
                        var checked = document.querySelectorAll('.pick-checkbox:checked').length;
                        var progressText = document.getElementById('progressText');
                        progressText.innerText = checked + " / " + total;

                        if (checked === total) {
                            progressText.className = "badge bg-success fs-6";
                        } else {
                            progressText.className = "badge bg-secondary fs-6";
                        }
                    }

                    // Hàm kiểm tra trước khi submit form (Bắt buộc phải tick đủ)
                    function validatePickingForm() {
                        var total = document.querySelectorAll('.pick-checkbox').length;
                        var checked = document.querySelectorAll('.pick-checkbox:checked').length;

                        if (total !== checked) {
                            alert("⚠️ Vui lòng hoàn tất việc lấy hàng! Bạn phải tick xác nhận ĐÃ LẤY (Picked) cho tất cả các sách trong danh sách trước khi đóng gói.");
                            return false; // Ngăn không cho form submit
                        }
                        return confirm("Xác nhận đã đóng gói đầy đủ đơn hàng này? ");
                    }

                    // Checkbox tổng cho cột "Đã Lấy"
                    document.addEventListener('DOMContentLoaded', function () {
                        const checkAllBox = document.getElementById('checkAll');
                        const pickCheckboxes = document.querySelectorAll('.pick-checkbox');

                        if (checkAllBox) {
                            checkAllBox.addEventListener('change', function () {
                                pickCheckboxes.forEach(cb => {
                                    cb.checked = checkAllBox.checked;

                                    const row = cb.closest('tr');
                                    if (checkAllBox.checked) {
                                        row.classList.add('row-picked');
                                    } else {
                                        row.classList.remove('row-picked');
                                    }
                                });
                                updateProgress();
                            });
                        }

                        // Khi người dùng tick từng ô, cập nhật checkbox tổng
                        pickCheckboxes.forEach(cb => {
                            cb.addEventListener('change', function () {
                                const allChecked = Array.from(pickCheckboxes).every(c => c.checked);
                                checkAllBox.checked = allChecked; // tick tổng nếu tất cả ô được tick
                            });
                        });
                    });
                </script>
            </body>

            </html>