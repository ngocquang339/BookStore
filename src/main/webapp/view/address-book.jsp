<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sổ địa chỉ - BookStore</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        /* Tận dụng lại background trắng và bo góc để khớp với class .main-profile-content nếu có */
        .address-wrapper {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08); /* Đổ bóng nhẹ nhàng hơn cho hài hòa với trang */
            padding: 30px;
            color: #333;
        }

        .address-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .address-header h5 {
            margin: 0;
            font-size: 20px; /* Chỉnh lại size chữ cho đồng bộ với H5 của đổi mật khẩu */
            font-weight: 600;
        }
        .btn-add-address {
            color: #2f80ed;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 5px;
            transition: 0.3s;
        }
        .btn-add-address:hover { text-decoration: underline; }

        .address-item { margin-bottom: 25px; }
        
        .address-info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            flex-wrap: wrap;
            gap: 10px;
        }
        .address-user {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 15px;
        }
        .address-user .name { font-weight: bold; color: #333; }
        .address-user .separator { color: #ccc; }
        .address-user .phone { font-weight: bold; color: #555; }
        
        .btn-edit {
            color: #2f80ed;
            text-decoration: none;
            font-size: 14px;
            transition: 0.3s;
        }
        .btn-edit:hover { text-decoration: underline; }

        .address-badge {
            display: inline-block;
            background-color: #e6f2ff;
            color: #2f80ed;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 10px;
        }
        .address-user .address-badge {
            margin-bottom: 0;
            margin-left: 5px;
        }

        .address-details { font-size: 14px; color: #666; line-height: 1.6; }
        .address-empty-msg { font-size: 14px; color: #555; }

        .address-divider {
            height: 1px;
            background-color: #f0f0f0;
            border: none;
            margin: 25px 0;
        }

        .address-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .btn-delete {
            color: #d9534f; /* Màu đỏ */
            text-decoration: none;
            font-size: 15px;
            transition: 0.3s;
        }
        .btn-delete:hover { 
            color: #c92127; /* Đỏ đậm hơn khi hover */
        }
    </style>
</head>

<body>
    
    <jsp:include page="component/header.jsp" />

    <c:if test="${not empty sessionScope.mess}">
        <div class="toast-message ${sessionScope.status == 'success' ? 'toast-success' : 'toast-error'}" id="toastMsg">
            <i class="fa-solid ${sessionScope.status == 'success' ? 'fa-circle-check' : 'fa-circle-exclamation'}" style="font-size: 24px;"></i>
            <div>
                <h6 style="margin:0; font-weight:bold;">Thông báo</h6>
                <p style="margin:0; font-size:13px;">${sessionScope.mess}</p>
            </div>
        </div>
        <c:remove var="mess" scope="session" />
        <c:remove var="status" scope="session" />
    </c:if>

    <div class="container profile-container">
        <div class="row">
            
            <div class="col-md-3">
                <jsp:include page="component/sidebar.jsp" />
            </div>

            <div class="col-md-9">
                <div class="address-wrapper">
                    
                    <div class="address-header">
                        <h5>Sổ địa chỉ</h5>
                       <a href="javascript:void(0);" 
                        class="btn-add-address btn-open-add-modal" 
                        data-bs-toggle="modal" 
                        data-bs-target="#addAddressModal">
                            <i class="fa-solid fa-plus"></i> Thêm địa chỉ mới
                        </a>
                    </div>

                    <c:choose>
                        
                        <%-- TRƯỜNG HỢP 1: TÀI KHOẢN CHƯA CÓ BẤT KỲ ĐỊA CHỈ NÀO --%>
                        <c:when test="${empty listAddresses}">
                            <div class="address-item" style="text-align: center; padding: 40px 0;">
                                <div class="address-empty-msg">
                                    Bạn chưa thiết lập địa chỉ nào trong Sổ địa chỉ.
                                </div>
                            </div>
                        </c:when>
                        
                        <%-- TRƯỜNG HỢP 2: ĐĐÃ CÓ ĐỊA CHỈ TRONG DB --%>
                        <c:otherwise>
                            
                            <c:set var="hasDefaultShipping" value="false" />
                            
                            <c:forEach var="addr" items="${listAddresses}">
                                <c:if test="${addr.defaultShipping}">
                                    <c:set var="hasDefaultShipping" value="true" />
                                    
                                    <div class="address-item">
                                        <div class="address-info-row">
                                            <div class="address-user">
                                                <span class="name">${addr.fullName}</span>
                                                <span class="separator">|</span>
                                                <span class="phone">${addr.phone}</span>
                                                <span class="address-badge">Địa chỉ giao hàng mặc định</span>
                                            </div>
                                            
                                            <div class="address-actions">
                                                <a href="${pageContext.request.contextPath}/address?action=edit&id=${addr.id}" class="btn-edit">Sửa</a>
                                                <a href="${pageContext.request.contextPath}/address?action=delete&id=${addr.id}" 
                                                   class="btn-delete" 
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa địa chỉ này?');">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </a>
                                            </div>
                                        </div>
                                        <div class="address-details">
                                            ${addr.addressDetail}<br>
                                            ${addr.ward}, ${addr.district}, ${addr.city}
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>

                            <c:if test="${!hasDefaultShipping}">
                                <div class="address-item">
                                    <span class="address-badge mb-3">Địa chỉ giao hàng mặc định</span>
                                    <div class="address-empty-msg mt-2">
                                        Bạn chưa thiết lập địa chỉ giao hàng mặc định.
                                    </div>
                                </div>
                            </c:if>

                            <hr class="address-divider">

                            <c:set var="hasOtherAddress" value="false" />
                            
                            <c:forEach var="addr" items="${listAddresses}" varStatus="loop">
                                <c:if test="${!addr.defaultShipping}">
                                    <c:set var="hasOtherAddress" value="true" />
                                    
                                    <div class="address-item">
                                        <div class="address-info-row">
                                            <div class="address-user">
                                                <span class="name">${addr.fullName}</span>
                                                <span class="separator">|</span>
                                                <span class="phone">${addr.phone}</span>
                                                
                                                <span class="address-badge" style="background-color: #e6f2ff; color: #2f80ed;">Địa chỉ khác</span>
                                            </div>
                                            
                                            <div class="address-actions">
                                                <a href="${pageContext.request.contextPath}/address?action=edit&id=${addr.id}" class="btn-edit">Sửa</a>
                                                <a href="${pageContext.request.contextPath}/address?action=delete&id=${addr.id}" 
                                                   class="btn-delete" 
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa địa chỉ này?');">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </a>
                                            </div>
                                        </div>
                                        <div class="address-details">
                                            ${addr.addressDetail}<br>
                                            ${addr.ward}, ${addr.district}, ${addr.city}
                                        </div>
                                    </div>
                                    
                                    <c:if test="${!loop.last}">
                                        <hr class="address-divider" style="margin: 15px 0;">
                                    </c:if>
                                </c:if>
                            </c:forEach>

                            <c:if test="${!hasOtherAddress}">
                                <div class="address-item">
                                    <span class="address-badge mb-3" style="background-color: #f0f0f0; color: #555;">Địa chỉ khác</span>
                                    <div class="address-empty-msg mt-2">
                                        Bạn không có địa chỉ khác trong Sổ địa chỉ.
                                    </div>
                                </div>
                            </c:if>

                        </c:otherwise>
                    </c:choose>
                </div> 
            </div> </div> </div> 
            
            <div class="modal fade" id="addAddressModal" tabindex="-1" aria-labelledby="addAddressModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content" style="border-radius: 10px;">
                    
                    <form action="${pageContext.request.contextPath}/edit-address" method="POST" id="dynamicAddressForm">
                        <input type="hidden" name="addressId" id="modal_addressId">
                        <div class="modal-header border-bottom-0 pb-0 mt-3 d-flex justify-content-center position-relative">
                        <h5 class="modal-title fw-bold" style="color: #d70018;" id="addAddressModalLabel">THÊM ĐỊA CHỈ GIAO HÀNG</h5>
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
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // Tắt Toast message sau 4s
        setTimeout(function() {
            let toast = document.getElementById('toastMsg');
            if (toast) toast.style.display = 'none';
        }, 4000);

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
    // 5. KHI BẤM NÚT "GIAO HÀNG ĐẾN ĐỊA CHỈ KHÁC" (THÊM MỚI)
    // ====================================================================================
    $('.btn-open-add-modal').on('click', function() {
        // Đổi tiêu đề và Action của form về THÊM MỚI
        $('#addAddressModalLabel').text('THÊM ĐỊA CHỈ MỚI');
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
    </script>
</body>
</html>