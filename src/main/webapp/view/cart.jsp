<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng - BookStore</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        /* --- CẤU HÌNH CHUNG --- */
        body { 
            background-color: #F0F0F0; 
            font-family: Arial, Helvetica, sans-serif; 
        }

        /* --- 1. HEADER --- */
        .header-section {
            background-color: white;
            padding: 15px 0;
            margin-bottom: 20px;
            border-bottom: 1px solid #ddd;
        }
        .brand-logo { text-decoration: none; font-size: 30px; letter-spacing: -1px; }
        .text-book { color: #C92127; font-weight: 800; } 
        .text-store { color: #333; font-weight: 400; }   

        .search-wrapper { position: relative; width: 60%; }
        .search-input { 
            border-radius: 4px 0 0 4px; border: 1px solid #e0e0e0; padding: 10px 15px; font-size: 14px;
        }
        .search-btn { 
            background-color: #C92127; color: white; border: none; border-radius: 0 4px 4px 0; padding: 0 25px; font-size: 18px;
        }
        .search-btn:hover { background-color: #b01c22; color: white; }

        .icon-group { display: flex; align-items: center; gap: 30px; margin-left: 20px; }
        .icon-item { 
            text-align: center; color: #7A7E7F; text-decoration: none; font-size: 13px; display: flex; flex-direction: column; align-items: center;
        }
        .icon-item i { font-size: 22px; margin-bottom: 5px; color: #7A7E7F; }
        .icon-item:hover i, .icon-item:hover { color: #C92127; }

        /* --- 2. GIỎ HÀNG --- */
        .cart-wrapper { max-width: 1200px; margin: 0 auto; padding-bottom: 50px; }
        .cart-heading { font-size: 18px; font-weight: 400; text-transform: uppercase; margin-bottom: 15px; color: #333; }

        .cart-content-box {
            background: white;
            border-radius: 8px;
            min-height: 300px; /* Chiều cao khung trắng */
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        }

        /* --- GIAO DIỆN KHI RỖNG (CHỈ CÓ CHỮ) --- */
        .empty-cart-container { text-align: center; padding: 40px; }
        
        .empty-text { 
            color: #333; 
            font-size: 16px; 
            margin-bottom: 30px; /* Khoảng cách giữa chữ và nút */
        }

        .btn-red-action {
            background-color: #C92127;
            color: white;
            padding: 12px 50px;
            font-size: 16px;
            font-weight: 700;
            border-radius: 4px;
            text-decoration: none;
            text-transform: uppercase;
            display: inline-block;
            transition: 0.2s;
        }
        .btn-red-action:hover { background-color: #b01c22; color: white; }
    </style>
</head>

<body>

    <header class="header-section sticky-top">
        <div class="container d-flex align-items-center justify-content-between">
            <a href="${pageContext.request.contextPath}/home" class="brand-logo">
                <span class="text-book">BOOK</span><span class="text-store">STORE</span>
            </a>

            <form action="search" class="d-flex search-wrapper">
                <input class="form-control search-input" type="search" placeholder="Tìm kiếm sách, tác giả..." name="keyword">
                <button class="btn search-btn" type="submit">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
            </form>

            <div class="icon-group">
                <a href="#" class="icon-item">
                    <i class="fa-regular fa-bell"></i>
                    <span>Thông báo</span>
                </a>

                <a href="${pageContext.request.contextPath}/Cart" class="icon-item position-relative">
                    <i class="fa-solid fa-cart-shopping"></i>
                    <span>Giỏ hàng</span>
                    <c:if test="${sessionScope.cart != null && sessionScope.cart.size() > 0}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 10px;">
                            ${sessionScope.cart.size()}
                        </span>
                    </c:if>
                </a>

                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                         <a href="profile.jsp" class="icon-item">
                            <i class="fa-regular fa-user" style="color: #C92127;"></i>
                            <span style="color: #C92127; font-weight: bold;">${sessionScope.user.username}</span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="login.jsp" class="icon-item">
                            <i class="fa-regular fa-user"></i>
                            <span>Tài khoản</span>
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <div class="cart-wrapper">
        <div class="container">
            
            <c:set var="cartSize" value="${sessionScope.cart != null ? sessionScope.cart.size() : 0}" />

            <h4 class="cart-heading">
                GIỎ HÀNG <span style="font-size: 16px; text-transform: none;">(${cartSize} sản phẩm)</span>
            </h4>

            <div class="cart-content-box">
                <c:choose>
                    
                    <%-- TRƯỜNG HỢP 1: GIỎ HÀNG RỖNG --%>
                    <c:when test="${cartSize == 0}">
                        <div class="empty-cart-container">
                            <p class="empty-text">Chưa có sản phẩm trong giỏ hàng của bạn.</p>
                            
                            <a href="${pageContext.request.contextPath}/home" class="btn-red-action">
                                MUA SẮM NGAY
                            </a>
                        </div>
                    </c:when>

                    <%-- TRƯỜNG HỢP 2: CÓ SẢN PHẨM --%>
                    <c:otherwise>
                         <div style="width: 100%; padding: 20px;">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th>Đơn giá</th>
                                        <th>Số lượng</th>
                                        <th>Thành tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${sessionScope.cart}" var="item">
                                        <tr>
                                            <td>${item.book.title}</td>
                                            <td><fmt:formatNumber value="${item.book.price}" type="currency" currencySymbol="₫"/></td>
                                            <td>${item.quantity}</td>
                                            <td><fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>

                </c:choose>
            </div>
        </div>
    </div>

</body>
</html>