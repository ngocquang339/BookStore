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
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/search.css">
</head>

<body>
    <header class="main-header">
        <div class="container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/home">
                    <span style="color: #C92127; font-weight: 900; font-size: 28px;">BOOK</span>STORE
                </a>
            </div>
            <div style="margin-left: auto;">
                <a href="${pageContext.request.contextPath}/home" style="text-decoration: none; color: #333; font-weight: bold;">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại trang chủ
                </a>
            </div>
        </div>
    </header>

<main class="container" style="margin-top: 20px;">
        
        <div class="search-container" style="margin-bottom: 20px;">
            <form action="search" method="get">
                <input type="text" name="txt" value="${txtS}" placeholder="Nhập tên sách, tác giả bạn muốn tìm...">
                <button type="submit">Tìm kiếm</button>
            </form>
        </div>

        <div class="content-wrapper" style="display: flex; gap: 30px; align-items: flex-start;">
            
            <div class="sidebar" style="width: 280px; padding: 20px; background: #fff; border: 1px solid #ddd; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05);">
                <h3 style="margin-top: 0; color: #333; border-bottom: 1px solid #eee; padding-bottom: 10px;">
                    <i class="fa-solid fa-filter"></i> Bộ lọc tìm kiếm
                </h3>
                
                <form action="${pageContext.request.contextPath}/search" method="get">
                    
                    <input type="hidden" name="txt" value="${txtS}">
                    
                    <div class="filter-group" style="margin-bottom: 15px;">
                        <label style="font-weight: bold; display: block; margin-bottom: 5px;">Danh mục:</label>
                        <select name="cid" style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                            <option value="0">Tất cả danh mục</option>
                            <c:forEach items="${listCategories}" var="c">
                                <option value="${c.id}" ${cid == c.id ? 'selected' : ''}>${c.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="filter-group" style="margin-bottom: 15px;">
                        <label style="font-weight: bold; display: block; margin-bottom: 5px;">Khoảng giá (VNĐ):</label>
                        <div style="display: flex; gap: 5px;">
                            <input type="number" name="priceFrom" value="${priceFrom > 0 ? priceFrom : ''}" placeholder="Từ..." style="width: 50%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                            <input type="number" name="priceTo" value="${priceTo > 0 ? priceTo : ''}" placeholder="Đến..." style="width: 50%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                        </div>
                    </div>

                    <div class="filter-group" style="margin-bottom: 15px;">
                        <label style="font-weight: bold; display: block; margin-bottom: 5px;">Tác giả:</label>
                        <input type="text" name="author" value="${author}" placeholder="Nhập tên tác giả..." style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                    </div>

                    <div class="filter-group" style="margin-bottom: 20px;">
                        <label style="font-weight: bold; display: block; margin-bottom: 5px;">Sắp xếp theo:</label>
                        <select name="sort" style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                            <option value="">Mặc định</option>
                            <option value="price" ${sort == 'price' ? 'selected' : ''}>Giá tiền (Tăng dần)</option>
                            <option value="title" ${sort == 'title' ? 'selected' : ''}>Tên sách (A-Z)</option>
                        </select>
                    </div>

                    <button type="submit" style="width: 100%; padding: 10px; background: #C92127; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; transition: 0.3s;">
                        Áp dụng bộ lọc
                    </button>
                    
                    <a href="search?txt=${txtS}" style="display: block; text-align: center; margin-top: 10px; color: #666; font-size: 13px; text-decoration: underline;">
                        Xóa bộ lọc
                    </a>
                </form>
            </div>

            <div class="results-column" style="flex: 1;">
                
                <h3 style="border-bottom: 2px solid #C92127; padding-bottom: 10px; display: inline-block; margin-top: 0;">
                    Kết quả cho từ khóa: <span style="color: #C92127">"${txtS}"</span>
                </h3>

                <c:if test="${empty listBooks}">
                    <div class="empty-message" style="text-align: center; margin-top: 50px;">
                        <i class="fa-regular fa-face-frown-open" style="font-size: 60px; color: #ccc; margin-bottom: 20px;"></i>
                        <p>Rất tiếc, không tìm thấy cuốn sách nào phù hợp với bộ lọc này.</p>
                    </div>
                </c:if>

                <div class="product-list">
                    <c:forEach items="${listBooks}" var="b">
                        <div class="product-card">
                            <a href="detail?pid=${b.id}" style="text-decoration: none; color: inherit;">
                                <img src="${pageContext.request.contextPath}/assets/image/books/${b.imageUrl}" alt="${b.title}">
                                <h4>${b.title}</h4>
                                <p style="color: #666; font-size: 14px;">${b.author}</p>
                                <p style="color: #C92127; font-weight: bold; font-size: 18px;">
                                    <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </p>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
            
        </div>
    </main>

</body>
</html>