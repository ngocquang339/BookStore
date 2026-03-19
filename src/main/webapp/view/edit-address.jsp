<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa địa chỉ - BookStore</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        .address-form-wrapper {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            padding: 30px;
            color: #333;
        }
        
        .address-form-wrapper h5 {
            font-size: 20px;
            font-weight: 500;
            color: #333;
            margin-bottom: 25px;
        }

        /* --- TÙY CHỈNH SMART LABEL (FLOATING) --- */
        .form-floating > label {
            color: #777;
            font-size: 14px;
        }
        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label,
        .form-floating > .form-select ~ label {
            color: #C92127; /* Đổi màu chữ label thành đỏ khi focus */
            font-weight: 500;
        }
        .form-control, .form-select {
            font-size: 14px;
            color: #333;
            border-radius: 6px;
            border: 1px solid #ddd;
        }
        .form-control:focus, .form-select:focus {
            border-color: #C92127;
            box-shadow: 0 0 0 0.2rem rgba(201, 33, 39, 0.1); /* Hiệu ứng viền đỏ */
        }
        .text-danger {
            color: #d9534f !important;
            margin-left: 2px;
        }

        /* Checkbox tùy chỉnh */
        .form-check-label {
            font-size: 14px;
            color: #555;
            font-style: italic;
        }
        .form-check-input:checked {
            background-color: #C92127;
            border-color: #C92127;
        }

        /* Phần Footer của Form (Nút Quay lại & Lưu) */
        .form-footer {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-top: 35px;
            border-top: 1px solid #f0f0f0;
            padding-top: 20px;
        }
        .btn-back {
            color: #2f80ed;
            text-decoration: none;
            font-size: 14px;
            transition: 0.3s;
        }
        .btn-back:hover {
            text-decoration: underline;
        }
        .btn-save-address {
            background-color: #C92127;
            color: #fff;
            border: none;
            padding: 10px 30px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            text-transform: uppercase;
            transition: background 0.3s;
        }
        .btn-save-address:hover {
            background-color: #a81c21;
        }
        .required-note {
            font-size: 12px;
            color: #d9534f;
            text-align: right;
            margin-bottom: 10px;
        }
        .static-label {
            font-size: 14px;
            color: #333;
            margin-bottom: 8px;
            display: block;
        }
    </style>
</head>

<body>
    
    <jsp:include page="component/header.jsp" />

    <div class="container profile-container">
        <div class="row">
            
            <div class="col-md-3">
                <jsp:include page="component/sidebar.jsp" />
            </div>

            <div class="col-md-9">
                <div class="address-form-wrapper">
                    
                    <h5>Sửa địa chỉ</h5>

                    <form action="${pageContext.request.contextPath}/edit-address" method="POST" onsubmit="return validateAddressForm(event)">
                        <input type="hidden" name="addressId" value="${address.id}"> 
                        
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Họ và tên" value="${address.fullName}" required>
                                    <label for="fullName">Họ và tên <span class="text-danger">*</span></label>
                                </div>
                            </div>
                            
                            <div class="col-md-12">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="phone" name="phone" placeholder="Điện thoại" value="${address.phone}" required>
                                    <label for="phone">Điện thoại <span class="text-danger">*</span></label>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-floating">
                                    <select class="form-select" id="city" name="city" required>
                                        <option value="" selected disabled>Chọn tỉnh/thành phố</option>
                                    </select>
                                    <label for="city">Tỉnh/Thành phố <span class="text-danger">*</span></label>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-floating">
                                    <select class="form-select" id="district" name="district" required>
                                        <option value="" selected disabled>Chọn quận/huyện</option>
                                    </select>
                                    <label for="district">Quận/Huyện <span class="text-danger">*</span></label>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-floating">
                                    <select class="form-select" id="ward" name="ward" required>
                                        <option value="" selected disabled>Chọn phường/xã</option>
                                    </select>
                                    <label for="ward">Xã/Phường <span class="text-danger">*</span></label>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="addressDetail" name="addressDetail" placeholder="Địa chỉ" value="${address.addressDetail}" required>
                                    <label for="addressDetail">Địa chỉ cụ thể <span class="text-danger">*</span></label>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4">
                            <span class="static-label">Địa chỉ thanh toán mặc định</span>
                            <div class="form-check mt-2">
                                <input class="form-check-input" type="checkbox" name="isDefaultShipping" id="checkShipping" ${address.defaultShipping ? 'checked' : ''}>
                                <label class="form-check-label" for="checkShipping">
                                    Sử dụng như Địa chỉ giao hàng mặc định của tôi
                                </label>
                            </div>
                        </div>

                        <div class="form-footer mt-4" style="display: flex; justify-content: space-between; align-items: center;">
                            <a href="${pageContext.request.contextPath}/address" class="btn-back text-decoration-none text-primary">« Quay lại</a>
                            <div style="display: flex; align-items: center; gap: 15px;">
                                <div class="required-note text-muted" style="font-size: 13px;">(*): bắt buộc</div>
                                <button type="submit" class="btn btn-danger px-4 py-2">LƯU ĐỊA CHỈ</button>
                            </div>
                        </div>

                    </form>

                </div> </div> </div> </div> 
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        const $city = $("#city");
        const $district = $("#district");
        const $ward = $("#ward");
        
        let localData = [];

        // === 1. LẤY DỮ LIỆU CŨ TỪ DATABASE LÊN (MA THUẬT NẰM Ở ĐÂY) ===
        let savedCity = "${address.city}";
        let savedDistrict = "${address.district}";
        let savedWard = "${address.ward}";

        // 2. Tải dữ liệu từ Github
        fetch('https://raw.githubusercontent.com/kenzouno1/DiaGioiHanhChinhVN/master/data.json')
            .then(response => response.json())
            .then(data => {
                localData = data; 
                let options = '<option value="" selected disabled>Chọn tỉnh/thành Phố</option>';
                data.forEach(item => {
                    options += '<option value="' + item.Name + '" data-id="' + item.Id + '">' + item.Name + '</option>';
                });
                $city.html(options);

                // === 3. TỰ ĐỘNG CHỌN TỈNH CŨ KHI TẢI XONG ===
                if(savedCity && savedCity !== "") {
                    $city.val(savedCity).trigger('change'); 
                }
            })
            .catch(err => console.error("Lỗi tải dữ liệu địa giới:", err));

        // 4. Sự kiện khi Tỉnh/Thành phố thay đổi
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

                    // === 5. TỰ ĐỘNG CHỌN QUẬN/HUYỆN CŨ KHI TẢI XONG TỈNH ===
                    if(savedDistrict && savedDistrict !== "") {
                        $district.val(savedDistrict).trigger('change');
                        savedDistrict = ""; // Xóa biến đi để người dùng đổi tỉnh khác thì không bị kẹt lỗi
                    }
                }
            }
        });

        // 6. Sự kiện khi Quận/Huyện thay đổi
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

                        // === 7. TỰ ĐỘNG CHỌN XÃ/PHƯỜNG CŨ KHI TẢI XONG HUYỆN ===
                        if(savedWard && savedWard !== "") {
                            $ward.val(savedWard);
                            savedWard = ""; // Xóa biến
                        }
                    }
                }
            }
        });
    });
    function validateAddressForm(e) {
    let isValid = true;
    
    let fullName = document.getElementById("fullName").value.trim();
    let phone = document.getElementById("phone").value.trim();
    let city = document.getElementById("city").value;
    let addressDetail = document.getElementById("addressDetail").value.trim();

    // 1. Kiểm tra Dropdown (EX 5)
    if (!city || city === "") {
        alert("Vui lòng chọn Tỉnh/Thành phố, Quận/Huyện, Xã/Phường đầy đủ.");
        isValid = false;
    }

    // 2. Kiểm tra Họ tên không chứa số & giới hạn 50 ký tự (EX 1, EX 2)
    if (/\d/.test(fullName)) {
        alert("Họ tên không được chứa chữ số.");
        isValid = false;
    } else if (fullName.length > 50) {
        alert("Họ tên không được vượt quá 50 ký tự.");
        isValid = false;
    }

    // 3. Kiểm tra Số điện thoại (EX 3) - 10 số và bắt đầu bằng 0
    if (!/^0\d{9}$/.test(phone)) {
        alert("Số điện thoại phải bao gồm đúng 10 chữ số và bắt đầu bằng 0.");
        isValid = false;
    }

    // 4. Kiểm tra địa chỉ cụ thể (EX 4)
    if (addressDetail.length > 100) {
        alert("Địa chỉ cụ thể không được vượt quá 100 ký tự.");
        isValid = false;
    }

    // Nếu có lỗi, chặn không cho submit form
    if (!isValid) {
        e.preventDefault();
    }
    return isValid;
}
    </script>
</body>
</html>