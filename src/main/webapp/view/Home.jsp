<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - BookStore</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; margin: 0; }
        .container { width: 80%; margin: 0 auto; }
        .main-header { background: #fff; padding: 15px 0; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .main-header .container { display: flex; align-items: center; justify-content: space-between; }
        
        /* CSS cho Form tìm kiếm */
        .search-box form { display: flex; }
        .search-box input { padding: 8px; width: 300px; border: 1px solid #ddd; border-radius: 4px 0 0 4px; outline: none; }
        .search-box button { padding: 8px 15px; background: #C92127; color: #fff; border: none; border-radius: 0 4px 4px 0; cursor: pointer; }
        
        /* CSS cho lưới sản phẩm */
        .product-list { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-top: 20px; }
        .product-card { background: #fff; padding: 15px; border-radius: 8px; text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1); transition: 0.3s; }
        .product-card:hover { transform: translateY(-5px); }
        .product-card img { max-width: 100%; height: 200px; object-fit: cover; margin-bottom: 10px; }
        .product-card h3 { font-size: 16px; margin: 10px 0; color: #333; height: 40px; overflow: hidden; }
        .price { color: #C92127; font-weight: bold; font-size: 18px; }
        .header-icons { display: flex; gap: 20px; }
        a { text-decoration: none; color: inherit; }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body>

    <header class="main-header">
        <div class="container">
            
            <div class="logo">
                <a href="${pageContext.request.contextPath}/search">
                    <span style="color: #C92127; font-weight: 900; font-size: 28px;">BOOK</span>STORE
                </a>
            </div>

            <div class="search-box">
                <form action="${pageContext.request.contextPath}/search" method="get">
                    <input type="text" name="txt" value="${txtS}" placeholder="Tìm kiếm sách, tác giả...">
                    <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
                </form>
            </div>

            <div class="header-icons">
                <div class="icon-item"><i class="fa-regular fa-bell"></i></div>
                <div class="icon-item"><i class="fa-solid fa-cart-shopping"></i></div>
                <div class="icon-item user-account">
                    <i class="fa-regular fa-user"></i>
                    <div class="account-info">
                        <c:if test="${sessionScope.user == null}">
                            <a href="${pageContext.request.contextPath}/login">Tài khoản</a>
                        </c:if>
                        <c:if test="${sessionScope.user != null}">
                            <span style="color: #C92127; font-weight: bold;">${sessionScope.user.username}</span>
                            <small><a href="${pageContext.request.contextPath}/logout"> (Thoát)</a></small>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <main class="main-content container">
        <h2 style="margin-top: 20px;">Danh sách Sách</h2>

        <c:if test="${sessionScope.user != null}">
            <div style="background: #e1f7d5; padding: 10px; margin-bottom: 20px; border-radius: 5px;">
                Chào mừng <b>${sessionScope.user.username}</b> đã quay trở lại!
            </div>
        </c:if>

        <c:if test="${empty listBooks}">
            <p style="color: red; text-align: center;">Không tìm thấy cuốn sách nào!</p>
        </c:if>

        <div class="product-list">
            <c:forEach items="${listBooks}" var="b">
                <div class="product-card">
                    <img src="${empty b.image ? 'https://via.placeholder.com/150' : b.image}" alt="${b.title}">
                    <h3>${b.title}</h3>
                    <p style="color: gray; font-size: 14px;">${b.author}</p>
                    <p class="price">${b.price} đ</p>
                    <a href="#" style="color: blue; font-size: 14px;">Xem chi tiết</a>
                </div>
            </c:forEach>
        </div>
    </main>

</body>
</html>