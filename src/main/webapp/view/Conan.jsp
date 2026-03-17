<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chuyên trang Thám Tử Lừng Danh Conan - MINDBOOK</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <style>
        /* TÔNG MÀU ĐẶC TRƯNG CỦA CONAN */
        :root {
            --conan-blue: #0f2027; /* Xanh vest đen bí ẩn */
            --conan-red: #C92127;  /* Đỏ nơ phá án */
            --conan-gold: #f1c40f; /* Vàng huy hiệu thám tử */
        }

        body {
            /* Dùng đúng link ảnh Banner đã chạy thành công + lệnh !important để chống bị đè CSS */
            background-image: url('${pageContext.request.contextPath}/assets/image/Banner/Kid.jpg') !important;
            
            background-size: cover !important;
            background-position: center top !important;
            background-attachment: fixed !important;
            background-repeat: no-repeat !important;
            
            /* Màu nền dự phòng nếu ảnh bị lỗi */
            background-color: #333 !important; 
            
            color: #fff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* KHỐI TIÊU ĐỀ (HERO SECTION) */
        .conan-hero {
            text-align: center;
            padding: 80px 20px;
            border-bottom: 3px solid var(--conan-red);
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            background: rgba(0, 0, 0, 0.3); /* Làm tối thêm phần chữ */
        }

        .quote {
            font-size: 2.5rem;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: #fff;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.8);
            margin-bottom: 15px;
        }

        .quote-highlight {
            color: var(--conan-red);
        }

        .sub-quote {
            font-size: 1.2rem;
            color: var(--conan-gold);
            font-style: italic;
            letter-spacing: 1px;
        }

        /* KHỐI HIỂN THỊ SÁCH */
        .conan-books-container {
            padding: 50px 0;
        }

        .section-title {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            font-size: 2rem;
            font-weight: bold;
            color: var(--conan-gold);
            margin-bottom: 40px;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.5);
        }

        /* Tùy chỉnh lại Card sản phẩm cho hợp tông màu đen/vàng/đỏ */
        .book-card {
            background-color: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            padding: 15px;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px); /* Hiệu ứng kính mờ */
            text-align: center;
            height: 100%;
        }

        .book-card:hover {
            transform: translateY(-10px);
            border-color: var(--conan-red);
            box-shadow: 0 10px 20px rgba(201, 33, 39, 0.4); /* Phát sáng màu đỏ */
        }

        .book-card img {
            width: 100%;
            height: 250px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .book-title {
            font-size: 16px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 10px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .book-price {
            font-size: 18px;
            font-weight: bold;
            color: var(--conan-gold);
            margin-bottom: 15px;
        }

        .btn-conan {
            background-color: var(--conan-red);
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 25px; /* Bo tròn trịa như chiếc huy hiệu */
            font-weight: bold;
            transition: 0.3s;
            width: 100%;
        }

        .btn-conan:hover {
            background-color: #a01a1f;
            color: #fff;
            transform: scale(1.05);
        }

        /* =========================================
           GHI ĐÈ CSS CHO HEADER RIÊNG TRANG CONAN
           ========================================= */

        /* 1. Nền Header: Đổi thành dải Gradient xanh đen (hợp với Conan) */
        header.main-header {
            background: linear-gradient(to right, rgba(15, 32, 39, 0.95), rgba(44, 83, 100, 0.95)) !important;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1) !important;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5) !important;
        }

        /* 2. Logo: Chữ "MIND" vẫn giữ màu đỏ, đổi chữ "BOOK" thành màu trắng */
        header.main-header .logo a span:last-child {
            color: #ffffff !important;
        }

        /* 3. Nút "Bộ lọc tìm kiếm": Đổi nền trắng thành nền kính mờ trong suốt */
        header.main-header .filter-trigger {
            background-color: rgba(255, 255, 255, 0.1) !important;
            border-color: rgba(255, 255, 255, 0.2) !important;
            color: #ffffff !important;
            backdrop-filter: blur(5px);
        }
        header.main-header .filter-trigger i.fa-chevron-down {
            color: #cccccc !important; /* Mũi tên xám nhạt */
        }

        /* 4. Thanh tìm kiếm: Nền mờ, viền mờ, chữ trắng */
        header.main-header .search-box form {
            background-color: rgba(255, 255, 255, 0.1) !important;
            border-color: rgba(255, 255, 255, 0.2) !important;
        }
        header.main-header .search-box input {
            background-color: transparent !important;
            color: #ffffff !important;
        }
        header.main-header .search-box input::placeholder {
            color: #bbbbbb !important; /* Chữ placeholder mờ đi một chút */
        }

        /* 5. Cụm Icon bên phải (Chuông, Giỏ hàng, Tài khoản) */
        /* Dùng dấu '>' để CHỈ tác động tới thẻ nằm ngay ngoài cùng, không làm tàng hình chữ trong Dropdown */
        header.main-header .header-icons > .icon-item > i,
        header.main-header .header-icons > .icon-item > span:not(.badge),
        header.main-header .header-icons > a.icon-item > i,
        header.main-header .header-icons > a.icon-item > span {
            color: #ffffff !important;
        }
        /* =========================================
           GHI ĐÈ CSS CHO FOOTER RIÊNG TRANG CONAN
           ========================================= */

        /* 1. Nền Footer: Phủ dải gradient xanh đen đồng bộ với Header */
        footer.site-footer {
            background: linear-gradient(to right, rgba(15, 32, 39, 0.95), rgba(44, 83, 100, 0.95)) !important;
            border-top: 3px solid var(--conan-red) !important; /* Viền đỏ rực rỡ hơn */
            color: #e0e0e0 !important;
            margin-top: 0 !important; /* Tùy chỉnh khoảng cách nếu cần */
            box-shadow: 0 -5px 20px rgba(0, 0, 0, 0.5) !important;
        }

        /* 2. Tiêu đề các cột: Đổi sang màu Trắng để nổi bật trên nền tối */
        footer.site-footer .footer-col h4 {
            color: #ffffff !important;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.5);
        }

        /* 3. Chữ thường và các đường link: Chuyển sang màu xám sáng */
        footer.site-footer .footer-contact p,
        footer.site-footer .footer-contact span,
        footer.site-footer .footer-col ul li a,
        footer.site-footer .footer-bottom div,
        footer.site-footer .footer-bottom span {
            color: #cccccc !important;
        }

        /* 4. Hiệu ứng Hover Link: Di chuột vào đổi sang màu Vàng Conan thay vì Đỏ */
        footer.site-footer .footer-col ul li a:hover {
            color: var(--conan-gold) !important;
            text-shadow: 0 0 5px rgba(241, 196, 15, 0.5);
        }

        /* 5. Chữ MINDBOOK to ở Footer: Cho thành màu đỏ Conan + phát sáng */
        footer.site-footer .footer-contact div:first-child {
            color: var(--conan-red) !important;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.8);
        }

        /* 6. Form đăng ký nhận tin: Ô nhập liệu làm kính mờ */
        footer.site-footer .newsletter-box input {
            background-color: rgba(255, 255, 255, 0.1) !important;
            color: #ffffff !important;
            border: 1px solid rgba(255, 255, 255, 0.3) !important;
        }
        footer.site-footer .newsletter-box input::placeholder {
            color: #aaaaaa !important;
        }
        /* Giữ nguyên màu đỏ của nút Đăng ký, không cần ghi đè */

        /* 7. Icon Mạng xã hội: Nền kính mờ, di chuột vào hóa Đỏ */
        footer.site-footer .footer-social a {
            background-color: rgba(255, 255, 255, 0.1) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            color: #ffffff !important;
        }
        footer.site-footer .footer-social a:hover {
            background-color: var(--conan-red) !important;
            border-color: var(--conan-red) !important;
            color: #ffffff !important;
            box-shadow: 0 0 10px var(--conan-red);
        }

        /* 8. Viền kẻ ngang dưới cùng: Làm mờ đi cho tinh tế */
        footer.site-footer .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.1) !important;
        }

        /* =========================================
           GHI ĐÈ CSS CHO DROPDOWN BỘ LỌC & TÀI KHOẢN
           ========================================= */

        /* 1. Nền của tất cả các bảng Dropdown (Bộ lọc, Tài khoản, Thông báo) */
        header .filter-dropdown,
        header .dropdown-content,
        header .dropdown-menu {
            background: linear-gradient(135deg, rgba(15, 32, 39, 0.98), rgba(44, 83, 100, 0.98)) !important;
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.7) !important;
            backdrop-filter: blur(10px);
        }

        /* -------------------------------------
           A. DROPDOWN BỘ LỌC TÌM KIẾM
           ------------------------------------- */
        /* Tiêu đề các cột (Khoảng giá, Thể loại, Sắp xếp...) */
        header .filter-group h4 {
            color: #ffffff !important;
        }
        
        /* Ô nhập giá và ô Select sắp xếp */
        header .price-inputs input,
        header .filter-select {
            background-color: rgba(255, 255, 255, 0.1) !important;
            color: #ffffff !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
        }
        header .filter-select option {
            background-color: #0f2027; /* Nền tối cho các option bên trong select */
            color: #fff;
        }
        header .price-inputs input::placeholder {
            color: #aaaaaa !important;
        }
        /* Dấu trừ (-) giữa 2 ô giá */
        header .price-inputs span {
            color: #ffffff !important;
        }

        /* Danh sách thể loại */
        header .category-item .cat-name {
            color: #cccccc !important;
        }
        header .category-item:hover .cat-name {
            background-color: rgba(255, 255, 255, 0.1) !important;
            color: #ffffff !important;
        }
        header .category-item input[type="radio"]:checked + .cat-name {
            background-color: rgba(201, 33, 39, 0.2) !important; /* Nền đỏ đen mờ */
            color: #ff6b6b !important; /* Đỏ sáng hơn chút cho dễ đọc */
        }
        
        /* Nút Đặt lại thiết lập */
        header .btn-reset {
            color: #cccccc !important;
        }
        header .btn-reset:hover {
            color: #ffffff !important;
        }
        
        /* Kẻ viền ngang khu vực nút bấm */
        header .filter-actions {
            border-top: 1px dashed rgba(255, 255, 255, 0.2) !important;
        }

        /* -------------------------------------
           B. DROPDOWN TÀI KHOẢN & THÔNG BÁO
           ------------------------------------- */
        /* Màu chữ chung cho các link bên trong Dropdown */
        header .dropdown-content a,
        header .dropdown-menu .dropdown-item {
            color: #e0e0e0 !important;
        }
        /* Hover vào các mục trong tài khoản/thông báo */
        header .dropdown-content a:hover,
        header .dropdown-menu .dropdown-item:hover {
            background-color: rgba(255, 255, 255, 0.1) !important;
            color: #ffffff !important;
        }

        /* Xử lý phần nền sáng cứng đầu của Thông báo và Tài khoản (khi đã login) */
        header .dropdown-menu li,
        header .dropdown-content .bg-light {
            background-color: transparent !important;
            border-color: rgba(255, 255, 255, 0.1) !important;
        }
        
        /* Chữ "Thông báo của bạn", "Xem tất cả", Tên User */
        header .dropdown-menu li[style*="background"],
        header .dropdown-content .text-dark {
            background-color: rgba(0, 0, 0, 0.3) !important;
            color: #ffffff !important;
        }

        /* =========================================
           SỬA LỖI ICON TÀI KHOẢN VÀ NÚT ĐĂNG NHẬP/ĐĂNG KÝ
           ========================================= */

        /* 1. Ép buộc icon và chữ "Tài khoản" thành màu trắng */
        header.main-header .icon-item.user-account > a,
        header.main-header .icon-item.user-account > a > i,
        header.main-header .icon-item.user-account > a > span {
            color: #ffffff !important;
        }

        /* 2. Nút Đăng Nhập: Đỏ Conan nguyên bản */
        header .dropdown-content .btn-auth-login {
            background-color: var(--conan-red) !important;
            color: #ffffff !important;
            border: 1px solid var(--conan-red) !important;
            transition: all 0.3s ease;
        }
        header .dropdown-content .btn-auth-login:hover {
            background-color: #a01a1f !important; /* Đỏ sậm hơn khi di chuột */
            border-color: #a01a1f !important;
            box-shadow: 0 4px 10px rgba(201, 33, 39, 0.4) !important;
        }

        /* 3. Nút Đăng Ký: Nền kính mờ, viền và chữ Vàng Conan (Cực kỳ nổi bật) */
        header .dropdown-content .btn-auth-register {
            background-color: rgba(255, 255, 255, 0.05) !important;
            color: var(--conan-gold) !important;
            border: 1px solid var(--conan-gold) !important;
            transition: all 0.3s ease;
        }
        header .dropdown-content .btn-auth-register:hover {
            background-color: var(--conan-gold) !important;
            color: #0f2027 !important; /* Chữ hóa đen khi di chuột vào nền vàng */
            box-shadow: 0 4px 10px rgba(241, 196, 15, 0.3) !important;
        }
        /* Ép cụm Tài khoản tụt xuống một chút để thẳng hàng với Thông báo và Giỏ hàng */
        header.main-header .icon-item.user-account {
            transform: translateY(4px) !important; /* Bạn có thể tăng/giảm con số 3px này để căn cho chuẩn nhất với mắt bạn nhé */
        }
    </style>
</head>
<body>

    <jsp:include page="component/header.jsp"/>

    <div class="conan-hero">
        <i class="fa-solid fa-magnifying-glass" style="font-size: 40px; color: var(--conan-red); margin-bottom: 20px;"></i>
        <div class="quote">Sự thật luôn chỉ có <span class="quote-highlight">một!</span></div>
        <div class="sub-quote">"Dù hung thủ có tài tình che giấu đến đâu, dấu vết vẫn luôn hiển hiện..."</div>
    </div>

    <div class="container conan-books-container">
        
        <div class="section-title">
            <i class="fa-solid fa-book-journal-whills"></i>
            TỦ SÁCH PHÁ ÁN
            <i class="fa-solid fa-fingerprint"></i>
        </div>

        <div class="row g-4">
            <%-- GIẢ SỬ BẠN TRUYỀN MỘT LIST CÁC TẬP CONAN TỪ SERVLET SANG VỚI TÊN 'conanList' --%>
            <c:choose>
                <c:when test="${not empty conanList}">
                    <c:forEach var="book" items="${conanList}">
                        <div class="col-md-3 col-sm-6">
                            <div class="book-card">
                                <a href="${pageContext.request.contextPath}/detail?pid=${book.id}" class="text-decoration-none">
                                    <img src="${pageContext.request.contextPath}/${book.imageUrl}" alt="${book.title}" onerror="this.src='https://placehold.co/200x300?text=Conan'">
                                    <div class="book-title">${book.title}</div>
                                </a>
                                <div class="book-price">
                                    <fmt:formatNumber value="${book.price}" type="currency" currencySymbol="₫"/>
                                </div>
                                
                                <button type="button" class="btn-conan" onclick="addToCartAjaxConan(${book.id})">
                                    <i class="fa-solid fa-cart-plus"></i> Đưa vào tầm ngắm
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                
                <%-- NẾU CHƯA CÓ DATA TỪ SERVLET, HIỂN THỊ TẠM VÀI CUỐN DEMO --%>
                <c:otherwise>
                    <div class="col-md-3 col-sm-6">
                        <div class="book-card">
                            <img src="https://salt.tikicdn.com/cache/w1200/ts/product/b6/ec/ab/c7ab216b251bd4c2d3a393e1dc240e94.jpg" alt="Conan Tập 100">
                            <div class="book-title">Thám Tử Lừng Danh Conan - Tập 100</div>
                            <div class="book-price">20.000 ₫</div>
                            <button class="btn-conan"><i class="fa-solid fa-cart-plus"></i> Đưa vào tầm ngắm</button>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="book-card">
                            <img src="https://salt.tikicdn.com/cache/w1200/ts/product/58/a3/14/ee97ed6b7b2af084dc91a5cc71adab4d.jpg" alt="Conan Tập 99">
                            <div class="book-title">Thám Tử Lừng Danh Conan - Tập 99</div>
                            <div class="book-price">20.000 ₫</div>
                            <button class="btn-conan"><i class="fa-solid fa-cart-plus"></i> Đưa vào tầm ngắm</button>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="book-card">
                            <img src="https://salt.tikicdn.com/cache/w1200/ts/product/d0/bd/56/6dd8996b7f14b62db80d2b6dbdf19e07.jpg" alt="Conan Kẻ Hành Pháp">
                            <div class="book-title">Conan - Kẻ Hành Pháp Zero</div>
                            <div class="book-price">45.000 ₫</div>
                            <button class="btn-conan"><i class="fa-solid fa-cart-plus"></i> Đưa vào tầm ngắm</button>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="book-card">
                            <img src="https://salt.tikicdn.com/cache/w1200/ts/product/d2/3f/8a/1638e8ec7fb3710bf30248cb962fc62a.png" alt="Conan Tập 101">
                            <div class="book-title">Thám Tử Lừng Danh Conan - Tập 101</div>
                            <div class="book-price">20.000 ₫</div>
                            <button class="btn-conan"><i class="fa-solid fa-cart-plus"></i> Đưa vào tầm ngắm</button>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <jsp:include page="component/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hàm rút gọn xài AJAX thêm vào giỏ hàng riêng cho trang này
        function addToCartAjaxConan(bookId) {
            let url = "${pageContext.request.contextPath}/add-to-cart?id=" + bookId + "&quantity=1&ajax=true";
            fetch(url)
            .then(response => response.text())
            .then(cartSize => {
                let cartBadge = document.getElementById("cartTotal");
                if (cartBadge) { cartBadge.innerText = cartSize; }
                alert("Đã bắt giữ thành công vào giỏ hàng! 🕵️‍♂️");
            })
            .catch(err => console.log("Lỗi:", err));
        }
    </script>
</body>
</html>