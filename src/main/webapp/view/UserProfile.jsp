<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ của ${sessionScope.user.username} - BookStore</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css"> 
    
    <style>
        /* Style cho thông báo thành công */
        .toast-message {
            position: fixed;
            top: 80px;
            right: 20px;
            background-color: #ffffff;
            color: #155724;
            border-left: 5px solid #28a745;
            padding: 15px 25px;
            border-radius: 4px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            display: flex;
            align-items: center;
            gap: 15px;
            z-index: 9999;
            animation: slideIn 0.5s ease forwards, fadeOut 0.5s ease 3s forwards;
            opacity: 0;
            min-width: 300px;
        }

        .toast-message i {
            font-size: 24px;
            color: #28a745;
        }

        .toast-content h4 {
            margin: 0;
            font-size: 16px;
            font-weight: bold;
        }

        .toast-content p {
            margin: 0;
            font-size: 14px;
            color: #666;
        }

        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        @keyframes fadeOut {
            to { opacity: 0; visibility: hidden; }
        }
    </style>
</head>

<body>
    <jsp:include page="component/header.jsp" />

    <c:if test="${empty sessionScope.user}">
        <c:redirect url="/login"/>
    </c:if>

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
                <div class="main-profile-content">
                    
                    <div class="page-header">
                        <h5>Hồ sơ cá nhân</h5>
                        <p style="font-size: 13px; color: #666; margin:0;">Quản lý thông tin hồ sơ để bảo mật tài khoản</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/update-profile" method="post">
                        
                        <div class="form-row">
                            <label class="form-label-custom">Tên đăng nhập</label>
                            <div class="form-input-custom">
                                <input type="text" name="username" value="${sessionScope.user.username}" class="form-control" readonly title="Không thể thay đổi tên đăng nhập">
                            </div>
                        </div>

                        <div class="form-row">
                            <label class="form-label-custom">Họ và tên</label>
                            <div class="form-input-custom">
                                <input type="text" name="fullname" value="${sessionScope.user.fullname}" class="form-control" placeholder="Nhập họ tên đầy đủ">
                            </div>
                        </div>

                        <div class="form-row">
                            <label class="form-label-custom">Email</label>
                            <div class="form-input-custom position-relative">
                                <input type="email" name="email" value="${sessionScope.user.email}" 
                                    class="form-control" readonly style="background-color: #fff;">
                                
                                <a href="javascript:void(0);" onclick="openEmailModal()" 
                                style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); color: #0d6efd; text-decoration: none; font-weight: 500;">
                                Thay đổi
                                </a>
                            </div>
                        </div>

                        <div class="form-row">
                            <label class="form-label-custom">Số điện thoại</label>
                            <div class="form-input-custom position-relative">
                                <input type="text" name="phone_number" value="${sessionScope.user.phone_number}" 
                                    class="form-control" readonly style="background-color: #fff;">
                                
                                <a href="javascript:void(0);" onclick="openPhoneModal(); return false;" 
                                style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); color: #0d6efd; text-decoration: none; font-weight: 500;">
                                Thay đổi
                                </a>
                            </div>
                        </div>

                        <div class="form-row">
                            <label class="form-label-custom">Địa chỉ nhận hàng</label>
                            <div class="form-input-custom">
                                <input type="text" name="address" value="${sessionScope.user.address}" class="form-control" placeholder="Nhập địa chỉ nhận hàng">
                            </div>
                        </div>

                        <div class="form-row">
                            <label class="form-label-custom"></label> 
                            <div class="form-input-custom">
                                <button type="submit" class="btn-save-pass">
                                    <i class="fa-regular fa-floppy-disk"></i> Lưu thay đổi
                                </button>
                            </div>
                        </div>

                    </form>
                </div>
            </div> 
        </div> 
    </div> 

    <!-- Modal -->
   <div id="modalChangePhone" class="modal-overlay">
        <div class="modal-box">
            <h3 class="modal-title" style="text-align: center; margin-bottom: 20px; font-weight: bold;">THAY ĐỔI SỐ ĐIỆN THOẠI</h3>

            <form action="verify-otp" method="POST">
                
                <div class="modal-group" style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 500;">Số điện thoại mới</label>
                    
                    <input type="text" id="newPhoneInput" name="new_phone" class="modal-input" 
                        placeholder="Nhập số điện thoại mới" 
                        required 
                        oninput="validatePhone()"
                        style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px;">
                    
                    <small id="phoneError" style="color: #dc3545; font-size: 13px; display: none; margin-top: 5px; font-weight: bold;"></small>
                </div>

                <div class="modal-group" style="margin-bottom: 20px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 500;">Chọn phương thức xác minh OTP</label>
                    <div class="otp-options">
                        <label class="otp-option">
                            <input type="radio" name="otp_method" value="sms" checked>
                            <div class="otp-box">
                                <i class="fa-solid fa-comment-sms"></i> Tin nhắn SMS
                            </div>
                        </label>
                        <label class="otp-option">
                            <input type="radio" name="otp_method" value="zalo">
                            <div class="otp-box">
                                <i class="fa-solid fa-z"></i> Zalo ZNS
                            </div>
                        </label>
                    </div>
                </div>

                <div class="modal-group" style="margin-bottom: 20px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 500;">Mã xác nhận OTP</label>
                    <input type="text" name="otp_code" class="modal-input" placeholder="6 ký tự" style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px;">
                </div>

                <div class="modal-actions">
                    <button type="submit" class="btn-confirm" id="btnConfirmPhone">Xác nhận</button>
                    <button type="button" class="btn-cancel" onclick="closePhoneModal(); return false;">Trở về</button>
                </div>
            </form>
        </div>
    </div>

    <div id="modalChangeEmail" class="modal-overlay">
        <div class="modal-box">
            <h3 class="modal-title" style="text-align: center; margin-bottom: 20px; font-weight: bold;">THAY ĐỔI EMAIL</h3>

            <form action="change-email" method="POST"> 
                <div class="modal-group" style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 500;">Email</label>
                    
                    <div style="position: relative;">
                        <input type="email" id="newEmailInput" name="new_email" maxlength="255" class="modal-input" 
                            placeholder="Enter Email" required
                            style="width: 100%; padding: 10px 90px 10px 10px; border: 1px solid #ddd; border-radius: 5px;">
                        
                        <button type="submit" id="btnSendOTP"
                        style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); 
                                font-size: 13px; font-weight: bold; color: #0d6efd; text-decoration: none; background-color: #fff; border: none;outline: none;">
                            Gửi mã OTP
                        </button>
                    </div>
                    <small id="emailError" style="color: red; font-size: 13px; margin-top: 5px; font-weight: 500; display: ${not empty requestScope.error ? 'block' : 'none'};">
                        ${requestScope.error}
                    </small>
                </div>
            </form>

            <form action="verify-otp" method="POST">
                <div class="modal-group" style="margin-bottom: 20px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 500;">Mã xác nhận OTP</label>
                    <input type="text" name="email_otp" maxlength="10" class="modal-input" placeholder="6 ký tự" 
                        style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px;">
                </div>

                <div class="modal-actions">
                    <button type="submit" class="btn-confirm" style="background-color: #e0e0e0; color: #333;">Xác nhận</button>
                    
                    <button type="button" class="btn-cancel" onclick="closeEmailModal()">Trở về</button>
                </div>
            </form>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Tự động xóa element sau khi chạy xong hiệu ứng fadeOut
        setTimeout(function() {
            let toast = document.getElementById('toastMsg');
            if (toast) {
                toast.remove();
            }
        }, 4000);

        // --- XỬ LÝ MODAL EMAIL ---
    function openEmailModal() {
        document.getElementById('modalChangeEmail').style.display = 'flex';
    }

    function closeEmailModal() {
        document.getElementById('modalChangeEmail').style.display = 'none';
    }

    // Cập nhật hàm đóng khi bấm ra ngoài để đóng được cả 2 modal
    window.onclick = function(event) {
        var modalPhone = document.getElementById('modalChangePhone');
        var modalEmail = document.getElementById('modalChangeEmail');
        if (event.target == modalPhone) {
            modalPhone.style.display = "none";
        }
        if (event.target == modalEmail) {
            modalEmail.style.display = "none";
        }
    }

    // Khi trang load xong, kiểm tra xem Server có yêu cầu mở Modal không
    

        // Hàm mở Modal
        function openPhoneModal() {
            var modal = document.getElementById('modalChangePhone');
            if (modal) {
                modal.style.display = 'flex';
            }
        }

        // Hàm đóng Modal
        function closePhoneModal() {
            var modal = document.getElementById('modalChangePhone');
            if (modal) {
                modal.style.display = 'none';
            }
        }
        function validatePhone() {
        var input = document.getElementById('newPhoneInput');
        var errorMsg = document.getElementById('phoneError');
        var btn = document.getElementById('btnConfirmPhone');
        var value = input.value;

        // Reset trạng thái ban đầu
        errorMsg.style.display = 'none';
        input.style.borderColor = '#ddd';
        btn.disabled = false;
        btn.style.opacity = '1'; // Nút sáng lên

        // 1. Kiểm tra nếu có chữ (Ký tự không phải số)
        // Regex: \D khớp với bất kỳ ký tự nào KHÔNG phải là số
        if (/\D/.test(value)) {
            errorMsg.innerText = 'Vui lòng chỉ nhập số, không nhập chữ!';
            errorMsg.style.display = 'block';
            input.style.borderColor = '#dc3545'; // Viền đỏ
            btn.disabled = true; // Khóa nút
            btn.style.opacity = '0.5'; // Nút mờ đi
            return;
        }

        // 2. Kiểm tra độ dài (Quá 10 số)
        if (value.length > 10) {
            errorMsg.innerText = 'Số điện thoại không được quá 10 số!';
            errorMsg.style.display = 'block';
            input.style.borderColor = '#dc3545';
            btn.disabled = true;
            btn.style.opacity = '0.5';
        }
    }

        // Đóng modal khi bấm ra ngoài vùng trắng
        window.onclick = function(event) {
            var modal = document.getElementById('modalChangePhone');
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }

        // Hợp nhất tất cả logic cần chạy khi load trang vào đây
        window.onload = function() {
            
            // --- PHẦN 1: Kiểm tra mở lại Modal Email (Sau khi gửi OTP) ---
            var shouldOpenEmail = "${requestScope.openVerifyEmail}"; 
            if (shouldOpenEmail === "true") {
                openEmailModal();
                
                var pendingEmail = "${requestScope.pendingEmail}";
                if (pendingEmail) {
                    var emailInput = document.getElementById("newEmailInput");
                    if(emailInput) emailInput.value = pendingEmail;
                }

                // Focus vào ô OTP
                var otpInput = document.querySelector("input[name='email_otp']");
                if(otpInput) otpInput.focus();
            }

            // --- PHẦN 2: Kiểm tra mở lại Modal Phone (Nếu bạn có làm tương tự) ---
            // var shouldOpenPhone = "${requestScope.openVerifyPhone}";
            // if (shouldOpenPhone === "true") { openPhoneModal(); }
        };
    </script>

</body>
</html>