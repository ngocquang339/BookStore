<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${collection.name} - BookStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>
<body style="background-color: #f5f5f5;">

    <jsp:include page="component/header.jsp" />

    <div class="container py-4">
        <div style="background-color: white; border-radius: 8px; padding: 30px; margin-bottom: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); border-top: 8px solid ${collection.coverColor};">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-2">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/my-collections" style="text-decoration: none; color: #777;">Giá sách của tôi</a></li>
                    <li class="breadcrumb-item active" aria-current="page">${collection.name}</li>
                </ol>
            </nav>
            <h2 style="font-weight: bold; color: #333; margin-bottom: 10px;">${collection.name}</h2>
            <p style="color: #666; font-size: 15px;">${empty collection.description ? 'Không có mô tả cho giá sách này.' : collection.description}</p>
            
            <div style="display: flex; gap: 15px; align-items: center; margin-top: 15px;">
                <span style="font-size: 14px; color: #555;"><i class="fa-solid fa-book me-1"></i> Có <strong>${booksInCollection.size()}</strong> cuốn sách</span>
                <span style="font-size: 14px; color: ${collection.isPublic() ? '#28a745' : '#6c757d'};">
                    <i class="fa-solid ${collection.isPublic() ? 'fa-earth-americas' : 'fa-lock'} me-1"></i> 
                    ${collection.isPublic() ? 'Công khai' : 'Riêng tư'}
                </span>
            </div>
        </div>

        <div style="background-color: white; border-radius: 8px; padding: 15px 20px; margin-bottom: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.08);">
            <form action="${pageContext.request.contextPath}/collection-detail" method="GET" class="d-flex flex-wrap gap-3 align-items-center m-0">
                
                <input type="hidden" name="id" value="${collection.id}">

                <div style="flex: 1; min-width: 250px;">
                    <div class="input-group">
                        <span class="input-group-text" style="background: white; border-right: none; color: #C92127;">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </span>
                        <input type="text" class="form-control" name="search" value="${paramSearch}" placeholder="Tìm tên sách trong bộ sưu tập này..." style="border-left: none; box-shadow: none;">
                    </div>
                </div>

                <div style="width: 220px;">
                    <select name="sort" class="form-select" onchange="this.form.submit()" style="cursor: pointer; box-shadow: none;">
                        <option value="newest" ${paramSort == 'newest' ? 'selected' : ''}>⏳ Mới thêm gần đây</option>
                        <option value="price_asc" ${paramSort == 'price_asc' ? 'selected' : ''}>📈 Giá: Thấp đến Cao</option>
                        <option value="price_desc" ${paramSort == 'price_desc' ? 'selected' : ''}>📉 Giá: Cao xuống Thấp</option>
                    </select>
                </div>

                <button type="submit" class="btn text-white fw-bold px-4" style="background-color: #C92127;">Lọc</button>
                
                <c:if test="${not empty paramSearch or paramSort != 'newest'}">
                    <a href="${pageContext.request.contextPath}/collection-detail?id=${collection.id}" class="btn btn-light border text-muted">Xóa lọc</a>
                </c:if>
            </form>
        </div>
        <div style="background-color: white; border-radius: 8px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.08);">
            
            <c:choose>
                <c:when test="${empty booksInCollection}">
                    <div class="text-center py-5">
                        <i class="fa-regular fa-folder-open text-muted" style="font-size: 50px; margin-bottom: 15px;"></i>
                        <h5 class="text-muted">Giá sách này chưa có cuốn sách nào.</h5>
                        <a href="${pageContext.request.contextPath}/home" class="btn text-white mt-3" style="background-color: #C92127;">Đi dạo tìm sách ngay</a>
                    </div>
                </c:when>
                
                <c:otherwise>
                    <div style="display: grid; grid-template-columns: repeat(5, 1fr); gap: 15px;">
                        <c:forEach var="b" items="${booksInCollection}">
                            
                            <div style="position: relative;">
                                <c:if test="${sessionScope.user.id == collection.userId}">
                                    <form action="${pageContext.request.contextPath}/my-collections" method="POST" style="position: absolute; top: 10px; right: 10px; z-index: 10;" onsubmit="return confirm('Bỏ cuốn này ra khỏi giá sách?');">
                                        <input type="hidden" name="action" value="removeBook">
                                        <input type="hidden" name="collectionId" value="${collection.id}">
                                        <input type="hidden" name="bookId" value="${b.id}">
                                        <button type="submit" class="btn btn-sm btn-light" style="border-radius: 50%; width: 30px; height: 30px; padding: 0; box-shadow: 0 2px 5px rgba(0,0,0,0.2); color: #dc3545;" title="Xóa khỏi giá sách">
                                            <i class="fa-solid fa-xmark"></i>
                                        </button>
                                    </form>
                                </c:if>

                                <a href="${pageContext.request.contextPath}/detail?pid=${b.id}" style="text-decoration: none; color: inherit; display: block; padding: 10px; transition: 0.3s; border-radius: 8px; border: 1px solid #eee;" 
                                   onmouseover="this.style.boxShadow='0 0 10px rgba(0,0,0,0.1)'" 
                                   onmouseout="this.style.boxShadow='none'">
                                    
                                    <div style="height: 200px; display: flex; justify-content: center; align-items: center; margin-bottom: 10px;">
                                        <img src="${pageContext.request.contextPath}/${b.imageUrl}" alt="${b.title}" style="max-width: 100%; max-height: 100%; object-fit: contain;">
                                    </div>

                                    <div style="font-size: 14px; color: #333; line-height: 1.4; height: 38px; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; margin-bottom: 8px;">
                                        ${b.title}
                                    </div>
                                    <div style="font-size: 12px; color: #777; margin-bottom: 5px;">${b.author}</div>

                                    <div style="color: #C92127; font-size: 16px; font-weight: bold;">
                                        <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </div>
                                </a>
                            </div>

                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
            
        </div>
    </div>

    <jsp:include page="component/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>