<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Trang chủ - BookStore</title>
        
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
        
    </head>

    <body>

        <c:if test="${sessionScope.user == null}">
            <h1 style="color: red;">Bạn chưa đăng nhậpp!</h1>
            <p>Vui lòng quay lại trang <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>.</p>
        </c:if>

        <c:if test="${sessionScope.user != null}">
            <div class="success-msg">
                ✅ Đăng nhập thành công!
            </div>

            <div class="user-info">
                <h3>Xin chào, ${sessionScope.user.username}!</h3>
                <p>Chào mừng bạn đến với hệ thống BookStore.</p>
            </div>

            <br>
            <a href="../logout" class="btn-logout">Đăng xuất</a>
        </c:if>

    </body>
</html>