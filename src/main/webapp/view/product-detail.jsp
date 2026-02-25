
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

    <main class="container-fluid" style=" margin-top: 20px; margin-bottom: 50px">
        

        <div class="product-top-section" style="max-width: 1250px; margin: 0 auto; padding: 0;">
            
            <div class="product-image-box white-box" style="flex: 0 0 42%;position: sticky; top: 20px;">

                <div class="main-image-container" style="text-align: center; border: none; padding: 10px; margin-bottom: 15px; height: 400px; display: flex; align-items: center; justify-content: center;">
                    <img id="mainImage" src="${pageContext.request.contextPath}/${book.imageUrl}"
                        alt="${book.title}" class="main-img" style="max-width: 100%; max-height: 100%; object-fit: contain;">
                </div>

                <div class="thumbnail-list" style="display:flex; gap:12px; justify-content:center;">

    <div class="thumb-item active" 
        style="width: 80px; height: 80px; border: 2px solid #C92127; border-radius: 4px; cursor: pointer; padding: 2px; display: flex; justify-content: center; align-items: center;"
        onclick="changeImage(this, '${pageContext.request.contextPath}/${book.imageUrl}')">
        <img src="${pageContext.request.contextPath}/${book.imageUrl}" style="max-width: 100%; max-height: 100%; object-fit: contain;">
    </div>

    <c:forEach items="${bookImages}" var="img" varStatus="status">

        <c:if test="${status.index < 3}">
            <div class="thumb-item" 
                style="width: 80px; height: 80px; border: 2px solid transparent; border-radius: 4px; cursor: pointer; padding: 2px; display: flex; justify-content: center; align-items: center;"
                onclick="changeImage(this, '${pageContext.request.contextPath}/${img.imageUrl}')">
                <img src="${pageContext.request.contextPath}/${img.imageUrl}" style="max-width: 100%; max-height: 100%; object-fit: contain;">
            </div>
        </c:if>

        <c:if test="${status.index == 3}">
            <div class="thumb-item plus-item" 
                style="position:relative; width: 80px; height: 80px; border: 2px solid transparent; border-radius: 4px; cursor: pointer; padding: 2px; display: flex; justify-content: center; align-items: center;"
                onclick="openFullscreenGallery()">

                <img src="${pageContext.request.contextPath}/${img.imageUrl}" style="max-width: 100%; max-height: 100%; object-fit: contain; opacity:0.4;">

                <div style="position:absolute; top:0; left:0; right:0; bottom:0; display:flex; align-items:center; justify-content:center; font-weight:bold; font-size: 22px; color:#fff; background: rgba(0,0,0,0.5); border-radius: 2px;">
                    +${bookImages.size() - 3}
                </div>
            </div>
        </c:if>

    </c:forEach>
</div>
                <form action="cart" method="post" style="width: 100%; margin-top: 25px;">
    
    <div class="button-group" style="display: flex; gap: 15px; width: 100%;">
        
        <button type="submit" style="background: white; color: #C92127; border: 2px solid #C92127; padding: 12px 20px; font-weight: bold; font-size: 16px; cursor: pointer; border-radius: 8px; flex: 1; display: flex; align-items: center; justify-content: center; gap: 8px; transition: 0.3s;">
            <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
        </button>

        <button type="button" style="background: #C92127; color: white; border: none; padding: 12px 20px; font-weight: bold; font-size: 16px; cursor: pointer; border-radius: 8px; flex: 1; display: flex; align-items: center; justify-content: center; transition: 0.3s;">
            Mua ngay
        </button>
        
    </div>
</form>
            </div>
            <div class="product-info-column" style="flex: 1;display: flex; flex-direction: column; gap: 15px;">
                <div class="product-info-box white-box" style="padding: 20px; border-radius: 8px;">
        
    <%-- ===================================== --%>
    <%-- PHẦN ADMIN (GIỮ NGUYÊN KHÔNG CHẠM VÀO)--%>
    <c:if test="${sessionScope.user != null && sessionScope.user.role == 1}">
        <div class="admin-inspector" style="margin-bottom: 15px;">
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

    <h1 class="product-title" style="font-size: 24px; color: #333; margin-bottom: 15px; line-height: 1.4;">${book.title}</h1>
    
    <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 10px; font-size: 14px; margin-bottom: 15px; color: #333;">
        <div>Nhà cung cấp: <a href="#" style="color:#2489F4; text-decoration:none;">${book.supplier}</a></div>
        <div>Tác giả: <strong>${book.author}</strong></div>
        <div>Nhà xuất bản: <strong>${book.publisher}</strong></div>
        <div>Hình thức bìa: <strong>Bìa Mềm</strong></div>
    </div>

    <div style="display: flex; align-items: center; gap: 10px; font-size: 14px; margin-bottom: 20px;">
        <div style="color: #F5A623; font-size: 13px;">
            <i class="fa-solid fa-star"></i>
            <i class="fa-solid fa-star"></i>
            <i class="fa-solid fa-star"></i>
            <i class="fa-solid fa-star"></i>
            <i class="fa-solid fa-star"></i>
        </div>
        <div style="color: #F5A623;">(0 đánh giá)</div>
        <div style="color: #ccc;">|</div>
        <div style="color: #777;">Đã bán ${book.soldQuantity != null ? book.soldQuantity : 0}</div>
    </div>

    <div class="price-box" style="margin-bottom: 12px;">
        <span class="price-current" style="color: #C92127; font-size: 34px; font-weight: bold;">
            <fmt:formatNumber value="${book.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
        </span>
        <span style="color:#999; text-decoration:line-through; font-size: 16px; margin-left: 10px;">
            <fmt:formatNumber value="${book.price * 1.2}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
        </span>
        <span style="background:#C92127; color:white; padding:3px 8px; border-radius:4px; font-size:14px; font-weight: bold; margin-left: 10px;">-20%</span>
    </div>

    <div style="font-size: 13px; color: #C92127; margin-bottom: 5px;">
        Chính sách khuyến mãi trên chỉ áp dụng khi đặt hàng Online <i class="fa-solid fa-angle-right" style="font-size: 11px;"></i>
    </div>
    
</div>


            <div class="product-action-box white-box" style="padding: 20px; border-radius: 8px;">
    
    <h3 style="font-size: 16px; margin-top: 0; margin-bottom: 15px; color: #333;">Thông tin vận chuyển</h3>
    
    <div style="font-size: 14px; margin-bottom: 15px;">
        Giao hàng đến <strong>Phường Bến Nghé, Quận 1, Hồ Chí Minh</strong> 
        <a href="#" style="color: #2489F4; text-decoration: none; margin-left: 10px;">Thay đổi</a>
    </div>
    
    <div style="display: flex; align-items: flex-start; gap: 10px; margin-bottom: 25px;">
        <i class="fa-solid fa-truck-fast" style="color: #00b14f; font-size: 18px; margin-top: 2px;"></i>
        <div>
            <div style="font-weight: bold; font-size: 15px; margin-bottom: 5px; color: #333;">Giao hàng tiêu chuẩn</div>
            <div style="font-size: 13px; color: #555;">Dự kiến giao <strong>Thứ hai - 23/02</strong></div>
        </div>
    </div>

    <h3 style="font-size: 16px; margin-top: 0; margin-bottom: 15px; color: #333; display: flex; align-items: center; justify-content: space-between;">
        <span>Ưu đãi liên quan</span>
        <a href="#" style="font-size: 13px; color: #2489F4; font-weight: normal; text-decoration: none;">Xem thêm <i class="fa-solid fa-angle-right"></i></a>
    </h3>

    <div style="display: flex; gap: 10px; overflow-x: auto; padding-bottom: 15px; margin-bottom: 20px; border-bottom: 1px solid #f0f0f0;" class="coupon-scroll">
        
        <div style="border: 1px dashed #ccc; border-radius: 4px; display: flex; align-items: center; font-size: 13px; white-space: nowrap; overflow: hidden;">
            <div style="background: #F5A623; color: white; padding: 6px 8px;"><i class="fa-solid fa-certificate"></i></div>
            <div style="padding: 6px 10px; color: #333;">Mã giảm 10k - to...</div>
        </div>
        
        <div style="border: 1px dashed #ccc; border-radius: 4px; display: flex; align-items: center; font-size: 13px; white-space: nowrap; overflow: hidden;">
            <div style="background: #F5A623; color: white; padding: 6px 8px;"><i class="fa-solid fa-certificate"></i></div>
            <div style="padding: 6px 10px; color: #333;">Mã giảm 20k - to...</div>
        </div>

        <div style="border: 1px dashed #ccc; border-radius: 4px; display: flex; align-items: center; font-size: 13px; white-space: nowrap; overflow: hidden;">
            <div style="background: #2489F4; color: white; padding: 6px 8px;"><i class="fa-solid fa-credit-card"></i></div>
            <div style="padding: 6px 10px; color: #333;">Shopeepay: giảm...</div>
        </div>

        <div style="border: 1px dashed #ccc; border-radius: 4px; display: flex; align-items: center; font-size: 13px; white-space: nowrap; overflow: hidden;">
            <div style="background: #2489F4; color: white; padding: 6px 8px;"><i class="fa-solid fa-wallet"></i></div>
            <div style="padding: 6px 10px; color: #333;">Zalopay: giảm 20...</div>
        </div>

    </div>

    <div style="display: flex; align-items: center; gap: 40px; margin-bottom: 10px;">
        <span style="font-weight: bold; font-size: 15px; color: #333;">Số lượng:</span>
        
        <div style="display: flex; align-items: center; border: 1px solid #ddd; border-radius: 4px; overflow: hidden;">
            <button type="button" style="background: white; border: none; padding: 8px 15px; cursor: pointer; border-right: 1px solid #ddd; color: #888; transition: 0.2s;" onmouseover="this.style.background='#f5f5f5'" onmouseout="this.style.background='white'" onclick="let q = document.getElementById('qtyInput'); if(q.value > 1) q.value--;"><i class="fa-solid fa-minus"></i></button>
            
            <input type="text" id="qtyInput" value="1" max="${book.stockQuantity}" style="width: 50px; text-align: center; border: none; font-weight: bold; font-size: 15px; outline: none;">
            
            <button type="button" style="background: white; border: none; padding: 8px 15px; cursor: pointer; border-left: 1px solid #ddd; color: #888; transition: 0.2s;" onmouseover="this.style.background='#f5f5f5'" onmouseout="this.style.background='white'" onclick="let q = document.getElementById('qtyInput'); if(parseInt(q.value) < ${book.stockQuantity}) q.value++;"><i class="fa-solid fa-plus"></i></button>
        </div>
    </div>

</div>

<style>
    .coupon-scroll::-webkit-scrollbar { height: 4px; }
    .coupon-scroll::-webkit-scrollbar-track { background: transparent; }
    .coupon-scroll::-webkit-scrollbar-thumb { background: #ddd; border-radius: 4px; }
    .coupon-scroll::-webkit-scrollbar-thumb:hover { background: #bbb; }
</style>


            <div class="product-detail-box white-box" style="padding: 15px; border-radius: 8px;">
                <h3 class="section-header" style="margin-top: 0; margin-bottom: 15px; font-size: 18px;">Thông tin chi tiết</h3>
                
                <div class="detail-row" style="margin-bottom: 10px;">
                    <div class="detail-label" style="color: #777; width: 150px; display: inline-block;">Mã hàng</div>
                    <div class="detail-value" style="display: inline-block;">893${book.id}00${book.id}</div>
                </div>
                <div class="detail-row" style="margin-bottom: 10px;">
                    <div class="detail-label" style="color: #777; width: 150px; display: inline-block;">Tên Nhà Cung Cấp</div>
                    <div class="detail-value" style="display: inline-block; color:#2489F4;">${book.supplier}</div>
                </div>
                <div class="detail-row" style="margin-bottom: 10px;">
                    <div class="detail-label" style="color: #777; width: 150px; display: inline-block;">Tác giả</div>
                    <div class="detail-value" style="display: inline-block;">${book.author}</div>
                </div>
                <div class="detail-row" style="margin-bottom: 10px;">
                    <div class="detail-label" style="color: #777; width: 150px; display: inline-block;">NXB</div>
                    <div class="detail-value" style="display: inline-block;">${book.publisher}</div>
                </div>
                <div class="detail-row" style="margin-bottom: 10px;">
                    <div class="detail-label" style="color: #777; width: 150px; display: inline-block;">Năm xuất bản</div>
                    <div class="detail-value" style="display: inline-block;">${book.yearOfPublish}</div>
                </div>
                <div class="detail-row" style="margin-bottom: 10px;">
                    <div class="detail-label" style="color: #777; width: 150px; display: inline-block;">Số trang</div>
                    <div class="detail-value" style="display: inline-block;">${book.numberPage}</div>
                </div>
            </div>


            <div class="product-desc-box white-box" style="padding: 15px; border-radius: 8px;">
                <h3 class="section-header" style="margin-top: 0; margin-bottom: 15px; font-size: 18px;">Mô tả sản phẩm</h3>
                <div style="line-height:1.6; color:#333; text-align:justify;">
                    <p style="font-size: 16px;"><strong>${book.title}</strong></p>
                    <p>${book.description}</p>
                </div>
            </div>
                    </div>

        </div>

        <div class="product-review-box white-box" style="padding: 20px; border-radius: 8px;">
        <h3 class="section-header" style="margin-top: 0; margin-bottom: 25px; font-size: 18px;">Đánh giá sản phẩm</h3>
        
        <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 20px;">
            
            <div style="text-align: center; min-width: 120px;">
                <div style="font-size: 48px; font-weight: bold; line-height: 1;">
                    0<span style="font-size: 24px; color: #999; font-weight: normal;">/5</span>
                </div>
                <div style="color: #ddd; font-size: 18px; margin: 8px 0;">
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                </div>
                <div style="color: #777; font-size: 13px;">(0 đánh giá)</div>
            </div>

            <div style="flex: 1; min-width: 250px; max-width: 400px; margin: 0 20px;">
                
                <c:forEach var="i" begin="1" end="5" step="1">
                    <c:set var="starValue" value="${6 - i}" /> <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px; font-size: 13px; color: #555;">
                        <span style="width: 45px; text-align: right;">${starValue} sao</span>
                        
                        <div style="flex: 1; height: 6px; background-color: #eee; border-radius: 3px; overflow: hidden;">
                            <div style="width: 0%; height: 100%; background-color: #F5A623;"></div>
                        </div>
                        
                        <span style="width: 30px; text-align: right;">0%</span>
                    </div>
                </c:forEach>
                
            </div>

            <div style="min-width: 200px; display: flex; justify-content: center;">
                <button type="button" 
                        style="background: white; color: #C92127; border: 1px solid #C92127; padding: 10px 40px; border-radius: 6px; font-size: 14px; cursor: pointer; display: flex; align-items: center; gap: 8px; transition: background 0.3s;"
                        onmouseover="this.style.background='#fff0f0'" 
                        onmouseout="this.style.background='white'">
                    <i class="fa-solid fa-pen"></i> Viết đánh giá
                </button>
            </div>

        </div>
    </div>

    <div class="same-author-box white-box" style="padding: 20px; border-radius: 8px; margin-top: 20px;">
        <h3 style="text-transform: uppercase; font-size: 16px; font-weight: bold; margin-bottom: 20px; color: #333;">
            Sản phẩm cùng tác giả
        </h3>

        <div style="display: grid; grid-template-columns: repeat(5, 1fr); gap: 15px;">
            
            <c:forEach items="${bookSameAuthor}" var="b" end="4">
                
                <a href="detail?id=${b.id}" style="text-decoration: none; color: inherit; display: block; padding: 10px; transition: 0.3s; border-radius: 8px;" 
                   onmouseover="this.style.boxShadow='0 0 10px rgba(0,0,0,0.1)'" 
                   onmouseout="this.style.boxShadow='none'">
                    
                    <div class="product-card" style="display: flex; flex-direction: column;">
                        
                        <div style="height: 200px; display: flex; justify-content: center; align-items: center; margin-bottom: 10px;">
                            <img src="${pageContext.request.contextPath}/${b.imageUrl}" alt="${b.title}" style="max-width: 100%; max-height: 100%; object-fit: contain;">
                        </div>

                        <div style="font-size: 14px; color: #333; line-height: 1.4; height: 38px; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; margin-bottom: 8px;">
                            ${b.title}
                        </div>

                        <div style="display: flex; align-items: center; flex-wrap: wrap; gap: 5px; margin-bottom: 5px;">
                            <span style="color: #C92127; font-size: 16px; font-weight: bold;">
                                <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </span>
                            <span style="background: #C92127; color: white; font-size: 12px; padding: 2px 4px; border-radius: 3px;">-20%</span>
                        </div>

                        <div style="color: #999; font-size: 13px; text-decoration: line-through; margin-bottom: 5px;">
                            <fmt:formatNumber value="${b.price * 1.2}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </div>

                        <div style="color: #F5A623; font-size: 12px;">
                            <i class="fa-regular fa-star" style="color: #ddd;"></i>
                            <i class="fa-regular fa-star" style="color: #ddd;"></i>
                            <i class="fa-regular fa-star" style="color: #ddd;"></i>
                            <i class="fa-regular fa-star" style="color: #ddd;"></i>
                            <i class="fa-regular fa-star" style="color: #ddd;"></i>
                            <span style="color: #999; margin-left: 5px;">(0)</span>
                        </div>
                    </div>
                </a>
            </c:forEach>
            
        </div>

        <div style="text-align: center; margin-top: 30px;">
            <a href="#" style="display: inline-block; border: 1px solid #C92127; color: #C92127; font-weight: bold; font-size: 14px; padding: 10px 60px; border-radius: 4px; text-decoration: none; transition: 0.3s;"
               onmouseover="this.style.background='#fff0f0'" 
               onmouseout="this.style.background='white'">
                Xem thêm
            </a>
        </div>
    </div>

    <jsp:include page="component/suggested-books.jsp" />
    <jsp:include page="component/footer.jsp" />

        <div id="fullscreenGalleryModal" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.95); z-index: 9999; flex-direction: column; justify-content: space-between;">
    
            <div style="position: absolute; top: 20px; right: 30px; z-index: 10002;">
                <span onclick="closeFullscreenGallery()" style="color: #fff; font-size: 40px; cursor: pointer; font-family: sans-serif; opacity: 0.8; text-shadow: 0 0 5px #000;">&times;</span>
            </div>

            <div class="nav-btn prev-btn" onclick="prevImage()" 
                style="position: absolute; top: 50%; left: 20px; transform: translateY(-50%); z-index: 10001; cursor: pointer; padding: 20px; background: rgba(0,0,0,0.3); border-radius: 50%; width: 60px; height: 60px; display: flex; justify-content: center; align-items: center; transition: 0.3s;">
                <i class="fa-solid fa-chevron-left" style="color: white; font-size: 30px;"></i>
            </div>

            <div class="nav-btn next-btn" onclick="nextImage()" 
                style="position: absolute; top: 50%; right: 20px; transform: translateY(-50%); z-index: 10001; cursor: pointer; padding: 20px; background: rgba(0,0,0,0.3); border-radius: 50%; width: 60px; height: 60px; display: flex; justify-content: center; align-items: center; transition: 0.3s;">
                <i class="fa-solid fa-chevron-right" style="color: white; font-size: 30px;"></i>
            </div>

            <div style="flex: 1; display: flex; justify-content: center; align-items: center; padding: 20px; overflow: hidden; position: relative;">
                
                <img id="modalMainImage" src="${pageContext.request.contextPath}/${book.imageUrl}" 
                    style="max-width: 90%; max-height: 85vh; object-fit: contain; transition: transform 0.2s ease-in-out;">
                
                <div style="position: absolute; bottom: 30px; right: 50px; display: flex; gap: 25px; background: rgba(30, 30, 30, 0.7); padding: 10px 20px; border-radius: 8px; z-index: 10001;">
                    <i class="fa-solid fa-magnifying-glass-minus" style="color: #fff; font-size: 24px; cursor: pointer;" onclick="zoomOut()"></i>
                    <i class="fa-solid fa-magnifying-glass-plus" style="color: #fff; font-size: 24px; cursor: pointer;" onclick="zoomIn()"></i>
                </div>
            </div>

            <div style="width: 100%; background: #111; padding: 15px 0; display: flex; justify-content: center; z-index: 10001;">
                <div style="display: flex; gap: 10px; overflow-x: auto; max-width: 90%; padding-bottom: 5px;" class="modal-thumb-scroll">
                    
                    <div class="modal-thumb-item" style="border: 2px solid #C92127; width: 80px; height: 80px; flex-shrink: 0; cursor: pointer; background: white; border-radius: 4px; padding: 2px;" 
                        onclick="changeModalImage(this, '${pageContext.request.contextPath}/${book.imageUrl}', 0)"> <img src="${pageContext.request.contextPath}/${book.imageUrl}" style="width: 100%; height: 100%; object-fit: contain;">
                    </div>

                    <c:forEach items="${bookImages}" var="img" varStatus="status">
                        <div class="modal-thumb-item" style="border: 2px solid transparent; width: 80px; height: 80px; flex-shrink: 0; cursor: pointer; background: white; border-radius: 4px; padding: 2px;" 
                            onclick="changeModalImage(this, '${pageContext.request.contextPath}/${img.imageUrl}', ${status.index + 1})"> <img src="${pageContext.request.contextPath}/${img.imageUrl}" style="width: 100%; height: 100%; object-fit: contain;">
                        </div>
                    </c:forEach>

                </div>
            </div>
        </div>

<style>
    .nav-btn:hover { background: rgba(255,255,255,0.2) !important; transform: translateY(-50%) scale(1.1) !important; }
</style>

        <style>
            .modal-thumb-scroll::-webkit-scrollbar { height: 6px; }
            .modal-thumb-scroll::-webkit-scrollbar-track { background: #333; border-radius: 4px; }
            .modal-thumb-scroll::-webkit-scrollbar-thumb { background: #888; border-radius: 4px; }
            .modal-thumb-scroll::-webkit-scrollbar-thumb:hover { background: #bbb; }
        </style>
    </main>

    <script>
        function changeImage(element, imageUrl) {
            // 1. Thay đổi nguồn ảnh của ảnh chính (ảnh to)
            document.getElementById('mainImage').src = imageUrl;

            // 2. Xóa viền đỏ ở tất cả các ảnh nhỏ
            var allThumbs = document.querySelectorAll('.thumb-item');
            allThumbs.forEach(function(thumb) {
                thumb.style.borderColor = "transparent"; // Đưa về trong suốt
            });

            // 3. Thêm viền đỏ cho ảnh đang được click
            element.style.borderColor = "#C92127";
        }

        // --- KHAI BÁO BIẾN TOÀN CỤC ---
    let currentZoom = 1;
    const zoomStep = 0.3;
    
    // Mảng chứa danh sách tất cả các URL ảnh
    let galleryImages = [];
    let currentIndex = 0; // Đánh dấu đang xem ảnh thứ mấy

    // --- HÀM KHỞI TẠO (CHẠY KHI LOAD TRANG) ---
    window.onload = function() {
        // 1. Quét tất cả ảnh nhỏ trong Modal để nạp vào danh sách
        let thumbs = document.querySelectorAll('.modal-thumb-item img');
        thumbs.forEach((img) => {
            galleryImages.push(img.src);
        });
        
        // 2. Lắng nghe sự kiện bàn phím
        document.addEventListener('keydown', function(event) {
            // Chỉ bắt sự kiện khi Modal đang mở
            if(document.getElementById('fullscreenGalleryModal').style.display === 'flex') {
                if(event.key === "ArrowLeft") { prevImage(); }
                if(event.key === "ArrowRight") { nextImage(); }
                if(event.key === "Escape") { closeFullscreenGallery(); }
            }
        });
        
        // (Giữ lại logic mở modal email cũ của bạn nếu có ở đây...)
    };

    // --- CÁC HÀM ĐIỀU HƯỚNG ---
    
    // Chuyển sang ảnh TIẾP THEO
    function nextImage() {
        currentIndex++;
        if (currentIndex >= galleryImages.length) {
            currentIndex = 0; // Quay về đầu nếu hết ảnh
        }
        updateGalleryView();
    }

    // Chuyển sang ảnh TRƯỚC ĐÓ
    function prevImage() {
        currentIndex--;
        if (currentIndex < 0) {
            currentIndex = galleryImages.length - 1; // Nhảy về cuối nếu đang ở đầu
        }
        updateGalleryView();
    }

    // Hàm cập nhật giao diện (Ảnh to + Viền đỏ) dựa trên currentIndex
    function updateGalleryView() {
        // 1. Reset Zoom
        currentZoom = 1;
        let mainImg = document.getElementById('modalMainImage');
        mainImg.style.transform = 'scale(1)';
        
        // 2. Đổi ảnh to
        mainImg.src = galleryImages[currentIndex];

        // 3. Cập nhật viền đỏ ở dưới
        let allThumbs = document.querySelectorAll('.modal-thumb-item');
        allThumbs.forEach((thumb, index) => {
            if (index === currentIndex) {
                thumb.style.borderColor = "#C92127";
                // Tự động cuộn thanh thumbnail đến ảnh đang chọn (để không bị khuất)
                thumb.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'center' });
            } else {
                thumb.style.borderColor = "transparent";
            }
        });
    }

    // --- CÁC HÀM XỬ LÝ SỰ KIỆN CŨ (Đã nâng cấp) ---

    function openFullscreenGallery() {
        // Mặc định mở lên là chọn ảnh bìa (index 0) hoặc bạn có thể logic phức tạp hơn
        currentIndex = 3; // Vì bấm nút +Xem thêm thường là đang ở ảnh thứ 4
        updateGalleryView(); 
        
        document.getElementById('fullscreenGalleryModal').style.display = 'flex';
        document.body.style.overflow = 'hidden'; 
    }

    // Hàm này được gọi khi click trực tiếp vào ảnh nhỏ trong Modal
    function changeModalImage(element, imageUrl, index) {
        currentIndex = index; // Cập nhật vị trí hiện tại
        updateGalleryView();  // Vẽ lại giao diện
    }

    function closeFullscreenGallery() {
        document.getElementById('fullscreenGalleryModal').style.display = 'none';
        document.body.style.overflow = 'auto'; 
        currentZoom = 1;
        document.getElementById('modalMainImage').style.transform = 'scale(1)';
    }

    // --- LOGIC ZOOM ĐÃ SỬA LỖI ---
    function zoomIn() {
        if (currentZoom < 4) {
            currentZoom += zoomStep;
            // Dùng cộng chuỗi thông thường thay vì template literal
            document.getElementById('modalMainImage').style.transform = 'scale(' + currentZoom + ')';
        }
    }

    function zoomOut() {
        if (currentZoom > 0.4) {
            currentZoom -= zoomStep;
            // Dùng cộng chuỗi thông thường
            document.getElementById('modalMainImage').style.transform = 'scale(' + currentZoom + ')';
        }
    }
    
    // Hàm changeImage bên ngoài trang chính (giữ nguyên)
    function changeImage(element, imageUrl) {
        document.getElementById('mainImage').src = imageUrl;
        var allThumbs = document.querySelectorAll('.thumb-item:not(.plus-item)');
        allThumbs.forEach(function(thumb) { thumb.style.borderColor = "transparent"; });
        element.style.borderColor = "#C92127";
    }
    </script>
</body>
</html>