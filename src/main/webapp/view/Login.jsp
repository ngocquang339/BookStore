<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - MINDBOOK</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
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

        /* Các nhóm input */
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            color: #333;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            background-color: #eef2f9; 
            border: 1px solid #dcdfe6;
            border-radius: 4px;
            font-size: 14px;
            color: #333;
            box-sizing: border-box;
            outline: none;
        }

        .form-group input:focus {
            border-color: #b3c0d1;
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
    </style>
</head>
<body>
    <jsp:include page="component/header.jsp" />
    
    <div class="login-page-container">
        <div class="login-wrapper">
            <div class="tabs">
                <a href="${pageContext.request.contextPath}/login" class="tab active">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="tab">Đăng ký</a>
            </div>

            <c:if test="${not empty mess}">
                <div class="error-message">
                    <i class="fa-solid fa-circle-exclamation"></i> ${mess}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                
                <div class="form-group">
                    <label for="username">Tên đăng nhập</label>
                    <input type="text" id="username" name="username" value="${param.username}" placeholder="Nhập số điện thoại/Email" maxlength="50" required>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" maxlength="50" required>
                    <span class="toggle-password" onclick="togglePassword()">Hiện</span>
                </div>

                <div class="forgot-password">
                    <a href="javascript:void(0);" onclick="openPhoneModal(); return false;">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn-submit">Đăng nhập</button>

            </form>
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
        function togglePassword() {
            var passwordInput = document.getElementById("password");
            var toggleText = document.querySelector(".toggle-password");
            
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                toggleText.textContent = "Ẩn"; 
            } else {
                passwordInput.type = "password";
                toggleText.textContent = "Hiện"; 
            }
        }

        // Hàm mở Modal và Reset lại trắng tinh như mới
    function openPhoneModal() {
        resetModalState();
        document.getElementById("forgotPasswordModal").style.display = "flex";
    }

    // Hàm đóng Modal
    function closePhoneModal() {
        document.getElementById("forgotPasswordModal").style.display = "none";
    }

    // ----------------------------------------------------
    // BƯỚC 1: XỬ LÝ GỬI EMAIL
    // ----------------------------------------------------
    function sendOTP() {
        let emailInput = document.getElementById("resetEmail");
        let emailValue = emailInput.value.trim();
        
        // Validate sơ bộ
        if (emailValue === "") {
            alert("Vui lòng nhập Email trước khi lấy mã!");
            return;
        }
        
        // === GIẢ LẬP GỌI API GỬI EMAIL THÀNH CÔNG ===
        // 1. Đổi UI ô Email sang trạng thái thành công
        document.getElementById("btnSendOtp").style.display = "none"; // Ẩn chữ Gửi OTP
        document.getElementById("emailSuccessIcon").style.display = "block"; // Hiện tích xanh
        document.getElementById("emailSuccessText").style.display = "block"; // Hiện text dưới
        emailInput.classList.add("input-success");
        emailInput.readOnly = true; // Khóa không cho sửa Email nữa

        // 2. MỞ KHÓA Ô OTP cho phép nhập
        let otpInput = document.getElementById("otpCode");
        otpInput.disabled = false;
        otpInput.focus(); // Nhảy con trỏ chuột xuống ô OTP luôn
    }

    // ----------------------------------------------------
    // BƯỚC 2: XỬ LÝ NHẬP VÀ KIỂM TRA OTP
    // ----------------------------------------------------
    function checkOTP(value) {
        // Chỉ kiểm tra khi user nhập đủ 6 số
        if (value.length === 6) {
            
            // === GIẢ LẬP OTP ĐÚNG LÀ "123456" ===
            // (Sau này bạn thay bằng AJAX gọi về Java Servlet để check nhé)
            if (value === "123456") { 
                
                let otpInput = document.getElementById("otpCode");
                
                // 1. Đổi UI ô OTP sang trạng thái thành công
                document.getElementById("otpSuccessIcon").style.display = "block";
                document.getElementById("otpSuccessText").style.display = "block";
                otpInput.classList.add("input-success");
                otpInput.readOnly = true; // Khóa ô OTP lại

                // 2. MỞ KHÓA Ô MẬT KHẨU MỚI & NÚT XÁC NHẬN
                let pwdInput = document.getElementById("newPassword");
                pwdInput.disabled = false;
                pwdInput.focus();
                
                document.getElementById("btnSubmitReset").disabled = false;

            } else {
                alert("Mã OTP không chính xác. (Mẹo: Nhập thử 123456)");
            }
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
    </script>

</body>
</html>