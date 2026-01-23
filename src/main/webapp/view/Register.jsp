<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng kí Bookstore</title>
    
</head>
<body>
    <form action="${pageContext.request.contextPath}/register" method="post">
    <input type="text" name="username" placeholder="Nhập user name: " required>
    <input type="text" name="email" placeholder="Nhập email: " required>
    <input type="password" name="password" placeholder="Nhập mật khẩu: " required>
    <input type="password" name="re_pass" placeholder="Nhập lại mật khẩu: " required>
    <input type="submit" value="Đăng kí" class="btn-submit">
    </form>
</body>