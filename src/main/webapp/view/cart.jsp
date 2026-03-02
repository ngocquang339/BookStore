<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng - BookStore</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* GIỮ NGUYÊN TOÀN BỘ CSS CŨ CỦA BẠN */
        body { background-color: #F0F0F0; font-family: Arial, sans-serif; }
        .main-header { background: white; padding: 15px 0; margin-bottom: 20px; border-bottom: 1px solid #ddd; }
        .cart-wrapper { max-width: 1200px; margin: 0 auto; padding-bottom: 50px; }
        .cart-title { font-size: 18px; font-weight: 400; text-transform: uppercase; margin-bottom: 15px; color: #333; }
        .cart-box { background: white; border-radius: 8px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }

        .product-img { width: 80px; height: 100px; object-fit: cover; border: 1px solid #eee; }
        .product-title { font-weight: 600; color: #333; margin-bottom: 5px; }
        .price-text { font-weight: bold; color: #C92127; }
        
        .qty-input { width: 50px; text-align: center; border: 1px solid #ddd; border-left: none; border-right: none; height: 30px; outline: none; }
        .qty-input::-webkit-inner-spin-button, .qty-input::-webkit-outer-spin-button { -webkit-appearance: none; margin: 0; }
        
        .btn-qty { border: 1px solid #ddd; background: white; height: 30px; width: 30px; display: flex; align-items: center; justify-content: center; cursor: pointer; text-decoration: none; color: #333; font-weight: bold; }
        .btn-qty:hover { background-color: #f5f5f5; color: #C92127; }

        .btn-delete { color: #999; cursor: pointer; font-size: 18px; text-decoration: none; }
        .btn-delete:hover { color: #C92127; }

        .empty-content { text-align: center; padding: 50px 0; }
        .btn-shopping { background-color: #C92127; color: white; padding: 12px 50px; font-weight: 700; border-radius: 4px; text-decoration: none; }
        .total-section { text-align: right; margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee; }
        
        .alert-fixed { position: fixed; top: 20px; right: 20px; z-index: 9999; min-width: 350px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        
        /* CSS MỚI CHO Ô CHECKBOX TO HƠN */
        .custom-checkbox { transform: scale(1.5); cursor: pointer; accent-color: #C92127; }
    </style>
</head>

<body>

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show alert-fixed" role="alert">
            <i class="fa-solid ${sessionScope.messageType == 'success' ? 'fa-circle-check' : 'fa-triangle-exclamation'}"></i> 
            <strong>Thông báo:</strong> ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="message" scope="session" />
        <c:remove var="messageType" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.cartError}">
        <div class="alert alert-danger alert-dismissible fade show alert-fixed" role="alert">
            <i class="fa-solid fa-triangle-exclamation"></i> 
            <strong>Lỗi:</strong> ${sessionScope.cartError}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="cartError" scope="session" />
    </c:if>


    <header class="main-header">
        <div class="container d-flex justify-content-between align-items-center">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
                    <span style="color: #C92127; font-weight: 900; font-size: 28px;">BOOK</span><span style="color: #333; font-weight: 900; font-size: 28px;">STORE</span>
                </a>
            </div>
            
            <div class="search-box" style="flex-grow: 0.5;"> 
                <form action="search" method="get" style="display: flex; width: 100%; position: relative;">
                    <input type="text" name="txt" placeholder="Tìm kiếm sách, tác giả..." style="width: 100%; padding: 8px 15px; border: 1px solid #ddd; border-radius: 4px;">
                    <button type="submit" style="position: absolute; right: 0; top: 0; bottom: 0; background: #C92127; border: none; color: white; padding: 0 15px; border-radius: 0 4px 4px 0;">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </form>
            </div>

            <div class="header-icons d-flex gap-4 align-items-center">
                <a href="${pageContext.request.contextPath}/home" class="text-decoration-none text-dark"><i class="fa-solid fa-arrow-left"></i> Tiếp tục mua sắm</a>
            </div>
        </div>
    </header>

    <div class="cart-wrapper">
        <c:set var="cartSize" value="${sessionScope.cart != null ? sessionScope.cart.size() : 0}" />

        <h4 class="cart-title">GIỎ HÀNG <span style="font-size: 16px; text-transform: none;">(${cartSize} sản phẩm)</span></h4>

        <div class="cart-box">
            <c:choose>
                <c:when test="${cartSize == 0}">
                    <div class="empty-content">
                        <img src="https://cdn-icons-png.flaticon.com/512/11329/11329060.png" width="150px" style="opacity: 0.5; margin-bottom: 20px;">
                        <p class="empty-text">Chưa có sản phẩm trong giỏ hàng của bạn.</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn-shopping">MUA SẮM NGAY</a>
                    </div>
                </c:when>

                <c:otherwise>
                    <form action="${pageContext.request.contextPath}/checkout" method="GET">
                        <table class="table table-borderless align-middle">
                            <thead>
                                <tr style="border-bottom: 1px solid #eee;">
                                    <th style="width: 5%" class="text-center">Chọn</th>
                                    <th style="width: 45%">Sản phẩm</th>
                                    <th style="width: 15%" class="text-center">Số lượng</th>
                                    <th style="width: 15%" class="text-center">Thành tiền</th>
                                    <th style="width: 5%" class="text-center"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${sessionScope.cart}" var="item">
                                    <tr style="border-bottom: 1px solid #eee;">
                                        
                                        <td class="text-center">
                                            <input type="checkbox" name="selectedItems" value="${item.book.id}" class="form-check-input custom-checkbox">
                                        </td>

                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="${pageContext.request.contextPath}/${item.book.imageUrl}" 
                                                     class="product-img me-3" 
                                                     alt="${item.book.title}"
                                                     onerror="this.src='https://placehold.co/80x100'">
                                                <div>
                                                    <div class="product-title">${item.book.title}</div>
                                                    <div style="font-size: 14px; color: #555;">
                                                        <fmt:formatNumber value="${item.book.price}" type="currency" currencySymbol="₫"/>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        
                                        <td>
                                            <div class="d-flex justify-content-center">
                                                <a href="${pageContext.request.contextPath}/update-cart?id=${item.book.id}&action=dec" class="btn-qty text-decoration-none">-</a>
                                                <input type="number" class="qty-input" value="${item.quantity}" min="1"
                                                       onchange="window.location.href='${pageContext.request.contextPath}/update-cart?id=${item.book.id}&action=update&quantity=' + this.value">
                                                <a href="${pageContext.request.contextPath}/update-cart?id=${item.book.id}&action=inc" class="btn-qty text-decoration-none">+</a>
                                            </div>
                                        </td>
                                        
                                        <td class="text-center">
                                            <span class="price-text">
                                                <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫"/>
                                            </span>
                                        </td>
                                        
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/update-cart?id=${item.book.id}&action=remove" 
                                               class="btn-delete" title="Xóa sản phẩm"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này không?');">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <div class="total-section">
                            <div class="d-flex justify-content-end align-items-center gap-3">
                                <span>Tổng giỏ hàng:</span>
                                <span style="font-size: 24px; font-weight: bold; color: #C92127;">
                                    <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₫"/>
                                </span>
                            </div>
                            
                            <div class="d-flex justify-content-end mt-3">
                                <button type="submit" class="btn-shopping" style="border: none; width: 300px;">THANH TOÁN</button>
                            </div>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>