<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="main-header">
    <div class="container">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/home" style="text-decoration: none;">
                <span style="color: #C92127; font-weight: 900; font-size: 28px;">MIND</span><span style="color: #333; font-weight: 900; font-size: 28px;">BOOK</span>
            </a>
        </div>

        <div class="filter-wrapper">
            <div class="filter-trigger">
                <i class="fa-solid fa-filter"></i>
                <span>Bộ lọc sản phẩm</span>
                <i class="fa-solid fa-chevron-down" style="font-size: 12px;"></i>
            </div>

            <div class="filter-dropdown">
                <form action="${pageContext.request.contextPath}/search" method="get">
                    <input type="hidden" name="txt" value="${param.txt}">
                    <div class="filter-grid">
                        <div class="filter-group">
                            <h4><i class="fa-solid fa-tags"></i> Khoảng giá</h4>
                            <div class="price-inputs">
                                <input type="number" name="minPrice" placeholder="Từ (đ)" min="0">
                                <span>-</span>
                                <input type="number" name="maxPrice" placeholder="Đến (đ)" min="0">
                            </div>
                        </div>
                        <div class="filter-group">
                            <h4><i class="fa-solid fa-book"></i> Thể loại</h4>
                            <label class="checkbox-item"><input type="checkbox" name="cid" value="1"> Văn học</label>
                            <label class="checkbox-item"><input type="checkbox" name="cid" value="2"> Kinh tế</label>
                            <label class="checkbox-item"><input type="checkbox" name="cid" value="3"> Thiếu nhi</label>
                            <label class="checkbox-item"><input type="checkbox" name="cid" value="4"> Kỹ năng sống</label>
                        </div>
                        <div class="filter-group">
                            <h4><i class="fa-solid fa-layer-group"></i> Hình thức</h4>
                            <select name="format" class="filter-select">
                                <option value="">Tất cả</option>
                                <option value="hardcover">Bìa cứng</option>
                                <option value="paperback">Bìa mềm</option>
                                <option value="ebook">Ebook</option>
                            </select>
                            <h4 style="margin-top: 15px;"><i class="fa-solid fa-language"></i> Ngôn ngữ</h4>
                            <div class="radio-group">
                                <label><input type="radio" name="lang" value="vi" checked> Tiếng Việt</label>
                                <label><input type="radio" name="lang" value="en"> Tiếng Anh</label>
                            </div>
                        </div>
                        <div class="filter-group">
                            <h4><i class="fa-solid fa-arrow-up-wide-short"></i> Sắp xếp</h4>
                            <select name="sort" class="filter-select">
                                <option value="newest">Mới nhất</option>
                                <option value="price_asc">Giá: Thấp đến Cao</option>
                                <option value="price_desc">Giá: Cao đến Thấp</option>
                                <option value="name_asc">Tên: A-Z</option>
                            </select>
                            <h4 style="margin-top: 15px;"><i class="fa-solid fa-star"></i> Đánh giá</h4>
                            <label class="rating-option">
                                <input type="radio" name="rating" value="4"> 
                                <span style="color: #ffc107;">
                                    <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                                </span> trở lên
                            </label>
                        </div>
                    </div>
                    <div class="filter-actions">
                        <button type="reset" class="btn-reset">Đặt lại</button>
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
                        <div class="dropdown-header">
                            <span class="welcome-text">Xin chào,</span>
                            <span class="user-name">${sessionScope.user.username}</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/update-profile" class="dropdown-link">
                            <i class="fa-regular fa-id-card"></i> Hồ sơ của tôi
                        </a>

                        <c:if test="${sessionScope.user.role == 3}">
                            <hr style="border: 0; border-top: 1px solid #eee; margin: 5px 0;">
                            
                            <a href="${pageContext.request.contextPath}/staff/customers" style="color: #C92127; font-weight: bold;">
                                <i class="fa-solid fa-users-gear"></i> Hỗ trợ Khách hàng
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/staff/reviews" style="color: #C92127; font-weight: bold;">
                                <i class="fa-solid fa-comments"></i> Quản lý Đánh giá
                            </a>
                            
                            <hr style="border: 0; border-top: 1px solid #eee; margin: 5px 0;">
                        </c:if>
                        <a href="${pageContext.request.contextPath}/logout" class="dropdown-link logout-link">
                            <i class="fa-solid fa-power-off"></i> Đăng xuất
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</header>