<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    /* BỐ CỤC TỔNG THỂ CỦA DROPDOWN */
    .filter-dropdown {
        background: #ffffff;
        border-radius: 12px;
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08); /* Bóng đổ mềm mại, sang trọng */
        border: 1px solid #f0f0f0;
        padding: 25px;
        margin-top: 10px;
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
        color: #C92127; /* Màu đỏ thương hiệu cho icon */
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
        display: none; /* ẨN HOÀN TOÀN Ô TRÒN RADIO */
    }
    .category-item .cat-name {
        display: block;
        padding: 8px 10px;
        color: #555;
        font-size: 14px;
        border-radius: 6px;
        transition: all 0.3s ease; /* Chuyển động mượt */
        position: relative;
    }
    /* HIỆU ỨNG HOVER (DI CHUỘT) */
    .category-item:hover .cat-name {
        color: #C92127;
        transform: translateX(6px); /* Dịch chuyển sang phải 6px */
        background-color: #fdf5f5; /* Nền đỏ cực nhạt */
    }
    /* HIỆU ỨNG KHI ĐƯỢC CHỌN (CLICK VÀO) */
    .category-item input[type="radio"]:checked + .cat-name {
        color: #C92127;
        font-weight: 700;
        background-color: #fcebeb;
    }
    .category-item input[type="radio"]:checked + .cat-name::before {
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
    .filter-select:hover { border-color: #C92127; }

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
    .btn-reset:hover { color: #333; text-decoration: underline; }
    
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
        transform: translateY(-2px); /* Hiệu ứng nút nảy lên */
        box-shadow: 0 6px 15px rgba(201, 33, 39, 0.4);
    }

    /* XÂY CÂY CẦU TÀNG HÌNH NỐI DROPDOWN VỚI NÚT BẤM */
    .filter-dropdown::before {
        content: '';
        position: absolute;
        top: -15px; /* Kéo cây cầu dịch lên trên lấp kín khoảng hở 10px */
        left: 0;
        width: 100%;
        height: 15px;
        background: transparent; /* Tàng hình (trong suốt) */
        /* background: red; Bạn có thể mở comment màu đỏ này để nhìn thấy cây cầu, hiểu nguyên lý rồi thì xóa màu đỏ đi */
    }
</style>
<header class="main-header">
    <div class="container">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
                <span style="color: #C92127; font-weight: 900; font-size: 28px;">MIND</span><span style="color: #333; font-weight: 900; font-size: 28px;">BOOK</span>
            </a>
        </div>

       <div class="filter-wrapper">
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
                        <label class="category-item">
                            <input type="radio" name="cid" value="" checked>
                            <span class="cat-name">Tất cả thể loại</span>
                        </label>
                        <label class="category-item">
                            <input type="radio" name="cid" value="1">
                            <span class="cat-name">Văn học</span>
                        </label>
                        <label class="category-item">
                            <input type="radio" name="cid" value="6">
                            <span class="cat-name">Kinh tế</span>
                        </label>
                        <label class="category-item">
                            <input type="radio" name="cid" value="11">
                            <span class="cat-name">Kỹ năng sống</span>
                        </label>
                        <label class="category-item">
                            <input type="radio" name="cid" value="16">
                            <span class="cat-name">Nuôi dạy con</span>
                        </label>
                        <label class="category-item">
                            <input type="radio" name="cid" value="21">
                            <span class="cat-name">Sách thiếu nhi</span>
                        </label>
                        <label class="category-item">
                            <input type="radio" name="cid" value="26">
                            <span class="cat-name">Tiểu sử - Hồi kí</span>
                        </label>
                        <label class="category-item">
                            <input type="radio" name="cid" value="31">
                            <span class="cat-name">Giáo khoa - Tham khảo</span>
                        </label>
                        <label class="category-item">
                            <input type="radio" name="cid" value="36">
                            <span class="cat-name">Ngoại ngữ</span>
                        </label>
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

        <div class="search-box">
            <form action="search" method="get" style="display: flex; width: 100%; position: relative;">
                <input type="text" name="txt" placeholder="Tìm kiếm sách, tác giả..." value="${searchKeyword}">
                <button type="submit" style="position: absolute; right: 0; top: 0; bottom: 0; background: #C92127; border: none; color: white; padding: 0 15px; border-radius: 0 4px 4px 0;">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
            </form>
        </div>

        <div class="header-icons">
            <div class="icon-item">
                <i class="fa-regular fa-bell"></i>
                <span>Thông báo</span>
            </div>

            <a href="${pageContext.request.contextPath}/cart" class="icon-item" style="text-decoration: none; color: inherit;">
                <i class="fa-solid fa-cart-shopping"></i>
                <span>Giỏ hàng (${sessionScope.cart != null ? sessionScope.cart.size() : 0})</span>
            </a>

            <div class="icon-item user-account">
                <i class="fa-regular fa-user"></i>
                <div class="account-info">
                    <a href="${pageContext.request.contextPath}/update-profile" style="text-decoration: none; color: inherit;">
                        <span class="account-label">Tài khoản</span>
                    </a>
                </div>

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

    <c:if test="${sessionScope.user.role == 3}">
        <hr class="dropdown-divider my-2">
        <h6 class="dropdown-header text-uppercase fw-bold text-primary px-3" style="font-size: 0.75rem; letter-spacing: 0.5px;">
            <i class="fa-solid fa-briefcase me-1"></i> Nghiệp vụ Sale
        </h6>
        
        <a href="${pageContext.request.contextPath}/staff/customers" class="dropdown-item py-2 fw-bold" style="color: #0d6efd;">
            <i class="fa-solid fa-users-viewfinder me-2" style="width: 20px; text-align: center;"></i> Hỗ trợ Khách hàng
        </a>
        
        <a href="${pageContext.request.contextPath}/staff/reviews" class="dropdown-item py-2 fw-bold" style="color: #ffc107;">
            <i class="fa-regular fa-comments me-2" style="width: 20px; text-align: center;"></i> Quản lý Đánh giá
        </a>
    </c:if>

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