<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả tìm kiếm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* CSS Nhanh cho trang Search */
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f5f5; }
        .main-header { background: #fff; box-shadow: 0 2px 5px rgba(0,0,0,0.1); padding: 15px 0; margin-bottom: 20px; }
        .product-card { background: #fff; border: 1px solid #eee; border-radius: 8px; padding: 15px; text-align: center; transition: 0.3s; height: 100%; display: flex; flex-direction: column; justify-content: space-between; position: relative; }
        .product-card:hover { box-shadow: 0 5px 15px rgba(0,0,0,0.1); transform: translateY(-3px); }
        .product-card img { max-width: 100%; height: 200px; object-fit: contain; margin-bottom: 10px; }
        .product-list { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; }
        
        /* Sidebar Style */
        .sidebar input, .sidebar select { width: 100%; padding: 8px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        .sidebar label { font-weight: 600; font-size: 14px; margin-bottom: 5px; display: block; color: #333; }
        .filter-group { margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
        .filter-group:last-child { border-bottom: none; }
        
        /* Button Style */
        .btn-filter { width: 100%; padding: 10px; background: #C92127; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; }
        .btn-filter:hover { background: #a01a1f; }

        /* Badge cho Admin */
        .badge-hidden { position: absolute; top: 10px; right: 10px; background: rgba(0,0,0,0.7); color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px; z-index: 10; }
        .card-inactive { opacity: 0.6; border: 1px dashed #999; }
    </style>
</head>

<body>
    <jsp:include page="component/header.jsp" />

    <main class="container" style="max-width: 1200px; margin: 0 auto; padding: 0 15px;">

        <div class="content-wrapper" style="display: flex; gap: 30px; align-items: flex-start;">
            
            <div class="sidebar" style="width: 280px; padding: 20px; background: #fff; border: 1px solid #ddd; border-radius: 8px; flex-shrink: 0;">
                <h3 style="margin-top: 0; color: #C92127; border-bottom: 2px solid #C92127; padding-bottom: 10px; margin-bottom: 20px;">
                    <i class="fa-solid fa-filter"></i> Bộ lọc tìm kiếm
                </h3>
                
                <form action="${pageContext.request.contextPath}/search" method="get">
                    
                    <input type="hidden" name="txt" value="${txtS}">
                    
                    <div class="filter-group">
                        <label>Danh mục sách:</label>
                        <select name="cid">
                            <option value="0">Tất cả danh mục</option>
                            <c:forEach items="${listCategories}" var="c">
                                <option value="${c.id}" ${cid == c.id ? 'selected' : ''}>${c.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label>Khoảng giá (VNĐ):</label>
                        <div style="display: flex; gap: 5px;">
                            <input type="number" name="minPrice" value="${minPrice}" placeholder="Từ..." min="0">
                            <input type="number" name="maxPrice" value="${maxPrice}" placeholder="Đến..." min="0">
                        </div>
                    </div>

                    <div class="filter-group">
                        <label>Tác giả:</label>
                        <input type="text" name="author" value="${author}" placeholder="Nhập tên tác giả...">
                    </div>

                    <div class="filter-group">
                        <label>Nhà xuất bản:</label>
                        <select name="publisher">
                            <option value="">Tất cả NXB</option>
                            <c:forEach items="${listPublishers}" var="p">
                                <option value="${p}" ${publisher == p ? 'selected' : ''}>${p}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label>Sắp xếp theo:</label>
                        <select name="sort">
                            <option value="">Mặc định (Mới nhất)</option>
                            <option value="price" ${sort == 'price' ? 'selected' : ''}>Giá tiền</option>
                            <option value="title" ${sort == 'title' ? 'selected' : ''}>Tên sách (A-Z)</option>
                            <option value="stock_quantity" ${sort == 'stock_quantity' ? 'selected' : ''}>Số lượng tồn kho</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-filter">
                        Áp dụng bộ lọc
                    </button>
                    
                    <a href="search?txt=${txtS}" style="display: block; text-align: center; margin-top: 15px; color: #666; font-size: 14px; text-decoration: underline;">
                        Xóa bộ lọc
                    </a>
                </form>
            </div>

            <div class="results-column" style="flex: 1;">
                
                <h3 style="margin-top: 0; margin-bottom: 20px;">
                    Kết quả cho: <span style="color: #C92127">"${txtS}"</span> 
                    <span style="font-size: 14px; color: #666; font-weight: normal;">(Tìm thấy ${listBooks.size()} sản phẩm)</span>
                </h3>

                <c:if test="${empty listBooks}">
                    <div class="empty-message" style="text-align: center; margin-top: 50px; background: white; padding: 40px; border-radius: 8px;">
                        <i class="fa-solid fa-magnifying-glass" style="font-size: 50px; color: #ddd; margin-bottom: 20px;"></i>
                        <p style="font-size: 18px; color: #666;">Rất tiếc, không tìm thấy cuốn sách nào phù hợp với bộ lọc này.</p>
                        <a href="search" style="color: #C92127; font-weight: bold;">Xem tất cả sách</a>
                    </div>
                </c:if>

                <div class="product-list">
                    <c:forEach items="${listBooks}" var="b">
                        
                        <div class="product-card ${!b.active ? 'card-inactive' : ''}">
                            
                            <c:if test="${!b.active}">
                                <div class="badge-hidden">
                                    <i class="fa-solid fa-eye-slash"></i> Đang ẩn
                                </div>
                            </c:if>

                            <a href="detail?pid=${b.id}" style="text-decoration: none; color: inherit; display: flex; flex-direction: column; height: 100%;">
                                <img src="${pageContext.request.contextPath}/assets/image/books/${b.imageUrl}" 
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
                </div>
            
        </div>
    </main>
</body>
</html>