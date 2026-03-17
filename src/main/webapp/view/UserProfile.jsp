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
        /* 1. KHUNG CHUNG CỦA TOAST */
        .toast-message {
            position: fixed;
            top: 80px;
            right: 20px;
            background-color: #ffffff;
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

        /* 2. CHUYÊN BIỆT CHO TRẠNG THÁI THÀNH CÔNG (XANH) */
        .toast-success {
            color: #155724;
            border-left: 5px solid #28a745;
        }
        .toast-success i {
            color: #28a745;
            font-size: 24px;
        }

        /* 3. CHUYÊN BIỆT CHO TRẠNG THÁI LỖI (ĐỎ) */
        .toast-error {
            color: #721c24; /* Chữ đỏ thẫm */
            border-left: 5px solid #dc3545; /* Viền đỏ Bootstrap */
        }
        .toast-error i {
            color: #dc3545; /* Icon đỏ */
            font-size: 24px;
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

    <%-- SỬA THÀNH requestScope --%>
    <c:if test="${not empty requestScope.mess or not empty sessionScope.mess}">
        <%-- Lấy biến ra (Ưu tiên request, nếu không có mới lấy session) --%>
        <c:set var="finalMess" value="${not empty requestScope.mess ? requestScope.mess : sessionScope.mess}" />
        <c:set var="finalStatus" value="${not empty requestScope.status ? requestScope.status : sessionScope.status}" />

        <div class="toast-message ${finalStatus == 'success' ? 'toast-success' : 'toast-error'}" id="toastMsg">
            <i class="fa-solid ${finalStatus == 'success' ? 'fa-circle-check' : 'fa-circle-exclamation'}" style="font-size: 24px;"></i>
            <div>
                <h6 style="margin:0; font-weight:bold;">Thông báo</h6>
                <p style="margin:0; font-size:13px;">${finalMess}</p>
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
   <div id="modalChangePhone" class="modal-overlay" style="display: none;">
        <div class="modal-box">
            <h3 class="modal-title" style="text-align: center; margin-bottom: 20px; font-weight: bold;">THAY ĐỔI SỐ ĐIỆN THOẠI</h3>

            <form action="change-phone" method="POST">
                
                <div class="modal-group" style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 500;">Email xác thực</label>
                    <div style="position: relative;">
                        <input type="email" id="verifyEmailForPhone" name="verify_email" value="${sessionScope.user.email}" class="modal-input" 
                            placeholder="Nhập email..." required readonly
                            style="width: 100%; padding: 10px 100px 10px 10px; border: 1px solid #ddd; border-radius: 5px; background-color: #f9f9f9;">
                        
                        <button type="button" id="btnSendOtpPhone" onclick="sendOtpForPhone()"
                        style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); 
                                font-size: 13px; font-weight: bold; color: #0d6efd; background-color: transparent; border: none; outline: none; cursor: pointer;">
                            Gửi mã OTP
                        </button>
                    </div>
                    <small id="phoneEmailSuccessMsg" style="color: #28a745; font-size: 13px; margin-top: 5px; font-weight: 500; display: none;">
                        <i class="fa-solid fa-circle-check"></i> Mã OTP đã được gửi đến email!
                    </small>
                </div>

                <div class="modal-group" style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 500;">Mã xác nhận OTP</label>
                    <input type="text" id="otpCodePhone" name="otp_code" maxlength="6" class="modal-input" placeholder="Nhập 6 số OTP" required
                        style="width: 100%; padding: 10px; border: 1px solid ${not empty requestScope.otpError ? '#dc3545' : '#ddd'}; border-radius: 5px; text-align: center; letter-spacing: 3px; font-size: 16px; font-weight: bold;">
                    
                    <small style="color: #dc3545; font-size: 13px; margin-top: 5px; font-weight: bold; display: ${not empty requestScope.otpError ? 'block' : 'none'};">
                        <i class="fa-solid fa-triangle-exclamation"></i> ${requestScope.otpError}
                    </small>

                    <small id="otpCountdownWrapper" style="color: #666; font-size: 13px; margin-top: 5px; display: none; font-style: italic;">
                        Mã có hiệu lực trong: <span id="phoneCountdown" style="color: #C92127; font-weight: bold;">01:00</span>
                    </small>
                </div>

                <div class="modal-group" style="margin-bottom: 25px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 500;">Số điện thoại mới</label>
                    <input type="text" id="newPhoneInput" name="new_phone" class="modal-input" 
                        placeholder="Nhập số điện thoại mới" required oninput="validatePhone()"
                        style="width: 100%; padding: 10px; border: 1px solid ${not empty requestScope.phoneErrorServer ? '#dc3545' : '#ddd'}; border-radius: 5px;">
                    
                    <small style="color: #dc3545; font-size: 13px; margin-top: 5px; font-weight: bold; display: ${not empty requestScope.phoneErrorServer ? 'block' : 'none'};">
                        <i class="fa-solid fa-triangle-exclamation"></i> ${requestScope.phoneErrorServer}
                    </small>

                    <small id="phoneError" style="color: #dc3545; font-size: 13px; display: none; margin-top: 5px; font-weight: bold;"></small>
                </div>

                <div class="modal-actions" style="display: flex; justify-content: flex-end; gap: 10px;">
                    <button type="button" class="btn-cancel" onclick="closePhoneModal()" style="background: transparent; border: 1px solid #ddd; padding: 8px 20px; border-radius: 4px; font-weight: bold; color: #555; cursor: pointer;">Trở về</button>
                    <button type="submit" class="btn-confirm" id="btnConfirmPhone" style="background-color: #C92127; color: white; border: none; padding: 8px 20px; border-radius: 4px; font-weight: bold; cursor: pointer;">Xác nhận</button>
                </div>
            </form>
        </div>
    </div>
    <div id="modalChangeEmail" class="modal-overlay" style="display: none;">
        <div class="modal-box">
            <h3 class="modal-title" style="text-align: center; margin-bottom: 20px; font-weight: bold;">THAY ĐỔI EMAIL</h3>

            <form action="verify-otp" method="POST">
                <input type="hidden" name="action_type" value="change_email">
                
                <div class="modal-group" style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 500;">Email mới</label>
                    <div style="position: relative;">
                        <input type="email" id="newEmailInputAjax" name="new_email" maxlength="100" class="modal-input" 
                            placeholder="Nhập email mới..." required value="${requestScope.pendingEmail}"
                            style="width: 100%; padding: 10px 90px 10px 10px; border: 1px solid #ddd; border-radius: 5px;">
                        
                        <button type="button" id="btnSendOTPAjax" onclick="sendOtpForEmail()"
                        style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); 
                                font-size: 13px; font-weight: bold; color: #0d6efd; background-color: transparent; border: none; outline: none; cursor: pointer;">
                            Gửi mã OTP
                        </button>
                    </div>
                    
                    <small id="emailErrorAjax" style="color: #dc3545; font-size: 13px; margin-top: 5px; font-weight: bold; display: none;">
                        <i class="fa-solid fa-triangle-exclamation"></i> <span></span>
                    </small>

                    <small id="emailSuccessAjax" style="color: #28a745; font-size: 13px; margin-top: 5px; font-weight: bold; display: none;">
                        <i class="fa-solid fa-circle-check"></i> Mã OTP đã được gửi đến email của bạn!
                    </small>
                </div>

                <div class="modal-group" style="margin-bottom: 20px;">
                    <label style="display: block; margin-bottom: 5px; font-weight: 500;">Mã xác nhận OTP</label>
                    <input type="number" id="otpCodeEmailAjax" name="Userotp" maxlength="6" class="modal-input" placeholder="6 ký tự" required
                        style="width: 100%; padding: 10px; border: 1px solid ${not empty requestScope.otpEmailError ? '#dc3545' : '#ddd'}; border-radius: 5px; letter-spacing: 2px; text-align: center; font-size: 16px; font-weight: bold;">
                    
                    <small style="color: #dc3545; font-size: 13px; margin-top: 5px; font-weight: bold; display: ${not empty requestScope.otpEmailError ? 'block' : 'none'};">
                        <i class="fa-solid fa-triangle-exclamation"></i> ${requestScope.otpEmailError}
                    </small>

                    <small id="emailCountdownWrapper" style="color: #666; font-size: 13px; margin-top: 5px; display: none; font-style: italic;">
                        Mã có hiệu lực trong: <span id="emailCountdown" style="color: #C92127; font-weight: bold;">01:00</span>
                    </small>
                </div>

                <div class="modal-actions" style="display: flex; justify-content: flex-end; gap: 10px;">
                    <button type="button" class="btn-cancel" onclick="closeEmailModal()" style="background: transparent; border: 1px solid #ddd; padding: 8px 20px; border-radius: 4px; font-weight: bold; color: #555; cursor: pointer;">Trở về</button>
                    <button type="submit" class="btn-confirm" style="background-color: #C92127; color: white; border: none; padding: 8px 20px; border-radius: 4px; font-weight: bold; cursor: pointer;">Xác nhận</button>
                </div>
            </form>
        </div>
    </div>
    <jsp:include page="component/suggested-books.jsp" />
    <jsp:include page="component/footer.jsp" />
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
        
        // =========================================================
        // --- PHẦN 1: Kiểm tra mở lại Modal Email (Sau khi submit sai OTP) ---
        // =========================================================
        var shouldOpenEmail = "${requestScope.openVerifyEmail}"; 
        if (shouldOpenEmail === "true") {
            openEmailModal();
            
            // 1. Điền lại Email đang gõ dở
            var pendingEmail = "${requestScope.pendingEmail}";
            if (pendingEmail) {
                var emailInput = document.getElementById("newEmailInputAjax");
                if(emailInput) {
                    emailInput.value = pendingEmail;
                    // Đảm bảo ô nhập mở khóa bình thường
                    emailInput.readOnly = false;
                    emailInput.style.backgroundColor = "#fff";
                    emailInput.style.borderColor = "#ddd";
                }
                
                // Đảm bảo nút "Gửi mã OTP" sẵn sàng để bấm lại ngay
                let btn = document.getElementById("btnSendOTPAjax");
                if(btn) {
                    btn.innerHTML = 'Gửi mã OTP';
                    btn.style.color = "#0d6efd";
                    btn.style.pointerEvents = "auto";
                }
            }

            // 2. Focus vào ô OTP cho khách nhập lại
            var otpInput = document.getElementById("otpCodeEmailAjax");
            if(otpInput) otpInput.focus();
        }

        // =========================================================
        // --- PHẦN 2: Kiểm tra mở lại Modal Phone ---
        // =========================================================
        var shouldOpenPhone = "${requestScope.openVerifyPhone}";
        if (shouldOpenPhone === "true") { 
            openPhoneModal(); 
            
            // Giữ lại số điện thoại khách vừa nhập sai OTP
            var pendingPhone = "${requestScope.pendingPhone}";
            if(pendingPhone) {
                var phoneInput = document.getElementById("newPhoneInput");
                if(phoneInput) phoneInput.value = pendingPhone;
            }
            
            // Trỏ chuột sẵn vào ô OTP cho khách nhập lại
            var otpPhoneInput = document.getElementById("otpCodePhone");
            if(otpPhoneInput) otpPhoneInput.focus();
        }
        
    };

        // Khai báo biến toàn cục để lưu bộ đếm (tránh bị lỗi đếm chồng chéo)
    let phoneTimerInterval; 

    function sendOtpForPhone() {
        let emailVal = document.getElementById("verifyEmailForPhone").value;
        let btn = document.getElementById("btnSendOtpPhone");
        
        btn.innerText = "Đang gửi...";
        btn.style.pointerEvents = "none";
        btn.style.color = "#888"; // Làm mờ nút đi lúc đang gửi

        // Gọi API gửi mail
        fetch('${pageContext.request.contextPath}/forgot-password-api', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=send&email=' + encodeURIComponent(emailVal)
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                // Hiện dòng báo "Đã gửi mail"
                document.getElementById("phoneEmailSuccessMsg").style.display = "block";
                
                // Mở khóa ô OTP cho khách nhập
                document.getElementById("otpCodePhone").focus();
                
                // KÍCH HOẠT BỘ ĐẾM NGƯỢC 5 PHÚT (300 giây)
                startPhoneCountdown(60);
            } else {
                alert("Lỗi: " + data.message);
                btn.innerText = "Gửi mã OTP";
                btn.style.pointerEvents = "auto";
                btn.style.color = "#0d6efd";
            }
        })
        .catch(err => {
            alert("Lỗi kết nối đến máy chủ!");
            btn.innerText = "Gửi mã OTP";
            btn.style.pointerEvents = "auto";
            btn.style.color = "#0d6efd";
        });
    }

    // --- HÀM XỬ LÝ ĐẾM NGƯỢC THỜI GIAN ---
    function startPhoneCountdown(duration) {
        let btn = document.getElementById("btnSendOtpPhone");
        let countdownWrapper = document.getElementById("otpCountdownWrapper");
        let countdownSpan = document.getElementById("phoneCountdown");
        
        // Hiện dòng chữ "Mã có hiệu lực trong..."
        countdownWrapper.style.display = "block";
        
        // Reset timer nếu khách bấm "Gửi lại"
        clearInterval(phoneTimerInterval); 
        
        let timer = duration, minutes, seconds;
        
        phoneTimerInterval = setInterval(function () {
            minutes = parseInt(timer / 60, 10);
            seconds = parseInt(timer % 60, 10);

            // Thêm số 0 đằng trước nếu nhỏ hơn 10 (VD: 04:09)
            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;

            // Cập nhật số giây lên màn hình
            countdownSpan.textContent = minutes + ":" + seconds;
            btn.innerText = "Gửi lại sau (" + minutes + ":" + seconds + ")";

            // Khi đếm lùi về 0
            if (--timer < 0) {
                clearInterval(phoneTimerInterval);
                
                // Trả lại nút "Gửi lại mã" và cho phép bấm
                btn.innerText = "Gửi lại mã OTP";
                btn.style.pointerEvents = "auto";
                btn.style.color = "#0d6efd"; // Sáng xanh lại
                
                countdownSpan.textContent = "Đã hết hạn!";
            }
        }, 1000);
    }

    // --- XỬ LÝ AJAX CHO MODAL ĐỔI EMAIL ---
    let emailTimerInterval;

    function sendOtpForEmail() {
        let emailInput = document.getElementById("newEmailInputAjax");
        let emailVal = emailInput.value.trim();
        let btn = document.getElementById("btnSendOTPAjax");
        let errorMsg = document.getElementById("emailErrorAjax");
        let successMsg = document.getElementById("emailSuccessAjax");
        
        if (emailVal === "") {
            errorMsg.querySelector("span").innerText = "Vui lòng nhập email!";
            errorMsg.style.display = "block";
            successMsg.style.display = "none";
            return;
        }

        btn.innerText = "Đang gửi...";
        btn.style.pointerEvents = "none";
        btn.style.color = "#888";
        
        // Ẩn các thông báo cũ
        errorMsg.style.display = "none";
        successMsg.style.display = "none";

        // Bắn AJAX xuống ChangeEmailServlet
        fetch('${pageContext.request.contextPath}/change-email', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'new_email=' + encodeURIComponent(emailVal)
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                // 1. Hiện báo xanh, khóa ô nhập email lại
                successMsg.style.display = "block";
                emailInput.readOnly = true;
                emailInput.style.backgroundColor = "#f8fff9";
                emailInput.style.borderColor = "#28a745";
                
                // 2. Chuyển trỏ chuột sang ô OTP
                document.getElementById("otpCodeEmailAjax").focus();
                
                // 3. Chạy đếm ngược 1 phút (60 giây)
                startEmailCountdownAjax(60);
            } else {
                // Lỗi (Trùng email, sai format...)
                errorMsg.querySelector("span").innerText = data.message;
                errorMsg.style.display = "block";
                
                btn.innerHTML = "Gửi mã OTP";
                btn.style.pointerEvents = "auto";
                btn.style.color = "#0d6efd";
            }
        })
        .catch(err => {
            errorMsg.querySelector("span").innerText = "Lỗi kết nối máy chủ!";
            errorMsg.style.display = "block";
            btn.innerHTML = "Gửi mã OTP";
            btn.style.pointerEvents = "auto";
            btn.style.color = "#0d6efd";
        });
    }

    function startEmailCountdownAjax(duration) {
        let btn = document.getElementById("btnSendOTPAjax");
        let countdownWrapper = document.getElementById("emailCountdownWrapper");
        let countdownSpan = document.getElementById("emailCountdown");
        let emailInput = document.getElementById("newEmailInputAjax");
        
        countdownWrapper.style.display = "block";
        clearInterval(emailTimerInterval); 
        
        let timer = duration, minutes, seconds;
        
        emailTimerInterval = setInterval(function () {
            minutes = parseInt(timer / 60, 10);
            seconds = parseInt(timer % 60, 10);
            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;

            countdownSpan.textContent = minutes + ":" + seconds;
            btn.innerText = "Gửi lại sau (" + minutes + ":" + seconds + ")";

            if (--timer < 0) {
                clearInterval(emailTimerInterval);
                btn.innerText = "Gửi lại mã OTP";
                btn.style.pointerEvents = "auto";
                btn.style.color = "#0d6efd";
                
                countdownSpan.textContent = "Đã hết hạn!";
                
                // Cho phép sửa lại email nếu muốn
                emailInput.readOnly = false;
                emailInput.style.backgroundColor = "#fff";
                emailInput.style.borderColor = "#ddd";
            }
        }, 1000);
    }
    function startEmailCountdownAjax(duration) {
        let btn = document.getElementById("btnSendOTPAjax");
        let countdownWrapper = document.getElementById("emailCountdownWrapper");
        let countdownSpan = document.getElementById("emailCountdown");
        let emailInput = document.getElementById("newEmailInputAjax");
        
        // Hiện dòng chữ "Mã có hiệu lực trong..."
        countdownWrapper.style.display = "block";
        countdownSpan.style.color = "#C92127"; // Trả lại màu đỏ phòng khi trước đó báo hết hạn
        
        clearInterval(emailTimerInterval); 
        let timer = duration, minutes, seconds;
        
        emailTimerInterval = setInterval(function () {
            minutes = parseInt(timer / 60, 10);
            seconds = parseInt(timer % 60, 10);
            
            // Thêm số 0 đằng trước (VD: 00:09)
            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;

            // Cập nhật số giây
            countdownSpan.textContent = minutes + ":" + seconds;
            
            // Đổi chữ ở nút thành "Gửi lại sau (xx:xx)"
            btn.innerHTML = "Gửi lại sau (" + minutes + ":" + seconds + ")";

            // Khi hết thời gian
            if (--timer < 0) {
                clearInterval(emailTimerInterval);
                
                // Mở khóa nút cho gửi lại
                btn.innerHTML = "Gửi lại mã OTP";
                btn.style.pointerEvents = "auto";
                btn.style.color = "#0d6efd";
                
                // Báo hết hạn
                countdownSpan.textContent = "Đã hết hạn!";
                countdownSpan.style.color = "#dc3545";
                
                // Cho phép sửa lại email nếu muốn đổi ý
                emailInput.readOnly = false;
                emailInput.style.backgroundColor = "#fff";
                emailInput.style.borderColor = "#ddd";
            }
        }, 1000);
    }
    </script>

</body>
</html>