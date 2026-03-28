<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả tìm kiếm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
        /* CSS Cơ bản */
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f5f5; }
        .main-header { background: #fff; box-shadow: 0 2px 5px rgba(0,0,0,0.1); padding: 15px 0; margin-bottom: 20px; }
        
        /* =========================================
           1. LAYOUT CHÍNH (SIDEBAR + KẾT QUẢ)
           ========================================= */
        /* Giữ cho Sidebar và Cột kết quả nằm ngang nhau */
        .content-wrapper { 
            display: flex; 
            gap: 30px; 
            align-items: flex-start; 
        }
        /* Cột bên phải PHẢI có min-width: 0 để không bị tràn màn hình */
        .results-column { 
            flex: 1; 
            min-width: 0; 
        }

        /* =========================================
           2. KHUNG LƯỚI SẢN PHẨM (ÉP 5 CỘT)
           ========================================= */
        .book-list { 
            display: grid !important; 
            /* Ép buộc chia 5 cột, bất chấp nội dung bên trong to cỡ nào */
            grid-template-columns: repeat(5, minmax(0, 1fr)) !important; 
            gap: 15px !important; 
        }
        
        /* Thẻ bao ngoài từng cuốn sách */
        .product-card { 
            background: #fff; border: 1px solid #eee; border-radius: 8px; 
            padding: 12px; text-align: center; transition: 0.3s; height: 100%; 
            display: flex; flex-direction: column; justify-content: space-between; 
            position: relative; 
            /* min-width: 0 giúp thẻ sách chịu co lại khi lưới bị hẹp */
            min-width: 0 !important; 
            overflow: hidden; 
        }
        .product-card:hover { box-shadow: 0 5px 15px rgba(0,0,0,0.1); transform: translateY(-3px); }
        .product-card img { max-width: 100%; height: 180px; object-fit: contain; margin-bottom: 10px; }
        
        /* =========================================
           3. SIDEBAR STYLES (ĐÃ ĐƯỢC GIỮ NGUYÊN)
           ========================================= */
        .smart-sidebar { width: 280px; padding: 25px 20px; background: #ffffff; border-radius: 12px; box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06); border: 1px solid #f2f2f2; flex-shrink: 0; }
        .smart-sidebar h3 { margin-top: 0; color: #C92127; font-size: 18px; font-weight: 700; display: flex; align-items: center; gap: 8px; margin-bottom: 25px; position: relative; }
        .smart-sidebar h3::after { content: ''; position: absolute; bottom: -10px; left: 0; width: 40px; height: 3px; background: #C92127; border-radius: 2px; }
        .smart-filter-group { margin-bottom: 22px; }
        .smart-filter-group label { display: block; font-size: 13px; font-weight: 600; color: #555; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px; }
        .smart-input { width: 100%; padding: 10px 14px; background-color: #f9f9fc; border: 1.5px solid #e8e8ed; border-radius: 8px; font-size: 14px; color: #333; transition: all 0.3s ease; box-sizing: border-box; }
        .smart-input:hover { background-color: #ffffff; border-color: #d1d1d1; }
        .smart-input:focus { background-color: #ffffff; border-color: #C92127; box-shadow: 0 0 0 4px rgba(201, 33, 39, 0.1); outline: none; }
        select.smart-input { appearance: none; background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23777' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e"); background-repeat: no-repeat; background-position: right 12px center; background-size: 16px; padding-right: 40px; cursor: pointer; }
        .price-range-flex { display: flex; align-items: center; gap: 10px; }
        .price-range-flex span { color: #999; font-weight: bold; }
        .btn-smart-apply { width: 100%; background: #C92127; color: white; border: none; padding: 12px; border-radius: 8px; font-weight: bold; font-size: 15px; cursor: pointer; transition: all 0.3s ease; box-shadow: 0 4px 15px rgba(201, 33, 39, 0.25); margin-top: 10px; }
        .btn-smart-apply:hover { background: #a91b21; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(201, 33, 39, 0.35); }
        .btn-smart-clear { display: block; text-align: center; margin-top: 15px; color: #888; font-size: 14px; text-decoration: none; font-weight: 500; transition: 0.3s; }
        .btn-smart-clear:hover { color: #C92127; text-decoration: underline; }
        
        /* =========================================
           4. PHÂN TRANG VÀ BADGE
           ========================================= */
        .page-link:hover { background-color: #f8f9fa; border-color: #C92127 !important; color: #C92127 !important; transition: 0.3s; }
        .pagination .page-item.active .page-link:hover { background-color: #a01a1f !important; color: white !important; }
        .badge-hidden { position: absolute; top: 10px; right: 10px; background: rgba(0,0,0,0.7); color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px; z-index: 10; }
        .card-inactive { opacity: 0.6; border: 1px dashed #999; }
    </style>
</head>

<body>
    <jsp:include page="component/header.jsp" />

    <main class="container" style="max-width: 1200px; margin: 0 auto; padding: 0 15px;">

        <div class="content-wrapper" style="display: flex; gap: 30px; align-items: flex-start;">
            
            <%-- CỘT BÊN TRÁI: SIDEBAR BỘ LỌC --%>
            <div class="smart-sidebar">
                <h3><i class="fa-solid fa-filter"></i> Bộ lọc tìm kiếm</h3>
                
                <form action="${pageContext.request.contextPath}/search" method="get">
                    
                    <input type="hidden" name="txt" value="${txtS}">
                    
                    

                    <div class="smart-filter-group">
                        <label>Khoảng giá (VNĐ)</label>
                        <div class="price-range-flex">
                            <input type="number" name="minPrice" value="${minPrice}" placeholder="Từ..." min="0" class="smart-input">
                            <span>-</span>
                            <input type="number" name="maxPrice" value="${maxPrice}" placeholder="Đến..." min="0" class="smart-input">
                        </div>
                    </div>

                    <div class="smart-filter-group">
                        <label>Tác giả</label>
                        <input type="text" name="author" value="${author}" placeholder="Nhập tên tác giả..." class="smart-input">
                    </div>

                    <div class="smart-filter-group">
                        <label>Nhà xuất bản</label>
                        <select name="publisher" class="smart-input">
                            <option value="">Tất cả NXB</option>
                            <c:forEach items="${listPublishers}" var="p">
                                <option value="${p}" ${publisher == p ? 'selected' : ''}>${p}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="smart-filter-group">
                        <label>Sắp xếp theo</label>
                        <select name="sort" class="smart-input">
                            <option value="">Mặc định (Mới nhất)</option>
                            <option value="price" ${sort == 'price' ? 'selected' : ''}>Giá tiền</option>
                            <option value="title" ${sort == 'title' ? 'selected' : ''}>Tên sách (A-Z)</option>
                            <option value="stock_quantity" ${sort == 'stock_quantity' ? 'selected' : ''}>Số lượng tồn kho</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-smart-apply">
                        Áp dụng bộ lọc
                    </button>
                    
                    <a href="search?txt=${txtS}" class="btn-smart-clear">
                        Xóa bộ lọc
                    </a>
                </form>
            </div>

            <%-- CỘT BÊN PHẢI: KẾT QUẢ VÀ PHÂN TRANG --%>
            <div class="results-column" style="flex: 1;">
                <%-- TÌM VÀ ĐỊNH DẠNG TÊN THỂ LOẠI (Chỉ viết hoa chữ cái đầu) --%>
                <c:set var="selectedCatName" value="" />
                <c:if test="${cid > 0}">
                    <c:forEach var="cat" items="${listCategories}">
                        <c:if test="${cat.id == cid}">
                            <%-- Lấy tên gốc từ DB --%>
                            <c:set var="rawName" value="${cat.name}" />
                            <%-- Chuyển tất cả thành chữ thường: "ngoại ngữ" --%>
                            <c:set var="lowered" value="${fn:toLowerCase(rawName)}" />
                            <%-- Lấy chữ cái đầu và viết hoa: "N" --%>
                            <c:set var="firstChar" value="${fn:toUpperCase(fn:substring(lowered, 0, 1))}" />
                            <%-- Lấy phần còn lại: "goại ngữ" --%>
                            <c:set var="restChars" value="${fn:substring(lowered, 1, fn:length(lowered))}" />
                            <%-- Nối lại thành: "Ngoại ngữ" --%>
                            <c:set var="selectedCatName" value="${firstChar}${restChars}" />
                        </c:if>
                    </c:forEach>
                </c:if>

                <h3 style="margin-top: 0; margin-bottom: 20px;">
                    <c:choose>
                        <%-- 1. Nếu có gõ từ khóa tìm kiếm --%>
                        <c:when test="${not empty txtS}">
                            Kết quả tìm kiếm: <span style="color: #C92127">"${txtS}"</span>
                        </c:when>
                        
                        <%-- 2. Nếu không gõ từ khóa, nhưng có gõ Tác giả --%>
                        <c:when test="${not empty author}">
                            Sách của tác giả: <span style="color: #C92127">"${author}"</span>
                        </c:when>
                        
                        <%-- 3. Nếu lọc theo Nhà xuất bản --%>
                        <c:when test="${not empty publisher}">
                            Sách của NXB: <span style="color: #C92127">"${publisher}"</span>
                        </c:when>
                        
                        <%-- 4. NHÓM BỘ LỌC KẾT HỢP (THỂ LOẠI, GIÁ, SAO) --%>
                        <c:when test="${cid > 0 or not empty minPrice or not empty maxPrice or ratingFilter > 0}">
                            Kết quả lọc: 
                            <span style="color: #C92127">
                                <%-- In Thể loại --%>
                                <c:if test="${cid > 0}">
                                    Thể loại ${selectedCatName}
                                </c:if>
                                
                                <%-- Dấu phân cách nếu có Thể loại VÀ (Giá hoặc Sao) --%>
                                <c:if test="${cid > 0 and (not empty minPrice or not empty maxPrice or ratingFilter > 0)}">
                                    &nbsp;|&nbsp; 
                                </c:if>

                                <%-- In Khoảng Giá --%>
                                <c:if test="${not empty minPrice or not empty maxPrice}">
                                    Giá từ <fmt:formatNumber value="${empty minPrice ? 0 : minPrice}" type="number" pattern="#,###"/>đ 
                                    đến 
                                    <c:choose>
                                        <c:when test="${empty maxPrice}">trở lên</c:when>
                                        <c:otherwise><fmt:formatNumber value="${maxPrice}" type="number" pattern="#,###"/>đ</c:otherwise>
                                    </c:choose>
                                </c:if>
                                
                                <%-- Dấu phân cách nếu có Giá VÀ Sao --%>
                                <c:if test="${(not empty minPrice or not empty maxPrice) and ratingFilter > 0}">
                                    &nbsp;|&nbsp; 
                                </c:if>
                                
                                <%-- In Số Sao --%>
                                <c:if test="${ratingFilter > 0}">
                                    Từ ${ratingFilter} Sao <i class="fa-solid fa-star" style="font-size: 15px; margin-bottom: 2px;"></i>
                                </c:if>
                            </span>
                        </c:when>
                        
                        <%-- 5. Nếu không lọc gì cả (Xem toàn bộ sách) --%>
                        <c:otherwise>
                            Danh sách: <span style="color: #C92127">Tất cả sản phẩm</span>
                        </c:otherwise>
                    </c:choose>
                    
                    <span style="font-size: 14px; color: #666; font-weight: normal;">(Tìm thấy ${totalResult} sản phẩm)</span>
                </h3>

                <c:if test="${empty listBooks}">
                    <div class="empty-message" style="text-align: center; margin-top: 50px; background: white; padding: 40px; border-radius: 8px;">
                        <i class="fa-solid fa-magnifying-glass" style="font-size: 50px; color: #ddd; margin-bottom: 20px;"></i>
                        <p style="font-size: 18px; color: #666;">Rất tiếc, không tìm thấy cuốn sách nào phù hợp với bộ lọc này.</p>
                        <a href="search" style="color: #C92127; font-weight: bold;">Xem tất cả sách</a>
                    </div>
                </c:if>

                <div class="book-list">
                    <c:forEach items="${listBooks}" var="b">
                        
                        <div class="product-card ${!b.active ? 'card-inactive' : ''}">
                            
                            <c:if test="${!b.active}">
                                <div class="badge-hidden">
                                    <i class="fa-solid fa-eye-slash"></i> Đang ẩn
                                </div>
                            </c:if>

                            <a href="detail?pid=${b.id}" style="text-decoration: none; color: inherit; display: flex; flex-direction: column; height: 100%;">
                                <img src="${pageContext.request.contextPath}/${b.imageUrl}" 
                                     alt="${b.title}"
                                     onerror="this.src='https://via.placeholder.com/200x300?text=No+Image'">
                                
                                <div style="flex: 1; display: flex; flex-direction: column;">
                                    <h4 style="margin: 10px 0; font-size: 16px; line-height: 1.4; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;">
                                        ${b.title}
                                    </h4>
                                    <p style="color: #666; font-size: 13px; margin: 0 0 10px 0;">${b.author}</p>
                                    
                                    <div style="margin-top: auto;">
                                        <p style="color: #C92127; font-weight: bold; font-size: 18px; margin: 0;">
                                            <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </p>
                                        <c:if test="${b.stockQuantity == 0}">
                                            <span style="display: inline-block; background: #eee; color: #999; font-size: 12px; padding: 2px 6px; border-radius: 4px; margin-top: 5px;">Hết hàng</span>
                                        </c:if>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>

                <%-- ========================================== --%>
                <%-- BẮT ĐẦU PHẦN PHÂN TRANG (PAGINATION) CHUẨN --%>
                <%-- ========================================== --%>
                <%-- ========================================== --%>
                <%-- BẮT ĐẦU PHẦN PHÂN TRANG CHUYÊN NGHIỆP (DẤU ...) --%>
                <%-- ========================================== --%>
                <c:if test="${endPage > 1}">
                    <%-- Gom toàn bộ URL filter lại thành 1 biến 'q' cho code gọn gàng, dễ nhìn --%>
                    <c:set var="q" value="txt=${txtS}&cid=${cid}&minPrice=${minPrice}&maxPrice=${maxPrice}&author=${author}&publisher=${publisher}&sort=${sort}" />
                    
                    <div class="pagination-wrapper" style="margin-top: 40px; display: flex; justify-content: center;">
                        <nav aria-label="Page navigation">
                            <ul class="pagination" style="display: flex; align-items: center; list-style: none; gap: 8px; padding: 0;">
                                
                                <%-- 1. NÚT "TRƯỚC" --%>
                                <c:if test="${tag > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="search?index=${tag - 1}&${q}" 
                                           style="padding: 8px 16px; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #333;">
                                            <i class="fa-solid fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>

                                <%-- 2. LOGIC HIỂN THỊ SỐ TRANG --%>
                                <c:choose>
                                    <%-- Trường hợp A: Nếu tổng số trang ít (từ 7 trang trở xuống) -> Hiện hết không cần che --%>
                                    <c:when test="${endPage <= 7}">
                                        <c:forEach begin="1" end="${endPage}" var="i">
                                            <li class="page-item">
                                                <a class="page-link" href="search?index=${i}&${q}"
                                                   style="padding: 8px 16px; border: 1px solid ${tag == i ? '#C92127' : '#ddd'}; background-color: ${tag == i ? '#C92127' : 'white'}; color: ${tag == i ? 'white' : '#333'}; border-radius: 4px; text-decoration: none; font-weight: bold;">
                                                    ${i}
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </c:when>
                                    
                                    <%-- Trường hợp B: Nhiều hơn 7 trang -> Bắt đầu che bằng dấu ... --%>
                                    <c:otherwise>
                                        
                                        <%-- Tính toán dải số ở giữa (luôn hiển thị 3 số cạnh nhau) --%>
                                        <c:set var="startLoop" value="${tag - 1}" />
                                        <c:set var="endLoop" value="${tag + 1}" />
                                        
                                        <c:if test="${startLoop <= 2}">
                                            <c:set var="startLoop" value="2" />
                                            <c:set var="endLoop" value="4" />
                                        </c:if>
                                        <c:if test="${endLoop >= endPage - 1}">
                                            <c:set var="startLoop" value="${endPage - 3}" />
                                            <c:set var="endLoop" value="${endPage - 1}" />
                                        </c:if>

                                        <%-- Trang đầu tiên (Luôn hiện) --%>
                                        <li class="page-item">
                                            <a class="page-link" href="search?index=1&${q}"
                                               style="padding: 8px 16px; border: 1px solid ${tag == 1 ? '#C92127' : '#ddd'}; background-color: ${tag == 1 ? '#C92127' : 'white'}; color: ${tag == 1 ? 'white' : '#333'}; border-radius: 4px; text-decoration: none; font-weight: bold;">1</a>
                                        </li>

                                        <%-- Dấu ... Đầu --%>
                                        <c:if test="${startLoop > 2}">
                                            <li class="page-item"><span style="padding: 8px 5px; color: #888; font-weight: bold;">...</span></li>
                                        </c:if>

                                        <%-- Các trang ở giữa --%>
                                        <c:forEach begin="${startLoop}" end="${endLoop}" var="i">
                                            <li class="page-item">
                                                <a class="page-link" href="search?index=${i}&${q}"
                                                   style="padding: 8px 16px; border: 1px solid ${tag == i ? '#C92127' : '#ddd'}; background-color: ${tag == i ? '#C92127' : 'white'}; color: ${tag == i ? 'white' : '#333'}; border-radius: 4px; text-decoration: none; font-weight: bold;">
                                                    ${i}
                                                </a>
                                            </li>
                                        </c:forEach>

                                        <%-- Dấu ... Cuối --%>
                                        <c:if test="${endLoop < endPage - 1}">
                                            <li class="page-item"><span style="padding: 8px 5px; color: #888; font-weight: bold;">...</span></li>
                                        </c:if>

                                        <%-- Trang cuối cùng (Luôn hiện) --%>
                                        <li class="page-item">
                                            <a class="page-link" href="search?index=${endPage}&${q}"
                                               style="padding: 8px 16px; border: 1px solid ${tag == endPage ? '#C92127' : '#ddd'}; background-color: ${tag == endPage ? '#C92127' : 'white'}; color: ${tag == endPage ? 'white' : '#333'}; border-radius: 4px; text-decoration: none; font-weight: bold;">${endPage}</a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>

                                <%-- 3. NÚT "SAU" --%>
                                <c:if test="${tag < endPage}">
                                    <li class="page-item">
                                        <a class="page-link" href="search?index=${tag + 1}&${q}"
                                           style="padding: 8px 16px; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #333;">
                                            <i class="fa-solid fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                                
                            </ul>
                        </nav>
                    </div>
                </c:if>
                <%-- KẾT THÚC PHÂN TRANG --%>
                

            </div> <%-- Đóng thẻ div results-column --%>
            
        </div> <%-- Đóng thẻ div content-wrapper --%>
        <%-- CHUYỂN NÓ VÀO ĐÂY ĐỂ ĐƯỢC GIỚI HẠN KÍCH THƯỚC ĐẸP MẮT --%>
        <div style="margin-top: 40px;">
            <jsp:include page="component/suggested-books.jsp" />
        </div>
    </main>
    <jsp:include page="component/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>