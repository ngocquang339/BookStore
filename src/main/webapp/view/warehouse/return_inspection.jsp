<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Kiểm Tra Nhập Kho Hàng Trả</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body { background-color: #fffaf0; }
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
        .row-inspected { background-color: #fff4e5 !important; }
        .progress { height: 20px; }
        .disabled-btn {
            opacity: 0.6;
            pointer-events: none;
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
                    <small>
                        Đơn #${orderId} - ${orderInfo.customerName}
                    </small>
                </div>
                <span class="badge bg-info text-dark align-self-center">
                    Đang kiểm hàng
                </span>
            </div>

            <form action="${pageContext.request.contextPath}/warehouse/return-process" method="POST" onsubmit="return validateReturnForm()">
                <input type="hidden" name="orderId" value="${orderId}">

                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th class="text-center" style="width: 60px;">Check</th>
                            <th>Tên sách</th>
                            <th class="text-center">SL</th>
                            <th>Lý do của khách</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach items="${items}" var="item">
                            <tr class="align-middle">
                                <td class="text-center">
                                    <input type="checkbox" class="form-check-input inspect-checkbox checkbox-lg" onchange="handleRow(this)">
                                </td>
                                <td class="fw-bold">${item.bookTitle}</td>
                                <td class="text-center">
                                    <span class="badge bg-danger fs-6">${item.quantity}</span>
                                </td>
                                <td class="text-muted fst-italic">
                                    ${item.customerReason}
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1">
                        <small>Tiến độ</small>
                        <small id="progressPercent">0%</small>
                    </div>

                    <div class="progress">
                        <div id="progressBar" class="progress-bar bg-warning" style="width: 0%"></div>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-4">
                    
                    <button id="submitBtn" type="submit" name="qcAction" value="PASS" class="btn btn-success px-4 fw-bold disabled-btn">
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

        function checkAll(state) {
            document.querySelectorAll('.inspect-checkbox').forEach(cb => {
                cb.checked = state;
                handleRow(cb);
            });
        }

        function updateProgress() {
            const total = document.querySelectorAll('.inspect-checkbox').length;
            const checked = document.querySelectorAll('.inspect-checkbox:checked').length;
            const percent = total === 0 ? 0 : Math.round((checked / total) * 100);

            document.getElementById('progressBar').style.width = percent + "%";
            document.getElementById('progressPercent').innerText = percent + "%";

            const btn = document.getElementById('submitBtn');
            if (checked === total && total > 0) {
                btn.classList.remove('disabled-btn');
            } else {
                btn.classList.add('disabled-btn');
            }
        }

        function validateReturnForm() {
            const total = document.querySelectorAll('.inspect-checkbox').length;
            const checked = document.querySelectorAll('.inspect-checkbox:checked').length;
            if (checked !== total) return false;
            return confirm("Xác nhận đã kiểm tra đủ số lượng hàng hoàn trả?");
        }
    </script>

</body>
</html>