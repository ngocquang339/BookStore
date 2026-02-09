<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực OTP - BookStore</title>
    
    <style>
        /* CSS NHANH CHO TRANG OTP GỌN GÀNG */
        body { font-family: Arial, sans-serif; background-color: #f5f5fa; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .otp-container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); text-align: center; width: 100%; max-width: 400px; }
        h3 { color: #333; margin-bottom: 10px; }
        p { color: #666; font-size: 14px; margin-bottom: 20px; }
        input[type="text"] { width: 100%; padding: 12px; margin-bottom: 15px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; font-size: 16px; text-align: center; letter-spacing: 5px; }
        button { background-color: #C92127; color: white; border: none; padding: 12px; width: 100%; border-radius: 4px; font-size: 16px; cursor: pointer; transition: 0.3s; }
        button:hover { background-color: #a01a1f; }
        .error-msg { color: #dc3545; font-size: 13px; margin-bottom: 15px; display: block; }
    </style>
</head>
<body>

    <div class="otp-container">
        <form action="${pageContext.request.contextPath}/verify-otp" method="post">
            
            <h3>Xác thực tài khoản</h3>
            
            <c:if test="${not empty error}">
                <span class="error-msg">
                    <i class="fa-solid fa-triangle-exclamation"></i> ${error}
                </span>
            </c:if>

            <p>Mã xác thực đã được gửi đến email của bạn.<br>Vui lòng kiểm tra và nhập mã 6 số.</p>
            
            <input type="text" name="userOtp" placeholder="------" maxlength="6" required autocomplete="off">
            
            <button type="submit">Xác nhận</button>
            
            <div style="margin-top: 15px; font-size: 13px;">
                <a href="${pageContext.request.contextPath}/register" style="color: #666; text-decoration: none;">Quay lại đăng ký</a>
            </div>
        </form>
    </div>

</body>
</html>