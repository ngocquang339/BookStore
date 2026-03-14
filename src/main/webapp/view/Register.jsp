<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản - BookStore</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/register.css">
    
    <style>
        /* FIX LỖI BỊ CHE KHUẤT CHỮ TRÊN CÙNG */
        body {
            min-height: 100vh;
            height: auto !important; 
            padding: 40px 15px; /* Thêm padding để tạo khoảng không gian an toàn trên/dưới */
            box-sizing: border-box;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow-y: auto; /* Cho phép cuộn nếu màn hình quá ngắn */
        }
        .register-container {
            margin: auto; /* Giữ form ở giữa nhưng không bị đẩy lố lên trên */
        }
        
        /* CSS cho Form khi bị khóa (Đang ở bước nhập OTP) */
        .input-locked {
            background-color: #f5f5f5 !important;
            color: #888;
            pointer-events: none;
        }
    </style>
</head>
<body>

    <div class="register-container">
        <div class="register-header">
            <h2>Đăng Ký Thành Viên</h2>
            <p>Chào mừng bạn đến với <span class="brand-text">MINDBOOK</span></p>
        </div>

        <%-- Hiện lỗi chung từ RegisterServlet (nếu có) --%>
        <c:if test="${not empty mess}">
            <div class="alert-error">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <span>${mess}</span>
            </div>
        </c:if>

        <%-- ĐỔI ACTION TỰ ĐỘNG: 
             - Nếu chưa có OTP -> action là /register
             - Nếu đang nhập OTP -> action là /verify-otp --%>
        <form action="${pageContext.request.contextPath}/${not empty requestScope.showOtpStep ? 'verify-otp' : 'register'}" method="post">
            
            <%-- GIỮ LẠI DỮ LIỆU CŨ TỪ TEMPUSER (Nếu đang ở bước 2) --%>
            <c:set var="valName" value="${not empty sessionScope.tempUser ? sessionScope.tempUser.fullname : fullname}" />
            <c:set var="valPhone" value="${not empty sessionScope.tempUser ? sessionScope.tempUser.phone_number : phone_number}" />
            <c:set var="valUser" value="${not empty sessionScope.tempUser ? sessionScope.tempUser.username : username}" />
            <c:set var="valEmail" value="${not empty sessionScope.tempUser ? sessionScope.tempUser.email : email}" />
            <c:set var="lockClass" value="${not empty requestScope.showOtpStep ? 'input-locked' : ''}" />
            <c:set var="isReadonly" value="${not empty requestScope.showOtpStep ? 'readonly' : ''}" />

            <div class="input-group">
                <label>Họ và tên</label>
                <div class="input-wrapper">
                    <input type="text" name="fullname" value="${valName}" class="${lockClass}" ${isReadonly} placeholder="Ví dụ: Nguyễn Văn An" required autocomplete="off" maxlength="50">
                    <i class="fa-regular fa-id-card"></i>
                </div>
            </div>

            <div class="input-group">
                <label>Số điện thoại</label>
                <div class="input-wrapper">
                    <input type="tel" name="phone_number" value="${valPhone}" class="${lockClass}" ${isReadonly} placeholder="Ví dụ: 0912345678" required autocomplete="off" maxlength="10">
                    <i class="fa-solid fa-phone"></i>
                </div>
            </div>

            <div class="input-group">
                <label>Tên đăng nhập</label>
                <div class="input-wrapper">
                    <input type="text" name="username" value="${valUser}" class="${lockClass}" ${isReadonly} placeholder="Ví dụ: nguyenvanan" required autocomplete="off" maxlength="50">
                    <i class="fa-regular fa-user"></i>
                </div>
            </div>

            <div class="input-group">
                <label>Địa chỉ Email</label>
                <div class="input-wrapper">
                    <input type="email" name="email" value="${valEmail}" class="${lockClass}" ${isReadonly} placeholder="example@gmail.com" required autocomplete="off" maxlength="100">
                    <i class="fa-regular fa-envelope"></i>
                </div>
            </div>

            <%-- CHỈ HIỆN Ô MẬT KHẨU Ở BƯỚC 1 --%>
            <c:if test="${empty requestScope.showOtpStep}">
                <div class="input-group">
                    <label>Mật khẩu</label>
                    <div class="input-wrapper">
                        <input type="password" name="password" placeholder="Nhập mật khẩu..." required autocomplete="off" maxlength="100">
                        <i class="fa-solid fa-lock"></i>
                    </div>
                </div>

                <div class="input-group">
                    <label>Nhập lại mật khẩu</label>
                    <div class="input-wrapper">
                        <input type="password" name="re_pass" placeholder="Xác nhận lại mật khẩu..." required autocomplete="off" maxlength="100">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                </div>
            </c:if>

            <%-- ======================================================== --%>
            <%-- BƯỚC 2: KHU VỰC NHẬP OTP (Chỉ hiện khi showOtpStep = true) --%>
            <%-- ======================================================== --%>
            <c:if test="${not empty requestScope.showOtpStep}">
                <div class="input-group" style="animation: fadeIn 0.5s; padding: 15px; background: #fff5f5; border: 1px dashed #C92127; border-radius: 8px; margin-top: 20px;">
                    <label style="color: #C92127; font-weight: bold; font-size: 15px;">Mã xác nhận OTP</label>
                    <p style="font-size: 13px; color: #555; margin-top: 5px; margin-bottom: 10px;">Chúng tôi vừa gửi mã 6 số vào email <strong>${valEmail}</strong> của bạn.</p>
                    
                    <div class="input-wrapper">
                        <input type="text" name="Userotp" placeholder="------" required maxlength="6" autofocus
                               style="border: 2px solid ${not empty requestScope.otpError ? '#dc3545' : '#ddd'}; text-align: center; letter-spacing: 10px; font-weight: bold; font-size: 18px;">
                        <i class="fa-solid fa-key" style="color: ${not empty requestScope.otpError ? '#dc3545' : ''};"></i>
                    </div>
                    
                    <%-- THÔNG BÁO LỖI SAI OTP NẰM NGAY DƯỚI Ô INPUT NÀY --%>
                    <c:if test="${not empty requestScope.otpError}">
                        <small style="color: #dc3545; font-size: 13px; font-weight: bold; margin-top: 8px; display: block;">
                            <i class="fa-solid fa-triangle-exclamation"></i> ${requestScope.otpError}
                        </small>
                    </c:if>
                </div>
            </c:if>

            <%-- ĐỔI CHỮ CỦA NÚT SUBMIT THEO TỪNG BƯỚC --%>
            <button type="submit" class="btn-submit" style="margin-top: 20px;">
                ${not empty requestScope.showOtpStep ? 'Xác Nhận & Hoàn Tất Đăng Ký' : 'Đăng Ký & Nhận Mã OTP'}
            </button>

            <div class="form-footer">
                Bạn đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập tại đây</a>
            </div>
        </form>
    </div>

</body>
</html>