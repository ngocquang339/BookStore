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
                            <label class="form-label">Họ tên người nhận</label>
                            <input type="text" name="fullname" id="fullname" class="form-control" 
                                   placeholder="Nhập đầy đủ họ và tên" 
                                   value="${sessionScope.user.fullname}" required>
                        </div>
                        <small id="fullname-error" class="error-hint ms-5 ps-5">* Họ tên không bao gồm chữ số</small>
                    </div>

                    <div class="mb-4">
                        <div class="d-flex align-items-center">
                            <label class="form-label">Số điện thoại</label>
                            <%-- Sửa phone_number để khớp User.java --%>
                            <input type="text" name="phone" id="phone" class="form-control" 
                                   placeholder="Nhập 10 chữ số" maxlength="10"
                                   value="${sessionScope.user.phone_number}" required>
                        </div>
                        <small id="phone-error" class="error-hint ms-5 ps-5">* Số điện thoại gồm 10 chữ số, bắt đầu bằng số 0</small>
                    </div>

                    <div class="mb-3 d-flex align-items-center">
                        <label class="form-label">Địa chỉ nhận hàng</label>
                        <textarea name="address" class="form-control" rows="2" required>${sessionScope.user.address}</textarea>
                    </div>
                </div>

                <div class="checkout-section">
                    <div class="section-title">PHƯƠNG THỨC THANH TOÁN</div>
                    <div class="payment-option">
                        <input type="radio" name="paymentMethod" value="COD" id="cod" class="form-check-input me-3" checked>
                        <img src="https://cdn0.fahasa.com/skin/frontend/ma_mobile/default/images/payment_icon/cashondelivery.png" alt="COD">
                        <label for="cod">Thanh toán bằng tiền mặt khi nhận hàng</label>
                    </div>
                    <div class="payment-option">
                        <input type="radio" name="paymentMethod" value="Momo" id="momo" class="form-check-input me-3">
                        <img src="https://cdn0.fahasa.com/skin/frontend/ma_mobile/default/images/payment_icon/momopay.png" alt="Momo">
                        <label for="momo">Ví Momo</label>
                    </div>
                </div>

                <div class="checkout-section">
                    <div class="section-title">KIỂM TRA LẠI ĐƠN HÀNG</div>
                    <c:forEach items="${sessionScope.cart}" var="item">
                        <div class="book-item">
                            <img src="${pageContext.request.contextPath}/assets/image/books/${item.book.imageUrl}" 
                                 class="book-img" alt="${item.book.title}"
                                 onerror="this.src='https://placehold.co/80x80?text=Book'">
                            <div class="flex-grow-1">
                                <div class="fw-bold">${item.book.title}</div>
                                <div class="book-price mt-1">
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
                        <span class="text-success">Miễn phí</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between mb-4">
                        <span class="fw-bold fs-5">Tổng số tiền</span>
                        <span class="fw-bold fs-4 text-danger">
                            <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₫"/>
                        </span>
                    </div>
                    
                    <button type="submit" class="btn btn-confirm" id="btnConfirm">XÁC NHẬN THANH TOÁN</button>
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

<script>
    // Logic kiểm tra Họ tên: hiện lỗi khi có số
    document.getElementById('fullname').addEventListener('input', function() {
        const errorHint = document.getElementById('fullname-error');
        const hasNumber = /\d/.test(this.value); 
        if (hasNumber) {
            this.classList.add('input-error');
            errorHint.classList.add('show-error');
        } else {
            this.classList.remove('input-error');
            errorHint.classList.remove('show-error');
        }
    });

    // Logic kiểm tra Số điện thoại: hiện lỗi khi không đúng định dạng
    document.getElementById('phone').addEventListener('input', function() {
        const errorHint = document.getElementById('phone-error');
        const isValidPhone = /^0\d{9}$/.test(this.value);
        if (this.value !== "" && !isValidPhone) {
            this.classList.add('input-error');
            errorHint.classList.add('show-error');
        } else {
            this.classList.remove('input-error');
            errorHint.classList.remove('show-error');
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>