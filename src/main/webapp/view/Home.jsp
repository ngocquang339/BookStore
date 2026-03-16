<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        .admin-overlay {
            background-color: #333; color: white; padding: 10px 20px;
            display: flex; justify-content: space-between; align-items: center;
            font-size: 14px;
        }
        .admin-btn {
            color: #fff; background: #C92127; padding: 5px 15px; 
            text-decoration: none; border-radius: 4px; font-weight: bold;
        }
        .admin-active { margin-top: 0; }
        
        /* ==========================================
   CSS BANNER CHUẨN (KHÔNG BỊ TRÀN, KHÔNG LỆCH)
   ========================================== */
        .banner-section { 
            margin-bottom: 30px;
        }

        /* --- Khối Trên --- */
        .banner-top { 
            display: flex; gap: 10px; 
            margin-bottom: 10px; 
            height: 340px; /* CHỐT CỨNG CHIỀU CAO ĐỂ KHÔNG BỊ TRÀN XUỐNG DƯỚI */
        }

        /* Cột Trái */
        .banner-left { 
            width: 66%; height: 100%;
        } 
        .banner-left img { 
            width: 100%; height: 100%; 
            object-fit: cover; 
            border-radius: 8px; 
        }

        /* Cột Phải */
        .banner-right { 
            width: 34%; display: flex; 
            flex-direction: column; 
            gap: 10px; 
            height: 100%;
        }
        .right-item {
            flex: 1; /* Tự động chia đôi chiều cao khoảng trống (mỗi ảnh 50%) */
            display: block; height: 100%; 
            overflow: hidden; 
            border-radius: 8px;
        }
        .right-item img { 
            width: 100%; height: 100%; 
            object-fit: cover; 
            display: block;
        }

        /* --- Khối Dưới --- */
        .banner-bottom { 
            display: flex; gap: 10px; 
        }
        .banner-bottom a {
            flex: 1; /* 4 banner chia đều nhau */
            display: block;
        }
        .banner-bottom img { 
            width: 100%; height: 140px; 
            object-fit: cover; 
            border-radius: 8px; 
        }

        /* Hiệu ứng hover cho tất cả ảnh */
        .banner-left img:hover, .right-item img:hover, .banner-bottom img:hover {
            opacity: 0.9; transform: translateY(-2px);
            transition: all 0.2s ease;
        }
    </style>
</head>

<body class="${sessionScope.user != null && sessionScope.user.role == 1 ? 'admin-active' : ''}">
    <%-- KIỂM TRA QUYỀN VÀ HIỂN THỊ TOP BAR CHO ADMIN/SALE --%>
<c:if test="${sessionScope.user != null and (sessionScope.user.role == 1 or sessionScope.user.role == 3)}">
    <div style="background-color: #343a40; color: white; font-size: 13px; display: flex; justify-content: space-between; align-items: stretch; z-index: 1000; position: relative;">
        <div style="padding: 10px 15px; display: flex; align-items: center;">
             <span style="color: #ffc107; font-weight: bold; margin-right: 8px;">
                <c:choose>
                    <c:when test="${sessionScope.user.role == 1}">CHẾ ĐỘ QUẢN TRỊ VIÊN:</c:when>
                    <c:when test="${sessionScope.user.role == 3}">CHẾ ĐỘ NHÂN VIÊN:</c:when>
                </c:choose>
             </span>
            
            <span>Xin chào, ${sessionScope.user.username} 
                <c:choose>
                    <c:when test="${sessionScope.user.role == 1}"></c:when>
                    <c:when test="${sessionScope.user.role == 3}"></c:when>
                 </c:choose>
            </span>
        </div>
        
        <div style="display: flex;">
            <c:choose>
                <c:when test="${sessionScope.user.role == 1}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" style="background-color: #C92127; color: white; padding: 10px 20px; text-decoration: none; font-weight: bold; display: flex; align-items: center; transition: background-color 0.2s;">
                        VÀO TRANG QUẢN LÝ <i class="fa-solid fa-arrow-right ms-2"></i>
                    </a>
                </c:when>
                <c:when test="${sessionScope.user.role == 3}">
                    <a href="${pageContext.request.contextPath}/staff-dashboard" style="background-color: #C92127; color: white; padding: 10px 20px; text-decoration: none; font-weight: bold; display: flex; align-items: center; transition: background-color 0.2s;">
                        VÀO TRANG QUẢN LÝ SALE <i class="fa-solid fa-arrow-right ms-2"></i>
                    </a>
                </c:when>
            </c:choose>
        </div>
    </div>
</c:if>

    <%-- 2. THÔNG BÁO --%>
    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show" role="alert" 
             style="position: fixed; top: 60px; right: 20px; z-index: 9999; min-width: 300px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
            <i class="fa-solid fa-bell"></i> 
            <strong>Thông báo:</strong> ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="message" scope="session" />
        <c:remove var="messageType" scope="session" />
    </c:if>

    <jsp:include page="component/header.jsp" />

    <%-- Gộp tất cả vào 1 thẻ MAIN duy nhất --%>
    <main class="main-content container" style="margin-top: 20px;">
        
        <%-- TRƯỜNG HỢP A: ĐANG TÌM KIẾM (Có kết quả search) --%>
        <c:if test="${not empty listBooks}">
            <h2 style="border-left: 4px solid #C92127; padding-left: 10px;">Kết quả tìm kiếm: "${searchKeyword}"</h2>
            <div class="book-list">
                <c:forEach items="${listBooks}" var="b">
                    <div class="book-card">
                        <div class="book-image">
                            <a href="${pageContext.request.contextPath}/detail?pid=${b.id}">
                                <img src="${pageContext.request.contextPath}/${b.imageUrl}" 
                                     alt="${b.title}" onerror="this.src='https://placehold.co/200x300?text=No+Image'">
                            </a>
                        </div>
                        <div class="book-info">
                            <h3 class="book-title"><a href="${pageContext.request.contextPath}/detail?pid=${b.id}" style="text-decoration: none; color: #333;">${b.title}</a></h3>
                            <p class="book-author">${b.author}</p>
                            <div class="book-price">
                                <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </div>
                            <a href="${pageContext.request.contextPath}/add-to-cart?id=${b.id}" class="btn-buy">
                                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty listBooks}">
            <section class="banner-section">
                <div class="banner-top">
                    <div class="banner-left">
                        <img src="${pageContext.request.contextPath}/assets/image/Banner/Conan.jpg" alt="Banner Chính">
                    </div>
                    <div class="banner-right">
                        <a href="${pageContext.request.contextPath}/vouchers" class="right-item">
                            <img src="${pageContext.request.contextPath}/assets/image/Banner/Voucher.jpg" alt="Săn Voucher Khủng">
                        </a>
                        
                        <a href="#" class="right-item">
                            <img src="${pageContext.request.contextPath}/assets/image/Banner/BannerRight2.jpg" alt="Banner Phụ 2">
                        </a>
                    </div>
                </div>
                <div class="banner-bottom">
                    <a href="${pageContext.request.contextPath}/search?cid=6">
                        <img src="${pageContext.request.contextPath}/assets/image/Banner/BannerKinhte.jpg" alt="Small 1">
                    </a>
                    <a href="${pageContext.request.contextPath}/search?cid=1">
                        <img src="${pageContext.request.contextPath}/assets/image/Banner/BannerVanHoc.jpg" alt="Small 2">
                    </a>
                    <a href="${pageContext.request.contextPath}/search?cid=36">
                        <img src="${pageContext.request.contextPath}/assets/image/Banner/BannerNgoaingu.jpg" alt="Small 3">
                    </a>
                    <a href="${pageContext.request.contextPath}/search?cid=34">
                        <img src="${pageContext.request.contextPath}/assets/image/Banner/LuyenthiTHPT.jpg" alt="Small 4">
                    </a>
                </div>
            </section>

            <%-- === FLASH SALE SECTION (CAROUSEL VERSION) === --%>
            <section class="flash-sale-section">
                <div class="container">
                    <div class="fs-header">
                        <div class="fs-header-left">
                            <div class="fs-title">
                                <i class="fa-solid fa-bolt"></i> FLASH SALE
                            </div>
                            <div class="fs-timer">
                                <span>Kết thúc trong</span>
                                <div class="timer-box">
                                    <span id="hours">02</span> : 
                                    <span id="minutes">15</span> : 
                                    <span id="seconds">45</span>
                                </div>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/flash-sale" class="fs-view-all">Xem tất cả <i class="fa-solid fa-chevron-right"></i></a>
                    </div>

                    <div class="fs-body">
                        <div class="fs-carousel-wrapper">
                            
                            <button class="fs-nav-btn prev-btn" id="fsPrevBtn" onclick="moveSlide(-1)">
                                <i class="fa-solid fa-chevron-left"></i>
                            </button>

                            <div class="fs-carousel-window">
                                <div class="fs-carousel-track" id="fsTrack">
                                    
                                    <c:forEach items="${flashSaleBooks}" var="b" begin="0" end="9">
                                        <div class="fs-card-item">
                                            <div class="fs-card-content">
                                                <div class="fs-image">
                                                    <a href="${pageContext.request.contextPath}/detail?pid=${b.id}">
                                                        <img src="${pageContext.request.contextPath}/${b.imageUrl}" 
                                                            alt="${b.title}" onerror="this.src='https://placehold.co/200x300?text=No+Image'">
                                                    </a>
                                                    <div class="fs-discount-badge">-50%</div>
                                                </div>
                                                
                                                <div class="fs-info">
                                                    <a href="${pageContext.request.contextPath}/detail?pid=${b.id}" class="fs-name">
                                                        ${b.title}
                                                    </a>
                                                    
                                                    <div class="fs-price">
                                                        <span class="price-new">
                                                            <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                        </span>
                                                        <span class="price-old">
                                                            <fmt:formatNumber value="${b.price * 2}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                        </span>
                                                    </div>

                                                    <div class="fs-progress-bar">
                                                        <c:if test="${b.stockQuantity lt 10}">
                                                            <div class="progress-fill" style="width: 90%;"></div>
                                                        </c:if>

                                                        <c:if test="${b.stockQuantity ge 10}">
                                                            <div class="progress-fill" style="width: 40%;"></div>
                                                        </c:if>
                                                        <span class="progress-text">Đã bán ${b.stockQuantity lt 10 ? 'gần hết' : '12'}</span>
                                                        <c:if test="${b.stockQuantity lt 10}">
                                                            <img src="https://deo.shopeemobile.com/shopee/shopee-pcmall-live-sg/flashsale/ac7f81d9ee062223753413c2f305c304.png" class="fire-icon" alt="hot">
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>

                                </div>
                            </div>

                            <button class="fs-nav-btn next-btn" id="fsNextBtn" onclick="moveSlide(1)">
                                <i class="fa-solid fa-chevron-right"></i>
                            </button>

                        </div>
                    </div>
                </div>
            </section>

            <%-- === CATEGORY SECTION === --%>
            <section class="category-section">
                <div class="container">
                    <div class="cat-header">
                        <i class="fa-solid fa-border-all"></i> Danh mục sản phẩm
                    </div>

                    <div class="cat-list">
                        <c:forEach items="${listCategories}" var="c">
                            <a href="${pageContext.request.contextPath}/search?cid=${c.id}" class="cat-item">
                                <div class="cat-image">
                                    <c:if test="${not empty c.imageUrl}">
                                        <img src="${pageContext.request.contextPath}/${c.imageUrl}" alt="${c.name}">
                                    </c:if>
                                    
                                    <c:if test="${empty c.imageUrl}">
                                        <img src="https://placehold.co/100x100?text=${c.name}" alt="${c.name}">
                                    </c:if>
                                </div>
                                <div class="cat-name">${c.name}</div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </section>

            <h2 style="border-left: 4px solid #C92127; padding-left: 10px; margin-bottom: 20px;">Sách Mới Nổi Bật</h2>
            
            <div class="book-list">
                <c:forEach items="${randomBooks}" var="b">
                    <div class="book-card">
                        <div class="book-image">
                            <a href="${pageContext.request.contextPath}/detail?pid=${b.id}">
                                <img src="${pageContext.request.contextPath}/${b.imageUrl}" 
                                     alt="${b.title}" onerror="this.src='https://placehold.co/200x300?text=No+Image'">
                            </a>
                        </div>
                        <div class="book-info">
                            <h3 class="book-title"><a href="${pageContext.request.contextPath}/detail?pid=${b.id}" style="text-decoration: none; color: #333;">${b.title}</a></h3>
                            <div class="book-price">
                                <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </div>
                            
                        </div>
                    </div>
                </c:forEach>
            </div>

            <jsp:include page="component/suggested-books.jsp" />
            <jsp:include page="component/footer.jsp" />
        </c:if>

    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
    // ==========================================
    // 1. SCRIPT ĐẾM NGƯỢC (COUNTDOWN)
    // ==========================================
    function startCountdown() {
        let endTime = new Date().getTime() + (3 * 60 * 60 * 1000); 

        let x = setInterval(function() {
            let now = new Date().getTime();
            let distance = endTime - now;

            let hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            let seconds = Math.floor((distance % (1000 * 60)) / 1000);

            hours = hours < 10 ? "0" + hours : hours;
            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;
            // Kiểm tra xem element có tồn tại không trước khi gán để tránh lỗi
            if(document.getElementById("hours")) {
                document.getElementById("hours").innerHTML = hours;
                document.getElementById("minutes").innerHTML = minutes;
                document.getElementById("seconds").innerHTML = seconds;
            }

            if (distance < 0) {
                clearInterval(x);
                if(document.getElementById("hours")) {
                    document.getElementById("hours").innerHTML = "00";
                    document.getElementById("minutes").innerHTML = "00";
                    document.getElementById("seconds").innerHTML = "00";
                }
            }
        }, 1000);
    }

    // ==========================================
    // 2. SCRIPT XỬ LÝ TRƯỢT (SLIDER LOGIC)
    // ==========================================
    
    // Khai báo biến toàn cục
    let currentSlide = 0;
    const itemsPerSlide = 5; // Hiển thị 5 cuốn 1 lần

    // Lấy tổng số sách từ Server (JSP) truyền vào biến JS
    const totalItems = parseInt('${flashSaleBooks != null ? flashSaleBooks.size() : 0}');
    function moveSlide(direction) {
        const track = document.getElementById('fsTrack');
        const nextBtn = document.getElementById('fsNextBtn');
        const prevBtn = document.getElementById('fsPrevBtn');

        // Nếu không tìm thấy element thì dừng lại (tránh lỗi console)
        if (!track || !nextBtn || !prevBtn) return;
        // Tính toán vị trí slide mới
        currentSlide += direction;
        // Giới hạn:
        // Max slide = Tổng số sách - Số sách hiển thị (Ví dụ: 10 - 5 = 5)
        // Nghĩa là chỉ cần trượt thêm 5 nấc là hết sách.
        const maxSlide = totalItems - itemsPerSlide;

        // Chặn không cho trượt quá đầu hoặc quá đuôi
        if (currentSlide < 0) currentSlide = 0;
        if (currentSlide > maxSlide) currentSlide = maxSlide;

        // Tính toán khoảng cách dịch chuyển (%)
        // Mỗi cuốn sách chiếm 20% chiều rộng (100% / 5 cuốn)
        // Dịch chuyển = Số thứ tự slide * 20%
        const translateValue = -(currentSlide * 20);
        // Thực hiện CSS Transform để trượt
        track.style.transform = "translateX(" + translateValue + "%)";
        // Ẩn hiện nút bấm thông minh
        // Nếu ở đầu (0) -> Ẩn nút Trái
        prevBtn.style.visibility = (currentSlide === 0) ? 'hidden' : 'visible';
        
        // Nếu ở cuối (maxSlide) -> Ẩn nút Phải
        nextBtn.style.visibility = (currentSlide >= maxSlide) ? 'hidden' : 'visible';
    }

    // ==========================================
    // 3. KHỞI CHẠY KHI TRANG LOAD XONG
    // ==========================================
    document.addEventListener('DOMContentLoaded', function() {
        // Chạy đồng hồ
        startCountdown();

        // Cấu hình Slider ban đầu
        const nextBtn = document.getElementById('fsNextBtn');
        const prevBtn = document.getElementById('fsPrevBtn');

        if (totalItems > itemsPerSlide) {
            // Nếu có nhiều sách hơn 5 cuốn -> Kích hoạt Slider
            moveSlide(0); 
        } else {
            // Nếu ít hơn hoặc bằng 5 cuốn -> Ẩn luôn 2 nút mũi tên đi
            if(nextBtn) nextBtn.style.display = 'none';
            if(prevBtn) prevBtn.style.display = 'none';
        }
    });
    </script>

    <style>
        .chat-widget-btn {
            position: fixed; bottom: 30px; right: 30px; width: 60px; height: 60px;
            border-radius: 50%; background: #1e74b6; color: white; display: flex;
            align-items: center; justify-content: center; font-size: 28px; cursor: pointer;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2); z-index: 9999; transition: transform 0.3s ease;
        }
        .chat-widget-btn:hover { transform: scale(1.1); }
        .chat-window {
            position: fixed; bottom: 100px; right: 30px; width: 350px; height: 480px;
            background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            display: none; flex-direction: column; z-index: 9999; overflow: hidden; font-family: Arial, sans-serif;
        }
        .chat-header { background: #1e74b6; color: white; padding: 15px; display: flex; align-items: center; justify-content: space-between; }
        .chat-header img { width: 45px; height: 45px; border-radius: 50%; border: 2px solid white; margin-right: 12px; object-fit: cover; }
        .chat-body { flex: 1; padding: 15px; overflow-y: auto; background: #f8f9fa; display: flex; flex-direction: column; gap: 12px; }
        .chat-message { max-width: 80%; padding: 10px 15px; border-radius: 18px; font-size: 14px; line-height: 1.4; }
        .chat-message.bot { background: white; color: black; align-self: flex-start; border-bottom-left-radius: 4px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .chat-message.user { background: #1e74b6; color: white; align-self: flex-end; border-bottom-right-radius: 4px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .chat-footer { padding: 12px; border-top: 1px solid #eee; background: white; display: flex; align-items: center; }
        .chat-footer input { flex: 1; border: none; outline: none; padding: 10px 15px; border-radius: 20px; background: #f1f1f1; margin-right: 10px; }
        .chat-footer button { background: none; border: none; color: #1e74b6; font-size: 22px; cursor: pointer; padding: 0 5px; }
        .chat-footer button:hover { color: #15558d; }
    </style>

    <div class="chat-widget-btn" onclick="toggleChat()"><i class="fa-solid fa-comment-dots"></i></div>

    <div class="chat-window" id="chatWindow">
        <div class="chat-header">
            <div class="d-flex align-items-center">
                <img src="https://ui-avatars.com/api/?name=Staff&background=ffffff&color=1e74b6" alt="Avatar">
                <div>
                    <h6 class="mb-0 fw-bold">BookStore Support</h6>
                    <small style="font-size: 12px; opacity: 0.9;">Chúng tôi có thể giúp gì cho bạn?</small>
                </div>
            </div>
            <i class="fa-solid fa-chevron-down" style="cursor: pointer; font-size: 20px;" onclick="toggleChat()"></i>
        </div>
        
        <div class="chat-body" id="chatBody">
            <div class="chat-message bot">Chào bạn, bạn đang tìm sách thể loại gì, mình tư vấn cho nhé? 😊</div>
        </div>
        
        <div class="chat-footer">
            <input type="text" id="chatInput" placeholder="Nhập tin nhắn..." onkeypress="handleKeyPress(event)">
            <button onclick="sendMessage()"><i class="fa-solid fa-paper-plane"></i></button>
        </div>
    </div>

    <script>
        function toggleChat() {
            const chatWindow = document.getElementById('chatWindow');
            if (chatWindow.style.display === 'flex') {
                chatWindow.style.display = 'none';
            } else {
                chatWindow.style.display = 'flex';
                document.getElementById('chatInput').focus();
            }
        }

        // --- ĐỊNH DANH KHÁCH HÀNG ---
        let customerName = "${sessionScope.user != null ? sessionScope.user.username : ''}";
        if (customerName === '') {
            // Nếu chưa đăng nhập, cấp cho họ 1 mã vãng lai ngẫu nhiên lưu vào máy
            customerName = localStorage.getItem('guestChatName');
            if (!customerName) {
                customerName = "Khách_" + Math.floor(Math.random() * 10000);
                localStorage.setItem('guestChatName', customerName);
            }
        }

        const wsUrl = "ws://" + window.location.host + "${pageContext.request.contextPath}/livechat";
        const websocket = new WebSocket(wsUrl);

        // Nhận tin từ Staff
        websocket.onmessage = function(event) {
            const chatBody = document.getElementById('chatBody');
            const data = event.data;
            if(data.startsWith("STAFF|||")) {
                const content = data.split("|||")[1];
                chatBody.innerHTML += '<div class="chat-message bot">' + content + '</div>';
                chatBody.scrollTop = chatBody.scrollHeight;
            }
        };

        // Gửi tin lên Server
        function sendMessage() {
            const input = document.getElementById('chatInput');
            const message = input.value.trim();
            const chatBody = document.getElementById('chatBody');

            if (message) {
                chatBody.innerHTML += '<div class="chat-message user">' + message + '</div>';
                chatBody.scrollTop = chatBody.scrollHeight;
                
                // Gửi theo chuẩn: CUST|||Tên|||Nội dung
                websocket.send("CUST|||" + customerName + "|||" + message);
                input.value = '';
            }
        }

        function handleKeyPress(e) {
            if (e.key === 'Enter') sendMessage();
        }
    </script>
    </body>
</html>