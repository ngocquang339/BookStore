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

        /* --- CSS CHO BỐ CỤC FORM NGANG CHUẨN --- */
        .address-form-wrapper .row {
            align-items: center; /* Căn giữa label với input theo chiều dọc */
            margin-bottom: 20px;
        }

        .form-label-custom {
            font-size: 14px;
            font-weight: 600; /* Làm đậm chữ label một chút */
            color: #333;
            margin-bottom: 0;
            text-align: left; /* Đảm bảo nhãn luôn canh lề trái */
        }

        /* Tùy chỉnh ô Input */
        .form-control, .form-select {
            font-size: 14px;
            color: #333;
            border-radius: 4px; /* Bo góc nhẹ giống ảnh 2 */
            border: 1px solid #ddd;
            padding: 10px 15px;
            box-shadow: none;
        }
        .form-control:focus, .form-select:focus {
            border-color: #C92127; /* Đỏ Fahasa */
            box-shadow: 0 0 0 0.1rem rgba(201, 33, 39, 0.1);
        }
        .text-danger {
            color: #d9534f !important;
            margin-left: 2px;
        }

        /* Phần Checkbox mặc định nằm ở góc dưới bên trái */
        .form-check-default {
            padding-left: 0;
            text-align: left; /* Thẳng lề trái với label */
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
        }
        .form-check-default .form-check-input {
            margin-left: 0;
            float: none;
            cursor: pointer;
        }
        .form-check-default .form-check-label {
            font-size: 14px;
            color: #555;
            font-style: italic;
            cursor: pointer;
        }
        .form-check-input:checked {
            background-color: #C92127;
            border-color: #C92127;
        }

        /* Nút Lưu và Quay lại */
        .form-footer {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-top: 30px;
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
            padding: 10px 40px;
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
                    
                    <h5>Nhập địa chỉ mới</h5>

                    <form action="add-address" method="POST">
                        <input type="hidden" name="addressId" value="${address.id}"> 

                        <div class="row">
                            <label class="col-sm-3 form-label-custom">Họ và tên<span class="text-danger">*</span></label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="fullName" placeholder="Họ và tên" required>
                            </div>
                        </div>

                        <div class="row">
                            <label class="col-sm-3 form-label-custom">Điện thoại <span class="text-danger">*</span></label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="phone" placeholder="Số điện thoại" value="0357355646" required>
                            </div>
                        </div>

                        <div class="row">
                            <label class="col-sm-3 form-label-custom">Tỉnh/Thành phố <span class="text-danger">*</span></label>
                            <div class="col-sm-9">
                                <select class="form-select" id="city" name="city" required>
                                    <option value="" selected disabled>Chọn tỉnh/thành phố</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <label class="col-sm-3 form-label-custom">Quận/Huyện <span class="text-danger">*</span></label>
                            <div class="col-sm-9">
                                <select class="form-select" id="district" name="district" required>
                                    <option value="" selected disabled>Chọn quận/huyện</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <label class="col-sm-3 form-label-custom">Xã/Phường <span class="text-danger">*</span></label>
                            <div class="col-sm-9">
                                <select class="form-select" id="ward" name="ward" required>
                                    <option value="" selected disabled>Chọn phường/xã</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <label class="col-sm-3 form-label-custom">Địa chỉ <span class="text-danger">*</span></label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="addressDetail" placeholder="Địa chỉ cụ thể (Số nhà, tên đường...)" value="vugj" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-sm-3">
                                <div class="form-check form-check-default">
                                    <input class="form-check-input" type="checkbox" name="isDefaultShipping" id="checkShipping">
                                    <label class="form-check-label" for="checkShipping">
                                        Sử dụng làm Địa chỉ giao hàng mặc định
                                    </label>
                                </div>
                            </div>
                            <div class="col-sm-9"></div> </div>

                        <div class="form-footer">
                            <a href="${pageContext.request.contextPath}/address" class="btn-back">« Quay lại</a>
                            <div>
                                <div class="required-note">(*): bắt buộc</div>
                                <button type="submit" class="btn-save-address">LƯU ĐỊA CHỈ</button>
                            </div>
                        </div>

                    </form>

                </div> 
            </div> 
        </div> 
    </div> 
    
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
</script>

</body>
</html>