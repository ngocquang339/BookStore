<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi - BookStore</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        /* CSS DÀNH RIÊNG CHO TRANG QUẢN LÝ ĐƠN HÀNG */
        .orders-wrapper {
            background-color: transparent; /* Bỏ background trắng tổng để các phần tử rời nhau */
        }

        /* 1. Phần Tab trạng thái */
        .order-tabs-container {
            background-color: #fff;
            border-radius: 8px;
            padding: 15px 10px 0 10px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        .order-tabs-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
            padding-left: 10px;
        }
        .order-tabs {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #eee;
            margin: 0;
            padding: 0;
            list-style: none;
        }
        .tab-item {
            flex: 1;
            text-align: center;
            text-decoration: none;
            color: #555;
            padding-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .tab-item:hover {
            color: #C92127;
        }
        .tab-item.active {
            color: #C92127;
            border-bottom: 2px solid #C92127;
            font-weight: 500;
        }
        .tab-item .count {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 2px;
        }
        .tab-item .label {
            font-size: 13px;
        }

        /* 2. Phần Thẻ Đơn hàng (Order Card) */
        .order-card {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 15px;
            margin-bottom: 15px;
        }
        .order-id {
            color: #2f80ed;
            font-weight: 500;
            text-decoration: none;
            font-size: 15px;
        }
        .order-id:hover { text-decoration: underline; }
        
        /* Badges trạng thái */
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
            margin-left: 10px;
        }
        .status-cancelled { background-color: #ffe5e5; color: #dc3545; }
        .status-success { background-color: #e6f8ec; color: #28a745; }
        .status-pending { background-color: #fff3cd; color: #ffc107; }

        .order-date { font-size: 13px; color: #777; }

        /* Thông tin sản phẩm */
        .order-product { display: flex; gap: 15px; }
        .order-product img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border: 1px solid #eee;
            border-radius: 4px;
        }
        .order-product-name {
            font-size: 14px;
            color: #333;
            margin-bottom: 5px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        /* Footer thẻ đơn hàng */
        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-top: 15px;
        }
        .total-items-text { font-size: 14px; color: #777; }
        .order-total-price { font-size: 15px; color: #333; margin-bottom: 15px; text-align: right;}
        .order-total-price strong { font-size: 18px; color: #333; }
        
        .order-actions button {
            padding: 8px 20px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            margin-left: 10px;
        }
        .btn-cancel-disabled {
            background-color: #fff;
            border: 1px solid #ccc;
            color: #999;
            cursor: not-allowed;
        }
        .btn-buy-again {
            background-color: #C92127;
            border: 1px solid #C92127;
            color: #fff;
            transition: 0.3s;
        }
        .btn-buy-again:hover { background-color: #a81b20; color: #fff; }
    </style>
</head>

<body>
    
    <jsp:include page="component/header.jsp" />

    <div class="container profile-container py-4">
        <div class="row">
            
            <div class="col-md-3">
                <jsp:include page="component/sidebar.jsp" />
            </div>

            <div class="col-md-9">
                <div class="orders-wrapper">
                    
                    <div class="order-tabs-container">
                        <div class="order-tabs-title">Đơn hàng của tôi</div>
                        <ul class="order-tabs">
                            <a href="?status=all" class="tab-item ${currentStatus == 'all' ? 'active' : ''}">
                                <div class="count">1</div> <div class="label">Tất cả</div>
                            </a>
                            <a href="?status=pending" class="tab-item ${currentStatus == 'pending' ? 'active' : ''}">
                                <div class="count">0</div>
                                <div class="label">Chờ thanh toán</div>
                            </a>
                            <a href="?status=processing" class="tab-item ${currentStatus == 'processing' ? 'active' : ''}">
                                <div class="count">0</div>
                                <div class="label">Đang xử lý</div>
                            </a>
                            <a href="?status=shipping" class="tab-item ${currentStatus == 'shipping' ? 'active' : ''}">
                                <div class="count">0</div>
                                <div class="label">Đang giao</div>
                            </a>
                            <a href="?status=completed" class="tab-item ${currentStatus == 'completed' ? 'active' : ''}">
                                <div class="count">0</div>
                                <div class="label">Hoàn tất</div>
                            </a>
                            <a href="?status=cancelled" class="tab-item ${currentStatus == 'cancelled' ? 'active' : ''}">
                                <div class="count">1</div>
                                <div class="label">Bị hủy</div>
                            </a>
                        </ul>
                    </div>

                    <c:choose>
                        <%-- TRƯỜNG HỢP 1: KHÔNG CÓ ĐƠN HÀNG NÀO --%>
                        <c:when test="${empty listOrders}">
                            <div class="order-card text-center py-5">
                                <i class="fa-solid fa-receipt mb-3" style="font-size: 50px; color: #ccc;"></i>
                                <div style="font-size: 16px; color: #777;">Chưa có đơn hàng nào</div>
                            </div>
                        </c:when>

                        <%-- TRƯỜNG HỢP 2: CÓ ĐƠN HÀNG -> VÒNG LẶP --%>
                        <c:otherwise>
                            <c:forEach var="order" items="${listOrders}">
                                <div class="order-card">
                                    
                                    <div class="order-header">
                                        <div>
                                            <a href="#" class="order-id">#${order.id}</a>
                                            
                                            <%-- XỬ LÝ BADGE TRẠNG THÁI DỰA VÀO SỐ TRONG DB --%>
                                            <c:choose>
                                                <c:when test="${order.status == 0}">
                                                    <span class="status-badge status-cancelled">Bị hủy</span>
                                                </c:when>
                                                <c:when test="${order.status == 1}">
                                                    <span class="status-badge status-pending" style="background-color: #fff3cd; color: #856404;">Chờ thanh toán</span>
                                                </c:when>
                                                <c:when test="${order.status == 2}">
                                                    <span class="status-badge status-pending" style="background-color: #cce5ff; color: #004085;">Đang xử lý</span>
                                                </c:when>
                                                <c:when test="${order.status == 3}">
                                                    <span class="status-badge status-pending" style="background-color: #d1ecf1; color: #0c5460;">Đang giao</span>
                                                </c:when>
                                                <c:when test="${order.status == 4}">
                                                    <span class="status-badge status-success">Hoàn tất</span>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                        <div class="order-date">
                                            <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy - HH:mm" />
                                        </div>
                                    </div>

                                    <c:set var="totalItemsCount" value="0" />
                                    
                                    <c:forEach var="item" items="${order.details}">
                                        <c:set var="totalItemsCount" value="${totalItemsCount + item.quantity}" />
                                        
                                        <div class="order-product mt-3 pb-3 border-bottom" style="border-color: #f9f9f9 !important;">
                                            <img src="${pageContext.request.contextPath}/${item.book.imageUrl}" 
                                                 alt="${item.book.title}" 
                                                 onerror="this.src='https://placehold.co/80x80?text=No+Image'">
                                            <div class="d-flex justify-content-between w-100">
                                                <div style="padding-right: 15px;">
                                                    <div class="order-product-name">${item.book.title}</div>
                                                    <div class="text-muted" style="font-size: 13px;">Số lượng: x${item.quantity}</div>
                                                </div>
                                                <div class="text-end" style="min-width: 90px;">
                                                    <span style="font-weight: 500; color: #333;">
                                                        <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫"/>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <div class="order-footer mt-3">
                                        <div class="total-items-text">${totalItemsCount} sản phẩm</div>
                                        <div class="text-end">
                                            <div class="order-total-price">Tổng tiền: 
                                                <strong style="color: #C92127;">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                                                </strong>
                                            </div>
                                            
                                            <div class="order-actions">
                                                <%-- CHỈ HIỂN THỊ NÚT HỦY KHI ĐƠN ĐANG CHỜ THANH TOÁN HOẶC ĐANG XỬ LÝ (Tùy logic doanh nghiệp của bạn) --%>
                                                <c:choose>
                                                    <c:when test="${order.status == 1 || order.status == 2}">
                                                        <form action="${pageContext.request.contextPath}/my-orders" method="POST" style="display:inline;">
                                                            <input type="hidden" name="action" value="cancel">
                                                            <input type="hidden" name="orderId" value="${order.id}">
                                                            <button type="submit" class="btn btn-outline-danger" style="padding: 8px 20px; font-size: 14px;" onclick="return confirm('Bạn chắc chắn muốn hủy đơn hàng này?');">Hủy đơn</button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-cancel-disabled" disabled>Hủy đơn</button>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <button class="btn btn-buy-again">Mua lại</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    
                    </div> 
            </div> 
        </div> 
    </div> 

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>