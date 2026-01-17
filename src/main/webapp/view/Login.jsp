<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập Bookstore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/login.css">
</head>
<body>

    <div class="login-container">
        <h2>Đăng Nhập</h2>

        <c:if test="${not empty mess}">
            <div class="error-message">
                <i class="fa fa-exclamation-circle"></i> ${mess}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="input-group">
                <label>Tài khoản</label>
                <input type="text" name="username" placeholder="Nhập username..." required>
            </div>

            <div class="input-group">
                <label>Mật khẩu</label>
                <input type="password" name="password" placeholder="Nhập password..." required>
            </div>

            <input type="submit" value="Đăng nhập" class="btn-submit">
        </form>
    </div>

</body>
</html>