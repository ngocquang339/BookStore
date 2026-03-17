<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Create Purchase Order</title>

            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

            <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
            <link
                href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css"
                rel="stylesheet" />

            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

            <style>
                body {
                    background-color: #f8f9fa;
                    font-family: Arial, sans-serif;
                }

                .card {
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    border: none;
                }

                .select2-container .select2-selection--single {
                    height: 38px;
                    line-height: 38px;
                }

                .select2-container--bootstrap-5 .select2-selection {
                    border-radius: 0.375rem;
                }

                .select2-container--bootstrap-5 .select2-results__option[aria-disabled="true"] {
                    display: none !important;
                }

                /* Title gradient */
                .text-gradient {
                    background: linear-gradient(45deg, #0d6efd, #20c997, #6610f2);
                    -webkit-background-clip: text;
                    -webkit-text-fill-color: transparent;
                    font-size: 28px;
                    letter-spacing: 1px;
                }
            </style>
        </head>

        <body>

            <div class="container mt-4 mb-5">

                <!-- HEADER -->
                <div class="d-flex justify-content-between align-items-center mb-4">

                    <!-- Back -->
                    <a href="${pageContext.request.contextPath}/warehouse/dashboard"
                        class="btn btn-outline-dark shadow-sm">
                        <i class="fas fa-arrow-left"></i> Dashboard
                    </a>

                    <!-- Title -->
                    <h2 class="text-center flex-grow-1 m-0 fw-bold text-gradient">
                        ✨ Tạo Đơn Nhập Hàng ✨
                    </h2>

                    <!-- Spacer -->
                    <div style="width:120px;"></div>
                </div>

                <!-- ERROR -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <strong>Lỗi!</strong> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="create-po" method="post" id="poForm">

                    <!-- INFO -->
                    <div class="card mb-4">
                        <div class="card-header bg-white fw-bold">
                            1. Thông tin chung
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <label class="form-label">
                                        <b>Nhà cung cấp:</b> <span class="text-danger">*</span>
                                    </label>
                                    <select name="supplierId" class="form-select select2-supplier" required>
                                        <option value="">-- Gõ để tìm kiếm Nhà cung cấp --</option>
                                        <c:forEach items="${suppliers}" var="s">
                                            <option value="${s.id}">${s.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-12 mt-3">
                                    <label class="form-label">
                                        <b>Ghi chú đơn hàng:</b>
                                    </label>
                                    <textarea name="statusNote" class="form-control" rows="2"
                                        placeholder="VD: Nhập sách chuẩn bị cho đợt Sale cuối năm..."></textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- TABLE -->
                    <div class="card">
                        <div class="card-header bg-white fw-bold d-flex justify-content-between align-items-center">
                            <span>2. Chi tiết Sách nhập</span>
                            <button type="button" class="btn btn-success btn-sm" onclick="addNewRow()">
                                + Thêm dòng sách
                            </button>
                        </div>

                        <div class="card-body p-0">
                            <table class="table table-hover table-bordered mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th width="45%">Tên Sách</th>
                                        <th width="20%">Số lượng</th>
                                        <th width="25%">Giá nhập</th>
                                        <th width="10%" class="text-center">Xóa</th>
                                    </tr>
                                </thead>

                                <tbody id="bookTableBody">
                                    <tr>
                                        <td>
                                            <select name="bookId[]" class="form-select select2-book" required>
                                                <option value="">-- Gõ để tìm kiếm Sách --</option>
                                                <c:forEach items="${books}" var="b">
                                                    <option value="${b.id}">
                                                        ${b.title} (Tồn: ${b.stockQuantity})
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </td>

                                        <td>
                                            <input type="number" name="expectedQuantity[]" class="form-control" min="1"
                                                max="1000" required>
                                        </td>
                                        <td>
                                            <input type="number" name="importPrice[]" class="form-control" min="1"
                                                max="100000000" step="0.01" required>
                                        </td>
                                        <td class="text-center">
                                            <button type="button" class="btn btn-danger btn-sm"
                                                onclick="removeRow(this)">Xóa</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- ACTION -->
                    <div class="text-end mt-4">
                        <div class="text-end mt-3">
                            <h5>
                                Tổng tiền:
                                <span id="totalAmount" class="text-success fw-bold">0</span> VND
                            </h5>
                        </div>
                        <a href="${pageContext.request.contextPath}/warehouse/dashboard"
                            class="btn btn-outline-dark shadow-sm">Hủy</a>
                        <button type="submit" class="btn btn-primary fw-bold px-4">
                            Lưu Đơn
                        </button>
                    </div>

                </form>
            </div>

            <!-- TEMPLATE -->
            <template id="book-options-template">
                <option value="">-- Gõ để tìm kiếm Sách --</option>
                <c:forEach items="${books}" var="b">
                    <option value="${b.id}">
                        ${b.title} (Tồn: ${b.stockQuantity})
                    </option>
                </c:forEach>
            </template>

            <!-- JS -->
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

            <script>
                $(document).ready(function () {
                    initSelect2();
                    updateAvailableBooks();
                });

                function initSelect2() {
                    $('.select2-supplier').select2({
                        theme: 'bootstrap-5',
                        width: '100%'
                    });

                    $('.select2-book').select2({
                        theme: 'bootstrap-5',
                        width: '100%'
                    });
                }

                function addNewRow() {
                    const tbody = document.getElementById('bookTableBody');
                    const tr = document.createElement('tr');

                    const optionsHtml = document.getElementById('book-options-template').innerHTML;

                    tr.innerHTML = `
            <td>
                <select name="bookId[]" class="form-select select2-new" required>
                    ` + optionsHtml + `
                </select>
            </td>
            <td>
                <input type="number" name="expectedQuantity[]" class="form-control" min="1" max="1000" required>
            </td>
            <td>
                <input type="number" name="importPrice[]" class="form-control" min="1" max="100000000" step="0.01" required>
            </td>
            <td class="text-center">
                <button type="button" class="btn btn-danger btn-sm"
                        onclick="removeRow(this)">Xóa</button>
            </td>
        `;

                    tbody.appendChild(tr);

                    // Khởi tạo Select2 cho dòng mới
                    $(tr).find('.select2-new').select2({
                        theme: 'bootstrap-5',
                        width: '100%'
                    }).removeClass('select2-new').addClass('select2-book');
                    updateAvailableBooks();
                    calculateTotalAmount();
                }

                // ==========================================
                // 1. XỬ LÝ POPUP KHI LƯU THÀNH CÔNG
                // ==========================================
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('status') === 'success') {
                    // Hiển thị hộp thoại xác nhận (Confirm)
                    if (confirm("✅ Tạo đơn nhập hàng thành công!\n\nBạn có muốn tạo thêm một đơn hàng mới không?")) {
                        // NẾU CHỌN OK: Xóa chữ ?status=success trên URL để form trở về trạng thái bình thường (trống)
                        window.history.replaceState(null, null, window.location.pathname);
                    } else {
                        // NẾU CHỌN CANCEL: Chuyển hướng về trang Dashboard
                        window.location.href = "${pageContext.request.contextPath}/warehouse/dashboard";
                    }
                }
                // ==========================================
                // CẬP NHẬT DROPDOWN: ẨN SÁCH ĐÃ CHỌN Ở DÒNG KHÁC
                // ==========================================
                // Bắt sự kiện mỗi khi có bất kỳ dropdown sách nào thay đổi
                $(document).on('change', '.select2-book', function () {
                    updateAvailableBooks();
                });

                // Hàm xử lý logic ẩn/hiện sách
                function updateAvailableBooks() {
                    // 1. Lấy danh sách ID của tất cả các sách ĐANG ĐƯỢC CHỌN
                    let selectedIds = [];
                    $('.select2-book').each(function () {
                        let val = $(this).val();
                        if (val) {
                            selectedIds.push(val);
                        }
                    });

                    // 2. Quét qua từng dropdown để cập nhật trạng thái thẻ <option>
                    $('.select2-book').each(function () {
                        let currentSelect = $(this);
                        let currentValue = currentSelect.val();

                        currentSelect.find('option').each(function () {
                            let optionValue = $(this).val();
                            if (!optionValue) return; // Bỏ qua dòng chữ "-- Gõ để tìm kiếm..."

                            // Nếu sách này nằm trong danh sách ĐÃ ĐƯỢC CHỌN ở trên 
                            // VÀ nó KHÔNG PHẢI là cuốn sách mà dropdown hiện tại đang giữ
                            if (selectedIds.includes(optionValue) && optionValue !== currentValue) {
                                $(this).prop('disabled', true);  // Khóa nó lại (CSS sẽ tự động ẩn đi)
                            } else {
                                $(this).prop('disabled', false); // Mở khóa (hiển thị lại bình thường)
                            }
                        });

                    });
                }

                // ==========================================
                // HÀM XÓA DÒNG (Cần cập nhật thêm lệnh gọi updateAvailableBooks)
                // ==========================================
                function removeRow(button) {
                    const row = button.closest('tr');
                    const tbody = document.getElementById('bookTableBody');

                    if (tbody.rows.length > 1) {
                        // Xóa Select2 để giải phóng bộ nhớ
                        $(row).find('.select2-book').select2('destroy');
                        row.remove();

                        // QUAN TRỌNG: Gọi lại hàm này để "nhả" cuốn sách vừa xóa ra cho các dropdown khác chọn lại
                        updateAvailableBooks();
                    } else {
                        alert("Đơn hàng phải có ít nhất 1 quyển sách!");
                    }
                    calculateTotalAmount();
                }
                function calculateTotalAmount() {
                    let total = 0;

                    document.querySelectorAll('#bookTableBody tr').forEach(row => {
                        let qtyInput = row.querySelector('input[name="expectedQuantity[]"]');
                        let priceInput = row.querySelector('input[name="importPrice[]"]');

                        let qty = parseFloat(qtyInput?.value) || 0;
                        let price = parseFloat(priceInput?.value) || 0;

                        total += qty * price;
                    });

                    document.getElementById('totalAmount').innerText =
                        total.toLocaleString('vi-VN');
                }

                $(document).on('input', 'input[name="expectedQuantity[]"], input[name="importPrice[]"]', function () {
                    calculateTotalAmount();
                });

            </script>

        </body>

        </html>