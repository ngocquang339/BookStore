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
        
        /* CSS sửa lỗi banner */
        .banner-section { margin-bottom: 30px; }
        .banner-top { display: flex; gap: 10px; margin-bottom: 10px; }
        .banner-left { width: 66%; } .banner-left img { width: 100%; border-radius: 8px; }
        .banner-right { width: 33%; display: flex; flex-direction: column; gap: 10px; }
        .banner-right img { width: 100%; border-radius: 8px; }
        .banner-bottom { display: flex; gap: 10px; justify-content: space-between; }
        .banner-bottom img { width: 24%; border-radius: 8px; }
    </style>
</head>

<body class="${sessionScope.user != null && sessionScope.user.role == 1 ? 'admin-active' : ''}">
    <%-- KIỂM TRA QUYỀN VÀ HIỂN THỊ TOP BAR CHO ADMIN/SALE --%>
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
                    <a href="${pageContext.request.contextPath}/dashboard" style="background-color: #C92127; color: white; padding: 10px 20px; text-decoration: none; font-weight: bold; display: flex; align-items: center; transition: background-color 0.2s;">
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

    <%-- SỬA LỖI 2: Gộp tất cả vào 1 thẻ MAIN duy nhất --%>
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
                        <img src="${pageContext.request.contextPath}/assets/image/Banner/Screenshot 2026-01-19 150229.png" alt="Banner Chính">
                    </div>
                    <div class="banner-right">
                        <img src="${pageContext.request.contextPath}/assets/image/Banner/BannerRight1.jpg" alt="Banner Phụ 1">
                        <img src="${pageContext.request.contextPath}/assets/image/Banner/BannerRight2.jpg" alt="Banner Phụ 2">
                    </div>
                </div>
                <div class="banner-bottom">
                    <img src="${pageContext.request.contextPath}/assets/image/Banner/BannerBottom1.jpg" alt="Small 1">
                    <img src="${pageContext.request.contextPath}/assets/image/Banner/BannerBottom2.jpg" alt="Small 2">
                    <img src="${pageContext.request.contextPath}/assets/image/Banner/BannerBottom3.jpg" alt="Small 3">
                    <img src="${pageContext.request.contextPath}/assets/image/Banner/BannerBottom4.jpg" alt="Small 4">
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
                        <a href="#" class="fs-view-all">Xem tất cả <i class="fa-solid fa-chevron-right"></i></a>
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
                            <a href="${pageContext.request.contextPath}/add-to-cart?id=${b.id}" class="btn-buy">
                                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                            </a>
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
</body>
</html>