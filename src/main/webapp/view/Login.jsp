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
                    <label for="username">Số điện thoại/Email</label>
                    <input type="text" id="username" name="username" value="${param.username}" placeholder="Nhập số điện thoại/Email" maxlength="50" required>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" maxlength="50" required>
                    <span class="toggle-password" onclick="togglePassword()">Hiện</span>
                </div>

                <div class="forgot-password">
                    <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn-submit">Đăng nhập</button>

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
    </script>

</body>
</html>