    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%
        com.group2.bookstore.model.User currentUser = (com.group2.bookstore.model.User) session.getAttribute("user");
        int unreadCount = 0;
        java.util.List<com.group2.bookstore.model.Notification> notifList = new java.util.ArrayList<>();
        
        if (currentUser != null) {
            com.group2.bookstore.dal.NotificationDAO notifDAO = new com.group2.bookstore.dal.NotificationDAO();
            unreadCount = notifDAO.getUnreadCount(currentUser.getId());
            notifList = notifDAO.getTopNotifications(currentUser.getId(), 10); // Lấy 10 cái mới nhất
        }
        request.setAttribute("unreadCount", unreadCount);
        request.setAttribute("notifList", notifList);
    %>
    <style>
        /* Ensure the header is fixed and transitions smoothly */
        .header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
            background-color: #fff;
            transition: transform 0.4s ease-in-out, box-shadow 0.3s;
            /* Adjust this box-shadow to match your current design */
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
            /* This class will be added by JavaScript when the user scrolls down */
            .header.header-hidden {
                transform: translateY(-100%);
            }

            /* TIÊU ĐỀ CÁC CỘT */
            .filter-group h4 {
                font-size: 15px;
                font-weight: 700;
                color: #333;
                margin-bottom: 15px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .filter-group h4 i {
                color: #C92127;
                /* Màu đỏ thương hiệu cho icon */
            }

            /* 1. KHOẢNG GIÁ */
            .price-inputs {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .price-inputs input {
                width: 100%;
                padding: 10px 15px;
                border: 1px solid #ddd;
                border-radius: 8px;
                outline: none;
                font-size: 14px;
                transition: 0.3s;
            }

            .price-inputs input:focus {
                border-color: #C92127;
                box-shadow: 0 0 0 3px rgba(201, 33, 39, 0.1);
            }

            /* 2. THỂ LOẠI - MA THUẬT ẨN RADIO NẰM Ở ĐÂY */
            .category-list {
                display: flex;
                flex-direction: column;
                gap: 4px;
            }

            .category-item {
                cursor: pointer;
                display: block;
            }

            .category-item input[type="radio"] {
                display: none;
                /* ẨN HOÀN TOÀN Ô TRÒN RADIO */
            }

            .category-item .cat-name {
                display: block;
                padding: 8px 10px;
                color: #555;
                font-size: 14px;
                border-radius: 6px;
                transition: all 0.3s ease;
                /* Chuyển động mượt */
                position: relative;
            }

            /* HIỆU ỨNG HOVER (DI CHUỘT) */
            .category-item:hover .cat-name {
                color: #C92127;
                transform: translateX(6px);
                /* Dịch chuyển sang phải 6px */
                background-color: #fdf5f5;
                /* Nền đỏ cực nhạt */
            }

            /* HIỆU ỨNG KHI ĐƯỢC CHỌN (CLICK VÀO) */
            .category-item input[type="radio"]:checked+.cat-name {
                color: #C92127;
                font-weight: 700;
                background-color: #fcebeb;
            }

            .category-item input[type="radio"]:checked+.cat-name::before {
                content: '';
                position: absolute;
                left: 0;
                top: 15%;
                height: 70%;
                width: 3px;
                background-color: #C92127;
                border-radius: 4px;
            }

            /* 3. SẮP XẾP & SELECT */
            .filter-select {
                width: 100%;
                padding: 10px 15px;
                border: 1px solid #ddd;
                border-radius: 8px;
                outline: none;
                font-size: 14px;
                color: #333;
                cursor: pointer;
                transition: 0.3s;
                appearance: auto;
            }

            .filter-select:hover {
                border-color: #C92127;
            }

            /* NÚT BẤM (BUTTONS) */
            .filter-actions {
                display: flex;
                justify-content: flex-end;
                gap: 15px;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px dashed #eee;
            }

            .btn-reset {
                background: transparent;
                border: none;
                color: #777;
                font-weight: 600;
                cursor: pointer;
                padding: 10px 20px;
                transition: 0.3s;
            }

            .btn-reset:hover {
                color: #333;
                text-decoration: underline;
            }

            .btn-apply {
                background: #C92127;
                color: white;
                border: none;
                padding: 10px 30px;
                border-radius: 8px;
                font-weight: bold;
                cursor: pointer;
                box-shadow: 0 4px 10px rgba(201, 33, 39, 0.3);
                transition: 0.3s;
            }

            .btn-apply:hover {
                background: #a91b21;
                transform: translateY(-2px);
                /* Hiệu ứng nút nảy lên */
                box-shadow: 0 6px 15px rgba(201, 33, 39, 0.4);
            }

            /* XÂY CÂY CẦU TÀNG HÌNH NỐI DROPDOWN VỚI NÚT BẤM */
            .filter-dropdown::before {
                content: '';
                position: absolute;
                top: -15px;
                /* Kéo cây cầu dịch lên trên lấp kín khoảng hở 10px */
                left: 0;
                width: 100%;
                height: 15px;
                background: transparent;
                /* Tàng hình (trong suốt) */
            }
            /* Ép cụm Tài khoản tụt xuống một chút để thẳng hàng với Thông báo và Giỏ hàng */
        header.main-header .icon-item.user-account {
            transform: translateY(4px) !important; /* Bạn có thể tăng/giảm con số 3px này để căn cho chuẩn nhất với mắt bạn nhé */
        }
        </style>


    <header class="main-header">
        <div class="container" style="display: flex; align-items: center; gap: 20px; justify-content: space-between;">
            
            <div class="logo">
                <a href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
                    <span style="color: #C92127; font-weight: 900; font-size: 28px;">MIND</span><span style="color: #333; font-weight: 900; font-size: 28px;">BOOK</span>
                </a>
            </div>

            <div class="filter-wrapper" style="position: relative;">
                <div class="filter-trigger" style="cursor: pointer; display: inline-flex; align-items: center; gap: 8px; padding: 10px 20px; border: 1px solid #ddd; border-radius: 8px; background: white; font-weight: 600; color: #333;">
                    <i class="fa-solid fa-filter" style="color: #C92127;"></i>
                    <span>Bộ lọc tìm kiếm</span>
                    <i class="fa-solid fa-chevron-down" style="font-size: 12px; color: #777;"></i>
                </div>

                <div class="filter-dropdown">
                    <form action="${pageContext.request.contextPath}/search" method="get">
                        <input type="hidden" name="txt" value="${param.txt}">

                        <div class="filter-grid" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 40px;">
                            
                            <div class="filter-group">
                                <h4><i class="fa-solid fa-tags"></i> Khoảng giá</h4>
                                <div class="price-inputs">
                                    <input type="number" name="minPrice" placeholder="Từ (đ)" min="0">
                                    <span style="color: #999;">-</span>
                                    <input type="number" name="maxPrice" placeholder="Đến (đ)" min="0">
                                </div>
                            </div>

                            <div class="filter-group">
                                <h4><i class="fa-solid fa-book"></i> Thể loại</h4>
                                <div class="category-list">
                                    <label class="category-item"><input type="radio" name="cid" value="" checked><span class="cat-name">Tất cả thể loại</span></label>
                                    <label class="category-item"><input type="radio" name="cid" value="1"><span class="cat-name">Văn học</span></label>
                                    <label class="category-item"><input type="radio" name="cid" value="6"><span class="cat-name">Kinh tế</span></label>
                                    <label class="category-item"><input type="radio" name="cid" value="11"><span class="cat-name">Kỹ năng sống</span></label>
                                    <label class="category-item"><input type="radio" name="cid" value="16"><span class="cat-name">Nuôi dạy con</span></label>
                                    <label class="category-item"><input type="radio" name="cid" value="21"><span class="cat-name">Sách thiếu nhi</span></label>
                                    <label class="category-item"><input type="radio" name="cid" value="26"><span class="cat-name">Tiểu sử - Hồi kí</span></label>
                                    <label class="category-item"><input type="radio" name="cid" value="31"><span class="cat-name">Giáo khoa - Tham khảo</span></label>
                                    <label class="category-item"><input type="radio" name="cid" value="36"><span class="cat-name">Ngoại ngữ</span></label>
                                </div>
                            </div>
                            
                            <div class="filter-group">
                                <h4><i class="fa-solid fa-arrow-up-wide-short"></i> Sắp xếp</h4>
                                <select name="sort" class="filter-select">
                                    <option value="newest">Mới nhất</option>
                                    <option value="price_asc">Giá: Thấp đến Cao</option>
                                    <option value="price_desc">Giá: Cao đến Thấp</option>
                                    <option value="title">Tên: A-Z</option>
                                </select>
                                
                                <h4 style="margin-top: 30px;"><i class="fa-solid fa-star"></i> Đánh giá</h4>
                                <label class="category-item" style="display: inline-block;">
                                    <input type="radio" name="rating" value="4"> 
                                    <span class="cat-name" style="padding: 5px 10px;">
                                        <span style="color: #ffc107; font-size: 13px;">
                                            <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                                        </span> 
                                        <span style="color: #555; margin-left: 5px;">trở lên</span>
                                    </span>
                                </label>
                            </div>
                        </div>
                        
                        <div class="filter-actions">
                            <button type="reset" class="btn-reset">Đặt lại thiết lập</button>
                            <button type="submit" class="btn-apply">Áp dụng bộ lọc</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="search-box" style="flex: 1;">
                <form action="search" method="get" style="display: flex; width: 100%; border: 1.5px solid #e0e0e0; border-radius: 8px; overflow: hidden; align-items: stretch;">
                    <input type="text" name="txt" placeholder="Tìm kiếm sách, tác giả..." value="${searchKeyword}" 
                           style="flex: 1; border: none; padding: 10px 15px; outline: none; font-size: 14px;">
                    
                    <button type="submit" 
                            style="background: #C92127; border: none; color: white; padding: 0 25px; cursor: pointer; transition: 0.2s;"
                            onmouseover="this.style.background='#a91b21'" 
                            onmouseout="this.style.background='#C92127'">
                        <i class="fa-solid fa-magnifying-glass" style="font-size: 16px;"></i>
                    </button>
                </form>
            </div>

            <div class="header-icons" style="display: flex; align-items: center; gap: 20px;">
                
                <div class="icon-item dropdown" style="position: relative; cursor: pointer; display: flex; flex-direction: column; align-items: center;" data-bs-toggle="dropdown">
                    <i class="fa-regular fa-bell" style="font-size: 20px;"></i>
                    <c:if test="${unreadCount > 0}">
                        <span class="position-absolute translate-middle badge rounded-pill bg-danger" 
                            style="top: 5px; right: -5px; font-size: 10px; padding: 3px 6px;">
                            ${unreadCount > 99 ? '99+' : unreadCount}
                        </span>
                    </c:if>
                    <span>Thông báo</span>
                    
                    <ul class="dropdown-menu dropdown-menu-end shadow-lg" style="width: 360px; max-height: 450px; overflow-y: auto; padding: 0; border: none;">
                        <li class="p-3 fw-bold border-bottom" style="background-color: #fcfcfc; position: sticky; top: 0; z-index: 10;">
                            <i class="fa-regular fa-bell me-2 text-danger"></i>Thông báo của bạn
                        </li>
                        
                        <c:choose>
                            <c:when test="${empty notifList}">
                                <li class="p-5 text-center text-muted" style="font-size: 14px;">
                                    <i class="fa-solid fa-box-open mb-2" style="font-size: 30px; opacity: 0.3;"></i><br>
                                    Bạn chưa có thông báo nào.
                                </li>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="n" items="${notifList}">
                                    <li style="border-bottom: 1px solid #f5f5f5;">
                                        <a class="dropdown-item px-3 py-3 d-flex align-items-start" 
                                        href="javascript:void(0);" 
                                        onclick="readAndRedirect(${n.id}, '${pageContext.request.contextPath}/${n.link}')"
                                        style="white-space: normal; transition: 0.2s; ${n.isRead ? 'background-color: #fff; opacity: 0.7;' : 'background-color: #f4faff;'}">
                                            
                                            <div class="mt-1 me-3 ${n.isRead ? 'text-secondary' : 'text-primary'}">
                                                <i class="fa-solid fa-comment-dots" style="font-size: 18px;"></i>
                                            </div>
                                            <div>
                                                <div style="font-size: 13.5px; color: #333; line-height: 1.4;">${n.message}</div>
                                                <div style="font-size: 11px; color: #999; margin-top: 5px;">
                                                    <i class="fa-regular fa-clock me-1"></i>
                                                    <fmt:formatDate value="${n.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        
                        <li class="p-3 text-center border-top" 
                            style="position: sticky; bottom: 0; background: #f9f9f9; cursor: pointer; transition: 0.2s;"
                            onmouseover="this.style.backgroundColor='#f0f0f0'"
                            onmouseout="this.style.backgroundColor='#f9f9f9'"
                            onclick="window.location.href='${pageContext.request.contextPath}/notifications'">
                            
                            <a href="${pageContext.request.contextPath}/notifications" 
                            class="text-primary text-decoration-none" 
                            style="font-size: 14px; font-weight: bold; display: block; width: 100%;"
                            onclick="event.preventDefault();">
                                Xem tất cả thông báo
                            </a>
                        </li>
                    </ul>
                </div>

                <a href="${pageContext.request.contextPath}/cart" class="icon-item" style="text-decoration: none; color: inherit; display: flex; flex-direction: column; align-items: center;">
                    <i class="fa-solid fa-cart-shopping" style="font-size: 20px;"></i>
                    <span>Giỏ hàng (<span id="cartTotal">${sessionScope.cart != null ? sessionScope.cart.size() : 0}</span>)</span>
                </a>
<div class="icon-item user-account">
                    <a href="${pageContext.request.contextPath}${sessionScope.user != null ? '/update-profile' : '/login'}" style="text-decoration: none; color: inherit; display: flex; flex-direction: column; align-items: center;">
                        <i class="fa-regular fa-user" style="font-size: 20px;"></i>
                        <span>Tài khoản</span>
                    </a>
                    <div class="dropdown-content">
                        <c:if test="${sessionScope.user == null}">
                            <div class="auth-buttons"></div>
                            <a href="${pageContext.request.contextPath}/login" class="btn-auth-login">Đăng nhập</a>
                            <a href="${pageContext.request.contextPath}/register" class="btn-auth-register">Đăng ký</a>
                        </c:if>

                        <c:if test="${sessionScope.user != null}">
                            <div class="px-3 py-2 text-center border-bottom mb-2 bg-light rounded-top">
                                <div class="fw-bold text-dark fs-6"><c:out value="${sessionScope.user.fullname}" /></div>
                                <small class="text-muted">
                                    <c:choose>
                                        <c:when test="${sessionScope.user.role == 1}"><span class="badge bg-danger">Quản trị viên</span></c:when>
                                        <c:when test="${sessionScope.user.role == 3}"><span class="badge bg-primary">Nhân viên Sale</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">Khách hàng</span></c:otherwise>
                                    </c:choose>
                                </small>
                            </div>

                            <a href="${pageContext.request.contextPath}/update-profile" class="dropdown-item py-2">
                                <i class="fa-regular fa-id-badge text-secondary me-2" style="width: 20px; text-align: center;"></i> Hồ sơ cá nhân
                            </a>
                            <a href="${pageContext.request.contextPath}/change-password" class="dropdown-item py-2">
                                <i class="fa-solid fa-key text-secondary me-2" style="width: 20px; text-align: center;"></i> Đổi mật khẩu
                            </a>

                            <hr class="dropdown-divider mt-2 mb-1">
                            
                            <a href="${pageContext.request.contextPath}/logout" class="dropdown-item py-2 text-danger fw-bold">
                                <i class="fa-solid fa-arrow-right-from-bracket me-2" style="width: 20px; text-align: center;"></i> Đăng xuất
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <script>
        let lastScrollTop = 0;
        const header = document.querySelector('header'); // Make sure your tag is <header>
        const scrollThreshold = 150; // Distance in pixels before hiding (length of a "section")

        window.addEventListener('scroll', function () {
            let currentScroll = window.pageYOffset || document.documentElement.scrollTop;

            // 1. Hide header if scrolling down beyond the threshold
            if (currentScroll > lastScrollTop && currentScroll > scrollThreshold) {
                header.classList.add('header-hidden');
            }

            // 2. Reappear header when scrolling back up to the top
            // Note: 'currentScroll <= 10' ensures it feels snappy when hitting the top
            if (currentScroll < lastScrollTop || currentScroll <= 10) {
                header.classList.remove('header-hidden');
            }

            lastScrollTop = currentScroll <= 0 ? 0 : currentScroll;
        }, false);
        function readAndRedirect(notifId, link) {
            // Gọi AJAX ngầm xuống server để đánh dấu Đã đọc
            fetch('${pageContext.request.contextPath}/notification', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=markRead&notifId=' + notifId
            }).then(res => {
                // Đánh dấu xong (hoặc kể cả lỗi) thì vẫn chuyển hướng người dùng đến đúng comment
                window.location.href = link;
            }).catch(err => {
                window.location.href = link;
            });
        }
    </script>