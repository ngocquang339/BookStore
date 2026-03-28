<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- THIẾT LẬP LOCALE ĐỂ FIX TRIỆT ĐỂ LỖI TRẮNG TRANG KHI FORMAT SỐ --%>
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flash Sale Chớp Nhoáng - BookStore</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        body { background-color: #f8f9fa; }

        /* Banner Flash Sale */
        .flash-sale-header {
            background: linear-gradient(to right, #ff416c, #ff4b2b);
            border-radius: 8px 8px 0 0;
            padding: 15px 25px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            color: white;
        }
        .flash-sale-header .left-side {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .flash-sale-header h2 {
            margin: 0;
            font-style: italic;
            font-weight: 900;
            font-size: 24px;
            letter-spacing: 1px;
        }

        /* Đồng hồ đếm ngược */
        .countdown-box {
            display: flex;
            align-items: center;
            gap: 5px;
            font-weight: bold;
            font-size: 14px;
        }
        .time-block {
            background-color: #000;
            color: #fff;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 16px;
            min-width: 35px;
            text-align: center;
        }

        /* Card Sản phẩm */
        .flash-sale-container {
            background: white;
            border-radius: 0 0 8px 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            margin-bottom: 40px;
        }
        .product-card {
            border: none;
            transition: 0.3s;
            position: relative;
            padding: 10px;
        }
        .product-card:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transform: translateY(-5px);
            z-index: 2;
        }
        .discount-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: #ffca28;
            color: #d70018;
            font-weight: bold;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 12px;
            z-index: 3;
        }
        .product-img {
            width: 100%;
            height: 200px;
            object-fit: contain;
            margin-bottom: 15px;
        }
        .product-title {
            font-size: 14px;
            color: #333;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            margin-bottom: 10px;
            height: 40px;
        }
        .price-sale {
            color: #d70018;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 2px;
        }
        .price-original {
            color: #999;
            font-size: 13px;
            text-decoration: line-through;
            margin-bottom: 15px;
        }

        /* Thanh tiến trình "Đã bán" */
        .progress-container {
            background-color: #ffcccc;
            border-radius: 20px;
            height: 20px;
            position: relative;
            overflow: hidden;
            margin-top: auto;
        }
        .progress-fill {
            background: linear-gradient(to right, #ff758c, #ff7eb3);
            height: 100%;
            border-radius: 20px;
            transition: width 0.5s ease-in-out;
        }
        .progress-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 11px;
            color: white;
            font-weight: bold;
            white-space: nowrap;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
        }
    </style>
</head>
<body>

    <jsp:include page="component/header.jsp" />

    <div class="container mt-4">
        <div class="flash-sale-header">
            <div class="left-side">
                <h2><i class="fa-solid fa-bolt"></i> FLASH SALE</h2>
                <div class="countdown-box">
                    <span>Kết thúc trong</span>
                    <span class="time-block" id="hours">00</span> :
                    <span class="time-block" id="minutes">00</span> :
                    <span class="time-block" id="seconds">00</span>
                </div>
            </div>
        </div>

        <div class="flash-sale-container">
            <div class="row">
                
                <%-- Lặp qua danh sách sách lấy từ Servlet --%>
                <c:forEach items="${allSuggestedBooks}" var="book">
                    <div class="col-md-2 col-sm-4 col-6 mb-4">
                        <div class="product-card card h-100">
                            <div class="discount-badge">-50%</div>
                            
                            <a href="detail?pid=${book.id}">
                                <img src="${pageContext.request.contextPath}/${book.imageUrl}" class="product-img" alt="${book.title}" onerror="this.src='https://placehold.co/200x300?text=No+Image'">
                            </a>
                            
                            <div class="card-body p-0 d-flex flex-column">
                                <a href="detail?pid=${book.id}" class="text-decoration-none">
                                    <h6 class="product-title">${book.title}</h6>
                                </a>
                                
                                <div class="price-sale"><fmt:formatNumber value="${book.price}" type="number" pattern="#,###"/> đ</div>
                                <div class="price-original"><fmt:formatNumber value="${book.price * 2}" type="number" pattern="#,###"/> đ</div>
                                
                                <c:set var="totalItems" value="${book.soldQuantity + book.stockQuantity}" />
                                <c:set var="percentSold" value="${totalItems > 0 ? (book.soldQuantity * 100.0 / totalItems) : 0}" />
                                
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <jsp:include page="component/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Thiết lập đếm ngược đến 23:59:59 ngày hôm nay
            let countDownDate = new Date();
            countDownDate.setHours(23, 59, 59, 0);

            function updateTimer() {
                let now = new Date().getTime();
                let distance = countDownDate.getTime() - now;

                if (distance < 0) {
                    document.getElementById("hours").innerText = "00";
                    document.getElementById("minutes").innerText = "00";
                    document.getElementById("seconds").innerText = "00";
                    return; 
                }

                let hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                let seconds = Math.floor((distance % (1000 * 60)) / 1000);

                document.getElementById("hours").innerText = hours < 10 ? "0" + hours : hours;
                document.getElementById("minutes").innerText = minutes < 10 ? "0" + minutes : minutes;
                document.getElementById("seconds").innerText = seconds < 10 ? "0" + seconds : seconds;
            }

            updateTimer();
            setInterval(updateTimer, 1000);
        });
    </script>
</body>
</html>