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
        body {
            background-color: #fffaf0; /* Tông màu nhẹ khác biệt với đơn bán */
        }

        .card-custom {
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: none;
            background-color: #fff;
        }

        .checkbox-lg {
            width: 24px;
            height: 24px;
            cursor: pointer;
        }

        .row-inspected {
            background-color: #fff4e5 !important; /* Màu cam nhạt khi đã check */
            transition: background-color 0.3s;
        }

        .table th {
            background-color: #f8f9fa;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }
    </style>
</head>

<body>

    <div class="container mt-5 mb-5">
        <div class="mb-4">
            <a href="returns" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách đơn trả
            </a>
        </div>

        <div class="card card-custom p-4">
            <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
                <div>
                    <h2 class="text-warning mb-1">
                        <i class="fas fa-box-open me-2"></i>Kiểm Hàng Hoàn Trả
                    </h2>
                    <p class="text-muted mb-0">Đơn hàng: <strong>#${orderId}</strong> | Khách hàng: <strong>${orderInfo.fullname}</strong></p>
                </div>
                <div class="text-end">
                    <span class="badge bg-info text-dark p-2">Trạng thái: Đang kiểm hàng</span>
                </div>
            </div>

            <form action="return-process" method="POST" onsubmit="return validateReturnForm()">
                <input type="hidden" name="orderId" value="${orderId}">

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th style="width: 10%">Hình ảnh</th>
                                <th style="width: 50%">Tên sách</th>
                                <th style="width: 20%" class="text-center">Số lượng trả về</th>
                                <th style="width: 20%" class="text-center">Xác nhận nhận đủ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${items}" var="item">
                                <tr>
                                    <td>
                                        <img src="${item.image_url}" alt="${item.title}" style="width: 50px; height: 70px; object-fit: cover; border-radius: 4px;">
                                    </td>
                                    <td>
                                        <div class="fw-bold">${item.title}</div>
                                        <small class="text-muted">ID: ${item.book_id}</small>
                                    </td>
                                    <td class="text-center">
                                        <span class="fs-5 fw-bold text-primary">${item.quantity}</span>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check d-flex justify-content-center">
                                            <input type="checkbox" class="inspect-checkbox form-check-input checkbox-lg" 
                                                   onchange="handleRowHighlight(this)">
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex justify-content-between align-items-center mt-4 p-3 bg-light rounded">
                    <div>
                        <span class="me-2">Tiến độ kiểm hàng:</span>
                        <span id="progressText" class="badge bg-secondary fs-6">0 / ${items.size()}</span>
                    </div>
                    <div>
                        <button type="submit" class="btn btn-warning btn-lg px-5 fw-bold">
                            <i class="fas fa-file-import me-2"></i>XÁC NHẬN NHẬP KHO & HOÀN TẤT
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Highlight dòng khi được tích chọn
        function handleRowHighlight(checkbox) {
            var row = checkbox.closest('tr');
            if (checkbox.checked) {
                row.classList.add('row-inspected');
            } else {
                row.classList.remove('row-inspected');
            }
            updateProgress();
        }

        // Cập nhật số lượng đã kiểm
        function updateProgress() {
            var total = document.querySelectorAll('.inspect-checkbox').length;
            var checked = document.querySelectorAll('.inspect-checkbox:checked').length;
            var progressText = document.getElementById('progressText');
            
            progressText.innerText = checked + " / " + total;

            if (checked === total) {
                progressText.className = "badge bg-success fs-6";
            } else {
                progressText.className = "badge bg-secondary fs-6";
            }
        }

        // Kiểm tra bắt buộc phải check hết mới cho submit
        function validateReturnForm() {
            var total = document.querySelectorAll('.inspect-checkbox').length;
            var checked = document.querySelectorAll('.inspect-checkbox:checked').length;

            if (total !== checked) {
                alert("⚠️ Bạn chưa xác nhận kiểm đủ tất cả các mặt hàng! Vui lòng tích chọn đầy đủ trước khi nhập kho.");
                return false;
            }
            
            return confirm("Xác nhận: Hàng hóa đã được kiểm tra đầy đủ và đúng số lượng. Hệ thống sẽ tự động CỘNG tồn kho cho các đầu sách này và hoàn tất quy trình trả hàng?");
        }
    </script>
</body>
</html>