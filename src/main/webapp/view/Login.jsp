<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - MINDBOOK</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Khởi tạo font chữ và nền cơ bản */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5; /* Thêm nền xám nhạt để nổi bật form */
            margin: 0;
        }

       /* 2. KHUNG BAO NGOÀI ĐỂ CĂN GIỮA CHUẨN */
        .login-page-container {
            display: flex;
            justify-content: center;
            align-items: flex-start; /* Sửa ở đây: Kéo form bám lên phía trên thay vì lơ lửng ở giữa */
            min-height: 60vh;
            padding: 20px 15px 50px 15px; /* Sửa ở đây: Giảm khoảng cách bên trên xuống còn 20px */
        }

       /* Khung chứa form đăng nhập */
        .login-wrapper {
            width: 100%;
            max-width: 1200px;
            
            /* SỬA CHỖ NÀY: Tăng padding-bottom lên 100px để kéo dài phần dưới */
            padding: 30px 30px 50px 30px; /* Cú pháp: Top Right Bottom Left */
            
            /* THÊM CHỖ NÀY: Ép khối trắng luôn cao ít nhất 500px */
            min-height: 400px; 
            
            background-color: #ffffff;
            border-radius: 8px; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.08); 
        }

        /* Phần Tabs Đăng nhập / Đăng ký */
        .tabs {
            display: flex;
            justify-content: center;
            gap: 60px;
            margin-bottom: 30px;
        }

        .tab {
            font-size: 16px;
            color: #777;
            text-decoration: none;
            padding-bottom: 10px;
            cursor: pointer;
        }

        .tab.active {
            color: #d0011b; 
            border-bottom: 2px solid #d0011b;
        }

        /* 3. CSS CHO THÔNG BÁO LỖI */
        .error-message {
            background-color: #fdecee; /* Nền đỏ nhạt */
            color: #d0011b; /* Chữ đỏ đậm */
            border: 1px solid #f5c6cb;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
            font-size: 14px;
            text-align: center;
        }

        /* ========================================= */
        /* CSS CHO Ô NHẬP LIỆU (ĐẸP & HIỆN ĐẠI HƠN)  */
        /* ========================================= */
        
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 600; /* In đậm label một chút cho rõ ràng */
            color: #444;
        }

        /* 1. Style chung cho mọi ô input (Đăng nhập & Đăng ký) */
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            background-color: #fff; /* Đổi sang nền trắng tinh khôi */
            border: 1.5px solid #e0e0e0; /* Viền xám nhạt tinh tế, dày hơn chút xíu */
            border-radius: 8px; /* Bo góc mềm mại */
            font-size: 14.5px;
            color: #333;
            box-sizing: border-box;
            outline: none;
            transition: all 0.3s ease; /* Hiệu ứng chuyển màu mượt mà */
        }

        /* Hiệu ứng khi lướt chuột qua */
        .form-group input:hover {
            border-color: #ccc;
        }

        /* 2. Hiệu ứng khi click vào để gõ (Focus) */
        .form-group input:focus {
            border-color: #C92127; /* Đổi viền sang màu đỏ thương hiệu */
            box-shadow: 0 0 0 4px rgba(201, 33, 39, 0.1); /* Phủ một lớp sương mờ màu đỏ xung quanh */
        }

        /* Bóp chiều rộng form cho cân đối */
        .login-wrapper form {
            max-width: 400px; 
            margin: 0 auto;  
        }

        /* ========================================= */
        /* 3. DÀNH RIÊNG CHO CÁC Ô CÓ ICON BÊN TRONG */
        /* ========================================= */
        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-wrapper input {
            padding-left: 42px; /* Đẩy chữ sang phải nhường chỗ cho Icon */
        }

        .input-wrapper i {
            position: absolute;
            left: 15px;
            color: #a0a0a0; /* Màu icon tĩnh */
            font-size: 16px;
            transition: color 0.3s ease;
            pointer-events: none; /* Tránh tình trạng bấm trúng icon không gõ được chữ */
        }

        /* MA THUẬT: Đổi màu Icon sang đỏ khi click vào ô input chứa nó */
        .input-wrapper:focus-within i {
            color: #C92127;
        }

        /* Bóp nhỏ form nhập liệu và căn giữa bên trong khối trắng */
        .login-wrapper form {
            max-width: 400px; /* Chiều rộng giống hệt như cũ để input nhìn gọn gàng */
            margin: 0 auto;   /* Đẩy form ra chính giữa khối trắng */
        }

        .toggle-password {
            position: absolute;
            right: 15px;
            top: 38px; 
            color: #1a73e8; 
            font-size: 14px;
            cursor: pointer;
            user-select: none;
        }

        .forgot-password {
            text-align: right;
            margin-bottom: 30px;
        }

        .forgot-password a {
            color: #d0011b; 
            text-decoration: none;
            font-size: 13px;
        }
/* Nút Submit */
        .btn-submit {
            display: block; /* Bắt buộc để căn giữa nút */
            width: 55%; /* Giảm chiều dài nút xuống, ngắn hơn ô input */
            margin: 0 auto; /* Đẩy nút ra chính giữa */
            padding: 10px; /* Giảm từ 12px xuống 10px để nút bớt cao lại */
            background-color: #C92127; 
            color: #ffffff; 
            border: none;
            border-radius: 8px; /* Tăng bo góc cho tròn trịa giống Fahasa */
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        /* Hiệu ứng khi hover vào nút */
        .btn-submit:hover {
            background-color: #a01a1f; /* Đỏ sậm hơn một chút khi di chuột vào */
        }

        /* Nền đen mờ phủ ngoài */
.custom-modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.4); /* Làm tối nền */
    display: none; /* Mặc định ẩn */
    align-items: center;
    justify-content: center;
    z-index: 9999;
}

/* Hộp Modal */
.custom-modal-box {
    background-color: #fff;
    width: 450px;
    max-width: 90%;
    border-radius: 12px;
    padding: 30px 40px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.15);
}

/* Tiêu đề */
.modal-title {
    text-align: center;
    font-size: 20px;
    font-weight: bold;
    color: #333;
    margin-top: 0;
    margin-bottom: 30px;
}

/* Nhóm form */
.modal-form-group {
    margin-bottom: 20px;
}

.modal-form-group label {
    display: block;
    font-size: 14px;
    font-weight: 600;
    color: #333;
    margin-bottom: 8px;
}

/* Input có nút Gửi mã OTP bên trong */
.input-with-action {
    position: relative;
    display: flex;
    align-items: center;
}

.input-with-action input, 
.full-width-input {
    width: 100%;
    padding: 12px 15px;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 14px;
    outline: none;
    transition: 0.3s;
    box-sizing: border-box;
}

.input-with-action input:focus, 
.full-width-input:focus {
    border-color: #C92127; /* Đổi màu viền khi click vào */
}

/* Chữ Gửi mã OTP màu xanh */
.btn-send-otp {
    position: absolute;
    right: 15px;
    font-size: 14px;
    font-weight: bold;
    color: #0056b3;
    text-decoration: none;
    cursor: pointer;
}
.btn-send-otp:hover {
    color: #003d82;
}

/* Nút bấm */
.modal-actions {
    display: flex;
    flex-direction: column;
    gap: 12px;
    margin-top: 30px;
}

.btn-confirm-modal {
    width: 100%;
    padding: 12px;
    background-color: #e6e6e6;
    color: #333;
    font-weight: bold;
    font-size: 15px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    transition: 0.3s;
}
.btn-confirm-modal:hover {
    background-color: #d4d4d4;
}

.btn-back-modal {
    width: 100%;
    padding: 12px;
    background-color: white;
    color: #d32f2f;
    font-weight: bold;
    font-size: 15px;
    border: 1px solid #d32f2f;
    border-radius: 6px;
    cursor: pointer;
    transition: 0.3s;
}
.btn-back-modal:hover {
    background-color: #fcebeb;
}
/* Trạng thái khóa (Disabled) của input và button */
.input-with-action input:disabled {
    background-color: #f7f7f7;
    cursor: not-allowed;
    border-color: #e0e0e0;
}
.btn-confirm-modal:disabled {
    background-color: #f0f0f0;
    color: #a0a0a0;
    cursor: not-allowed;
}

/* Các thành phần báo thành công (Tích xanh) */
.success-icon {
    position: absolute;
    right: 15px;
    font-size: 18px;
    color: #00b14f; /* Màu xanh lá chuẩn */
    display: none; /* Mặc định ẩn */
}
.success-text {
    display: none; /* Mặc định ẩn */
    font-size: 13px;
    color: #00b14f;
    margin-top: 5px;
}
/* Đổi viền input sang xanh lá và nền xanh nhạt khi thành công */
.input-success {
    border-color: #00b14f !important;
    background-color: #f2fcf5 !important;
}

/* Nút dạng Text bên trong Input (Gửi OTP, Hiện/Ẩn pass) */
.btn-inside-input {
    position: absolute;
    right: 15px;
    font-size: 14px;
    font-weight: bold;
    color: #0056b3;
    text-decoration: none;
    cursor: pointer;
}
.btn-inside-input:hover {
    color: #003d82;
}

/* Fix CSS phần action input */
.input-with-action {
    position: relative;
    display: flex;
    align-items: center;
}
.input-with-action input {
    width: 100%;
    padding: 12px 15px;
    padding-right: 90px; /* Chừa chỗ cho nút text bên phải */
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 14px;
    outline: none;
    transition: 0.3s;
    box-sizing: border-box;
}
.input-with-action input:focus:not(:disabled):not(.input-success) {
    border-color: #C92127;
}

/* ========================================= */
        /* CSS MỚI THÊM CHO HIỆU ỨNG TAB ĐĂNG KÝ     */
        /* ========================================= */
        
        /* Hiệu ứng mờ dần khi chuyển đổi form */
        .form-content { 
            display: none; 
            animation: fadeIn 0.4s ease-in-out; 
        }
        .form-content.active { 
            display: block; 
        }
        @keyframes fadeIn { 
            from { opacity: 0; transform: translateY(10px); } 
            to { opacity: 1; transform: translateY(0); } 
        }

        /* Khóa các ô input ở Bước 2 (Nhập OTP) */
        .input-locked {
            background-color: #f5f5f5 !important;
            color: #888;
            pointer-events: none;
        }

        /* Tinh chỉnh chiều rộng form đăng ký cho vừa box */
        #form-register form {
            max-width: 400px;
            margin: 0 auto;
        }
        #form-register .input-wrapper {
            position: relative; 
            margin-bottom: 15px;
        }
        #form-register .input-wrapper input {
            width: 100%; 
            padding: 10px 10px 10px 35px; /* Chừa chỗ cho icon bên trái */
            border: 1px solid #dcdfe6; 
            border-radius: 4px; 
            box-sizing: border-box;
            background-color: #eef2f9;
            outline: none;
            font-size: 14px;
        }
        #form-register .input-wrapper input:focus {
            border-color: #b3c0d1;
        }
        #form-register .input-wrapper i {
            position: absolute; 
            left: 12px; 
            top: 50%; 
            transform: translateY(-50%); 
            color: #888;
        }
    </style>
</head>
<body>
    <jsp:include page="component/header.jsp"/>
    
    <div class="login-page-container">
        <div class="login-wrapper">
            
            <c:set var="isRegisterMode" value="${not empty requestScope.showOtpStep or requestScope.activeTab == 'register'}" />

            <div class="tabs">
                <a href="javascript:void(0);" id="tab-login" class="tab ${not isRegisterMode ? 'active' : ''}" onclick="switchTab('login')">Đăng nhập</a>
                <a href="javascript:void(0);" id="tab-register" class="tab ${isRegisterMode ? 'active' : ''}" onclick="switchTab('register')">Đăng ký</a>
            </div>

            <c:if test="${not empty mess}">
                <div class="error-message">
                    <i class="fa-solid fa-circle-exclamation"></i> ${mess}
                </div>
            </c:if>

            <div id="form-login" class="form-content ${not isRegisterMode ? 'active' : ''}">
                <form id="loginForm" action="${pageContext.request.contextPath}/login" method="post" onsubmit="return validateLogin(event)">
                    
                    <div class="form-group">
                        <label for="username">Tên đăng nhập</label>
                        <input type="text" id="username" name="username" value="${not empty savedUser ? savedUser : param.username}" placeholder="Nhập tên đăng nhập" maxlength="50" required>
                        <span id="err-username" style="display:none; color: #dc3545; font-size: 13px; margin-top: 5px;"><i class="fa-solid fa-circle-exclamation"></i> Vui lòng nhập thông tin này</span>
                    </div>

                    <div class="form-group">
                        <label for="password">Mật khẩu</label>
                        <div style="position: relative;">
                            <input type="password" id="password" name="password" value="" placeholder="Nhập mật khẩu" maxlength="50" style="width: 100%;" required>
                            <span class="toggle-password" onclick="toggleLoginPassword()" style="position: absolute; right: 10px; top: 12px; cursor: pointer; color: #007bff; font-weight: bold; font-size: 13px;">Hiện</span>
                        </div>
                        <span id="err-password" style="display:none; color: #dc3545; font-size: 13px; margin-top: 5px;"><i class="fa-solid fa-circle-exclamation"></i> Vui lòng nhập thông tin này</span>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <div class="remember-me" style="display: flex; align-items: center; gap: 5px;">
                            <input type="checkbox" id="remember" name="remember" value="true" ${not empty savedUser ? 'checked' : ''} style="width: 16px; height: 16px; cursor: pointer;">
                            <label for="remember" style="font-size: 14px; margin: 0; cursor: pointer;">Ghi nhớ đăng nhập</label>
                        </div>
                        <div class="forgot-password" style="margin: 0;">
                            <a href="javascript:void(0);" onclick="openPhoneModal(); return false;" style="font-size: 14px; color: #C92127;">Quên mật khẩu?</a>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit">Đăng nhập</button>
                </form>
            </div>

            <div id="form-register" class="form-content ${isRegisterMode ? 'active' : ''}">
                <form id="registerForm" action="${pageContext.request.contextPath}/${not empty requestScope.showOtpStep ? 'verify-otp' : 'register'}" method="post" onsubmit="return validateRegister(event)">
                    
                    <c:set var="valName" value="${not empty sessionScope.tempUser ? sessionScope.tempUser.fullname : fullname}" />
                    <c:set var="valPhone" value="${not empty sessionScope.tempUser ? sessionScope.tempUser.phone_number : phone_number}" />
                    <c:set var="valUser" value="${not empty sessionScope.tempUser ? sessionScope.tempUser.username : username}" />
                    <c:set var="valEmail" value="${not empty sessionScope.tempUser ? sessionScope.tempUser.email : email}" />
                    <c:set var="lockClass" value="${not empty requestScope.showOtpStep ? 'input-locked' : ''}" />
                    <c:set var="isReadonly" value="${not empty requestScope.showOtpStep ? 'readonly' : ''}" />

                    <div class="form-group">
                        <label>Họ và tên</label>
                        <div class="input-wrapper">
                            <input type="text" name="fullname" value="${valName}" class="${lockClass}" ${isReadonly} 
                                placeholder="Ví dụ: Nguyễn Văn An" required autocomplete="off" maxlength="50"
                                pattern="^[A-Za-zÀ-ỹ\s]+$"
                                title="Chỉ được nhập chữ cái và khoảng trắng">
                            <i class="fa-regular fa-id-card"></i>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <div class="input-wrapper">
                            <input type="text" id="phoneInput" name="phone_number" value="${valPhone}" class="${lockClass}" ${isReadonly} 
                                placeholder="Ví dụ: 0912345678" required autocomplete="off" maxlength="10"
                                pattern="^0\d{9}$"
                                title="Số điện thoại phải bắt đầu bằng 0 và gồm 10 chữ số"
                                oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                            <i class="fa-solid fa-phone"></i>
                        </div>
                        <span id="phoneError" style="display:none; color: #dc3545; font-size: 13px; margin-top: 5px;">
                            <i class="fa-solid fa-circle-exclamation"></i> Số điện thoại bắt buộc phải bắt đầu bằng số 0.
                        </span>
                    </div>

                    <div class="form-group">
                        <label>Tên đăng nhập</label>
                        <div class="input-wrapper">
                            <input type="text" name="username" value="${valUser}" class="${lockClass}" ${isReadonly} 
                                placeholder="Ví dụ: nguyenvanan" required autocomplete="off" maxlength="50"
                                pattern="^\S+$" 
                                title="Tên đăng nhập không được chứa khoảng trắng">
                            <i class="fa-regular fa-user"></i>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Địa chỉ Email</label>
                        <div class="input-wrapper">
                            <input type="email" name="email" value="${valEmail}" class="${lockClass}" ${isReadonly} placeholder="example@gmail.com" required autocomplete="off" maxlength="100">
                            <i class="fa-regular fa-envelope"></i>
                        </div>
                    </div>

                    <c:if test="${empty requestScope.showOtpStep}">
                        <div class="form-group">
                            <label>Mật khẩu</label>
                            <div class="input-wrapper">
                                <input type="password" name="password" placeholder="Nhập mật khẩu..." required autocomplete="off" maxlength="30" minlength="6">
                                <i class="fa-solid fa-lock"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Nhập lại mật khẩu</label>
                            <div class="input-wrapper">
                                <input type="password" name="re_pass" placeholder="Xác nhận lại mật khẩu..." required autocomplete="off" maxlength="30" minlength="6">
                                <i class="fa-solid fa-shield-halved"></i>
                            </div>
                        </div>

                        <div class="form-group" style="margin-top: 15px;">
                            <div style="display: flex; align-items: flex-start; gap: 8px;">
                                <input type="checkbox" id="reg_terms" name="terms" required style="margin-top: 4px; cursor: pointer;">
                                <label for="reg_terms" style="font-size: 13px; color: #555; line-height: 1.4; cursor: pointer;">
                                    Tôi đồng ý với các <a href="#" style="color: #C92127;">Điều khoản dịch vụ</a> và <a href="#" style="color: #C92127;">Chính sách bảo mật</a>.
                                </label>
                            </div>
                            <span id="err-reg-terms" style="display:none; color: #dc3545; font-size: 13px; margin-top: 5px;"><i class="fa-solid fa-circle-exclamation"></i> Vui lòng chấp nhận điều khoản.</span>
                        </div>
                    </c:if>

                    <c:if test="${not empty requestScope.showOtpStep}">
                        <div class="form-group" style="padding: 15px; background: #fff5f5; border: 1px dashed #C92127; border-radius: 8px; margin-top: 20px;">
                            <label style="color: #C92127; font-weight: bold;">Mã xác nhận OTP</label>
                            <p style="font-size: 13px; color: #555; margin-top: 0; margin-bottom: 10px;">Chúng tôi vừa gửi mã 6 số vào email <strong>${valEmail}</strong></p>
                            
                            <div class="input-wrapper">
                                <input type="text" name="Userotp" placeholder="------" required maxlength="6" autofocus
                                        pattern="\d{6}" title="Mã OTP phải là 6 chữ số"
                                        oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                                       style="border: 2px solid ${not empty requestScope.otpError ? '#dc3545' : '#ddd'}; text-align: center; letter-spacing: 10px; font-weight: bold; font-size: 18px; padding-left: 10px;">
                            </div>
                            
                            <c:if test="${not empty requestScope.otpError}">
                                <small style="color: #dc3545; font-size: 13px; font-weight: bold; margin-top: 8px; display: block; text-align: center;">
                                    <i class="fa-solid fa-triangle-exclamation"></i> ${requestScope.otpError}
                                </small>
                            </c:if>
                        </div>
                    </c:if>

                    <button type="submit" class="btn-submit" style="width: 70%; margin-top: 10px;">
                        ${not empty requestScope.showOtpStep ? 'Xác Nhận & Hoàn Tất' : 'Đăng Ký & Nhận Mã OTP'}
                    </button>
                </form>
            </div>
        </div>
    </div>

    <div id="forgotPasswordModal" class="custom-modal-overlay">
        <div class="custom-modal-box">
            <h2 class="modal-title">KHÔI PHỤC MẬT KHẨU</h2>
            
            <form id="forgotPasswordForm" action="change-password" method="POST">
                <input type="hidden" name="flag" value="1">
                <div class="modal-form-group">
                    <label>Email</label>
                    <div class="input-with-action">
                        <input type="email" id="resetEmail" name="email" placeholder="Nhập email của bạn..." required>
                        <a href="javascript:void(0);" id="btnSendOtp" class="btn-inside-input" onclick="sendOTP()">Gửi mã OTP</a>
                        <i class="fa-solid fa-circle-check success-icon" id="emailSuccessIcon"></i>
                    </div>
                    <span class="success-text" id="emailSuccessText">OTP đã được gửi qua Email</span>
                </div>

                <div class="modal-form-group">
                    <label>Mã xác nhận OTP</label>
                    <div class="input-with-action">
                        <input type="text" id="otpCode" name="otp" placeholder="6 ký tự" required disabled maxlength="6" oninput="checkOTP(this.value)">
                        <i class="fa-solid fa-circle-check success-icon" id="otpSuccessIcon"></i>
                    </div>
                    <span class="success-text" id="otpSuccessText">OTP hợp lệ</span>
                </div>

                <div class="modal-form-group">
                    <label>Mật khẩu mới</label>
                    <div class="input-with-action">
                        <input type="password" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới..." required disabled>
                        <a href="javascript:void(0);" id="btnTogglePwd" class="btn-inside-input" style="color: #2b78e4;" onclick="togglePassword()">Hiện</a>
                    </div>
                </div>

                <div class="modal-actions">
                    <button type="submit" id="btnSubmitReset" class="btn-confirm-modal" disabled>Xác nhận</button>
                    <button type="button" class="btn-back-modal" onclick="closePhoneModal()">Trở về</button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="component/suggested-books.jsp" />
    <jsp:include page="component/footer.jsp" />

    <script>
        // Hàm mở Modal và Reset lại trắng tinh như mới
    function openPhoneModal(){
        resetModalState();
        document.getElementById("forgotPasswordModal").style.display = "flex";
    }

    // Hàm đóng Modal
    function closePhoneModal() {
        document.getElementById("forgotPasswordModal").style.display = "none";
    }

    // ----------------------------------------------------
    // BƯỚC 1: XỬ LÝ GỬI EMAIL (BẰNG AJAX THẬT)
    // ----------------------------------------------------
    function sendOTP() {
        let emailInput = document.getElementById("resetEmail");
        let emailValue = emailInput.value.trim();
        
        if (emailValue === "") {
            alert("Vui lòng nhập Email trước khi lấy mã!");
            return;
        }
        
        let btnSend = document.getElementById("btnSendOtp");
        btnSend.innerText = "Đang gửi...";
        btnSend.style.pointerEvents = "none"; // Tránh bấm nhiều lần
        
        // Gửi ngầm (AJAX) email xuống Server để Server gửi thư đi
        fetch('${pageContext.request.contextPath}/forgot-password-api', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=send&email=' + encodeURIComponent(emailValue)
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                // Thành công -> Đổi giao diện
                btnSend.style.display = "none";
                document.getElementById("emailSuccessIcon").style.display = "block";
                document.getElementById("emailSuccessText").style.display = "block";
                emailInput.classList.add("input-success");
                emailInput.readOnly = true;

                // Mở khóa ô nhập OTP
                let otpInput = document.getElementById("otpCode");
                otpInput.disabled = false;
                otpInput.focus();
            } else {
                // Thất bại (VD: Email không tồn tại)
                alert(data.message || "Không thể gửi email, vui lòng thử lại.");
                btnSend.innerText = "Gửi mã OTP";
                btnSend.style.pointerEvents = "auto";
            }
        })
        .catch(err => {
            alert("Lỗi kết nối đến máy chủ.");
            btnSend.innerText = "Gửi mã OTP";
            btnSend.style.pointerEvents = "auto";
        });
    }

    // ----------------------------------------------------
    // BƯỚC 2: XỬ LÝ NHẬP VÀ KIỂM TRA OTP (BẰNG AJAX THẬT)
    // ----------------------------------------------------
    function checkOTP(value) {
        if (value.length === 6) {
            let emailValue = document.getElementById("resetEmail").value.trim();
            
            // Gửi ngầm OTP khách nhập xuống Server để Server so sánh
            fetch('${pageContext.request.contextPath}/forgot-password-api', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=verify&email=' + encodeURIComponent(emailValue) + '&otp=' + value
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    let otpInput = document.getElementById("otpCode");
                    
                    // Thành công -> Đổi UI
                    document.getElementById("otpSuccessIcon").style.display = "block";
                    document.getElementById("otpSuccessText").style.display = "block";
                    otpInput.classList.add("input-success");
                    otpInput.readOnly = true;

                    // Mở khóa ô mật khẩu mới
                    let pwdInput = document.getElementById("newPassword");
                    pwdInput.disabled = false;
                    pwdInput.focus();
                    document.getElementById("btnSubmitReset").disabled = false;
                } else {
                    alert("Mã OTP không chính xác hoặc đã hết hạn!");
                }
            });
        }
    }

    // ----------------------------------------------------
    // HÀM BỔ TRỢ: HIỆN/ẨN MẬT KHẨU
    // ----------------------------------------------------
    function togglePassword() {
        let pwdInput = document.getElementById("newPassword");
        let btnToggle = document.getElementById("btnTogglePwd");
        
        if (pwdInput.disabled) return; // Nếu ô pass đang khóa thì nút này không có tác dụng

        if (pwdInput.type === "password") {
            pwdInput.type = "text";
            btnToggle.innerText = "Ẩn";
        } else {
            pwdInput.type = "password";
            btnToggle.innerText = "Hiện";
        }
    }

    // ----------------------------------------------------
    // HÀM BỔ TRỢ: ĐẶT LẠI TRẠNG THÁI MODAL TỪ ĐẦU
    // ----------------------------------------------------
    function resetModalState() {
        // Reset Email
        let emailInput = document.getElementById("resetEmail");
        emailInput.value = "";
        emailInput.readOnly = false;
        emailInput.classList.remove("input-success");
        document.getElementById("btnSendOtp").style.display = "block";
        document.getElementById("emailSuccessIcon").style.display = "none";
        document.getElementById("emailSuccessText").style.display = "none";

        // Reset OTP
        let otpInput = document.getElementById("otpCode");
        otpInput.value = "";
        otpInput.disabled = true;
        otpInput.readOnly = false;
        otpInput.classList.remove("input-success");
        document.getElementById("otpSuccessIcon").style.display = "none";
        document.getElementById("otpSuccessText").style.display = "none";

        // Reset Pass
        let pwdInput = document.getElementById("newPassword");
        pwdInput.value = "";
        pwdInput.disabled = true;
        pwdInput.type = "password";
        document.getElementById("btnTogglePwd").innerText = "Hiện";

        // Khóa nút submit
        document.getElementById("btnSubmitReset").disabled = true;
    }

    
    function switchTab(tabName) {
        document.getElementById('tab-login').classList.remove('active');
        document.getElementById('tab-register').classList.remove('active');
        document.getElementById('form-login').classList.remove('active');
        document.getElementById('form-register').classList.remove('active');

        // Bật tab được chọn
        document.getElementById('tab-' + tabName).classList.add('active');
        document.getElementById('form-' + tabName).classList.add('active');
        
        // Khóa không cho quay lại Đăng nhập nếu đang gõ OTP dở dang
        let isOtpStep = "${not empty requestScope.showOtpStep}";
        if (isOtpStep === "true" && tabName === 'login') {
             alert("Vui lòng hoàn tất mã OTP hoặc tải lại trang để hủy thao tác!");
             switchTab('register'); 
        }
    }
    
    // (Đổi tên hàm togglePassword cũ của bạn ở form đăng nhập để tránh bị nhầm)
    function toggleLoginPassword() {
        let pwdInput = document.getElementById("password");
        let toggleText = document.querySelector(".toggle-password");
        if (pwdInput.type === "password") {
            pwdInput.type = "text";
            toggleText.innerText = "Ẩn";
        } else {
            pwdInput.type = "password";
            toggleText.innerText = "Hiện";
        }
    }

    function validateLogin(e) {
        let u = document.getElementById("username").value.trim();
        let p = document.getElementById("password").value.trim();
        let isValid = true;

        let errU = document.getElementById("err-username");
        let errP = document.getElementById("err-password");

        // Kiểm tra User
        if (u === "") {
            errU.style.display = "block";
            isValid = false;
        } else {
            errU.style.display = "none";
        }

        // Kiểm tra Pass
        if (p === "") {
            errP.style.display = "block";
            isValid = false;
        } else {
            errP.style.display = "none";
        }

        // Nếu có lỗi thì chặn Form không cho gửi xuống Server
        if (!isValid) {
            e.preventDefault(); 
        }
        return isValid;
    }

    function validateRegister(e) {
        // Chỉ chạy validate nếu đang ở bước điền form (không phải bước OTP)
        console.log("1. Bắt đầu chạy validateRegister...");
        let isOtpStep = "${not empty requestScope.showOtpStep}";
        if (isOtpStep === "true") return true;

        let isValid = true;

        // Chỉ đích danh tìm trong form đăng ký
        let regForm = document.getElementById("registerForm"); 
        try{
            console.log("2. Bắt đầu quét các ô input...");
            let fields = [
                { id: regForm.querySelector('input[name="fullname"]'), errId: 'err-reg-fullname' },
                { id: regForm.querySelector('input[name="phone_number"]'), errId: 'err-reg-phone' },
                { id: regForm.querySelector('input[name="username"]'), errId: 'err-reg-username' },
                { id: regForm.querySelector('input[name="email"]'), errId: 'err-reg-email' },
                { id: regForm.querySelector('input[name="password"]'), errId: 'err-reg-password' },
                { id: regForm.querySelector('input[name="re_pass"]'), errId: 'err-reg-repass' }
            ];

            // Duyệt qua từng ô, nếu rỗng thì chặn lại và hiện thông báo lỗi
            for (let field of fields) {
                if (field.id === null) {
                    console.error("LỖI RỒI: Không tìm thấy ô input nào đó trên form!");
                }
                let inputEle = field.id;
                
                // Tự động tạo thẻ span báo lỗi nếu bạn chưa tự tay viết trong HTML
                let errSpan = inputEle.parentElement.nextElementSibling;
                if (!errSpan || !errSpan.classList.contains('err-msg-dynamic')) {
                    errSpan = document.createElement('span');
                    errSpan.className = 'err-msg-dynamic';
                    errSpan.style = 'display:none; color: #dc3545; font-size: 13px; margin-top: 5px;';
                    errSpan.innerHTML = '<i class="fa-solid fa-circle-exclamation"></i> This field is required';
                    inputEle.parentElement.after(errSpan);
                }

                if (inputEle.value.trim() === "") {
                    errSpan.style.display = "block";
                    isValid = false;
                } else {
                    errSpan.style.display = "none";
                }
            }
            console.log("3. Kết quả Validate: " + isValid);
        }
        catch (error) {
            console.error("CÓ LỖI CRASH JAVASCRIPT: ", error);
            isValid = false;
        }
        // Kiểm tra EX 6 (Terms and Conditions)
        let termsCheck = document.getElementById("reg_terms");
        let errTerms = document.getElementById("err-reg-terms");
        if (termsCheck && !termsCheck.checked) {
            errTerms.style.display = "block";
            isValid = false;
        } else if (errTerms) {
            errTerms.style.display = "none";
        }

        if (!isValid) {
            console.log("4. Bị chặn lại, không gửi xuống Server!");
            e.preventDefault();
        }
        else{
            console.log("4. Hợp lệ! Đang chuẩn bị gửi dữ liệu xuống Java Servlet...");
        }
        return isValid;
    }

    document.addEventListener("DOMContentLoaded", function() {
        const phoneInput = document.getElementById("phoneInput");
        const phoneError = document.getElementById("phoneError");

        if (phoneInput) {
            // Lắng nghe sự kiện mỗi khi người dùng nhập dữ liệu
            phoneInput.addEventListener("input", function(e) {
                let value = e.target.value;
                
                // Nếu ô input có dữ liệu VÀ ký tự đầu tiên không phải là số '0'
                if (value.length > 0 && value.charAt(0) !== '0') {
                    // Hiện câu cảnh báo
                    phoneError.style.display = "block"; 
                    
                    // (Tùy chọn) Xóa luôn số vừa nhập sai đi để ép nhập lại số 0
                    // Nếu bạn muốn dùng tính năng này thì bỏ comment dòng bên dưới
                    // e.target.value = ""; 
                } else {
                    // Nếu đã nhập đúng số 0 ở đầu, hoặc xóa hết ô trống thì ẩn cảnh báo đi
                    phoneError.style.display = "none";
                }

                // Tiện tay chặn luôn người dùng nhập chữ vào ô này (chỉ cho phép số)
                e.target.value = value.replace(/[^0-9]/g, '');
            });
        }
    });
    </script>

</body>
</html>