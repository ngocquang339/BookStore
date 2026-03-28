<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Kiểm Hàng Hoàn Trả</title>

            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

            <style>
                body {
                    background-color: #fffaf0;
                }

                .card-custom {
                    border-radius: 12px;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                    border: none;
                }

                .checkbox-lg {
                    width: 22px;
                    height: 22px;
                    cursor: pointer;
                }

                .row-inspected {
                    background-color: #fff4e5 !important;
                }

                .disabled-btn {
                    opacity: 0.6;
                    pointer-events: none;
                }

                .progress-text {
                    font-weight: bold;
                    font-size: 0.9rem;
                }
            </style>
        </head>

        <body>

            <div class="container mt-5 mb-5">

                <a href="${pageContext.request.contextPath}/warehouse/returns" class="btn btn-outline-secondary mb-3">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                </a>

                <div class="card card-custom p-4">

                    <div class="d-flex justify-content-between mb-3 border-bottom pb-2">
                        <div>
                            <h4 class="text-warning">
                                <i class="fas fa-box-open me-2"></i>Kiểm Hàng Hoàn Trả
                            </h4>
                            <small>Đơn #${orderId} - ${orderInfo.customerName}</small>
                        </div>
                        <span class="badge bg-info text-dark align-self-center">Đang kiểm hàng</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/warehouse/return-process" method="POST"
                        onsubmit="return validateReturnForm()">
                        <input type="hidden" name="orderId" value="${orderId}">

                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th class="text-center" style="width: 60px;">
                                        <input type="checkbox" id="checkAll" class="form-check-input checkbox-lg"
                                            onchange="toggleAll(this)">
                                    </th>
                                    <th>Tên sách</th>
                                    <th class="text-center">SL</th>
                                    <th>Lý do của khách</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach items="${items}" var="item">
                                    <tr class="align-middle">
                                        <td class="text-center">
                                            <input type="checkbox" class="form-check-input inspect-checkbox checkbox-lg"
                                                onchange="handleRow(this)">
                                        </td>
                                        <td class="fw-bold">${item.bookTitle}</td>
                                        <td class="text-center">${item.quantity}</td>
                                        <td class="text-muted fst-italic">${item.customerReason}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="progress-text">Đã kiểm: <span id="checkedQty">0</span> / <span
                                    id="totalQty">0</span></span>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-4">
                            <button id="submitBtn" type="submit" name="qcAction" value="PASS"
                                class="btn btn-success px-4 fw-bold disabled-btn">
                                <i class="fas fa-check me-1"></i> Đạt QC & Nhập kho
                            </button>
                        </div>

                    </form>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <script>
                function handleRow(cb) {
                    const row = cb.closest('tr');
                    cb.checked ? row.classList.add('row-inspected') : row.classList.remove('row-inspected');
                    updateProgress();
                }

                function toggleAll(master) {
                    document.querySelectorAll('.inspect-checkbox').forEach(cb => {
                        cb.checked = master.checked;
                        handleRow(cb);
                    });
                }

                function updateProgress() {
                    const checkboxes = document.querySelectorAll('.inspect-checkbox');
                    let total = 0;
                    let checked = 0;

                    checkboxes.forEach(cb => {
                        const qty = parseInt(cb.closest('tr').querySelector('td:nth-child(3)').innerText);
                        total += qty;
                        if (cb.checked) checked += qty;
                    });

                    document.getElementById('checkedQty').innerText = checked;
                    document.getElementById('totalQty').innerText = total;

                    // Nút submit active khi tất cả quantity đã check
                    const btn = document.getElementById('submitBtn');
                    if (checked === total && total > 0) {
                        btn.classList.remove('disabled-btn');
                    } else {
                        btn.classList.add('disabled-btn');
                    }

                    // Đồng bộ checkbox Check All
                    const master = document.getElementById('checkAll');
                    master.checked = (checked === total && total > 0);
                }

                function validateReturnForm() {
                    const checkboxes = document.querySelectorAll('.inspect-checkbox');
                    let total = 0;
                    let checked = 0;

                    checkboxes.forEach(cb => {
                        const qty = parseInt(cb.closest('tr').querySelector('td:nth-child(3)').innerText);
                        total += qty;
                        if (cb.checked) checked += qty;
                    });

                    if (checked !== total) {
                        alert("Bạn chưa kiểm tra đủ số lượng hàng hoàn trả!");
                        return false;
                    }
                    return confirm("Xác nhận đã kiểm tra đủ số lượng hàng hoàn trả?");
                }

                document.addEventListener("DOMContentLoaded", () => {
                    updateProgress();
                });
            </script>

        </body>

        </html>