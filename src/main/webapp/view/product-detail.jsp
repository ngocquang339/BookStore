
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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
        /* --- CSS CHO THÔNG BÁO GIỎ HÀNG THÀNH CÔNG --- */
        .cart-toast {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: rgba(30, 30, 30, 0.85); 
            color: white;
            padding: 30px 40px;
            border-radius: 8px;
            text-align: center;
            z-index: 10005; 
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
            animation: fadeInOut 2.5s ease-in-out forwards; 
            pointer-events: none; /* Không chặn click chuột của người dùng */
        }
        
        .cart-toast .toast-icon {
            font-size: 50px;
            color: #00b14f; /* Màu xanh lá cây giống ảnh */
            background: white;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .cart-toast .toast-text {
            font-size: 16px;
            font-weight: bold;
        }

        .cart-toast.active {
            display: flex !important;
            animation: fadeInOut 2.5s ease-in-out forwards;
        }

        .coupon-scroll::-webkit-scrollbar { height: 4px; }
        .coupon-scroll::-webkit-scrollbar-track { background: transparent; }
        .coupon-scroll::-webkit-scrollbar-thumb { background: #ddd; border-radius: 4px; }
        .coupon-scroll::-webkit-scrollbar-thumb:hover { background: #bbb; }

        /* Nền đen mờ phủ toàn màn hình */
        .address-modal-overlay {
            position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            background: rgba(0,0,0,0.5); z-index: 10005;
            display: flex; justify-content: center; align-items: center;
        }

        /* Hộp trắng Modal */
        .address-modal-box {
            background: #fff; width: 700px; padding: 30px;
            border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        /* Custom Radio Button */
        .address-radio-label {
            display: flex; align-items: center; cursor: pointer;
            font-size: 15px; color: #333; margin-bottom: 15px;
        }
        .address-radio-label input {
            width: 18px; height: 18px; margin-right: 10px; cursor: pointer;
            accent-color: #ea0606; /* Đổi màu nút tick sang đỏ MINDBOOK */
        }

        /* Nhóm Thẻ Select */
        .select-group {
            display: flex; align-items: center; margin-bottom: 15px;
        }
        
        .select-group label {
            width: 140px; /* Tăng lên 140px để chữ "Tỉnh/Thành Phố" không bị rớt xuống 2 dòng */
            font-size: 14px; color: #333;
        }
        
        .select-group select {
            width: 350px; /* SỬA Ở ĐÂY: Xóa 'flex: 1' và chốt cứng chiều rộng là 350px */
            padding: 8px 12px; border: 1px solid #ddd;
            border-radius: 4px; outline: none; font-size: 14px; color: #555;
            background-color: #fff;
        }
        /* Giao diện khi select bị khóa (disabled) */
        .select-group select:disabled {
            background-color: #f5f5f5; cursor: not-allowed;
        }

        /* Nút Hủy và Xác nhận */
        .address-modal-actions {
            display: flex; justify-content: flex-end; gap: 15px; margin-top: 30px;
        }
        .btn-cancel {
            background: transparent; border: none; color: #555;
            font-size: 15px; font-weight: bold; cursor: pointer;
        }
        .btn-confirm {
            background: #e0e0e0; color: #888; border: none; padding: 8px 20px;
            border-radius: 4px; font-size: 15px; font-weight: bold; 
            cursor: not-allowed; /* SỬA DÒNG NÀY: Hiện biểu tượng cấm click khi nút màu xám */
            transition: background 0.3s, color 0.3s;
        }
        
        /* CLASS MỚI: Dùng để đổi nút sang màu đỏ khi đã chọn đủ thông tin */
        .btn-confirm.ready {
            background: #C92127; color: white; cursor: pointer;
        }
        /* Nếu muốn nút Xác nhận đỏ lên khi sẵn sàng thì dùng class này: 
        background: #C92127; color: white; */
        .nav-btn:hover { background: rgba(255,255,255,0.2) !important; transform: translateY(-50%) scale(1.1) !important; }
        .modal-thumb-scroll::-webkit-scrollbar { height: 6px; }
        .modal-thumb-scroll::-webkit-scrollbar-track { background: #333; border-radius: 4px; }
        .modal-thumb-scroll::-webkit-scrollbar-thumb { background: #888; border-radius: 4px; }
        .modal-thumb-scroll::-webkit-scrollbar-thumb:hover { background: #bbb; }

        /* Hiệu ứng trượt nhẹ từ dưới lên và tự mờ đi */
        @keyframes fadeInOut {
            0% { opacity: 0; transform: translate(-50%, -40%); }
            15% { opacity: 1; transform: translate(-50%, -50%); }
            80% { opacity: 1; transform: translate(-50%, -50%); }
            100% { opacity: 0; transform: translate(-50%, -60%); visibility: hidden; }
        }

                /* KHUNG TỔNG THỂ */
        .review-container {
            background-color: #ffffff;
            padding: 25px;
            border-radius: 8px;
            margin-top: 20px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.1);
        }
        .review-title {
            font-size: 18px;
            color: #333;
            margin-top: 0;
            margin-bottom: 20px;
            text-transform: uppercase;
        }

        /* 1. PHẦN TỔNG QUAN */
        .review-overview {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 20px;
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 25px;
            margin-bottom: 25px;
        }
        .rating-score { text-align: center; min-width: 120px; }
        .rating-bars { flex: 1; min-width: 250px; max-width: 400px; margin: 0 20px; }
        .rating-action { min-width: 200px; display: flex; justify-content: center; align-items: center; }

        .btn-write-review {
            background: white;
            color: #C92127;
            border: 1px solid #C92127;
            padding: 10px 30px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.3s;
        }
        .btn-write-review:hover { background: #fff0f0; }

        /* 2. PHẦN FORM ĐÁNH GIÁ (ẨN MẶC ĐỊNH) */
        .review-form-wrapper {
            background: #f9f9f9;
            border: 1px solid #eee;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            display: none; /* Sẽ được hiện bằng JS */
        }
        .star-voting {
            font-size: 28px;
            color: #ddd;
            cursor: pointer;
            margin-bottom: 15px;
        }
        .star-voting i.active { color: #F5A623; }
        .review-textarea {
            width: 100%;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
            outline: none;
            box-sizing: border-box;
        }
        .review-textarea:focus { border-color: #C92127; }
        .btn-submit-review {
            background: #C92127;
            color: white;
            border: none;
            padding: 10px 25px;
            border-radius: 6px;
            font-weight: bold;
            margin-top: 15px;
            cursor: pointer;
        }

        /* 3. PHẦN DANH SÁCH USER REVIEWS */
        .review-list { display: flex; flex-direction: column; gap: 20px; }
        .review-item {
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 20px;
        }
        .review-item:last-child { border-bottom: none; }
        .reviewer-info {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
        }
        .reviewer-avatar {
            width: 40px;
            height: 40px;
            background: #e0e0e0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: #666;
        }
        .reviewer-name { font-weight: 600; color: #333; font-size: 14px; }
        .review-date { font-size: 12px; color: #999; }
        .review-stars { color: #F5A623; font-size: 12px; }
        .review-content { font-size: 14px; color: #444; line-height: 1.5; margin-top: 8px; }
    </style>
</head>
<body>

    <jsp:include page="component/header.jsp" />
    <div id="ajaxCartToast" class="cart-toast" style="display: none;">
        <div class="toast-icon">
            <i class="fa-solid fa-circle-check"></i>
        </div>
        <div class="toast-text">Sản phẩm đã được thêm vào giỏ hàng.</div>
    </div>

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
                <form style="width: 100%; margin-top: 25px;">
                    <input type="hidden" name="id" value="${book.id}">
                    <div class="button-group" style="display: flex; gap: 15px; width: 100%;">
                        
                        <button type="button" onclick="addToCartAjax()" style="background: white; color: #C92127; border: 2px solid #C92127; padding: 12px 20px; font-weight: bold; font-size: 16px; cursor: pointer; border-radius: 8px; flex: 1; display: flex; align-items: center; justify-content: center; gap: 8px; transition: 0.3s;">
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
                    <a href="javascript:void(0)" onclick="openAddressModal()" style="color: #0d8de7; text-decoration: none; margin-left: 10px;">Thay đổi</a>
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


            <div class="product-detail-box white-box" style="padding: 15px; border-radius: 8px;">
                <h3 class="section-header" style="margin-top: 0; margin-bottom: 15px; font-size: 18px;">Thông tin chi tiết</h3>
                
                <div class="detail-row" style="margin-bottom: 10px;">
                    <div class="detail-label" style="color: #777; width: 150px; display: inline-block;">Mã sách</div>
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

        <div id="review-section" class="review-container">
            <h3 class="review-title">Đánh Giá Sản Phẩm</h3>

            <div class="review-overview">
                <div class="rating-score">
                    <div style="font-size: 48px; font-weight: bold; line-height: 1; color: #333;">
                        ${totalReviews > 0 ? averageRating : '0.0'}<span style="font-size: 24px; color: #999; font-weight: normal;">/5</span>
                    </div>
                    
                    <div style="color: #F5A623; font-size: 18px; margin: 8px 0;">
                        <c:forEach var="i" begin="1" end="5">
                            <c:choose>
                                <%-- Nếu điểm trung bình >= vị trí sao (VD: 4.5 >= 4) -> In sao Vàng Full --%>
                                <c:when test="${averageRating >= i}">
                                    <i class="fa-solid fa-star"></i>
                                </c:when>
                                <%-- Nếu điểm trung bình có phần lẻ >= 0.5 (VD: 4.5 >= 5 - 0.5) -> In sao Vàng Khuyết Nửa --%>
                                <c:when test="${averageRating >= (i - 0.5)}">
                                    <i class="fa-solid fa-star-half-stroke"></i>
                                </c:when>
                                <%-- Còn lại -> In sao Xám --%>
                                <c:otherwise>
                                    <i class="fa-regular fa-star" style="color: #ddd;"></i>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                    
                    <div style="color: #777; font-size: 13px;">(${totalReviews} đánh giá)</div>
                </div>

                <div class="rating-bars">
                    <c:forEach var="i" begin="1" end="5" step="1">
                        <%-- Tạo biến starValue chạy lùi từ 5 xuống 1 --%>
                        <c:set var="starValue" value="${6 - i}" /> 
                        
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px; font-size: 13px; color: #555;">
                            <span style="width: 45px; text-align: right;">${starValue} sao</span>
                            
                            <div style="flex: 1; height: 6px; background-color: #eee; border-radius: 3px; overflow: hidden;">
                                <%-- Chiều rộng của thanh cam sẽ tự động lấy từ mảng % (Thêm transition để có hiệu ứng trượt mượt mà) --%>
                                <div style="width: ${starPercentages != null ? starPercentages[starValue] : 0}%; height: 100%; background-color: #F5A623; transition: width 0.8s ease-out;"></div>
                            </div>
                            
                            <%-- In con số % ra text --%>
                            <span style="width: 30px; text-align: right;">${starPercentages != null ? starPercentages[starValue] : 0}%</span>
                        </div>
                    </c:forEach>
                </div>

                <div class="rating-action">
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <button type="button" class="btn-write-review" onclick="toggleReviewForm()">
                                <i class="fa-solid fa-pen"></i> Viết đánh giá
                            </button>
                        </c:when>
                        <c:otherwise>
                            <div style="font-size: 14px; color: #333; text-align: center; line-height: 1.5;">
                                Chỉ có thành viên mới có thể viết nhận xét.<br>Vui lòng 
                                <a href="${pageContext.request.contextPath}/login" style="color: #2f80ed; font-weight: bold; text-decoration: none;">Đăng nhập</a> hoặc 
                                <a href="${pageContext.request.contextPath}/register" style="color: #2f80ed; font-weight: bold; text-decoration: none;">Đăng ký</a>.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <%-- phần form đánh giá khi người dùng click vào nút "Viết đánh giá" --%>
            <div id="reviewFormSection" class="review-form-wrapper">
                <form id="reviewForm" action="review" method="POST">
                    <input type="hidden" name="pid" value="${book.id}">
                    <input type="hidden" id="ratingValue" name="rating" value="5"> <div style="font-weight: bold; margin-bottom: 10px;">Bạn chấm sản phẩm này bao nhiêu sao?</div>
                    
                    <div class="star-voting" id="starVoting">
                        <i class="fa-solid fa-star active" data-value="1"></i>
                        <i class="fa-solid fa-star active" data-value="2"></i>
                        <i class="fa-solid fa-star active" data-value="3"></i>
                        <i class="fa-solid fa-star active" data-value="4"></i>
                        <i class="fa-solid fa-star active" data-value="5"></i>
                    </div>

                    <textarea name="comment" class="review-textarea" placeholder="Chia sẻ cảm nhận của bạn về cuốn sách này nhé..." required></textarea>
                    
                    <div style="text-align: right;">
                        <button type="button" class="btn-write-review" style="display: inline-block; color: #666; border-color: #ccc; margin-right: 10px;" onclick="toggleReviewForm()">Hủy</button>
                        <button type="submit" class="btn-submit-review">Gửi đánh giá</button>
                    </div>
                </form>
            </div>

            <div class="review-list" id="reviewListContainer">
        
                <c:choose>
                    <%-- Trường hợp 1: Có đánh giá --%>
                    <c:when test="${not empty listReviews}">
                        <c:forEach items="${listReviews}" var="r">
                            <div class="review-item">
                                <div class="reviewer-info">
                                    <div class="reviewer-avatar">${r.username.substring(0, 1).toUpperCase()}</div> 
                                    <div>
                                        <div class="reviewer-name">${r.username}</div>
                                        <div class="review-date">${r.createAt}</div>
                                    </div>
                                </div>
                                
                                <div class="review-stars">
                                    <c:forEach begin="1" end="${r.rating}">
                                        <i class="fa-solid fa-star"></i>
                                    </c:forEach>
                                    <c:forEach begin="${r.rating + 1}" end="5">
                                        <i class="fa-regular fa-star" style="color: #ddd;"></i>
                                    </c:forEach>
                                </div>
                                
                                <div class="review-content">
                                    ${r.comment}
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>

                    <%-- Trường hợp 2: Chưa có ai đánh giá --%>
                    <c:otherwise>
                        <div style="text-align: center; color: #999; padding: 30px; background: #fdfdfd; border-radius: 8px; border: 1px dashed #eee;">
                            <i class="fa-regular fa-comment-dots" style="font-size: 32px; color: #ddd; margin-bottom: 10px; display: block;"></i>
                            Chưa có đánh giá nào cho sản phẩm này.<br>Hãy là người đầu tiên nhận xét!
                        </div>
                    </c:otherwise>
                </c:choose>
                
            </div>
        </div>

    <div class="same-author-box white-box" style="padding: 20px; border-radius: 8px; margin-top: 20px;">
        <h3 style="text-transform: uppercase; font-size: 16px; font-weight: bold; margin-bottom: 20px; color: #333;">
            Sản phẩm cùng tác giả
        </h3>

        <div style="display: grid; grid-template-columns: repeat(5, 1fr); gap: 15px;">
            
            <c:forEach items="${bookSameAuthor}" var="b" end="4">
                
                <a href="${pageContext.request.contextPath}/detail?pid=${b.id}" style="text-decoration: none; color: inherit; display: block; padding: 10px; transition: 0.3s; border-radius: 8px;" 
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

        <div id="addressModalOverlay" class="address-modal-overlay" style="display: none;">
            <div class="address-modal-box">
                <h4 style="text-align: center; margin-top: 0; margin-bottom: 25px; font-size: 18px; color: #333;">Chọn địa chỉ giao hàng của bạn</h4>

                <label class="address-radio-label">
                    <input type="radio" name="address_type" value="existing" onchange="toggleAddressFields()">
                    <span class="radio-custom"></span>
                    Giao hàng đến <span style="color: #777; margin-left: 5px;"> Phường Bến Nghé, Quận 1, Hồ Chí Minh</span>
                </label>

                <label class="address-radio-label" style="margin-bottom: 15px;">
                    <input type="radio" name="address_type" value="new" checked onchange="toggleAddressFields()">
                    <span class="radio-custom"></span>
                    Giao hàng đến địa chỉ khác
                </label>

                <div id="newAddressFields" style="padding-left: 30px;">
                    <div class="select-group">
                        <label>Tỉnh/Thành Phố</label>
                        <select id="provinceSelect"><option>Chọn tỉnh/thành Phố</option></select>
                    </div>
                    <div class="select-group">
                        <label>Quận/Huyện</label>
                        <select id="districtSelect"><option>Chọn quận/huyện</option></select>
                    </div>
                    <div class="select-group" style="margin-bottom: 0;">
                        <label>Phường/Xã</label>
                        <select id="wardSelect"><option>Chọn phường/xã</option></select>
                    </div>
                </div>

                <div class="address-modal-actions">
                    <button class="btn-cancel" onclick="closeAddressModal()">Hủy</button>
                    <button class="btn-confirm" onclick="confirmAddress()">Xác nhận</button>
                </div>
            </div>
        </div>

    </main>

    <script>
        function changeImage(element, imageUrl){
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

    // --- LOGIC CHO MODAL CHỌN ĐỊA CHỈ ---

    // 1. Mở Modal
    function openAddressModal() {
        document.getElementById('addressModalOverlay').style.display = 'flex';
        toggleAddressFields(); // Cập nhật trạng thái ô select ngay khi mở
    }

    // 2. Đóng Modal
    function closeAddressModal() {
        document.getElementById('addressModalOverlay').style.display = 'none';
    }

    // 3. Khóa/Mở khóa các ô chọn Tỉnh-Huyện-Xã khi bấm Radio
    function toggleAddressFields() {
        // Kiểm tra xem nút "Địa chỉ khác" có đang được chọn hay không
        var isNewAddressChecked = document.querySelector('input[name="address_type"][value="new"]').checked;
        
        var selects = document.querySelectorAll('#newAddressFields select');
        
        // Nếu chọn "Địa chỉ có sẵn" -> Khóa ô select lại (disabled = true)
        // Nếu chọn "Địa chỉ khác" -> Mở khóa ô select (disabled = false)
        selects.forEach(function(select) {
            select.disabled = !isNewAddressChecked;
        });
    }

    $(document).ready(function() {
        const $province = $("#provinceSelect");
        const $district = $("#districtSelect");
        const $ward = $("#wardSelect");
        
        let localData = [];

        fetch('https://raw.githubusercontent.com/kenzouno1/DiaGioiHanhChinhVN/master/data.json')
            .then(response => response.json())
            .then(data => {
                localData = data; 
                let options = '<option value="">Chọn tỉnh/thành Phố</option>';
                data.forEach(item => {
                    // ĐÃ SỬA: Dùng dấu + để cộng chuỗi, Tomcat sẽ không cướp mất dữ liệu nữa
                    options += '<option value="' + item.Id + '">' + item.Name + '</option>';
                });
                $province.html(options);
            })
            .catch(err => console.error("Lỗi tải dữ liệu địa giới:", err));

        $province.change(function() {
            let idProv = $(this).val();
            $district.html('<option value="">Chọn quận/huyện</option>');
            $ward.html('<option value="">Chọn phường/xã</option>');

            if (idProv !== "") {
                let prov = localData.find(p => p.Id === idProv);
                if (prov && prov.Districts) {
                    let options = '<option value="">Chọn quận/huyện</option>';
                    prov.Districts.forEach(item => {
                        // ĐÃ SỬA: Dùng dấu + để cộng chuỗi
                        options += '<option value="' + item.Id + '">' + item.Name + '</option>';
                    });
                    $district.html(options);
                }
            }
        });

        $district.change(function() {
            let idProv = $province.val();
            let idDist = $(this).val();
            $ward.html('<option value="">Chọn phường/xã</option>');

            if (idProv !== "" && idDist !== "") {
                let prov = localData.find(p => p.Id === idProv);
                if (prov) {
                    let dist = prov.Districts.find(d => d.Id === idDist);
                    if (dist && dist.Wards) {
                        let options = '<option value="">Chọn phường/xã</option>';
                        dist.Wards.forEach(item => {
                            // ĐÃ SỬA: Dùng dấu + để cộng chuỗi
                            options += '<option value="' + item.Id + '">' + item.Name + '</option>';
                        });
                        $ward.html(options);
                    }
                }
            }
        });
    });

    // 4. HÀM BẤM NÚT XÁC NHẬN
    function confirmAddress() {
        if (!$(".btn-confirm").hasClass("ready")) {
            return; 
        }
        let isNewAddress = document.querySelector('input[name="address_type"][value="new"]').checked;
        
        if (isNewAddress) {
            // Lấy tên chữ (chứ không phải ID số) của Tỉnh, Huyện, Xã
            let provText = $("#provinceSelect option:selected").text();
            let distText = $("#districtSelect option:selected").text();
            let wardText = $("#wardSelect option:selected").text();

            if(provText === 'Chọn tỉnh/thành Phố' || distText === 'Chọn quận/huyện' || wardText === 'Chọn phường/xã') {
                alert("Vui lòng chọn đầy đủ địa chỉ!");
                return;
            }

            let fullAddress = wardText + ", " + distText + ", " + provText;
            
            // Tìm chỗ in địa chỉ ngoài màn hình (Bạn cần cấp id="displayAddress" cho thẻ <strong> ở ngoài HTML nhé)
            $("#displayAddress").text(fullAddress);
        }
        
        closeAddressModal();
    }

    function addToCartAjax() {
        let bookId = document.querySelector('input[name="id"]').value;
        let qty = document.getElementById("qtyInput").value;
        
        // THÊM BIẾN &ajax=true VÀO CUỐI ĐƯỜNG LINK ĐỂ BÁO CHO SERVLET BIẾT
        let url = "${pageContext.request.contextPath}/add-to-cart?id=" + bookId + "&quantity=" + qty + "&ajax=true";

        fetch(url)
        .then(response => response.text()) // Lấy dữ liệu dạng chữ (chính là con số cartSize từ Servlet trả về)
        .then(cartSize => {
            
            // 1. Cập nhật ngay lập tức con số thật từ Server vào Icon giỏ hàng
            let cartBadge = document.getElementById("cartTotal");
            if (cartBadge) {
                cartBadge.innerText = cartSize; // Điền số thật, không cộng mò nữa!
            }

            // 2. Hiện hộp thông báo thành công
            let toast = document.getElementById("ajaxCartToast");
            toast.style.display = "flex";
            toast.classList.remove("active"); 
            void toast.offsetWidth; 
            toast.classList.add("active");

            // 3. Giấu thông báo đi sau 1.5 giây
            setTimeout(() => {
                toast.style.display = "none";
                toast.classList.remove("active");
            }, 1500); 
            
        })
        .catch(err => console.log("Lỗi kết nối:", err));
    }
    // 5. HÀM KIỂM TRA ĐIỀU KIỆN ĐỂ BẬT NÚT XÁC NHẬN SÁNG LÊN
    function checkConfirmButtonState() {
        let isNewAddress = document.querySelector('input[name="address_type"][value="new"]').checked;
        let $btn = $(".btn-confirm");

        if (!isNewAddress) {
            // Nếu khách chọn "Địa chỉ có sẵn" -> Nút luôn sáng màu đỏ
            $btn.addClass("ready");
        } else {
            // Nếu chọn "Địa chỉ khác" -> Kiểm tra 3 ô select xem đã có value khác rỗng chưa
            let p = $("#provinceSelect").val();
            let d = $("#districtSelect").val();
            let w = $("#wardSelect").val();

            if (p !== "" && d !== "" && w !== "") {
                // Đã chọn đủ 3 ô -> Sáng nút
                $btn.addClass("ready");
            } else {
                // Chưa chọn đủ -> Nút xám
                $btn.removeClass("ready");
            }
        }
    }

    // Gắn "bộ nẹt" để tự động chạy hàm trên mỗi khi khách hàng bấm thay đổi bất cứ ô select hay radio nào trong Modal
    $(document).ready(function() {
        $('#addressModalOverlay').on('change', 'select, input[type="radio"]', function() {
            checkConfirmButtonState();
        });
    });

    // Hàm bật/tắt form viết đánh giá
    function toggleReviewForm() {
        const form = document.getElementById("reviewFormSection");
        if (form.style.display === "none" || form.style.display === "") {
            form.style.display = "block";
        } else {
            form.style.display = "none";
        }
    }

    // Xử lý hiệu ứng chọn sao (1 đến 5 sao)
    const stars = document.querySelectorAll("#starVoting i");
    const ratingInput = document.getElementById("ratingValue");

    stars.forEach(star => {
        star.addEventListener("click", function() {
            const value = this.getAttribute("data-value");
            ratingInput.value = value; // Cập nhật giá trị vào input hidden để submit lên Server

            // Đổi màu các sao
            stars.forEach(s => {
                if (s.getAttribute("data-value") <= value) {
                    s.classList.add("active");
                    s.classList.replace("fa-regular", "fa-solid");
                } else {
                    s.classList.remove("active");
                    s.classList.replace("fa-solid", "fa-regular");
                }
            });
        });
    });

    document.getElementById('reviewForm').addEventListener('submit', function(e) {
        // Chặn reload trang
        e.preventDefault(); 

        const form = this;
        const formData = new FormData(form);
        const submitBtn = form.querySelector('.btn-submit-review');
        const originalBtnText = submitBtn.innerText;

        submitBtn.innerText = "Đang xử lý...";
        submitBtn.disabled = true;

        const data = new URLSearchParams();
        for (const pair of formData) {
            data.append(pair[0], pair[1]);
        }

        fetch('review', {
            method: 'POST',
            body: data,
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        })
        .then(response => {
            // NẾU SERVLET TRẢ VỀ STATUS 200 (THÀNH CÔNG)
            if(response.ok) { 
                
                toggleReviewForm(); // Đóng form
                
                // Vẽ bình luận mới lên đầu
                const rating = parseInt(formData.get('rating'));
                const comment = formData.get('comment');
                const userName = '${sessionScope.user.username}'; 
                const avatarChar = userName ? userName.substring(0, 1).toUpperCase() : 'U';

                let starsHtml = '';
                for(let i=1; i<=5; i++) {
                    if(i <= rating) starsHtml += '<i class="fa-solid fa-star"></i>';
                    else starsHtml += '<i class="fa-regular fa-star" style="color: #ddd;"></i>';
                }

                // Dùng dấu cộng chuỗi truyền thống để tránh đụng độ với JSP
                const newReviewHtml = '<div class="review-item" style="animation: fadeIn 0.5s;">' +
                    '<div class="reviewer-info">' +
                        '<div class="reviewer-avatar">' + avatarChar + '</div>' +
                        '<div>' +
                            '<div class="reviewer-name">' + userName + '</div>' +
                            '<div class="review-date">Vừa xong</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="review-stars">' + starsHtml + '</div>' +
                    '<div class="review-content">' + comment + '</div>' +
                '</div>';

                const listContainer = document.getElementById('reviewListContainer');
                if(listContainer.innerHTML.includes('fa-comment-dots')) {
                    listContainer.innerHTML = ''; // Xóa thông báo trống
                }
                listContainer.insertAdjacentHTML('afterbegin', newReviewHtml);

                // Xóa form
                form.reset();
                document.getElementById('ratingValue').value = 5;
                document.querySelectorAll('#starVoting i').forEach(s => {
                    s.classList.add("active");
                    s.classList.replace("fa-regular", "fa-solid");
                });

            // NẾU SERVLET TRẢ VỀ STATUS 401 (CHƯA ĐĂNG NHẬP)
            } else if (response.status === 401) {
                alert("Phiên đăng nhập đã hết hạn. Vui lòng tải lại trang để đăng nhập!");
            } else {
                alert("Lỗi hệ thống, không thể lưu đánh giá!");
            }
        })
        .catch(error => {
            console.error('Error:', error);
            // Nếu bạn vẫn thấy dòng này hiện lên, nghĩa là mạng nhà bạn rớt hoặc Tomcat bị sập ngang
            alert("Không thể kết nối đến máy chủ!"); 
        })
        .finally(() => {
            submitBtn.innerText = originalBtnText;
            submitBtn.disabled = false;
        });
    });
    </script>
</body>
</html>