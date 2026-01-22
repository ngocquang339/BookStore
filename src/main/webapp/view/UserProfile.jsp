<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hồ sơ của ${sessionScope.user.username}</title>
    </head>

    <body>
        <c:if test="${empty sessionScope.user}">
            <c:redirect url="/login" />
        </c:if>

        <h1>Thông tin tài khoản</h1>
        <form action="" method="post">
            Tên người dùng: <input type="text" name="username" value="${sessionScope.user.username}">
            Email: <input type="text" name="email" value="${sessionScope.user.email}">
            Số điện thoại: <input type="text" name="phone_number" value="${sessionScope.user.phone_number}">

            <input type="submit" value="Lưu thay đổi" class="btn-submit">
        </form>
    </body>
</html>