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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <style>
        /* Đảm bảo các class CSS hiển thị lỗi hoạt động tốt */
        .error-hint { display: none; color: #dc3545; font-size: 0.875em; font-weight: bold; margin-top: 5px; }
        .show-error { display: block !important; }
        .input-error { border-color: #dc3545 !important; box-shadow: 0 0 0 0.25rem rgba(220,53,69,.25) !important; }
        /* CSS Cho List Địa chỉ ở trang Checkout */
        .address-checkout-item {
            padding: 15px 0;
            border-bottom: 1px dashed #ccc; /* Đường kẻ đứt */
        }
        .address-checkout-item:last-child {
            border-bottom: none;
        }
        .address-info-text {
            font-size: 15px;
            color: #555;
            line-height: 1.6;
        }
        .address-info-text .name {
            font-weight: 600;
            color: #333;
        }
        .address-action-links a {
            color: #2f80ed;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            margin-left: 15px;
        }
        .address-action-links a:hover {
            text-decoration: underline;
        }
        /* Đổi màu nút Radio thành Đỏ khi được chọn */
        .form-check-input:checked {
            background-color: #C92127;
            border-color: #C92127;
        }
        .form-check-input {
            cursor: pointer;
            width: 1.2em;
            height: 1.2em;
        }
        .btn-add-new-address {
            color: #C92127;
            font-weight: 600;
            text-decoration: none;
            font-size: 15px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-add-new-address:hover {
            color: #a81b20;
        }

        /* --- CSS CHO KHỐI THANH TOÁN CỐ ĐỊNH --- */
        body {
            /* Tạo khoảng trống dưới cùng để nội dung không bị che khuất bởi thanh sticky */
            padding-bottom: 220px !important; 
        }
        
        /* --- CSS CHO KHỐI THANH TOÁN CỐ ĐỊNH (TỐI ƯU CHIỀU CAO) --- */
        body {
            /* Giảm khoảng trống dưới cùng vì khối sticky giờ đã mỏng hơn */
            padding-bottom: 150px !important; 
        }
        
        .checkout-footer-sticky {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            background-color: #ffffff;
            box-shadow: 0 -2px 10px rgba(0,0,0,0.06); /* Đổ bóng nhẹ nhàng hơn */
            padding: 12px 0; /* Ép mỏng padding trên dưới */
            z-index: 1000;
            border-top: 1px solid #eaeaea;
        }

        /* Bảng giá tiền thu gọn */
        .price-table {
            width: 100%;
            max-width: 400px; /* Chiều rộng ôm sát góc phải */
            margin-left: auto;
            margin-bottom: 8px; /* Khoảng cách siêu nhỏ tới nút bấm */
        }
        
        .price-table td {
            padding: 2px 0; /* Ép các dòng chữ sát lại nhau */
            font-size: 14px;
        }

        .price-table .total-row td {
            padding-top: 6px; /* Cách dòng tổng tiền ra một chút */
        }

        .text-orange-total {
            color: #F5A623; /* Cam Fahasa */
            font-size: 20px !important; /* Chữ nhỏ lại một chút cho tinh tế */
            font-weight: 700;
        }

        /* Nút Xác nhận thanh toán gọn gàng */
        .btn-confirm-checkout {
            background-color: #C92127;
            border-color: #C92127;
            border-radius: 6px;
            font-size: 15px;
            padding: 9px 35px; /* Ép mỏng chiều cao, kéo dài chiều ngang */
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .btn-confirm-checkout:hover {
            background-color: #a81c21;
        }

        /* Chữ điều khoản nhỏ gọn */
        .terms-text {
            font-size: 12.5px;
            line-height: 1.3;
            color: #777;
        }
    </style>
</head>
<body>
<jsp:include page="component/header.jsp" />
<div class="container py-5">
    <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
        
        <div class="checkout-wrapper" style="max-width: 900px; margin: 0 auto;">
            
            <div class="checkout-section shadow-sm bg-white p-4 mb-4 rounded">
                <div class="section-title mb-3" style="border-bottom: 2px solid #f0f0f0; padding-bottom: 10px; color: #333; font-weight: bold;">
                    ĐỊA CHỈ GIAO HÀNG
                </div>
                
                <div class="address-list-container">
                    <c:forEach var="addr" items="${listAddresses}">
                        <div class="address-checkout-item py-2">
                            <div class="form-check d-flex align-items-start m-0">
                                
                                <input class="form-check-input flex-shrink-0 me-3 mt-1" type="radio" name="selectedAddressId" id="addr_${addr.id}" value="${addr.id}" ${addr.defaultShipping ? 'checked' : ''} required>
                                
                                <label class="form-check-label flex-grow-1 d-flex justify-content-between align-items-start" for="addr_${addr.id}" style="cursor: pointer; width: 100%;">
                                    
                                    <div class="address-info-text pe-3" style="font-size: 14.5px; line-height: 1.6; color: #444;">
                                        <span class="name text-dark fw-bold" style="font-size: 15px;">${addr.fullName}</span> 
                                        <span class="mx-2" style="color: #ccc;">|</span> 
                                        <span>${addr.addressDetail}, ${addr.ward}, ${addr.district}, ${addr.city}</span> 
                                        <span class="mx-2" style="color: #ccc;">|</span> 
                                        <span class="fw-medium">${addr.phone}</span>
                                    </div>
                                    
                                    <div class="address-action-links text-end flex-shrink-0" style="min-width: 90px; margin-top: 2px;">
                                        <a href="javascript:void(0);" 
                                           class="text-primary me-2 btn-edit-address fw-bold"
                                           data-bs-toggle="modal" 
                                           data-bs-target="#editAddressModal"
                                           data-id="${addr.id}"
                                           data-fullname="${addr.fullName}"
                                           data-phone="${addr.phone}"
                                           data-city="${addr.city}"
                                           data-district="${addr.district}"
                                           data-ward="${addr.ward}"
                                           data-detail="${addr.addressDetail}">
                                           Sửa
                                        </a>
                                        <a href="${pageContext.request.contextPath}/address?action=delete&id=${addr.id}&source=checkout" class="text-primary fw-bold" onclick="return confirm('Bạn có chắc chắn muốn xóa địa chỉ này?');">Xóa</a>
                                    </div>
                                </label>
                            </div>
                        </div>
                        <hr style="border-top: 1px dashed #e0e0e0; margin: 8px 0;">
                    </c:forEach>

                    <div class="address-checkout-item mt-3 pt-2" style="border-bottom: none;">
                        <a href="javascript:void(0);" 
                        class="btn-add-new-address text-danger text-decoration-none fw-bold btn-open-add-modal" 
                        data-bs-toggle="modal" 
                        data-bs-target="#editAddressModal"
                        style="font-size: 14.5px;">
                            <i class="fa-solid fa-circle-plus me-1"></i> Giao hàng đến địa chỉ khác
                        </a>
                    </div>
                </div>
            </div>
            <div class="checkout-section shadow-sm bg-white p-4 mb-4 rounded">
                <div class="section-title mb-3" style="border-bottom: 2px solid #f0f0f0; padding-bottom: 10px; color: #333; font-weight: bold;">
                    PHƯƠNG THỨC THANH TOÁN
                </div>
                <div class="payment-option d-flex align-items-center mb-3">
                    <input type="radio" name="paymentMethod" value="COD" id="cod" class="form-check-input me-3" checked>
                    <img src="https://cdn0.fahasa.com/skin/frontend/ma_mobile/default/images/payment_icon/cashondelivery.png" alt="COD" width="40" class="me-2 border rounded p-1">
                    <label for="cod" style="cursor: pointer;">Thanh toán bằng tiền mặt khi nhận hàng</label>
                </div>
                <div class="payment-option d-flex align-items-center mt-2">
                    <input type="radio" name="paymentMethod" value="VNPAY" id="vnpay" class="form-check-input me-3">
                    <img src="https://vnpay.vn/s1/statics.vnpay.vn/2023/9/06ncktiwd6dc1694418189687.png" alt="VNPAY" width="40" class="me-2 border rounded p-1" style="object-fit: contain;">
                    <label for="vnpay" style="cursor: pointer;">Thanh toán qua VNPAY</label>
                </div>
            </div>

            <div class="checkout-section shadow-sm bg-white p-4 mb-4 rounded">
                <div class="section-title mb-3" style="border-bottom: 2px solid #f0f0f0; padding-bottom: 10px; color: #333; font-weight: bold;">
                    KIỂM TRA LẠI ĐƠN HÀNG
                </div>
                <c:forEach items="${sessionScope.checkoutCart}" var="item">
                    <div class="book-item d-flex mb-3 border-bottom pb-3">
                        <img src="${pageContext.request.contextPath}/${item.book.imageUrl}" 
                             class="book-img border rounded me-3" alt="${item.book.title}"
                             style="width: 80px; height: 100px; object-fit: cover;"
                             onerror="this.src='https://placehold.co/80x100?text=No+Image'">
                        <div class="flex-grow-1">
                            <div class="fw-bold text-dark fs-6">${item.book.title}</div>
                            <div class="book-price mt-1 text-danger fw-bold">
                                <fmt:formatNumber value="${item.book.price}" type="currency" currencySymbol="₫"/>
                            </div>
                            <div class="small text-muted mt-1">Số lượng: ${item.quantity}</div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="checkout-section shadow-sm bg-white p-4 mb-4 rounded">
                <div class="section-title mb-3" style="border-bottom: 2px solid #f0f0f0; padding-bottom: 10px; color: #333; font-weight: bold;">
                    MÃ KHUYẾN MÃI / GIFT CARD
                </div>
                
                <div class="d-flex align-items-start mt-3 flex-wrap">
                    <div class="me-4 mt-2" style="min-width: 200px; color: #555; font-size: 15px;">
                        Mã khuyến mãi / Gift Card
                    </div>
                    <div class="flex-grow-1">
                        <div class="d-flex align-items-center flex-wrap gap-3">
                            <div class="input-group" style="max-width: 400px; border-radius: 8px; border: 1px solid #7cb3f5; padding: 3px;">
                                <input type="text" id="voucherCodeInput" class="form-control border-0 shadow-none" placeholder="Nhập mã khuyến mãi / Gift Card" style="font-size: 14px;">
                                <button type="button" class="btn text-white px-4 fw-bold" id="btnApplyVoucher" style="background-color: #2f80ed; border-radius: 6px;">Áp dụng</button>
                            </div>
                            
                            <a href="javascript:void(0)" class="text-decoration-none fw-medium" id="btnChooseVoucher" style="color: #2f80ed; font-size: 14.5px;" data-bs-toggle="modal" data-bs-target="#voucherModal">
                                Chọn mã khuyến mãi
                            </a>
                        </div>
                        
                        <div class="mt-2 text-muted" style="font-size: 13px;">
                            Hướng dẫn sử dụng Gift Card <i class="fa-regular fa-circle-question ms-1"></i>
                        </div>

                        <div id="voucherMessage" class="mt-2" style="font-size: 13px; display: none;"></div>
                    </div>
                </div>

                <input type="hidden" name="appliedVoucherId" id="appliedVoucherId" value="">
            </div>
            
        </div> 
        <div class="checkout-footer-sticky">
            <div class="container" style="max-width: 900px; margin: 0 auto;">
                
                <table class="price-table">
                    <tr>
                        <td class="text-muted text-start">Thành tiền</td>
                        <td class="text-end fw-bold"><fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₫"/></td>
                    </tr>
                    <tr>
                        <td class="text-muted text-start">Phí vận chuyển (Giao hàng tiêu chuẩn)</td>
                        <td class="text-end text-success fw-bold">Miễn phí</td>
                    </tr>
                    <tr class="total-row">
                        <td class="fw-bold text-start text-dark fs-6">Tổng Số Tiền (gồm VAT)</td>
                        <td class="text-end text-orange-total">
                            <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₫"/>
                        </td>
                    </tr>
                </table>

                <div class="d-flex justify-content-between align-items-center mt-1">
                    
                    <div class="form-check d-flex align-items-center m-0">
                        <input class="form-check-input flex-shrink-0 me-2" type="checkbox" id="agreeTerms" checked style="cursor: pointer; margin-top: 0;">
                        <label class="form-check-label terms-text" for="agreeTerms" style="cursor: pointer;">
                            Bằng việc tiến hành Mua hàng, Bạn đã đồng ý với <br>
                            <a href="#" style="text-decoration: none; color: #2f80ed; font-weight: 500;">Điều khoản & Điều kiện của BookStore</a>
                        </label>
                    </div>
                    
                    <div>
                        <button type="submit" class="btn text-white btn-confirm-checkout shadow-sm" id="btnConfirm">
                            Xác nhận thanh toán
                        </button>
                    </div>
                </div>

            </div>
        </div>
    </form>
</div>

<div class="modal fade" id="editAddressModal" tabindex="-1" aria-labelledby="editAddressModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border-radius: 10px;">
      
      <form action="${pageContext.request.contextPath}/edit-address" method="POST" id="dynamicAddressForm">
        
        <input type="hidden" name="source" value="checkout">
        <input type="hidden" name="addressId" id="modal_addressId">
        <input type="hidden" name="isDefaultShipping" value="on"> <div class="modal-header border-bottom-0 pb-0 mt-3 d-flex justify-content-center position-relative">
          <h5 class="modal-title fw-bold" style="color: #d70018;" id="editAddressModalLabel">THAY ĐỔI ĐỊA CHỈ GIAO HÀNG</h5>
        </div>

        <div class="modal-body px-4 pb-4">
            <div class="mb-3 row align-items-start">
                <label class="col-sm-4 col-form-label text-muted">Họ và tên <span class="text-danger">*</span></label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" name="fullName" id="modal_fullName" required>
                    <div class="error-hint" id="modal-fullname-error">Họ tên không được chứa số.</div>
                    <div class="error-hint" id="modal-fullname-length-error">Độ dài không quá 50 ký tự.</div>
                </div>
            </div>
            
            <div class="mb-3 row align-items-start">
                <label class="col-sm-4 col-form-label text-muted">Số điện thoại <span class="text-danger">*</span></label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" name="phone" id="modal_phone" required>
                    <div class="error-hint" id="modal-phone-type-error">Số điện thoại chỉ được chứa số.</div>
                    <div class="error-hint" id="modal-phone-error">SĐT phải có 10 số và bắt đầu bằng số 0.</div>
                </div>
            </div>

            <div class="mb-3 row align-items-center">
                <label class="col-sm-4 col-form-label text-muted">Tỉnh/Thành Phố</label>
                <div class="col-sm-8">
                    <select class="form-select" id="modal_city" name="city" required>
                        <option value="" selected disabled>Chọn tỉnh/thành phố</option>
                    </select>
                </div>
            </div>

            <div class="mb-3 row align-items-center">
                <label class="col-sm-4 col-form-label text-muted">Quận/Huyện</label>
                <div class="col-sm-8">
                    <select class="form-select" id="modal_district" name="district" required>
                        <option value="" selected disabled>Chọn quận/huyện</option>
                    </select>
                </div>
            </div>

            <div class="mb-3 row align-items-center">
                <label class="col-sm-4 col-form-label text-muted">Phường/Xã</label>
                <div class="col-sm-8">
                    <select class="form-select" id="modal_ward" name="ward" required>
                        <option value="" selected disabled>Chọn phường/xã</option>
                    </select>
                </div>
            </div>

            <div class="mb-3 row align-items-start">
                <label class="col-sm-4 col-form-label text-muted">Địa chỉ nhận hàng</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" name="addressDetail" id="modal_detail" placeholder="Số nhà, ngõ..." required>
                    <div class="error-hint" id="modal-address-length-error">Địa chỉ không được vượt quá 100 ký tự.</div>
                </div>
            </div>
            
            <div class="mt-4">
                <button type="submit" class="btn text-white w-100 mb-2 py-2 fw-bold" id="btn-save-modal" style="background-color: #d70018; border-radius: 5px;">Lưu địa chỉ</button>
                <button type="button" class="btn bg-white w-100 py-2 fw-bold" data-bs-dismiss="modal" style="color: #d70018; border: 1px solid #d70018; border-radius: 5px;">Hủy</button>
            </div>
        </div>
      </form>
    </div>
  </div>
</div>

<div class="modal fade" id="voucherModal" tabindex="-1" aria-labelledby="voucherModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content" style="border-radius: 10px;">
      <div class="modal-header border-bottom-0 pb-0 mt-2 d-flex justify-content-between align-items-center">
        <h5 class="modal-title fw-bold" style="color: #333;" id="voucherModalLabel">Chọn mã khuyến mãi</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <div class="modal-body px-4 pb-4" style="background-color: #f8f9fa;">
        <c:choose>
            <c:when test="${empty wallet}">
                <div class="text-center text-muted py-4">Ví của bạn hiện chưa có mã giảm giá nào.</div>
            </c:when>
            <c:otherwise>
                <c:forEach items="${wallet}" var="uv">
                    <c:set var="isEligible" value="${grandTotal >= uv.voucher.minOrderValue}" />
                    
                    <div class="card mb-3 border-0 shadow-sm ${!isEligible ? 'opacity-50' : ''}" style="border-radius: 8px;">
                        <div class="card-body d-flex align-items-center p-3">
                            <div class="voucher-icon bg-success text-white d-flex justify-content-center align-items-center rounded me-3" style="width: 60px; height: 60px; font-size: 24px;">
                                🎟️
                            </div>
                            <div class="flex-grow-1">
                                <h6 class="mb-1 fw-bold text-success">
                                    <c:choose>
                                        <c:when test="${uv.voucher.discountPercent > 0}">Giảm ${uv.voucher.discountPercent}%</c:when>
                                        <c:otherwise>Giảm <fmt:formatNumber value="${uv.voucher.discountAmount}" type="number" pattern="#,###"/>đ</c:otherwise>
                                    </c:choose>
                                </h6>
                                <div class="text-muted" style="font-size: 12px;">Đơn tối thiểu <fmt:formatNumber value="${uv.voucher.minOrderValue}" type="number" pattern="#,###"/>đ</div>
                                <div class="text-primary mt-1" style="font-size: 11px;">HSD: <fmt:formatDate value="${uv.voucher.endDate}" pattern="dd/MM/yyyy"/></div>
                            </div>
                            <div class="ms-2">
                                <c:choose>
                                    <c:when test="${isEligible}">
                                        <button type="button" class="btn btn-outline-danger btn-sm fw-bold px-3" 
                                                onclick="applyVoucher('${uv.voucher.code}', '${uv.voucher.discountAmount != null ? uv.voucher.discountAmount : 0}', '${uv.voucher.discountPercent != null ? uv.voucher.discountPercent : 0}', '${uv.voucher.id}')">
                                            Chọn
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn btn-secondary btn-sm disabled" style="font-size: 12px;">Chưa đạt</button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
$(document).ready(function() {
    // =================================================================
    // PHẦN 1: LOGIC GỌI API ĐỊA GIỚI & ĐỔ DỮ LIỆU DOMINO
    // =================================================================
    const $city = $("#modal_city");
    const $district = $("#modal_district");
    const $ward = $("#modal_ward");
    
    let localData = [];
    let savedDistrict = "";
    let savedWard = "";

    // 1. TẢI DỮ LIỆU TỈNH THÀNH
    fetch('https://raw.githubusercontent.com/kenzouno1/DiaGioiHanhChinhVN/master/data.json')
        .then(response => response.json())
        .then(data => {
            localData = data; 
            let options = '<option value="" selected disabled>Chọn tỉnh/thành phố</option>';
            data.forEach(item => {
                options += '<option value="' + item.Name + '" data-id="' + item.Id + '">' + item.Name + '</option>';
            });
            $city.html(options);
        })
        .catch(err => console.error("Lỗi tải dữ liệu địa giới:", err));

    // 2. KHI ĐỔI TỈNH -> TẠO HUYỆN
    $city.change(function() {
        let selectedCityId = String($city.find(':selected').data('id'));
        $district.html('<option value="" selected disabled>Chọn quận/huyện</option>');
        $ward.html('<option value="" selected disabled>Chọn phường/xã</option>');

        if (selectedCityId && selectedCityId !== "undefined") {
            let prov = localData.find(p => p.Id == selectedCityId);
            if (prov && prov.Districts) {
                let options = '<option value="" selected disabled>Chọn quận/huyện</option>';
                prov.Districts.forEach(item => {
                    options += '<option value="' + item.Name + '" data-id="' + item.Id + '">' + item.Name + '</option>';
                });
                $district.html(options);

                if(savedDistrict !== "") {
                    $district.val(savedDistrict).trigger('change');
                    savedDistrict = ""; 
                }
            }
        }
    });

    // 3. KHI ĐỔI HUYỆN -> TẠO XÃ
    $district.change(function() {
        let selectedCityId = String($city.find(':selected').data('id'));
        let selectedDistId = String($(this).find(':selected').data('id'));
        $ward.html('<option value="" selected disabled>Chọn phường/xã</option>');

        if (selectedCityId && selectedDistId && selectedDistId !== "undefined") {
            let prov = localData.find(p => p.Id == selectedCityId);
            if (prov) {
                let dist = prov.Districts.find(d => d.Id == selectedDistId);
                if (dist && dist.Wards) {
                    let options = '<option value="" selected disabled>Chọn phường/xã</option>';
                    dist.Wards.forEach(item => {
                        options += '<option value="' + item.Name + '">' + item.Name + '</option>';
                    });
                    $ward.html(options);

                    if(savedWard !== "") {
                        $ward.val(savedWard);
                        savedWard = ""; 
                    }
                }
            }
        }
    });

    // ====================================================================================
    // 4. KHI BẤM NÚT "SỬA" TRÊN ĐỊA CHỈ BẤT KỲ
    // ====================================================================================
    $('.btn-edit-address').on('click', function() {
        // Đổi tiêu đề và Action của form về SỬA
        $('#editAddressModalLabel').text('THAY ĐỔI ĐỊA CHỈ GIAO HÀNG');
        $('#dynamicAddressForm').attr('action', '${pageContext.request.contextPath}/edit-address');

        const id = $(this).data('id');
        const name = $(this).data('fullname');
        const phone = $(this).data('phone');
        const city = $(this).data('city');
        const district = $(this).data('district');
        const ward = $(this).data('ward');
        const detail = $(this).data('detail');
        
        $('#modal_addressId').val(id);
        $('#modal_fullName').val(name);
        $('#modal_phone').val(phone);
        $('#modal_detail').val(detail);

        $('.input-error').removeClass('input-error');
        $('.show-error').removeClass('show-error');

        if (city) {
            savedDistrict = district;
            savedWard = ward;
            $city.val(city).trigger('change');
        }
    });

    // ====================================================================================
    // 5. KHI BẤM NÚT "GIAO HÀNG ĐẾN ĐỊA CHỈ KHÁC" (THÊM MỚI)
    // ====================================================================================
    $('.btn-open-add-modal').on('click', function() {
        // Đổi tiêu đề và Action của form về THÊM MỚI
        $('#editAddressModalLabel').text('THÊM ĐỊA CHỈ MỚI');
        $('#dynamicAddressForm').attr('action', '${pageContext.request.contextPath}/add-address');

        // Làm trống toàn bộ ô nhập liệu
        $('#modal_addressId').val(''); // Quan trọng: Bỏ ID đi để hệ thống biết đây là địa chỉ mới
        $('#modal_fullName').val('');
        $('#modal_phone').val('');
        $('#modal_detail').val('');

        // Reset lại Dropdown Tỉnh/Huyện/Xã về trạng thái mặc định
        savedDistrict = "";
        savedWard = "";
        $city.val("").trigger('change');

        // Xóa viền đỏ báo lỗi cũ (nếu có)
        $('.input-error').removeClass('input-error');
        $('.show-error').removeClass('show-error');
    });

    // =================================================================
    // PHẦN 2: LOGIC KIỂM TRA LỖI (VALIDATION) CHO MODAL
    // =================================================================
    const modalFullname = document.getElementById('modal_fullName');
    const modalPhone = document.getElementById('modal_phone');
    const modalAddress = document.getElementById('modal_detail');
    const editForm = modalFullname.closest('form'); 

    // Check realtime Họ Tên
    modalFullname.addEventListener('input', function() {
        if (/\d/.test(this.value)) {
            this.classList.add('input-error');
            document.getElementById('modal-fullname-error').classList.add('show-error');
        } else {
            if (this.value.trim().length <= 50) this.classList.remove('input-error');
            document.getElementById('modal-fullname-error').classList.remove('show-error');
        }
    });

    // Check realtime SĐT
    modalPhone.addEventListener('input', function() {
        if (/\D/.test(this.value)) { 
            this.classList.add('input-error');
            document.getElementById('modal-phone-type-error').classList.add('show-error');
        } else {
            this.classList.remove('input-error');
            document.getElementById('modal-phone-type-error').classList.remove('show-error');
        }
    });

    // Check tổng thể khi bấm Lưu
    editForm.addEventListener('submit', function(event) {
        let isValid = true;
        
        document.getElementById('modal-fullname-length-error').classList.remove('show-error');
        document.getElementById('modal-phone-error').classList.remove('show-error');
        document.getElementById('modal-address-length-error').classList.remove('show-error');

        // Check Họ tên
        if (/\d/.test(modalFullname.value) || modalFullname.value.trim().length > 50) {
            isValid = false;
            modalFullname.classList.add('input-error');
            if(modalFullname.value.trim().length > 50) document.getElementById('modal-fullname-length-error').classList.add('show-error');
        }

        // Check SĐT
        if (/\D/.test(modalPhone.value) || !/^0\d{9}$/.test(modalPhone.value)) {
            isValid = false;
            modalPhone.classList.add('input-error');
            if(!/^0\d{9}$/.test(modalPhone.value)) document.getElementById('modal-phone-error').classList.add('show-error');
        }

        // Check Địa chỉ chi tiết
        if (modalAddress.value.trim().length > 100) {
            isValid = false;
            modalAddress.classList.add('input-error');
            document.getElementById('modal-address-length-error').classList.add('show-error');
        }

        if (!isValid) {
            event.preventDefault(); 
        }
        const checkoutForm = document.getElementById('checkoutForm');
        if(checkoutForm) {
            checkoutForm.addEventListener('submit', function(event) {
                const agreeTerms = document.getElementById('agreeTerms');
                if (!agreeTerms.checked) {
                    event.preventDefault(); // Chặn gửi form
                    alert('Vui lòng đồng ý với Điều khoản & Điều kiện để tiếp tục thanh toán!');
                }
            });
        }
    });
});

// Lấy giá trị tổng tiền gốc từ Backend và ép kiểu an toàn (loại bỏ phần thập phân .0 nếu có)
const originalGrandTotal = Math.round(Number('${grandTotal}')) || 0;

function applyVoucher(code, amount, percent, voucherId) {
    // Ép kiểu các tham số truyền vào thành số nguyên để tính toán cho chuẩn
    amount = Math.round(Number(amount)) || 0;
    percent = Number(percent) || 0;

    // 1. Điền mã vào ô Input và gắn ID vào thẻ ẩn
    document.getElementById('voucherCodeInput').value = code;
    document.getElementById('appliedVoucherId').value = voucherId;
    
    // 2. Tính toán số tiền được giảm
    let discountValue = 0;
    if (percent > 0) {
        // Khuyến mãi theo %
        discountValue = Math.round(originalGrandTotal * (percent / 100));
    } else if (amount > 0) {
        // Khuyến mãi trừ thẳng tiền mặt
        discountValue = amount;
    }
    
    // Đảm bảo tiền giảm không bao giờ lớn hơn tổng tiền đơn hàng (Tránh bị âm tiền)
    if (discountValue > originalGrandTotal) {
        discountValue = originalGrandTotal;
    }
    
    let newTotal = originalGrandTotal - discountValue;
    
    // 3. Cập nhật giao diện Bảng giá tiền
    const totalRow = document.querySelector('.total-row');
    
    // Kiểm tra xem đã có dòng "Voucher giảm giá" chưa, nếu có thì xóa đi tạo lại
    let discountRow = document.getElementById('discount-row');
    if (discountRow) discountRow.remove();
    
    // Chèn dòng Giảm giá mới vào TRƯỚC dòng Tổng Số Tiền
    const newRowHTML = `
        <tr id="discount-row">
            <td class="text-muted text-start">Voucher giảm giá</td>
            <td class="text-end fw-bold text-success">- ` + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(discountValue) + `</td>
        </tr>
    `;
    totalRow.insertAdjacentHTML('beforebegin', newRowHTML);
    
    // Cập nhật lại số tiền cuối cùng ở màu cam
    document.querySelector('.text-orange-total').innerHTML = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(newTotal);
    
    // Hiển thị thông báo thành công dưới ô input
    const msgBox = document.getElementById('voucherMessage');
    msgBox.style.display = 'block';
    msgBox.className = 'mt-2 text-success fw-bold';
    msgBox.innerHTML = '<i class="fa-solid fa-circle-check"></i> Đã áp dụng mã ' + code + ' thành công!';
    
    // 4. Đóng Modal
    const modalEl = document.getElementById('voucherModal');
    const modal = bootstrap.Modal.getInstance(modalEl);
    if(modal) modal.hide();
}

// 1. CHUYỂN DỮ LIỆU VÍ VOUCHER TỪ JAVA SANG JAVASCRIPT
    // Chúng ta lặp qua danh sách 'wallet' đã được gửi từ CheckoutServlet
    var myVouchers = [
        <c:forEach items="${wallet}" var="uv">
            {
                id: ${uv.voucher.id},
                code: '${uv.voucher.code.toUpperCase()}',
                amount: ${uv.voucher.discountAmount},
                percent: ${uv.voucher.discountPercent},
                minOrder: ${uv.voucher.minOrderValue}
            },
        </c:forEach>
    ];

    // Lấy tổng tiền gốc của đơn hàng từ Session
    var baseTotal = ${grandTotal != null ? grandTotal : 0};

    // 2. BẮT SỰ KIỆN KHI BẤM NÚT "ÁP DỤNG" (NHẬP TAY)
    document.getElementById('btnApplyVoucher').addEventListener('click', function() {
        var inputCode = document.getElementById('voucherCodeInput').value.trim().toUpperCase();
        
        if (inputCode === "") {
            showVoucherMsg("Vui lòng nhập mã khuyến mãi!", "#dc3545"); // Màu đỏ Bootstrap
            return;
        }

        // Dò tìm xem mã khách nhập có tồn tại trong ví không
        var matchedVoucher = myVouchers.find(function(v) {
            return v.code === inputCode;
        });

        if (!matchedVoucher) {
            showVoucherMsg("Mã khuyến mãi không hợp lệ, đã hết hạn hoặc chưa được lưu vào ví!", "#dc3545");
            return;
        }

        // Kiểm tra điều kiện đơn hàng tối thiểu
        if (baseTotal < matchedVoucher.minOrder) {
            showVoucherMsg("Đơn hàng chưa đạt tối thiểu " + matchedVoucher.minOrder.toLocaleString('vi-VN') + "đ để dùng mã này!", "#dc3545");
            return;
        }

        // TẬN DỤNG LUÔN HÀM CỦA MODAL ĐỂ XỬ LÝ (Không cần viết lại code trừ tiền)
        // Hàm này tự động trừ tiền, thêm dòng "Voucher giảm giá" và show thông báo thành công
        applyVoucher(matchedVoucher.code, matchedVoucher.amount, matchedVoucher.percent, matchedVoucher.id);
    });

    // Hàm phụ trợ để hiển thị text thông báo lỗi (Riêng phần báo lỗi thì vẫn dùng hàm này)
    function showVoucherMsg(text, color) {
        var msgDiv = document.getElementById('voucherMessage');
        msgDiv.innerText = text;
        msgDiv.style.color = color;
        msgDiv.style.fontWeight = "bold";
        msgDiv.style.display = "block";
    }
</script>

</body>
</html>