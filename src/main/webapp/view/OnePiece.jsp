<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hành Trình Trở Thành Vua Hải Tặc - MINDBOOK</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    
    <style>
        /* TÔNG MÀU ĐẶC TRƯNG CỦA ONE PIECE */
        :root {
            --op-ocean: #005c97; /* Xanh đại dương */
            --op-dark-sea: #011f4b; /* Xanh biển sâu */
            --op-red: #d32f2f; /* Đỏ rực lửa */
            --op-gold: #ffca28; /* Vàng kho báu */
            --op-wood: #5d4037; /* Nâu gỗ tàu */
        }

        body {
            /* Lớp phủ màu Xanh biển sâu mờ 40%, bên dưới là ảnh nền One Piece */
            /* !!! LƯU Ý: TẢI ẢNH onepiece-bg.jpg VÀO THƯ MỤC Banner !!! */
            background-image: linear-gradient(rgba(1, 31, 75, 0.4), rgba(0, 92, 151, 0.4)), 
                              url('${pageContext.request.contextPath}/assets/image/Banner/OnepieceBackground.jpg') !important;
            background-size: cover !important;
            background-position: center center !important;
            background-attachment: fixed !important;
            background-repeat: no-repeat !important;
            background-color: var(--op-dark-sea) !important; 
            color: #fff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* KHỐI TIÊU ĐỀ (HERO SECTION) */
        .op-hero {
            text-align: center;
            padding: 80px 20px;
            border-bottom: 4px solid var(--op-gold);
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
            background: rgba(1, 31, 75, 0.6); /* Nền xanh biển trong suốt */
            backdrop-filter: blur(5px);
        }

        .quote {
            font-size: 2.8rem;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: #fff;
            text-shadow: 3px 3px 6px rgba(0,0,0,0.9);
            margin-bottom: 15px;
        }

        .quote-highlight {
            color: var(--op-gold);
            text-shadow: 0 0 10px rgba(255, 202, 40, 0.8);
        }

        .sub-quote {
            font-size: 1.3rem;
            color: #fff;
            font-style: italic;
            letter-spacing: 1px;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.8);
        }

        /* KHỐI HIỂN THỊ SÁCH */
        .op-books-container {
            padding: 60px 0;
        }

        .section-title {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            font-size: 2.2rem;
            font-weight: 900;
            color: var(--op-gold);
            margin-bottom: 40px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.7);
            text-transform: uppercase;
        }

        /* Card hiển thị kiểu Truy nã (Wanted Poster) cách điệu */
        .book-card {
            background-color: rgba(244, 228, 188, 0.1); /* Hơi ngả vàng giấy cũ */
            border: 2px solid rgba(255, 202, 40, 0.3);
            border-radius: 8px;
            padding: 15px;
            transition: all 0.3s ease;
            backdrop-filter: blur(8px); 
            text-align: center;
            height: 100%;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }

        .book-card:hover {
            transform: translateY(-10px);
            border-color: var(--op-gold);
            box-shadow: 0 10px 25px rgba(255, 202, 40, 0.4); 
            background-color: rgba(244, 228, 188, 0.2);
        }

        .book-card img {
            width: 100%;
            height: 250px;
            object-fit: cover;
            border-radius: 4px;
            margin-bottom: 15px;
            border: 2px solid var(--op-wood);
        }

        .book-title {
            font-size: 16px;
            font-weight: bold;
            color: #fff;
            margin-bottom: 10px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.8);
        }

        .book-price {
            font-size: 20px;
            font-weight: 900;
            color: var(--op-gold);
            margin-bottom: 15px;
            letter-spacing: 1px;
        }

        .btn-op {
            background-color: var(--op-red);
            color: #fff;
            border: 2px solid #b71c1c;
            padding: 10px 20px;
            border-radius: 4px; 
            font-weight: bold;
            text-transform: uppercase;
            transition: 0.3s;
            width: 100%;
            box-shadow: inset 0 -3px 0 rgba(0,0,0,0.2); /* Tạo cảm giác nút nổi 3D */
        }

        .btn-op:hover {
            background-color: #b71c1c;
            color: var(--op-gold);
            transform: scale(1.03);
        }

        /* =========================================
           ĐỒNG BỘ GIAO DIỆN HEADER, FOOTER, DROPDOWN
           (Ngả sang màu Xanh Đại Dương thay vì Đen Conan)
           ========================================= */
           
        /* Header & Footer */
        header.main-header, footer.site-footer {
            background: linear-gradient(to right, rgba(1, 31, 75, 0.95), rgba(0, 92, 151, 0.95)) !important;
            border-bottom: 2px solid var(--op-gold) !important;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.6) !important;
        }
        footer.site-footer { border-top: 3px solid var(--op-gold) !important; border-bottom: none !important;}
        
        /* Logo: Đổi chữ BOOK thành Vàng Kho Báu */
        header.main-header .logo a span:last-child { color: var(--op-gold) !important; }

        /* Các phần tử kính mờ trên Header */
        header.main-header .filter-trigger,
        header.main-header .search-box form {
            background-color: rgba(255, 255, 255, 0.15) !important;
            border-color: rgba(255, 255, 255, 0.2) !important;
        }
        header.main-header .search-box input { color: #ffffff !important; }
        header.main-header .search-box input::placeholder { color: #dddddd !important; }

        /* Icon Header trắng */
        header.main-header .header-icons > .icon-item > i,
        header.main-header .header-icons > .icon-item > span:not(.badge),
        header.main-header .header-icons > a.icon-item > i,
        header.main-header .header-icons > a.icon-item > span,
        header.main-header .filter-trigger {
            color: #ffffff !important;
        }

        /* Nút Đăng nhập / Đăng ký */
        header .dropdown-content .btn-auth-login { background-color: var(--op-red) !important; border-color: var(--op-red) !important; color: #fff !important;}
        header .dropdown-content .btn-auth-register { background-color: transparent !important; color: var(--op-gold) !important; border-color: var(--op-gold) !important;}
        header .dropdown-content .btn-auth-register:hover { background-color: var(--op-gold) !important; color: var(--op-dark-sea) !important;}

        /* Dropdown & Modal Nền Xanh Biển */
        header .filter-dropdown, header .dropdown-content, header .dropdown-menu {
            background: linear-gradient(135deg, rgba(1, 31, 75, 0.98), rgba(0, 92, 151, 0.98)) !important;
            border: 1px solid var(--op-gold) !important;
        }

        /* Tiêu đề Dropdown/Modal */
        header .filter-group h4 { color: var(--op-gold) !important; }
        header .price-inputs input, header .filter-select { background-color: rgba(255,255,255,0.1) !important; color: #fff !important; }
        header .category-item .cat-name, header .dropdown-content a, header .dropdown-menu .dropdown-item { color: #e0e0e0 !important; }
        header .category-item:hover .cat-name, header .dropdown-content a:hover, header .dropdown-menu .dropdown-item:hover { color: var(--op-gold) !important; background-color: rgba(255,255,255,0.1) !important; }
        header .category-item input[type="radio"]:checked + .cat-name { background-color: rgba(211, 47, 47, 0.3) !important; color: var(--op-gold) !important; }
        header .dropdown-menu li[style*="background"], header .dropdown-content .text-dark { background-color: rgba(0,0,0,0.4) !important; color: var(--op-gold) !important; }
        header .dropdown-menu li, header .dropdown-content .bg-light { background-color: transparent !important; border-color: rgba(255,255,255,0.1) !important; }
        
        /* Ghi đè chữ Footer */
        footer.site-footer .footer-col h4 { color: var(--op-gold) !important; }
        footer.site-footer .footer-contact p, footer.site-footer .footer-contact span, footer.site-footer .footer-col ul li a, footer.site-footer .footer-bottom div, footer.site-footer .footer-bottom span { color: #e0e0e0 !important; }
        footer.site-footer .footer-col ul li a:hover { color: var(--op-gold) !important; }
        footer.site-footer .footer-contact div:first-child { color: var(--op-gold) !important; }
        /* Sửa lỗi màu xám của cụm Tài khoản trên Header */
        header.main-header .icon-item.user-account > a,
        header.main-header .icon-item.user-account > a > i,
        header.main-header .icon-item.user-account > a > span {
            color: #ffffff !important;
        }
        /* Ép cụm Tài khoản tụt xuống một chút để thẳng hàng với Thông báo và Giỏ hàng */
        header.main-header .icon-item.user-account {
            transform: translateY(4px) !important; /* Bạn có thể tăng/giảm con số 3px này để căn cho chuẩn nhất với mắt bạn nhé */
        }
    </style>
</head>
<body>

    <jsp:include page="component/header.jsp"/>

    <div class="op-hero">
        <i class="fa-solid fa-skull-crossbones" style="font-size: 50px; color: var(--op-gold); margin-bottom: 20px;"></i>
        <div class="quote">TÔI SẼ TRỞ THÀNH <span class="quote-highlight">VUA HẢI TẶC!</span></div>
        <div class="sub-quote">"Kho báu của ta à? Nếu muốn các ngươi cứ lấy đi. Hãy ra biển mà tìm..."</div>
    </div>

    <div class="container op-books-container">
        <div class="section-title">
            <i class="fa-solid fa-anchor"></i>
            RƯƠNG BÁU CHUYÊN ĐỀ
            <i class="fa-solid fa-anchor"></i>
        </div>

        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty onepieceList}">
                    <c:forEach var="book" items="${onepieceList}">
                        <div class="col-md-3 col-sm-6">
                            <div class="book-card">
                                <a href="${pageContext.request.contextPath}/detail?pid=${book.id}" class="text-decoration-none">
                                    <img src="${pageContext.request.contextPath}/${book.imageUrl}" alt="${book.title}" onerror="this.src='https://placehold.co/200x300?text=One+Piece'">
                                    <div class="book-title">${book.title}</div>
                                </a>
                                <div class="book-price">
                                    <fmt:formatNumber value="${book.price}" type="currency" currencySymbol="₫"/>
                                </div>
                                <button type="button" class="btn-op" onclick="addToCartAjaxOP(${book.id})">
                                    <i class="fa-solid fa-box-archive"></i> Đưa lên tàu
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                
                <%-- SÁCH DEMO NẾU CHƯA CÓ DATA --%>
                <c:otherwise>
                    <div class="col-md-3 col-sm-6">
                        <div class="book-card">
                            <img src="https://salt.tikicdn.com/cache/w1200/ts/product/f4/35/03/f30d0752a78f237bbbc3de107ef4e578.jpg" alt="One Piece Tập 100">
                            <div class="book-title">One Piece - Tập 100: Haoshoku</div>
                            <div class="book-price">25.000 ₫</div>
                            <button class="btn-op"><i class="fa-solid fa-box-archive"></i> Đưa lên tàu</button>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="book-card">
                            <img src="https://salt.tikicdn.com/cache/w1200/ts/product/c9/a1/38/c1103c80a218d6e9dc7bc582cd111bf4.jpg" alt="One Piece Tập 101">
                            <div class="book-title">One Piece - Tập 101: Những Vì Sao Tiến Bước</div>
                            <div class="book-price">25.000 ₫</div>
                            <button class="btn-op"><i class="fa-solid fa-box-archive"></i> Đưa lên tàu</button>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="book-card">
                            <img src="https://salt.tikicdn.com/cache/w1200/ts/product/a5/d8/d6/331a989ef376bf51d5203ceb3e8e2c7a.png" alt="One Piece Color Walk">
                            <div class="book-title">One Piece Color Walk 9 - Tiger</div>
                            <div class="book-price">150.000 ₫</div>
                            <button class="btn-op"><i class="fa-solid fa-box-archive"></i> Đưa lên tàu</button>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="book-card">
                            <img src="https://salt.tikicdn.com/cache/w1200/ts/product/7d/51/1c/488bd3704ad5de3cb8e6de02b794f6f7.jpg" alt="One Piece Novel">
                            <div class="book-title">One Piece Novel A - Tập 2</div>
                            <div class="book-price">55.000 ₫</div>
                            <button class="btn-op"><i class="fa-solid fa-box-archive"></i> Đưa lên tàu</button>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <jsp:include page="component/footer.jsp"/>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function addToCartAjaxOP(bookId) {
            let url = "${pageContext.request.contextPath}/add-to-cart?id=" + bookId + "&quantity=1&ajax=true";
            fetch(url)
            .then(response => response.text())
            .then(cartSize => {
                let cartBadge = document.getElementById("cartTotal");
                if (cartBadge) { cartBadge.innerText = cartSize; }
                alert("Đã thu thập kho báu lên tàu thành công! 🏴‍☠️");
            })
            .catch(err => console.log("Lỗi:", err));
        }
    </script>
</body>
</html>