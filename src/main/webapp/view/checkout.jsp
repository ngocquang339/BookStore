<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán - BookStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
    <style>
        /* Đảm bảo các class CSS hiển thị lỗi hoạt động tốt */
        .error-hint { display: none; color: #dc3545; font-size: 0.875em; font-weight: bold; margin-top: 5px; }
        .show-error { display: block !important; }
        .input-error { border-color: #dc3545 !important; box-shadow: 0 0 0 0.25rem rgba(220,53,69,.25) !important; }
    </style>
</head>
<body>

<div class="container py-5">
    <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
        <div class="row">
            <div class="col-lg-8">
                <div class="checkout-section">
                    <div class="section-title">ĐỊA CHỈ GIAO HÀNG</div>
                    
                    <div class="mb-4">
                        <div class="d-flex align-items-center">
                            <label class="form-label" style="min-width: 150px;">Họ tên người nhận</label>
                            <input type="text" name="fullname" id="fullname" class="form-control" 
                                   placeholder="Nhập đầy đủ họ và tên" 
                                   value="${sessionScope.user.fullname}" required>
                        </div>
                        <small id="fullname-error" class="error-hint ms-5 ps-5">* Họ tên không được bao gồm chữ số</small>
                        <small id="fullname-length-error" class="error-hint ms-5 ps-5">* Họ và tên không hợp lệ (vượt quá 50 ký tự)</small>
                    </div>

                    <div class="mb-4">
                        <div class="d-flex align-items-center">
                            <label class="form-label" style="min-width: 150px;">Số điện thoại</label>
                            <input type="text" name="phone" id="phone" class="form-control" 
                                   placeholder="Nhập 10 chữ số"
                                   value="${sessionScope.user.phone_number}" required maxlength="10">
                        </div>
                        <small id="phone-type-error" class="error-hint ms-5 ps-5">* Số điện thoại chỉ được nhập chữ số</small>
                        <small id="phone-error" class="error-hint ms-5 ps-5">* Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0</small>
                    </div>

                    <div class="mb-3">
                        <div class="d-flex align-items-center">
                            <label class="form-label" style="min-width: 150px;">Địa chỉ nhận hàng</label>
                            <textarea name="address" id="address" class="form-control" rows="2" required>${sessionScope.user.address}</textarea>
                        </div>
                        <small id="address-length-error" class="error-hint ms-5 ps-5">* Địa chỉ không hợp lệ (vượt quá 100 ký tự)</small>
                    </div>
                </div>

                <div class="checkout-section">
                    <div class="section-title">PHƯƠNG THỨC THANH TOÁN</div>
                    <div class="payment-option">
                        <input type="radio" name="paymentMethod" value="COD" id="cod" class="form-check-input me-3" checked>
                        <img src="https://cdn0.fahasa.com/skin/frontend/ma_mobile/default/images/payment_icon/cashondelivery.png" alt="COD" width="30">
                        <label for="cod">Thanh toán bằng tiền mặt khi nhận hàng</label>
                    </div>
                    <div class="payment-option mt-2">
                        <input type="radio" name="paymentMethod" value="Momo" id="momo" class="form-check-input me-3">
                        <img src="https://cdn0.fahasa.com/skin/frontend/ma_mobile/default/images/payment_icon/momopay.png" alt="Momo" width="30">
                        <label for="momo">Ví Momo</label>
                    </div>
                </div>

                <div class="checkout-section">
                    <div class="section-title">KIỂM TRA LẠI ĐƠN HÀNG</div>
                    <c:forEach items="${sessionScope.cart}" var="item">
                        <div class="book-item d-flex mb-3 border-bottom pb-3">
                            <img src="${pageContext.request.contextPath}/${item.book.imageUrl}" 
                                 class="book-img border rounded me-3" alt="${item.book.title}"
                                 style="width: 80px; height: 100px; object-fit: cover;"
                                 onerror="this.src='https://placehold.co/80x100?text=No+Image'">
                            <div class="flex-grow-1">
                                <div class="fw-bold text-dark">${item.book.title}</div>
                                <div class="book-price mt-1 text-danger fw-bold">
                                    <fmt:formatNumber value="${item.book.price}" type="currency" currencySymbol="₫"/>
                                </div>
                                <div class="small text-muted mt-1">Số lượng: ${item.quantity}</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="checkout-section sticky-top" style="top: 20px;">
                    <div class="section-title">TỔNG CỘNG ĐƠN HÀNG</div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Thành tiền</span>
                        <span><fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₫"/></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Phí vận chuyển</span>
                        <span class="text-success fw-bold">Miễn phí</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between mb-4">
                        <span class="fw-bold fs-5">Tổng số tiền</span>
                        <span class="fw-bold fs-4 text-danger">
                            <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₫"/>
                        </span>
                    </div>
                    
                    <button type="submit" class="btn btn-danger w-100 py-2 fw-bold fs-5 shadow-sm" id="btnConfirm">XÁC NHẬN THANH TOÁN</button>
                    
                    <div class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}/cart" class="text-decoration-none text-muted small">
                            <i class="fa-solid fa-chevron-left"></i> Quay lại giỏ hàng
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const fullname = document.getElementById('fullname');
    const phone = document.getElementById('phone');
    const address = document.getElementById('address');

    const nameNumErr = document.getElementById('fullname-error');
    const nameLenErr = document.getElementById('fullname-length-error');
    const phoneTypeErr = document.getElementById('phone-type-error');
    const phoneErr = document.getElementById('phone-error');
    const addressLenErr = document.getElementById('address-length-error');

    // ========================================================
    // 1. KIỂM TRA NGAY LẬP TỨC KHI ĐANG GÕ PHÍM (REAL-TIME)
    // ========================================================
    
    // Khi gõ Họ tên: Báo lỗi ngay nếu có số
    fullname.addEventListener('input', function() {
        if (/\d/.test(this.value)) {
            this.classList.add('input-error');
            nameNumErr.classList.add('show-error');
        } else {
            // Chỉ gỡ viền đỏ nếu độ dài <= 50 (để không gỡ nhầm lỗi khi bấm nút)
            if (this.value.trim().length <= 50) {
                this.classList.remove('input-error');
            }
            nameNumErr.classList.remove('show-error');
        }
    });

    // Khi gõ SĐT: Báo lỗi ngay nếu gõ chữ cái
    phone.addEventListener('input', function() {
        if (/\D/.test(this.value)) { 
            this.classList.add('input-error');
            phoneTypeErr.classList.add('show-error');
        } else {
            this.classList.remove('input-error');
            phoneTypeErr.classList.remove('show-error');
        }
    });

    // ========================================================
    // 2. KIỂM TRA ĐỘ DÀI & ĐỊNH DẠNG KHI BẤM NÚT XÁC NHẬN
    // ========================================================
    document.getElementById('checkoutForm').addEventListener('submit', function(event) {
        let isValid = true;

        // Reset các lỗi độ dài trước khi kiểm tra lại
        nameLenErr.classList.remove('show-error');
        phoneErr.classList.remove('show-error');
        addressLenErr.classList.remove('show-error');

        // A. Kiểm tra Họ tên
        if (/\d/.test(fullname.value)) {
            isValid = false; // Bị lỗi có số
        }
        if (fullname.value.trim().length > 50) {
            isValid = false;
            fullname.classList.add('input-error');
            nameLenErr.classList.add('show-error'); // Hiện lỗi quá 50 ký tự
        }

        // B. Kiểm tra Số điện thoại
        if (/\D/.test(phone.value)) {
            isValid = false; // Bị lỗi có chữ
        } else if (!/^0\d{9}$/.test(phone.value)) {
            isValid = false;
            phone.classList.add('input-error');
            phoneErr.classList.add('show-error'); // Hiện lỗi ko đủ 10 số
        }

        // C. Kiểm tra Địa chỉ
        if (address.value.trim().length > 100) {
            isValid = false;
            address.classList.add('input-error');
            addressLenErr.classList.add('show-error'); // Hiện lỗi quá 100 ký tự
        }

        // NẾU CÓ BẤT KỲ LỖI NÀO -> CHẶN KHÔNG CHO GỬI FORM LÊN SERVER
        if (!isValid) {
            event.preventDefault(); 
        }
    });
</script>

</body>
</html>