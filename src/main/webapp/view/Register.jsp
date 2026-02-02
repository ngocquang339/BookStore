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
</head>
<body>

    <div class="register-container">
        <div class="register-header">
            <h2>Đăng Ký Thành Viên</h2>
            <p>Chào mừng bạn đến với <span class="brand-text">BOOKSTORE</span></p>
        </div>

        <c:if test="${not empty mess}">
            <div class="alert-error">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <span>${mess}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="input-group">
                <label>Họ và tên</label>
                <div class="input-wrapper">
                    <input type="text" name="fullname" placeholder="Ví dụ: Nguyễn Văn An" required autocomplete="off">
                    <i class="fa-regular fa-id-card"></i>
                </div>
            </div>

            <div class="input-group">
                <label>Số điện thoại</label>
                <div class="input-wrapper">
                    <input
                        type="tel"
                        name="phone_number"
                        placeholder="Ví dụ: 0912345678"
                        pattern="[0-9]{10}"
                        maxlength="10"
                        required
                        autocomplete="off"
                        title="Số điện thoại phải gồm đúng 10 chữ số">
                    <i class="fa-solid fa-phone"></i>
                </div>
            </div>


            <div class="input-group">
                <label>Tên đăng nhập</label>
                <div class="input-wrapper">
                    <input type="text" name="username" placeholder="Ví dụ: nguyenvanan" required autocomplete="off">
                    <i class="fa-regular fa-user"></i>
                </div>
            </div>

            <div class="input-group">
                <label>Địa chỉ Email</label>
                <div class="input-wrapper">
                    <input type="email" name="email" placeholder="example@gmail.com" required autocomplete="off">
                    <i class="fa-regular fa-envelope"></i>
                </div>
            </div>

            <div class="input-group">
                <label>Mật khẩu</label>
                <div class="input-wrapper">
                    <input type="password" name="password" placeholder="Nhập mật khẩu..." required>
                    <i class="fa-solid fa-lock"></i>
                </div>
            </div>

            <div class="input-group">
                <label>Nhập lại mật khẩu</label>
                <div class="input-wrapper">
                    <input type="password" name="re_pass" placeholder="Xác nhận lại mật khẩu..." required>
                    <i class="fa-solid fa-shield-halved"></i>
                </div>
            </div>

            <button type="submit" class="btn-submit">
                Đăng Ký Ngay
            </button>

            <div class="form-footer">
                Bạn đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập tại đây</a>
            </div>
        </form>
    </div>

</body>
</html>