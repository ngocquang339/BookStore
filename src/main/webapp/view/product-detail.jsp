
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${book.title} - BookStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product-detail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* CSS for the Admin Internal Data Box */
        .admin-inspector {
            background-color: #fff3cd; /* Yellow warning color */
            border: 1px solid #ffeeba;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            color: #856404;
        }
        .admin-inspector h4 { margin-top: 0; display: flex; align-items: center; gap: 10px; }
        .edit-btn {
            background-color: #ffc107;
            color: #000;
            padding: 5px 10px;
            text-decoration: none;
            font-size: 14px;
            border-radius: 4px;
            font-weight: bold;
        }
        .edit-btn:hover { background-color: #e0a800; }
    </style>
</head>
<body>

    <jsp:include page="component/header.jsp" />

    <main class="container" style="margin-top: 20px; margin-bottom: 50px;">
        
        <div class="product-top-section">
            
            <div class="product-image-box white-box">
                <div class="main-image-container">
                    <img id="mainImage" src="${pageContext.request.contextPath}/${book.imageUrl}" 
                        alt="${book.title}" class="main-img">
                </div>
                
                <div class="thumbnail-list" style="display:flex; gap:10px; justify-content:center; margin-top:10px;">
                    
                    <div class="thumb-item active" onclick="changeImage(this, '${pageContext.request.contextPath}/assets/image/books/${book.imageUrl}')">
                        <img src="${pageContext.request.contextPath}/${book.imageUrl}" width="60" height="60">
                    </div>

                    <c:forEach items="${listImg}" var="img" varStatus="status">
                        
                        <c:if test="${status.index < 3}">
                            <div class="thumb-item" onclick="changeImage(this, '${pageContext.request.contextPath}/assets/image/books/${img.imageUrl}')">
                                <img src="${pageContext.request.contextPath}/${img.imageUrl}" width="60" height="60">
                            </div>
                        </c:if>

                        <c:if test="${status.index == 3}">
                            <div class="thumb-item plus-item" style="position:relative; width:60px; height:60px; overflow:hidden;">
                                <img src="${pageContext.request.contextPath}/${img.imageUrl}" width="60" height="60" style="opacity:0.5;">
                                <div style="position:absolute; top:0; left:0; right:0; bottom:0; display:flex; align-items:center; justify-content:center; font-weight:bold; color:#333;">
                                    +${listImg.size() - 3}
                                </div>
                            </div>
                        </c:if>
                        
                    </c:forEach>
                </div>
            </div>

            <div class="product-info-box white-box">
                
                <%-- === KHÔI PHỤC PHẦN ADMIN Ở ĐÂY === --%>
                <c:if test="${sessionScope.user != null && sessionScope.user.role == 1}">
                    <div class="admin-inspector">
                        <div class="admin-header">
                            <span><i class="fa-solid fa-user-secret"></i> Dữ liệu nội bộ (Admin)</span>
                            <a href="${pageContext.request.contextPath}/admin/product/edit?id=${book.id}" class="edit-btn">
                                <i class="fa-solid fa-pen"></i> Sửa nhanh
                            </a>
                        </div>
                        <ul class="admin-stats">
                            <li><strong>Giá nhập:</strong> $${book.importPrice}</li>
                            <li><strong>Tồn kho:</strong> ${book.stockQuantity}</li>
                            <li><strong>Trạng thái:</strong> ${book.active ? 'Đang hiện' : 'Đang ẩn'}</li>
                        </ul>
                    </div>
                </c:if>
                <%-- ===================================== --%>

                <h1 class="product-title">${book.title}</h1>
                
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 10px; font-size: 13px; margin-bottom: 20px;">
                    <div>Nhà cung cấp: <a href="#" style="color:#2489F4; text-decoration:none;">${book.publisher}</a></div>
                    <div>Tác giả: <strong>${book.author}</strong></div>
                    <div>Nhà xuất bản: <strong>${book.publisher}</strong></div>
                    <div>Hình thức bìa: <strong>Bìa Mềm</strong></div>
                </div>

                <div class="price-box">
                    <span class="price-current">
                        <fmt:formatNumber value="${book.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </span>
                    <span style="color:#999; text-decoration:line-through; margin-left:10px;">
                        <fmt:formatNumber value="${book.price * 1.2}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </span>
                    <span style="background:#C92127; color:white; padding:2px 5px; border-radius:4px; font-size:12px; margin-left:10px;">-20%</span>
                </div>

                <div class="actions" style="margin-top: 30px;">
                    <c:choose>
                        
                        <%-- Case 1: Hết hàng --%>
                        <c:when test="${book.stockQuantity <= 0 && (sessionScope.user == null || sessionScope.user.role != 1)}">
                             <button disabled style="background:#ccc; border:none; padding:15px; width:100%; color:white; font-weight:bold; cursor: not-allowed;">
                                Tạm hết hàng
                             </button>
                        </c:when>

                         <%-- Case 2: Hết hàng nhưng là Admin (Test) --%>
                        <c:when test="${book.stockQuantity <= 0 && sessionScope.user.role == 1}">
                            <div style="border: 1px dashed red; padding: 10px; text-align: center; margin-bottom: 10px; color: red;">
                                <i class="fa-solid fa-triangle-exclamation"></i> Admin Test: Sản phẩm hết hàng nhưng nút mua vẫn hiện
                            </div>
                            <form action="cart" method="post" style="display:flex; gap:15px;">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="id" value="${book.id}">
                                <button type="submit" style="background:white; color:#007bff; border:2px solid #007bff; padding:10px 20px; font-weight:bold; cursor:pointer; border-radius:8px; flex:1;">
                                    Test Add Cart
                                </button>
                            </form>
                        </c:when>

                        <%-- Case 3: Còn hàng (Bình thường) --%>
                        <c:otherwise>
                            <form action="cart" method="post" style="display:flex; gap:15px;">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="id" value="${book.id}">
                                
                                <div style="display:flex; align-items:center; gap:10px;">
                                    <span>Số lượng:</span>
                                    <input type="number" name="quantity" value="1" min="1" max="${book.stockQuantity}" style="padding: 8px; width: 60px; text-align:center; border: 1px solid #ddd; border-radius: 4px;">
                                </div>

                                <button type="submit" style="background:white; color:#C92127; border:2px solid #C92127; padding:10px 20px; font-weight:bold; cursor:pointer; border-radius:8px; flex:1; display: flex; align-items: center; justify-content: center; gap: 8px;">
                                    <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                                </button>
                                <button type="button" style="background:#C92127; color:white; border:none; padding:10px 20px; font-weight:bold; cursor:pointer; border-radius:8px; flex:1;">
                                    Mua ngay
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="white-box product-bottom-section">
            <h3 class="section-header">Thông tin chi tiết</h3>
            
            <div class="detail-row">
                <div class="detail-label">Mã hàng</div>
                <div class="detail-value">893${book.id}00${book.id}</div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Tên Nhà Cung Cấp</div>
                <div class="detail-value" style="color:#2489F4;">${book.publisher}</div>
            </div>
            <div class="detail-row">
                <div class="detail-label">Tác giả</div>
                <div class="detail-value">${book.author}</div>
            </div>
            <div class="detail-row">
                <div class="detail-label">NXB</div>
                <div class="detail-value">${book.publisher}</div>
            </div>
            
            <hr style="border-top:1px solid #eee; margin:20px 0;">
            
            <h3 class="section-header">Mô tả sản phẩm</h3>
            <div style="line-height:1.6; color:#333; text-align:justify;">
                <p><strong>${book.title}</strong></p>
                <p>${book.description}</p>
            </div>
        </div>

    </main>

    <script>
        function changeImage(element, newSrc) {
            // Đổi ảnh chính
            document.getElementById('mainImage').src = newSrc;
            
            // Xử lý viền active
            let thumbs = document.querySelectorAll('.thumb-item');
            thumbs.forEach(t => t.classList.remove('active')); // Xóa active cũ
            element.classList.add('active'); // Thêm active mới
            
            // Style active (ví dụ)
            // Bạn nên thêm CSS: .thumb-item.active { border: 2px solid #C92127; }
        }
    </script>
</body>
</html>