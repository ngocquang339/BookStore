<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <title>${book.title} - BookStore</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product-detail.css">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                    <style>
                        /* 1. Thiết lập nền xám cho toàn trang */
                        body {
                            background-color: #F0F0F0 !important;
                        }

                        /* CSS for the Admin Internal Data Box */
                        .admin-inspector {
                            background-color: #fff3cd;
                            /* Yellow warning color */
                            border: 1px solid #ffeeba;
                            padding: 15px;
                            margin-bottom: 20px;
                            border-radius: 5px;
                            color: #856404;
                        }

                        .admin-inspector h4 {
                            margin-top: 0;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }

                        .edit-btn {
                            background-color: #ffc107;
                            color: #000;
                            padding: 5px 10px;
                            text-decoration: none;
                            font-size: 14px;
                            border-radius: 4px;
                            font-weight: bold;
                        }

                        .edit-btn:hover {
                            background-color: #e0a800;
                        }

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
                            pointer-events: none;
                            /* Không chặn click chuột của người dùng */
                        }

                        .cart-toast .toast-icon {
                            font-size: 50px;
                            color: #00b14f;
                            /* Màu xanh lá cây giống ảnh */
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

                        .coupon-scroll::-webkit-scrollbar {
                            height: 4px;
                        }

                        .coupon-scroll::-webkit-scrollbar-track {
                            background: transparent;
                        }

                        .coupon-scroll::-webkit-scrollbar-thumb {
                            background: #ddd;
                            border-radius: 4px;
                        }

                        .coupon-scroll::-webkit-scrollbar-thumb:hover {
                            background: #bbb;
                        }

                        /* Nền đen mờ phủ toàn màn hình */
                        .address-modal-overlay {
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100vw;
                            height: 100vh;
                            background: rgba(0, 0, 0, 0.5);
                            z-index: 10005;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                        }

                        /* Hộp trắng Modal */
                        .address-modal-box {
                            background: #fff;
                            width: 700px;
                            padding: 30px;
                            border-radius: 8px;
                            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                        }

                        /* Custom Radio Button */
                        .address-radio-label {
                            display: flex;
                            align-items: center;
                            cursor: pointer;
                            font-size: 15px;
                            color: #333;
                            margin-bottom: 15px;
                        }

                        .address-radio-label input {
                            width: 18px;
                            height: 18px;
                            margin-right: 10px;
                            cursor: pointer;
                            accent-color: #ea0606;
                            /* Đổi màu nút tick sang đỏ MINDBOOK */
                        }

                        /* Nhóm Thẻ Select */
                        .select-group {
                            display: flex;
                            align-items: center;
                            margin-bottom: 15px;
                        }

                        .select-group label {
                            width: 140px;
                            /* Tăng lên 140px để chữ "Tỉnh/Thành Phố" không bị rớt xuống 2 dòng */
                            font-size: 14px;
                            color: #333;
                        }

                        .select-group select {
                            width: 350px;
                            /* SỬA Ở ĐÂY: Xóa 'flex: 1' và chốt cứng chiều rộng là 350px */
                            padding: 8px 12px;
                            border: 1px solid #ddd;
                            border-radius: 4px;
                            outline: none;
                            font-size: 14px;
                            color: #555;
                            background-color: #fff;
                        }

                        /* Giao diện khi select bị khóa (disabled) */
                        .select-group select:disabled {
                            background-color: #f5f5f5;
                            cursor: not-allowed;
                        }

                        /* Nút Hủy và Xác nhận */
                        .address-modal-actions {
                            display: flex;
                            justify-content: flex-end;
                            gap: 15px;
                            margin-top: 30px;
                        }

                        .btn-cancel {
                            background: transparent;
                            border: none;
                            color: #555;
                            font-size: 15px;
                            font-weight: bold;
                            cursor: pointer;
                        }

                        .btn-confirm {
                            background: #e0e0e0;
                            color: #888;
                            border: none;
                            padding: 8px 20px;
                            border-radius: 4px;
                            font-size: 15px;
                            font-weight: bold;
                            cursor: not-allowed;
                            /* SỬA DÒNG NÀY: Hiện biểu tượng cấm click khi nút màu xám */
                            transition: background 0.3s, color 0.3s;
                        }

                        /* CLASS MỚI: Dùng để đổi nút sang màu đỏ khi đã chọn đủ thông tin */
                        .btn-confirm.ready {
                            background: #C92127;
                            color: white;
                            cursor: pointer;
                        }

                        /* Nếu muốn nút Xác nhận đỏ lên khi sẵn sàng thì dùng class này: 
        background: #C92127; color: white; */
                        .nav-btn:hover {
                            background: rgba(255, 255, 255, 0.2) !important;
                            transform: translateY(-50%) scale(1.1) !important;
                        }

                        .modal-thumb-scroll::-webkit-scrollbar {
                            height: 6px;
                        }

                        .modal-thumb-scroll::-webkit-scrollbar-track {
                            background: #333;
                            border-radius: 4px;
                        }

                        .modal-thumb-scroll::-webkit-scrollbar-thumb {
                            background: #888;
                            border-radius: 4px;
                        }

                        .modal-thumb-scroll::-webkit-scrollbar-thumb:hover {
                            background: #bbb;
                        }

                        /* Hiệu ứng trượt nhẹ từ dưới lên và tự mờ đi */
                        @keyframes fadeInOut {
                            0% {
                                opacity: 0;
                                transform: translate(-50%, -40%);
                            }

                            15% {
                                opacity: 1;
                                transform: translate(-50%, -50%);
                            }

                            80% {
                                opacity: 1;
                                transform: translate(-50%, -50%);
                            }

                            100% {
                                opacity: 0;
                                transform: translate(-50%, -60%);
                                visibility: hidden;
                            }
                        }

                        /* KHUNG TỔNG THỂ */
                        .review-container {
                            background-color: #ffffff;
                            padding: 25px;
                            border-radius: 8px;
                            margin-top: 20px;
                            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
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

                        .rating-score {
                            text-align: center;
                            min-width: 120px;
                        }

                        .rating-bars {
                            flex: 1;
                            min-width: 250px;
                            max-width: 400px;
                            margin: 0 20px;
                        }

                        .rating-action {
                            min-width: 200px;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                        }

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

                        .btn-write-review:hover {
                            background: #fff0f0;
                        }

                        /* 2. PHẦN FORM ĐÁNH GIÁ (ẨN MẶC ĐỊNH) */
                        .review-form-wrapper {
                            background: #f9f9f9;
                            border: 1px solid #eee;
                            padding: 20px;
                            border-radius: 8px;
                            margin-bottom: 30px;
                            display: none;
                            /* Sẽ được hiện bằng JS */
                        }

                        .star-voting {
                            font-size: 28px;
                            color: #ddd;
                            cursor: pointer;
                            margin-bottom: 15px;
                        }

                        .star-voting i.active {
                            color: #F5A623;
                        }

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

                        .review-textarea:focus {
                            border-color: #C92127;
                        }

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
                        .review-list {
                            display: flex;
                            flex-direction: column;
                            gap: 20px;
                        }

                        .review-item {
                            border-bottom: 1px solid #f0f0f0;
                            padding-bottom: 20px;
                        }

                        .review-item:last-child {
                            border-bottom: none;
                        }

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

                        .reviewer-name {
                            font-weight: 600;
                            color: #333;
                            font-size: 14px;
                        }

                        .review-date {
                            font-size: 12px;
                            color: #999;
                        }

                        .review-stars {
                            color: #F5A623;
                            font-size: 12px;
                        }

                        .review-content {
                            font-size: 14px;
                            color: #444;
                            line-height: 1.5;
                            margin-top: 8px;
                        }

                        /* HIỆU ỨNG BÌNH LUẬN CON (THỤT LỀ) */
                        .nested-reply {
                            margin-left: 45px !important;
                            position: relative;
                        }

                        /* Vẽ đường gạch vuông góc như Facebook */
                        .nested-reply::before {
                            content: "";
                            position: absolute;
                            top: -10px;
                            left: -25px;
                            width: 20px;
                            height: 25px;
                            border-left: 2px solid #ddd;
                            border-bottom: 2px solid #ddd;
                            border-bottom-left-radius: 6px;
                        }

                        .avatar-normal {
                            width: 30px;
                            height: 30px;
                            font-size: 12px;
                        }

                        .avatar-nested {
                            width: 24px;
                            height: 24px;
                            font-size: 10px;
                        }

                        /* Class cho thẻ tag người dùng */
                        .user-tag {
                            color: #2489F4;
                            /* Màu xanh giống màu các link trên web của bạn */
                            font-weight: 500;
                            text-decoration: none;
                        }

                        .user-tag:hover {
                            text-decoration: underline;
                        }

                        /* Hiệu ứng bôi đậm comment khi từ thông báo nhảy tới */
                        .highlight-target {
                            animation: highlight-fade 3s ease-out;
                        }

                        @keyframes highlight-fade {
                            0% {
                                background-color: #ffe8a1;
                                box-shadow: 0 0 10px #ffe8a1;
                            }

                            100% {
                                background-color: transparent;
                                box-shadow: none;
                            }
                        }

                        .public-profile-link:hover {
                            color: #C92127 !important;
                            /* Đổi sang màu đỏ thương hiệu khi trỏ chuột */
                            text-decoration: underline;
                        }
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
                                <div class="main-image-container"
                                    style="text-align: center; border: none; padding: 10px; margin-bottom: 15px; height: 400px; display: flex; align-items: center; justify-content: center;">
                                    <img id="mainImage" src="${pageContext.request.contextPath}/${book.imageUrl}"
                                        alt="${book.title}" class="main-img"
                                        style="max-width: 100%; max-height: 100%; object-fit: contain;">
                                </div>

                                <div class="thumbnail-list" style="display:flex; gap:12px; justify-content:center;">

                                    <div class="thumb-item active"
                                        style="width: 80px; height: 80px; border: 2px solid #C92127; border-radius: 4px; cursor: pointer; padding: 2px; display: flex; justify-content: center; align-items: center;"
                                        onclick="changeImage(this, '${pageContext.request.contextPath}/${book.imageUrl}')">
                                        <img src="${pageContext.request.contextPath}/${book.imageUrl}"
                                            style="max-width: 100%; max-height: 100%; object-fit: contain;">
                                    </div>

                                    <c:forEach items="${bookImages}" var="img" varStatus="status">

                                        <c:if test="${status.index < 3}">
                                            <div class="thumb-item"
                                                style="width: 80px; height: 80px; border: 2px solid transparent; border-radius: 4px; cursor: pointer; padding: 2px; display: flex; justify-content: center; align-items: center;"
                                                onclick="changeImage(this, '${pageContext.request.contextPath}/${img.imageUrl}')">
                                                <img src="${pageContext.request.contextPath}/${img.imageUrl}"
                                                    style="max-width: 100%; max-height: 100%; object-fit: contain;">
                                            </div>
                                        </c:if>

                                        <c:if test="${status.index == 3}">
                                            <div class="thumb-item plus-item"
                                                style="position:relative; width: 80px; height: 80px; border: 2px solid transparent; border-radius: 4px; cursor: pointer; padding: 2px; display: flex; justify-content: center; align-items: center;"
                                                onclick="openFullscreenGallery()">

                                                <img src="${pageContext.request.contextPath}/${img.imageUrl}"
                                                    style="max-width: 100%; max-height: 100%; object-fit: contain; opacity:0.4;">

                                                <div
                                                    style="position:absolute; top:0; left:0; right:0; bottom:0; display:flex; align-items:center; justify-content:center; font-weight:bold; font-size: 22px; color:#fff; background: rgba(0,0,0,0.5); border-radius: 2px;">
                                                    +${bookImages.size() - 3}
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                                <form action="${pageContext.request.contextPath}/add-to-cart" method="get"
                                    style="width: 100%; margin-top: 25px;">
                                    <input type="hidden" name="id" value="${book.id}">
                                    <input type="hidden" name="purchase" value="1">
                                    <input type="hidden" name="quantity" id="hiddenPurchaseQty" value="1">

                                    <div class="button-group" style="display: flex; gap: 15px; width: 100%;">

                                        <%-- KIỂM TRA ĐIỀU KIỆN TỒN KHO --%>
                                            <c:choose>
                                                <%-- TRƯỜNG HỢP 1: HẾT HÀNG --%>
                                                    <c:when test="${book.stockQuantity <= 0}">
                                                        <button type="button" disabled
                                                            style="background: #f5f5f5; color: #999; border: 2px solid #ddd; padding: 12px 10px; font-weight: bold; font-size: 16px; cursor: not-allowed; border-radius: 8px; flex: 1; display: flex; align-items: center; justify-content: center; gap: 8px;">
                                                            <i class="fa-solid fa-cart-plus"></i> Tạm hết hàng
                                                        </button>

                                                        <button type="button" disabled
                                                            style="background: #ccc; color: white; border: none; padding: 12px 10px; font-weight: bold; font-size: 16px; cursor: not-allowed; border-radius: 8px; flex: 1; display: flex; align-items: center; justify-content: center;">
                                                            Hết hàng
                                                        </button>
                                                    </c:when>

                                                    <%-- TRƯỜNG HỢP 2: CÒN HÀNG (Code gốc của bạn) --%>
                                                        <c:otherwise>
                                                            <button type="button" onclick="addToCartAjax()"
                                                                style="background: white; color: #C92127; border: 2px solid #C92127; padding: 12px 10px; font-weight: bold; font-size: 16px; cursor: pointer; border-radius: 8px; flex: 1; display: flex; align-items: center; justify-content: center; gap: 8px; transition: 0.3s;">
                                                                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ
                                                            </button>

                                                            <button type="submit"
                                                                onclick="document.getElementById('hiddenPurchaseQty').value = document.getElementById('qtyInput').value;"
                                                                style="background: #C92127; color: white; border: none; padding: 12px 10px; font-weight: bold; font-size: 16px; cursor: pointer; border-radius: 8px; flex: 1; display: flex; align-items: center; justify-content: center; transition: 0.3s;">
                                                                Mua ngay
                                                            </button>
                                                        </c:otherwise>
                                            </c:choose>

                                            <%-- NÚT LƯU BỘ SƯU TẬP (Luôn hiển thị) --%>
                                                <c:if test="${sessionScope.user != null}">
                                                    <button type="button" class="btn btn-outline-danger"
                                                        data-bs-toggle="modal" data-bs-target="#addToCollectionModal"
                                                        title="Lưu vào Giá sách"
                                                        style="width: 50px; height: 50px; padding: 0; display: flex; align-items: center; justify-content: center; border-radius: 8px; border: 2px solid #dc3545; flex-shrink: 0;">
                                                        <i class="fa-regular fa-heart" style="font-size: 20px;"></i>
                                                    </button>
                                                </c:if>
                                                <c:if test="${sessionScope.user == null}">
                                                    <a href="${pageContext.request.contextPath}/login"
                                                        class="btn btn-outline-danger"
                                                        title="Vui lòng đăng nhập để lưu sách"
                                                        style="width: 50px; height: 50px; padding: 0; display: flex; align-items: center; justify-content: center; border-radius: 8px; border: 2px solid #dc3545; flex-shrink: 0;">
                                                        <i class="fa-regular fa-heart" style="font-size: 20px;"></i>
                                                    </a>
                                                </c:if>

                                    </div>
                                </form>
                            </div>
                            <div class="product-info-column"
                                style="flex: 1;display: flex; flex-direction: column; gap: 15px;">
                                <div class="product-info-box white-box" style="padding: 20px; border-radius: 8px;">
                                    <c:if test="${sessionScope.user != null && sessionScope.user.role == 1}">
                                        <div class="admin-inspector" style="margin-bottom: 15px;">
                                            <div class="admin-header">
                                                <span><i class="fa-solid fa-user-secret"></i> Dữ liệu nội bộ
                                                    (Admin)</span>
                                                <a href="${pageContext.request.contextPath}/admin/product/edit?id=${book.id}"
                                                    class="edit-btn">
                                                    <i class="fa-solid fa-pen"></i> Sửa nhanh
                                                </a>
                                            </div>
                                            <ul class="admin-stats">
                                                <li><strong>Giá nhập:</strong> ${book.importPrice}đ</li>
                                                <li><strong>Tồn kho:</strong> ${book.stockQuantity}</li>
                                                <li><strong>Trạng thái:</strong> ${book.active ? 'Đang hiện' : 'Đang
                                                    ẩn'}</li>
                                            </ul>
                                        </div>
                                    </c:if>
                                    <%--=====================================--%>

                                        <h1 class="product-title"
                                            style="font-size: 24px; color: #333; margin-bottom: 15px; line-height: 1.4;">
                                            ${book.title}</h1>

                                        <div
                                            style="display:grid; grid-template-columns: 1fr 1fr; gap: 10px; font-size: 14px; margin-bottom: 15px; color: #333;">
                                            <div>Nhà cung cấp: <a href="#"
                                                    style="color:#2489F4; text-decoration:none;">${book.supplier}</a>
                                            </div>
                                            <div>Tác giả: <strong>${book.author}</strong></div>
                                            <div>Nhà xuất bản: <strong>${book.publisher}</strong></div>
                                            <div>Hình thức bìa: <strong>Bìa Mềm</strong></div>
                                        </div>

                                        <div
                                            style="display: flex; align-items: center; gap: 10px; font-size: 14px; margin-bottom: 20px;">

                                            <%-- 1. HIỂN THỊ SAO ĐỘNG DỰA VÀO averageRating --%>
                                                <div style="color: #F5A623; font-size: 13px;">
                                                    <c:forEach var="i" begin="1" end="5">
                                                        <c:choose>
                                                            <%-- Nếu điểm trung bình>= vị trí sao (VD: 3.8 >= 3) -> Sao
                                                                Vàng Full --%>
                                                                <c:when test="${averageRating >= i}">
                                                                    <i class="fa-solid fa-star"></i>
                                                                </c:when>
                                                                <%-- Nếu điểm trung bình có phần lẻ>= 0.5 (VD: 3.8 >= 4
                                                                    - 0.5) -> Sao Vàng Nửa --%>
                                                                    <c:when test="${averageRating >= (i - 0.5)}">
                                                                        <i class="fa-solid fa-star-half-stroke"></i>
                                                                    </c:when>
                                                                    <%-- Còn lại -> Sao Xám --%>
                                                                        <c:otherwise>
                                                                            <i class="fa-regular fa-star"
                                                                                style="color: #ddd;"></i>
                                                                        </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </div>

                                                <%-- 2. HIỂN THỊ SỐ LƯỢNG ĐÁNH GIÁ ĐỘNG --%>
                                                    <div style="color: #F5A623;">
                                                        <c:choose>
                                                            <c:when test="${totalReviews > 0}">
                                                                (${totalReviews} đánh giá)
                                                            </c:when>
                                                            <c:otherwise>
                                                                (0 đánh giá)
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <div style="color: #ccc;">|</div>
                                                    <div style="color: #777;">Đã bán ${book.soldQuantity != null ?
                                                        book.soldQuantity : 0}</div>
                                        </div>

                                        <div class="price-box" style="margin-bottom: 12px;">
                                            <span class="price-current"
                                                style="color: #C92127; font-size: 34px; font-weight: bold;">
                                                <fmt:formatNumber value="${book.price}" type="currency"
                                                    currencySymbol="đ" maxFractionDigits="0" />
                                            </span>
                                            <span
                                                style="color:#999; text-decoration:line-through; font-size: 16px; margin-left: 10px;">
                                                <fmt:formatNumber value="${book.price * 1.2}" type="currency"
                                                    currencySymbol="đ" maxFractionDigits="0" />
                                            </span>
                                            <span
                                                style="background:#C92127; color:white; padding:3px 8px; border-radius:4px; font-size:14px; font-weight: bold; margin-left: 10px;">-20%</span>
                                        </div>

                                        <div style="font-size: 13px; color: #C92127; margin-bottom: 5px;">
                                            Chính sách khuyến mãi trên chỉ áp dụng khi đặt hàng Online <i
                                                class="fa-solid fa-angle-right" style="font-size: 11px;"></i>
                                        </div>

                                </div>


                                <div class="product-action-box white-box" style="padding: 20px; border-radius: 8px;">

                                    <h3 style="font-size: 16px; margin-top: 0; margin-bottom: 15px; color: #333;">Thông
                                        tin vận chuyển</h3>

                                    <div style="font-size: 14px; margin-bottom: 15px;">
                                        Giao hàng đến <strong id="displayAddressText">Phường Bến Nghé, Quận 1, Hồ Chí
                                            Minh</strong>
                                        <a href="javascript:void(0)" onclick="openAddressModal()"
                                            style="color: #0d8de7; text-decoration: none; margin-left: 10px;">Thay
                                            đổi</a>
                                    </div>

                                    <div
                                        style="display: flex; align-items: flex-start; gap: 10px; margin-bottom: 25px;">
                                        <i class="fa-solid fa-truck-fast"
                                            style="color: #00b14f; font-size: 18px; margin-top: 2px;"></i>
                                        <div>
                                            <div
                                                style="font-weight: bold; font-size: 15px; margin-bottom: 5px; color: #333;">
                                                Giao hàng tiêu chuẩn
                                                <span style="color: #ccc; margin: 0 8px;">|</span>
                                                Phí ship: <span id="displayShippingFee"
                                                    style="color: #C92127;">...</span>
                                            </div>

                                            <div style="font-size: 13px; color: #555;" id="expectedDeliveryText">Dự kiến
                                                giao <strong>...</strong></div>
                                        </div>
                                    </div>





                                    <div style="display: flex; align-items: center; gap: 40px; margin-bottom: 10px;">
                                        <span style="font-weight: bold; font-size: 15px; color: #333;">Số lượng:</span>

                                        <c:choose>
                                            <%-- NẾU HẾT HÀNG: Khóa ô nhập số lượng --%>
                                                <c:when test="${book.stockQuantity <= 0}">
                                                    <span class="badge bg-secondary px-3 py-2"
                                                        style="font-size: 14px;">Sản phẩm tạm hết hàng</span>
                                                </c:when>
                                                <%-- NẾU CÒN HÀNG: Hiện ô nhập số lượng bình thường --%>
                                                    <c:otherwise>
                                                        <div
                                                            style="display: flex; align-items: center; border: 1px solid #ddd; border-radius: 4px; overflow: hidden;">
                                                            <button type="button"
                                                                style="background: white; border: none; padding: 8px 15px; cursor: pointer; border-right: 1px solid #ddd; color: #888; transition: 0.2s;"
                                                                onmouseover="this.style.background='#f5f5f5'"
                                                                onmouseout="this.style.background='white'"
                                                                onclick="let q = document.getElementById('qtyInput'); if(q.value > 1) q.value--;"><i
                                                                    class="fa-solid fa-minus"></i></button>
                                                            <input type="text" id="qtyInput" value="1"
                                                                max="${book.stockQuantity}"
                                                                style="width: 50px; text-align: center; border: none; font-weight: bold; font-size: 15px; outline: none;">
                                                            <button type="button"
                                                                style="background: white; border: none; padding: 8px 15px; cursor: pointer; border-left: 1px solid #ddd; color: #888; transition: 0.2s;"
                                                                onmouseover="this.style.background='#f5f5f5'"
                                                                onmouseout="this.style.background='white'"
                                                                onclick="let q = document.getElementById('qtyInput'); if(parseInt(q.value) < ${book.stockQuantity}) q.value++;"><i
                                                                    class="fa-solid fa-plus"></i></button>
                                                        </div>
                                                    </c:otherwise>
                                        </c:choose>
                                    </div>

                                </div>


                                <div class="product-detail-box white-box" style="padding: 15px; border-radius: 8px;">
                                    <h3 class="section-header"
                                        style="margin-top: 0; margin-bottom: 15px; font-size: 18px;">Thông tin chi tiết
                                    </h3>

                                    <div class="detail-row" style="margin-bottom: 10px;">
                                        <div class="detail-label"
                                            style="color: #777; width: 150px; display: inline-block;">Mã sách</div>
                                        <div class="detail-value" style="display: inline-block;">
                                            893${book.id}00${book.id}</div>
                                    </div>
                                    <div class="detail-row" style="margin-bottom: 10px;">
                                        <div class="detail-label"
                                            style="color: #777; width: 150px; display: inline-block;">Tên Nhà Cung Cấp
                                        </div>
                                        <div class="detail-value" style="display: inline-block; color:#2489F4;">
                                            ${book.supplier}</div>
                                    </div>
                                    <div class="detail-row" style="margin-bottom: 10px;">
                                        <div class="detail-label"
                                            style="color: #777; width: 150px; display: inline-block;">Tác giả</div>
                                        <div class="detail-value" style="display: inline-block;">${book.author}</div>
                                    </div>
                                    <div class="detail-row" style="margin-bottom: 10px;">
                                        <div class="detail-label"
                                            style="color: #777; width: 150px; display: inline-block;">NXB</div>
                                        <div class="detail-value" style="display: inline-block;">${book.publisher}</div>
                                    </div>
                                    <div class="detail-row" style="margin-bottom: 10px;">
                                        <div class="detail-label"
                                            style="color: #777; width: 150px; display: inline-block;">Năm xuất bản</div>
                                        <div class="detail-value" style="display: inline-block;">${book.yearOfPublish}
                                        </div>
                                    </div>
                                    <div class="detail-row" style="margin-bottom: 10px;">
                                        <div class="detail-label"
                                            style="color: #777; width: 150px; display: inline-block;">Số trang</div>
                                        <div class="detail-value" style="display: inline-block;">${book.numberPage}
                                        </div>
                                    </div>
                                </div>


                                <div class="product-desc-box white-box" style="padding: 15px; border-radius: 8px;">
                                    <h3 class="section-header"
                                        style="margin-top: 0; margin-bottom: 15px; font-size: 18px;">Mô tả sản phẩm</h3>
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
                                        ${totalReviews > 0 ? averageRating : '0.0'}<span
                                            style="font-size: 24px; color: #999; font-weight: normal;">/5</span>
                                    </div>

                                    <div style="color: #F5A623; font-size: 18px; margin: 8px 0;">
                                        <c:forEach var="i" begin="1" end="5">
                                            <c:choose>
                                                <%-- Nếu điểm trung bình>= vị trí sao (VD: 4.5 >= 4) -> In sao Vàng Full
                                                    --%>
                                                    <c:when test="${averageRating >= i}">
                                                        <i class="fa-solid fa-star"></i>
                                                    </c:when>
                                                    <%-- Nếu điểm trung bình có phần lẻ>= 0.5 (VD: 4.5 >= 5 - 0.5) -> In
                                                        sao Vàng Khuyết Nửa --%>
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

                                            <div
                                                style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px; font-size: 13px; color: #555;">
                                                <span style="width: 45px; text-align: right;">${starValue} sao</span>

                                                <div
                                                    style="flex: 1; height: 6px; background-color: #eee; border-radius: 3px; overflow: hidden;">
                                                    <%-- Chiều rộng của thanh cam sẽ tự động lấy từ mảng % (Thêm
                                                        transition để có hiệu ứng trượt mượt mà) --%>
                                                        <div
                                                            style="width: ${starPercentages != null ? starPercentages[starValue] : 0}%; height: 100%; background-color: #F5A623; transition: width 0.8s ease-out;">
                                                        </div>
                                                </div>

                                                <%-- In con số % ra text --%>
                                                    <span style="width: 30px; text-align: right;">${starPercentages !=
                                                        null ? starPercentages[starValue] : 0}%</span>
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
                                            <div
                                                style="font-size: 14px; color: #333; text-align: center; line-height: 1.5;">
                                                Chỉ có thành viên mới có thể viết nhận xét.<br>Vui lòng
                                                <a href="${pageContext.request.contextPath}/login"
                                                    style="color: #2f80ed; font-weight: bold; text-decoration: none;">Đăng
                                                    nhập</a> hoặc
                                                <a href="${pageContext.request.contextPath}/register"
                                                    style="color: #2f80ed; font-weight: bold; text-decoration: none;">Đăng
                                                    ký</a>.
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <%-- phần form đánh giá khi người dùng click vào nút "Viết đánh giá" --%>
                                <%-- Phần form đánh giá --%>
                                    <div id="reviewFormSection" class="review-form-wrapper">
                                        <form id="reviewForm" action="review" method="POST">
                                            <input type="hidden" name="pid" value="${book.id}">

                                            <%-- [ĐÃ SỬA]: Xóa value="5" đi, để rỗng --%>
                                                <input type="hidden" id="ratingValue" name="rating" value="">

                                                <div style="font-weight: bold; margin-bottom: 10px;">Bạn chấm sản phẩm
                                                    này bao nhiêu sao?</div>

                                                <div class="star-voting" id="starVoting">
                                                    <%-- [ĐÃ SỬA]: Xóa class 'active' và đổi 'fa-solid'
                                                        thành 'fa-regular' để sao mặc định là viền xám --%>
                                                        <i class="fa-regular fa-star" data-value="1"></i>
                                                        <i class="fa-regular fa-star" data-value="2"></i>
                                                        <i class="fa-regular fa-star" data-value="3"></i>
                                                        <i class="fa-regular fa-star" data-value="4"></i>
                                                        <i class="fa-regular fa-star" data-value="5"></i>
                                                </div>

                                                <%-- [ĐÃ SỬA]: Bỏ thuộc tính required đi để ta dùng JS tự bắt lỗi --%>
                                                    <textarea name="comment" class="review-textarea"
                                                        placeholder="Chia sẻ cảm nhận của bạn về cuốn sách này nhé..."></textarea>

                                                    <div style="text-align: right;">
                                                        <button type="button" class="btn-write-review"
                                                            style="display: inline-block; color: #666; border-color: #ccc; margin-right: 10px;"
                                                            onclick="toggleReviewForm()">Hủy</button>
                                                        <button type="submit" class="btn-submit-review">Gửi đánh
                                                            giá</button>
                                                    </div>
                                        </form>
                                    </div>

                                    <div class="review-list" id="reviewListContainer">

                                        <c:choose>
                                            <%-- Trường hợp 1: Có đánh giá --%>
                                                <c:when test="${not empty listReviews}">
                                                    <c:forEach items="${listReviews}" var="r">
                                                        <div class="review-item" id="review-box-${r.reviewId}">
                                                            <div class="reviewer-info"
                                                                style="position: relative; display: flex; align-items: center; gap: 15px;">

                                                                <%-- 1. Bọc thẻ <a> cho Avatar --%>
                                                                    <a href="${pageContext.request.contextPath}/public-profile?id=${r.userId}"
                                                                        style="text-decoration: none;">
                                                                        <div class="reviewer-avatar"
                                                                            style="cursor: pointer; transition: 0.2s;"
                                                                            onmouseover="this.style.opacity='0.8'"
                                                                            onmouseout="this.style.opacity='1'">
                                                                            ${r.username.substring(0, 1).toUpperCase()}
                                                                        </div>
                                                                    </a>

                                                                    <div>
                                                                        <%-- 2. Bọc thẻ <a> cho Tên người dùng --%>
                                                                            <a href="${pageContext.request.contextPath}/public-profile?id=${r.userId}"
                                                                                style="text-decoration: none; color: inherit;">
                                                                                <div class="reviewer-name public-profile-link"
                                                                                    style="cursor: pointer; font-weight: bold; transition: color 0.2s;">
                                                                                    ${r.username}
                                                                                </div>
                                                                            </a>
                                                                            <div class="review-date">${r.createAt}</div>
                                                                    </div>

                                                                    <%-- Nút 3 chấm thông minh (Giữ nguyên của bạn) --%>
                                                                        <c:if test="${sessionScope.user != null}">
                                                                            <div class="dropdown"
                                                                                style="position: absolute; right: 0; top: 0;">
                                                                                <button class="btn btn-sm btn-light"
                                                                                    type="button"
                                                                                    data-bs-toggle="dropdown"
                                                                                    style="background: transparent; border: none; font-size: 18px; color: #888;">
                                                                                    <i
                                                                                        class="fa-solid fa-ellipsis-vertical"></i>
                                                                                </button>
                                                                                <ul
                                                                                    class="dropdown-menu dropdown-menu-end shadow-sm">
                                                                                    <c:choose>
                                                                                        <%-- NẾU LÀ CHỦ NHÂN BÌNH LUẬN
                                                                                            -> CHO SỬA & XÓA --%>
                                                                                            <c:when
                                                                                                test="${sessionScope.user.username == r.username}">
                                                                                                <li><a class="dropdown-item"
                                                                                                        href="javascript:void(0)"
                                                                                                        onclick="openEditReview(${r.reviewId}, ${r.rating}, '${r.comment}')"><i
                                                                                                            class="fa-solid fa-pen-to-square me-2 text-primary"></i>
                                                                                                        Sửa bình
                                                                                                        luận</a></li>
                                                                                                <li>
                                                                                                    <hr
                                                                                                        class="dropdown-divider">
                                                                                                </li>
                                                                                                <li>
                                                                                                    <form
                                                                                                        class="delete-review-form"
                                                                                                        style="margin: 0;">
                                                                                                        <input
                                                                                                            type="hidden"
                                                                                                            name="action"
                                                                                                            value="delete">
                                                                                                        <input
                                                                                                            type="hidden"
                                                                                                            name="reviewId"
                                                                                                            value="${r.reviewId}">
                                                                                                        <input
                                                                                                            type="hidden"
                                                                                                            name="pid"
                                                                                                            value="${book.id}">
                                                                                                        <button
                                                                                                            type="submit"
                                                                                                            class="dropdown-item text-danger"><i
                                                                                                                class="fa-solid fa-trash-can me-2"></i>
                                                                                                            Xóa bình
                                                                                                            luận</button>
                                                                                                    </form>
                                                                                                </li>
                                                                                            </c:when>

                                                                                            <%-- NẾU LÀ NGƯỜI KHÁC ĐỌC
                                                                                                -> CHỈ CHO TỐ CÁO --%>
                                                                                                <c:otherwise>
                                                                                                    <li>
                                                                                                        <a class="dropdown-item text-warning"
                                                                                                            href="javascript:void(0)"
                                                                                                            onclick="openReportModal(${r.reviewId})">
                                                                                                            <i
                                                                                                                class="fa-solid fa-flag me-2"></i>
                                                                                                            Báo cáo vi
                                                                                                            phạm
                                                                                                        </a>
                                                                                                    </li>
                                                                                                </c:otherwise>
                                                                                    </c:choose>
                                                                                </ul>
                                                                            </div>
                                                                        </c:if>
                                                            </div>

                                                            <%-- Phần hiển thị bình thường --%>
                                                                <div id="review-content-display-${r.reviewId}">
                                                                    <div class="review-stars">
                                                                        <c:forEach begin="1" end="${r.rating}"><i
                                                                                class="fa-solid fa-star"></i>
                                                                        </c:forEach>
                                                                        <c:forEach begin="${r.rating + 1}" end="5"><i
                                                                                class="fa-regular fa-star"
                                                                                style="color: #ddd;"></i></c:forEach>
                                                                    </div>
                                                                    <div class="review-content">${r.comment}</div>

                                                                    <c:if test="${not empty r.staffReply}">
                                                                        <div class="mt-3 p-3 rounded"
                                                                            style="background-color: #1a1c20; border-left: 4px solid #C92127;">
                                                                            <div class="fw-bold mb-1"
                                                                                style="color: #C92127;">
                                                                                <i class="fa-solid fa-reply me-1"></i>
                                                                                Phản hồi của Shop:
                                                                            </div>
                                                                            <div class="text-light"
                                                                                style="font-size: 14px;">
                                                                                ${r.staffReply}
                                                                            </div>
                                                                        </div>
                                                                    </c:if>
                                                                </div>

                                                                <%-- Phần Form Edit Ẩn --%>
                                                                    <div id="review-edit-form-${r.reviewId}"
                                                                        style="display: none; background: #f9f9f9; padding: 15px; border-radius: 8px; margin-top: 10px; border: 1px dashed #ccc;">
                                                                        <form class="edit-review-form">
                                                                            <input type="hidden" name="action"
                                                                                value="update">
                                                                            <input type="hidden" name="reviewId"
                                                                                value="${r.reviewId}">
                                                                            <input type="hidden" name="pid"
                                                                                value="${book.id}">

                                                                            <div
                                                                                style="font-weight: bold; margin-bottom: 5px; font-size: 13px;">
                                                                                Đánh giá lại:</div>
                                                                            <select name="rating"
                                                                                class="form-select form-select-sm mb-2"
                                                                                style="width: 150px;">
                                                                                <option value="5" ${r.rating==5
                                                                                    ? 'selected' : '' }>⭐⭐⭐⭐⭐ (Tuyệt
                                                                                    vời)</option>
                                                                                <option value="4" ${r.rating==4
                                                                                    ? 'selected' : '' }>⭐⭐⭐⭐ (Tốt)
                                                                                </option>
                                                                                <option value="3" ${r.rating==3
                                                                                    ? 'selected' : '' }>⭐⭐⭐ (Bình
                                                                                    thường)</option>
                                                                                <option value="2" ${r.rating==2
                                                                                    ? 'selected' : '' }>⭐⭐ (Tệ)</option>
                                                                                <option value="1" ${r.rating==1
                                                                                    ? 'selected' : '' }>⭐ (Rất tệ)
                                                                                </option>
                                                                            </select>

                                                                            <textarea name="comment"
                                                                                class="form-control" rows="2"
                                                                                required>${r.comment}</textarea>

                                                                            <div
                                                                                style="margin-top: 10px; text-align: right;">
                                                                                <button type="button"
                                                                                    class="btn btn-sm btn-light border"
                                                                                    onclick="cancelEditReview(${r.reviewId})">Hủy</button>
                                                                                <button type="submit"
                                                                                    class="btn btn-sm text-white"
                                                                                    style="background-color: #C92127;">Lưu
                                                                                    thay đổi</button>
                                                                            </div>
                                                                        </form>
                                                                    </div>
                                                        </div>
                                                    </c:forEach>
                                                </c:when>

                                                <%-- Trường hợp 2: Chưa có ai đánh giá --%>
                                                    <c:otherwise>
                                                        <div
                                                            style="text-align: center; color: #999; padding: 30px; background: #fdfdfd; border-radius: 8px; border: 1px dashed #eee;">
                                                            <i class="fa-regular fa-comment-dots"
                                                                style="font-size: 32px; color: #ddd; margin-bottom: 10px; display: block;"></i>
                                                            Chưa có đánh giá nào cho sản phẩm này.<br>Hãy là người đầu
                                                            tiên nhận xét!
                                                        </div>
                                                    </c:otherwise>
                                        </c:choose>

                                    </div>
                        </div>

                        <div id="qa-section" class="review-container" style="margin-top: 20px;">
                            <div
                                style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #f0f0f0; padding-bottom: 15px;">
                                <h3 class="review-title" style="margin: 0;">Hỏi Đáp & Thảo Luận</h3>
                                <c:choose>
                                    <c:when test="${sessionScope.user != null}">
                                        <button type="button" class="btn btn-outline-danger fw-bold"
                                            onclick="toggleQAForm()">
                                            <i class="fa-regular fa-comment-dots me-1"></i> Đặt câu hỏi
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/login"
                                            class="btn btn-outline-danger fw-bold text-decoration-none">
                                            Đăng nhập để hỏi đáp
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div id="qaFormSection"
                                style="display: none; background: #f9f9f9; padding: 20px; border-radius: 8px; border: 1px solid #eee; margin-bottom: 25px;">
                                <form id="discussionForm">
                                    <input type="hidden" name="pid" value="${book.id}">

                                    <div class="row">
                                        <div class="col-md-8 mb-3">
                                            <label class="fw-bold mb-1" style="font-size: 14px;">Tiêu đề câu hỏi <span
                                                    class="text-danger">*</span></label>
                                            <input type="text" name="discussionTitle" class="form-control"
                                                placeholder="Ví dụ: Bản dịch này có mượt không mọi người?" required>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <label class="fw-bold mb-1" style="font-size: 14px;">Chủ đề <span
                                                    class="text-danger">*</span></label>
                                            <select name="topicTag" class="form-select" required>
                                                <option value="Hỏi nội dung">Hỏi nội dung</option>
                                                <option value="Hỏi hình thức/Bìa">Hỏi hình thức/Bìa</option>
                                                <option value="Tìm sách tương tự">Tìm sách tương tự</option>
                                                <option value="Khác">Khác</option>
                                            </select>
                                        </div>
                                        <div class="col-12 mb-3">
                                            <label class="fw-bold mb-1" style="font-size: 14px;">Chi tiết câu hỏi <span
                                                    class="text-danger">*</span></label>
                                            <textarea name="discussionContent" class="form-control" rows="3"
                                                placeholder="Viết rõ hơn về thắc mắc của bạn..." required></textarea>
                                        </div>
                                        <div class="col-12 d-flex justify-content-between align-items-center">
                                            <div class="form-check form-switch">
                                                <input class="form-check-input" type="checkbox" id="spoilerCheck"
                                                    name="hasSpoiler">
                                                <label class="form-check-label text-danger fw-bold" for="spoilerCheck"
                                                    style="font-size: 13px;">
                                                    <i class="fa-solid fa-triangle-exclamation"></i> Có tiết lộ nội dung
                                                    truyện (Spoiler)
                                                </label>
                                            </div>
                                            <div>
                                                <button type="button" class="btn btn-light border me-2"
                                                    onclick="toggleQAForm()">Hủy</button>
                                                <button type="submit" class="btn text-white fw-bold px-4"
                                                    style="background-color: #C92127;">Gửi câu hỏi</button>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <div id="qaListContainer">
                                <c:choose>
                                    <c:when test="${empty listDiscussions}">
                                        <div class="text-center py-4"
                                            style="color: #999; border: 1px dashed #eee; border-radius: 8px;">
                                            <i class="fa-solid fa-clipboard-question mb-2"
                                                style="font-size: 30px; color: #ddd;"></i>
                                            <p class="mb-0">Chưa có thắc mắc nào cho cuốn sách này. Hãy là người đầu
                                                tiên đặt câu hỏi!</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="d" items="${listDiscussions}">
                                            <div class="discussion-item" id="discussion-box-${d.discussionId}"
                                                style="border: 1px solid #f0f0f0; padding: 15px; border-radius: 8px; margin-bottom: 15px; position: relative;">

                                                <%-- MENU 3 CHẤM BẢN XỊN --%>
                                                    <c:if test="${sessionScope.user != null}">
                                                        <div class="dropdown"
                                                            style="position: absolute; right: 15px; top: 15px;">
                                                            <button class="btn btn-sm btn-light" type="button"
                                                                data-bs-toggle="dropdown"
                                                                style="background: transparent; border: none; font-size: 18px; color: #888;">
                                                                <i class="fa-solid fa-ellipsis-vertical"></i>
                                                            </button>
                                                            <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${sessionScope.user.username == d.username}">
                                                                        <li>
                                                                            <a class="dropdown-item text-primary"
                                                                                href="javascript:void(0)"
                                                                                onclick="openEditDiscussion(${d.discussionId})">
                                                                                <i
                                                                                    class="fa-solid fa-pen-to-square me-2"></i>
                                                                                Sửa câu hỏi
                                                                            </a>
                                                                        </li>
                                                                        <li>
                                                                            <hr class="dropdown-divider">
                                                                        </li>
                                                                        <li>
                                                                            <form class="delete-discussion-form"
                                                                                style="margin: 0;">
                                                                                <input type="hidden" name="action"
                                                                                    value="delete">
                                                                                <input type="hidden" name="discussionId"
                                                                                    value="${d.discussionId}">
                                                                                <button type="submit"
                                                                                    class="dropdown-item text-danger"><i
                                                                                        class="fa-solid fa-trash-can me-2"></i>
                                                                                    Xóa câu hỏi</button>
                                                                            </form>
                                                                        </li>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <li>
                                                                            <a class="dropdown-item text-warning"
                                                                                href="javascript:void(0)"
                                                                                onclick="openReportModal('discussion', ${d.discussionId})">
                                                                                <i class="fa-solid fa-flag me-2"></i>
                                                                                Báo cáo
                                                                            </a>
                                                                        </li>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </ul>
                                                        </div>
                                                    </c:if>

                                                    <%-- 1. PHẦN HIỂN THỊ BÌNH THƯỜNG (Sẽ bị ẩn đi khi bấm Sửa) --%>
                                                        <div id="discussion-display-${d.discussionId}">
                                                            <div
                                                                class="d-flex justify-content-between align-items-start mb-2">
                                                                <div class="d-flex align-items-center gap-2">
                                                                    <div
                                                                        style="width: 35px; height: 35px; background: #e0e0e0; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; color: #555;">
                                                                        <c:choose>
                                                                            <c:when test="${not empty d.username}">
                                                                                ${d.username.substring(0,
                                                                                1).toUpperCase()}</c:when>
                                                                            <c:otherwise>U</c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                    <div>
                                                                        <div
                                                                            style="font-weight: bold; color: #333; font-size: 14px;">
                                                                            ${not empty d.username ? d.username : 'Ẩn
                                                                            danh'}</div>
                                                                        <div style="font-size: 12px; color: #999;">
                                                                            ${d.createdAt}</div>
                                                                    </div>
                                                                </div>
                                                                <div style="margin-right: 30px;">
                                                                    <span
                                                                        class="badge bg-light text-dark border display-topic-tag">${d.topicTag}</span>
                                                                    <c:if test="${d.hasSpoiler}">
                                                                        <span
                                                                            class="badge bg-danger ms-1 display-spoiler-tag">SPOILER</span>
                                                                    </c:if>
                                                                </div>
                                                            </div>

                                                            <h6 class="fw-bold mt-2 display-title"
                                                                style="color: #2489F4;">${d.discussionTitle}</h6>

                                                            <div class="display-content-area">
                                                                <c:choose>
                                                                    <c:when test="${d.hasSpoiler}">
                                                                        <div class="spoiler-box"
                                                                            style="background: #ffe6e6; padding: 10px; border-radius: 4px; border: 1px dashed #ff9999; cursor: pointer; text-align: center; color: #C92127; font-weight: bold; font-size: 13px;"
                                                                            onclick="this.nextElementSibling.style.display='block'; this.style.display='none';">
                                                                            <i class="fa-solid fa-eye-slash me-1"></i>
                                                                            Nội dung bị ẩn vì chứa Spoiler. Bấm vào để
                                                                            xem.
                                                                        </div>
                                                                        <p class="text-muted display-content"
                                                                            style="font-size: 14px; display: none;">
                                                                            ${d.discussionContent}</p>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <p class="text-muted display-content"
                                                                            style="font-size: 14px;">
                                                                            ${d.discussionContent}</p>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>

                                                            <div class="mt-2 text-end">
                                                                <a href="javascript:void(0)"
                                                                    onclick="toggleReplies(${d.discussionId})"
                                                                    style="text-decoration: none; font-size: 13px; font-weight: bold; color: #666; transition: 0.2s;"
                                                                    onmouseover="this.style.color='#C92127'"
                                                                    onmouseout="this.style.color='#666'">
                                                                    <i class="fa-regular fa-comments me-1"></i> <span
                                                                        id="reply-count-txt-${d.discussionId}">${d.replyCount}</span>
                                                                    Trả lời
                                                                </a>
                                                            </div>
                                                        </div>

                                                        <%-- 2. PHẦN FORM SỬA (Ẩn mặc định) --%>
                                                            <div id="discussion-edit-form-${d.discussionId}"
                                                                style="display: none; background: #fffdf2; padding: 15px; border-radius: 8px; margin-top: 10px; border: 1px dashed #ffc107;">
                                                                <form class="edit-discussion-form">
                                                                    <input type="hidden" name="action" value="update">
                                                                    <input type="hidden" name="discussionId"
                                                                        value="${d.discussionId}">

                                                                    <div class="mb-2">
                                                                        <label class="fw-bold"
                                                                            style="font-size: 13px;">Tiêu đề:</label>
                                                                        <input type="text" name="discussionTitle"
                                                                            class="form-control form-control-sm"
                                                                            value="${d.discussionTitle}" required>
                                                                    </div>
                                                                    <div class="mb-2">
                                                                        <label class="fw-bold"
                                                                            style="font-size: 13px;">Chủ đề:</label>
                                                                        <select name="topicTag"
                                                                            class="form-select form-select-sm" required>
                                                                            <option value="Hỏi nội dung"
                                                                                ${d.topicTag=='Hỏi nội dung'
                                                                                ? 'selected' : '' }>Hỏi nội dung
                                                                            </option>
                                                                            <option value="Hỏi hình thức/Bìa"
                                                                                ${d.topicTag=='Hỏi hình thức/Bìa'
                                                                                ? 'selected' : '' }>Hỏi hình thức/Bìa
                                                                            </option>
                                                                            <option value="Tìm sách tương tự"
                                                                                ${d.topicTag=='Tìm sách tương tự'
                                                                                ? 'selected' : '' }>Tìm sách tương tự
                                                                            </option>
                                                                            <option value="Khác" ${d.topicTag=='Khác'
                                                                                ? 'selected' : '' }>Khác</option>
                                                                        </select>
                                                                    </div>
                                                                    <div class="mb-2">
                                                                        <label class="fw-bold"
                                                                            style="font-size: 13px;">Nội dung:</label>
                                                                        <textarea name="discussionContent"
                                                                            class="form-control form-control-sm"
                                                                            rows="3"
                                                                            required>${d.discussionContent}</textarea>
                                                                    </div>
                                                                    <div
                                                                        class="d-flex justify-content-between align-items-center">
                                                                        <div class="form-check form-switch">
                                                                            <input class="form-check-input"
                                                                                type="checkbox" name="hasSpoiler"
                                                                                id="editSpoiler-${d.discussionId}"
                                                                                ${d.hasSpoiler ? 'checked' : '' }>
                                                                            <label
                                                                                class="form-check-label text-danger fw-bold"
                                                                                style="font-size: 12px;"
                                                                                for="editSpoiler-${d.discussionId}">Có
                                                                                Spoiler</label>
                                                                        </div>
                                                                        <div>
                                                                            <button type="button"
                                                                                class="btn btn-sm btn-light border"
                                                                                onclick="cancelEditDiscussion(${d.discussionId})">Hủy</button>
                                                                            <button type="submit"
                                                                                class="btn btn-sm text-white fw-bold"
                                                                                style="background-color: #f5a623;">Lưu
                                                                                thay đổi</button>
                                                                        </div>
                                                                    </div>
                                                                </form>
                                                            </div>

                                                            <div id="replies-section-${d.discussionId}"
                                                                style="display: none; margin-top: 15px; padding-top: 15px; border-top: 1px dashed #eee;">
                                                                <div id="reply-list-${d.discussionId}"
                                                                    style="display: flex; flex-direction: column;">
                                                                    <c:if test="${not empty d.replies}">
                                                                        <c:forEach var="reply" items="${d.replies}">

                                                                            <%-- BỘ QUÉT TAG THÔNG MINH (Xác định xem có
                                                                                thụt lề hay không) --%>
                                                                                <c:set var="isNested" value="false" />
                                                                                <c:set var="trimmedText"
                                                                                    value="${fn:trim(reply.replyContent)}" />
                                                                                <c:if
                                                                                    test="${fn:startsWith(trimmedText, '@')}">
                                                                                    <c:set var="tagAuthorExact"
                                                                                        value="@${d.username}" />
                                                                                    <c:set var="tagAuthorSpace"
                                                                                        value="@${d.username} " />
                                                                                    <c:if
                                                                                        test="${trimmedText == tagAuthorExact or fn:startsWith(trimmedText, tagAuthorSpace)}">
                                                                                        <c:set var="isNested"
                                                                                            value="true" />
                                                                                    </c:if>
                                                                                    <c:if test="${not isNested}">
                                                                                        <c:forEach var="other"
                                                                                            items="${d.replies}">
                                                                                            <c:set var="tagUserExact"
                                                                                                value="@${other.username}" />
                                                                                            <c:set var="tagUserSpace"
                                                                                                value="@${other.username} " />
                                                                                            <c:if
                                                                                                test="${trimmedText == tagUserExact or fn:startsWith(trimmedText, tagUserSpace)}">
                                                                                                <c:set var="isNested"
                                                                                                    value="true" />
                                                                                            </c:if>
                                                                                        </c:forEach>
                                                                                    </c:if>
                                                                                </c:if>

                                                                                <%-- BẮT ĐẦU VẼ TỪNG CÂU TRẢ LỜI --%>
                                                                                    <div class="reply-item-container d-flex gap-2 mb-3 ${isNested ? 'nested-reply' : ''}"
                                                                                        id="reply-box-${reply.replyId}">

                                                                                        <div class="${isNested ? 'avatar-nested' : 'avatar-normal'}"
                                                                                            style="background: #ddd; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-weight: bold; color: #555;">
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${not empty reply.username}">
                                                                                                    ${reply.username.substring(0,
                                                                                                    1).toUpperCase()}
                                                                                                </c:when>
                                                                                                <c:otherwise>U
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </div>

                                                                                        <div
                                                                                            style="flex: 1; background: #f9f9f9; padding: ${isNested ? '8px 10px' : '10px 12px'}; border-radius: 8px; position: relative;">

                                                                                            <%-- DẤU 3 CHẤM CHO CÂU TRẢ
                                                                                                LỜI --%>
                                                                                                <c:if
                                                                                                    test="${sessionScope.user != null}">
                                                                                                    <div class="dropdown"
                                                                                                        style="position: absolute; right: 5px; top: 5px;">
                                                                                                        <button
                                                                                                            class="btn btn-sm btn-light p-0"
                                                                                                            type="button"
                                                                                                            data-bs-toggle="dropdown"
                                                                                                            style="background: transparent; border: none; color: #888; width: 24px; height: 24px; display: flex; align-items: center; justify-content: center;">
                                                                                                            <i
                                                                                                                class="fa-solid fa-ellipsis-vertical"></i>
                                                                                                        </button>
                                                                                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm"
                                                                                                            style="font-size: 13px;">
                                                                                                            <c:choose>
                                                                                                                <c:when
                                                                                                                    test="${sessionScope.user.username == reply.username}">
                                                                                                                    <li><a class="dropdown-item text-primary"
                                                                                                                            href="javascript:void(0)"
                                                                                                                            onclick="openEditReply(${reply.replyId})"><i
                                                                                                                                class="fa-solid fa-pen-to-square me-2"></i>
                                                                                                                            Sửa</a>
                                                                                                                    </li>
                                                                                                                    <li>
                                                                                                                        <form
                                                                                                                            class="delete-reply-form"
                                                                                                                            style="margin: 0;">
                                                                                                                            <input
                                                                                                                                type="hidden"
                                                                                                                                name="action"
                                                                                                                                value="deleteReply">
                                                                                                                            <input
                                                                                                                                type="hidden"
                                                                                                                                name="replyId"
                                                                                                                                value="${reply.replyId}">
                                                                                                                            <button
                                                                                                                                type="submit"
                                                                                                                                class="dropdown-item text-danger"><i
                                                                                                                                    class="fa-solid fa-trash-can me-2"></i>
                                                                                                                                Xóa</button>
                                                                                                                        </form>
                                                                                                                    </li>
                                                                                                                </c:when>
                                                                                                                <c:otherwise>
                                                                                                                    <li><a class="dropdown-item text-warning"
                                                                                                                            href="javascript:void(0)"
                                                                                                                            onclick="openReportModal('reply', ${reply.replyId})">
                                                                                                                            <i
                                                                                                                                class="fa-solid fa-flag me-2"></i>
                                                                                                                            Báo
                                                                                                                            cáo
                                                                                                                        </a>
                                                                                                                    </li>
                                                                                                                </c:otherwise>
                                                                                                            </c:choose>
                                                                                                        </ul>
                                                                                                    </div>
                                                                                                </c:if>

                                                                                                <%-- KHU VỰC HIỂN THỊ
                                                                                                    --%>
                                                                                                    <div
                                                                                                        id="reply-display-${reply.replyId}">
                                                                                                        <div
                                                                                                            style="font-weight: bold; font-size: ${isNested ? '12px' : '13px'}; color: #333; display: flex; align-items: center; padding-right: 20px;">
                                                                                                            ${not empty
                                                                                                            reply.username
                                                                                                            ?
                                                                                                            reply.username
                                                                                                            : 'Ẩn danh'}
                                                                                                            <span
                                                                                                                style="font-weight: normal; color: #999; font-size: 11px; margin-left: 8px;"><i
                                                                                                                    class="fa-regular fa-clock me-1"></i>${reply.createdAt}</span>
                                                                                                            <a href="javascript:void(0)"
                                                                                                                onclick="replyToUser(${d.discussionId}, '${not empty reply.username ? reply.username : 'Ẩn danh'}', this)"
                                                                                                                style="font-size: 11px; color: #2489F4; text-decoration: none; margin-left: 10px; font-weight: normal;"><i
                                                                                                                    class="fa-solid fa-reply"></i>
                                                                                                                Trả
                                                                                                                lời</a>
                                                                                                        </div>
                                                                                                        <div id="reply-content-text-${reply.replyId}"
                                                                                                            style="font-size: ${isNested ? '13px' : '13.5px'}; color: #444; margin-top: 5px; line-height: 1.4;">

                                                                                                            <%-- CODE TÔ
                                                                                                                MÀU XANH
                                                                                                                CHO TAG
                                                                                                                VÀ ẨN
                                                                                                                TAG
                                                                                                                CHÍNH
                                                                                                                MÌNH
                                                                                                                --%>
                                                                                                                <% com.group2.bookstore.model.Discussion
                                                                                                                    currentD=(com.group2.bookstore.model.Discussion)
                                                                                                                    pageContext.getAttribute("d");
                                                                                                                    com.group2.bookstore.model.DiscussionReply
                                                                                                                    currentR=(com.group2.bookstore.model.DiscussionReply)
                                                                                                                    pageContext.getAttribute("reply");
                                                                                                                    String
                                                                                                                    rawContent=currentR.getReplyContent();
                                                                                                                    if
                                                                                                                    (rawContent
                                                                                                                    !=null)
                                                                                                                    {
                                                                                                                    String
                                                                                                                    escapedContent=rawContent.replace("&", "&amp;"
                                                                                                                    ).replace("<", "&lt;"
                                                                                                                    ).replace(">
                                                                                                                    ",
                                                                                                                    "&gt;").replace("\"",
                                                                                                                    "&quot;").replace("'",
                                                                                                                    "&#x27;");

                                                                                                                    java.util.Set
                                                                                                                    <String>
                                                                                                                        validUsers
                                                                                                                        =
                                                                                                                        new
                                                                                                                        java.util.HashSet
                                                                                                                        <String>
                                                                                                                            ();
                                                                                                                            if(currentD.getUsername()
                                                                                                                            !=
                                                                                                                            null)
                                                                                                                            validUsers.add(currentD.getUsername());
                                                                                                                            if(currentD.getReplies()
                                                                                                                            !=
                                                                                                                            null)
                                                                                                                            {
                                                                                                                            for(com.group2.bookstore.model.DiscussionReply
                                                                                                                            rep
                                                                                                                            :
                                                                                                                            currentD.getReplies())
                                                                                                                            {
                                                                                                                            if(rep.getUsername()
                                                                                                                            !=
                                                                                                                            null)
                                                                                                                            validUsers.add(rep.getUsername());
                                                                                                                            }
                                                                                                                            }

                                                                                                                            java.util.regex.Pattern
                                                                                                                            p
                                                                                                                            =
                                                                                                                            java.util.regex.Pattern.compile("(^|\\s)@(\\w+)");
                                                                                                                            java.util.regex.Matcher
                                                                                                                            m
                                                                                                                            =
                                                                                                                            p.matcher(escapedContent);
                                                                                                                            StringBuffer
                                                                                                                            sb
                                                                                                                            =
                                                                                                                            new
                                                                                                                            StringBuffer();

                                                                                                                            while
                                                                                                                            (m.find())
                                                                                                                            {
                                                                                                                            String
                                                                                                                            space
                                                                                                                            =
                                                                                                                            m.group(1);
                                                                                                                            String
                                                                                                                            matchedUser
                                                                                                                            =
                                                                                                                            m.group(2);

                                                                                                                            if
                                                                                                                            (validUsers.contains(matchedUser))
                                                                                                                            {
                                                                                                                            if
                                                                                                                            (currentR.getUsername()
                                                                                                                            !=
                                                                                                                            null
                                                                                                                            &&
                                                                                                                            currentR.getUsername().equals(matchedUser))
                                                                                                                            {
                                                                                                                            m.appendReplacement(sb,
                                                                                                                            "");
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                            m.appendReplacement(sb,
                                                                                                                            java.util.regex.Matcher.quoteReplacement(space
                                                                                                                            +
                                                                                                                            "<span
                                                                                                                                style='color: #2489F4; font-weight: bold;'>@"
                                                                                                                                +
                                                                                                                                matchedUser
                                                                                                                                +
                                                                                                                                "</span>"));
                                                                                                                            }
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                            m.appendReplacement(sb,
                                                                                                                            java.util.regex.Matcher.quoteReplacement(space
                                                                                                                            +
                                                                                                                            "@"
                                                                                                                            +
                                                                                                                            matchedUser));
                                                                                                                            }
                                                                                                                            }
                                                                                                                            m.appendTail(sb);
                                                                                                                            out.print(sb.toString().trim());
                                                                                                                            }
                                                                                                                            %>
                                                                                                        </div>
                                                                                                    </div>

                                                                                                    <%-- KHU VỰC FORM
                                                                                                        SỬA (Mặc định
                                                                                                        ẩn) --%>
                                                                                                        <div id="reply-edit-form-${reply.replyId}"
                                                                                                            style="display: none; margin-top: 5px;">
                                                                                                            <form
                                                                                                                class="edit-reply-form">
                                                                                                                <input
                                                                                                                    type="hidden"
                                                                                                                    name="action"
                                                                                                                    value="updateReply">
                                                                                                                <input
                                                                                                                    type="hidden"
                                                                                                                    name="replyId"
                                                                                                                    value="${reply.replyId}">
                                                                                                                <textarea
                                                                                                                    name="replyContent"
                                                                                                                    class="form-control form-control-sm mb-2"
                                                                                                                    rows="2"
                                                                                                                    required>${reply.replyContent}</textarea>
                                                                                                                <div
                                                                                                                    class="text-end">
                                                                                                                    <button
                                                                                                                        type="button"
                                                                                                                        class="btn btn-sm btn-light border py-1 px-2"
                                                                                                                        style="font-size: 12px;"
                                                                                                                        onclick="cancelEditReply(${reply.replyId})">Hủy</button>
                                                                                                                    <button
                                                                                                                        type="submit"
                                                                                                                        class="btn btn-sm text-white fw-bold py-1 px-2"
                                                                                                                        style="background-color: #f5a623; font-size: 12px;">Lưu</button>
                                                                                                                </div>
                                                                                                            </form>
                                                                                                        </div>
                                                                                                        <p>hello</p>
                                                                                        </div>
                                                                                    </div>
                                                                        </c:forEach>
                                                                    </c:if>
                                                                </div>
                                                                <c:choose>
                                                                    <c:when test="${sessionScope.user != null}">
                                                                        <form
                                                                            class="discussion-reply-form mt-2 d-flex gap-2">
                                                                            <input type="hidden" name="action"
                                                                                value="reply">
                                                                            <input type="hidden" name="discussionId"
                                                                                value="${d.discussionId}">
                                                                            <%-- ĐÂY LÀ DÒNG QUAN TRỌNG NHẤT VỪA THÊM
                                                                                VÀO --%>
                                                                                <input type="hidden" name="pid"
                                                                                    value="${book.id}">
                                                                                <input type="text" name="replyContent"
                                                                                    class="form-control form-control-sm"
                                                                                    placeholder="Viết câu trả lời của bạn..."
                                                                                    required autocomplete="off">
                                                                                <button type="submit"
                                                                                    class="btn btn-sm text-white fw-bold"
                                                                                    style="background: #C92127; white-space: nowrap;"><i
                                                                                        class="fa-solid fa-paper-plane me-1"></i>Gửi</button>
                                                                        </form>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="text-center mt-2 p-2"
                                                                            style="background: #fff3f3; border-radius: 4px; font-size: 13px;">
                                                                            <a href="${pageContext.request.contextPath}/login"
                                                                                style="color: #C92127; font-weight: bold; text-decoration: none;">Đăng
                                                                                nhập</a> để tham gia thảo luận.
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>

                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="same-author-box white-box"
                            style="padding: 20px; border-radius: 8px; margin-top: 20px;">
                            <h3
                                style="text-transform: uppercase; font-size: 16px; font-weight: bold; margin-bottom: 20px; color: #333;">
                                Sản phẩm cùng tác giả
                            </h3>

                            <div style="display: grid; grid-template-columns: repeat(5, 1fr); gap: 15px;">

                                <c:forEach items="${bookSameAuthor}" var="b" end="4">

                                    <a href="${pageContext.request.contextPath}/detail?pid=${b.id}"
                                        style="text-decoration: none; color: inherit; display: block; padding: 10px; transition: 0.3s; border-radius: 8px;"
                                        onmouseover="this.style.boxShadow='0 0 10px rgba(0,0,0,0.1)'"
                                        onmouseout="this.style.boxShadow='none'">

                                        <div class="product-card" style="display: flex; flex-direction: column;">

                                            <div
                                                style="height: 200px; display: flex; justify-content: center; align-items: center; margin-bottom: 10px;">
                                                <img src="${pageContext.request.contextPath}/${b.imageUrl}"
                                                    alt="${b.title}"
                                                    style="max-width: 100%; max-height: 100%; object-fit: contain;">
                                            </div>

                                            <div
                                                style="font-size: 14px; color: #333; line-height: 1.4; height: 38px; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; margin-bottom: 8px;">
                                                ${b.title}
                                            </div>

                                            <div
                                                style="display: flex; align-items: center; flex-wrap: wrap; gap: 5px; margin-bottom: 5px;">
                                                <span style="color: #C92127; font-size: 16px; font-weight: bold;">
                                                    <fmt:formatNumber value="${b.price}" type="currency"
                                                        currencySymbol="đ" maxFractionDigits="0" />
                                                </span>
                                                <span
                                                    style="background: #C92127; color: white; font-size: 12px; padding: 2px 4px; border-radius: 3px;">-20%</span>
                                            </div>

                                            <div
                                                style="color: #999; font-size: 13px; text-decoration: line-through; margin-bottom: 5px;">
                                                <fmt:formatNumber value="${b.price * 1.2}" type="currency"
                                                    currencySymbol="đ" maxFractionDigits="0" />
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
                                <a href="#"
                                    style="display: inline-block; border: 1px solid #C92127; color: #C92127; font-weight: bold; font-size: 14px; padding: 10px 60px; border-radius: 4px; text-decoration: none; transition: 0.3s;"
                                    onmouseover="this.style.background='#fff0f0'"
                                    onmouseout="this.style.background='white'">
                                    Xem thêm
                                </a>
                            </div>
                        </div>

                        <jsp:include page="component/suggested-books.jsp" />
                        <jsp:include page="component/footer.jsp" />

                        <div id="fullscreenGalleryModal"
                            style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0,0,0,0.95); z-index: 9999; flex-direction: column; justify-content: space-between;">

                            <div style="position: absolute; top: 20px; right: 30px; z-index: 10002;">
                                <span onclick="closeFullscreenGallery()"
                                    style="color: #fff; font-size: 40px; cursor: pointer; font-family: sans-serif; opacity: 0.8; text-shadow: 0 0 5px #000;">&times;</span>
                            </div>

                            <div class="nav-btn prev-btn" onclick="prevImage()"
                                style="position: absolute; top: 50%; left: 20px; transform: translateY(-50%); z-index: 10001; cursor: pointer; padding: 20px; background: rgba(0,0,0,0.3); border-radius: 50%; width: 60px; height: 60px; display: flex; justify-content: center; align-items: center; transition: 0.3s;">
                                <i class="fa-solid fa-chevron-left" style="color: white; font-size: 30px;"></i>
                            </div>

                            <div class="nav-btn next-btn" onclick="nextImage()"
                                style="position: absolute; top: 50%; right: 20px; transform: translateY(-50%); z-index: 10001; cursor: pointer; padding: 20px; background: rgba(0,0,0,0.3); border-radius: 50%; width: 60px; height: 60px; display: flex; justify-content: center; align-items: center; transition: 0.3s;">
                                <i class="fa-solid fa-chevron-right" style="color: white; font-size: 30px;"></i>
                            </div>

                            <div
                                style="flex: 1; display: flex; justify-content: center; align-items: center; padding: 20px; overflow: hidden; position: relative;">

                                <img id="modalMainImage" src="${pageContext.request.contextPath}/${book.imageUrl}"
                                    style="max-width: 90%; max-height: 85vh; object-fit: contain; transition: transform 0.2s ease-in-out;">

                                <div
                                    style="position: absolute; bottom: 30px; right: 50px; display: flex; gap: 25px; background: rgba(30, 30, 30, 0.7); padding: 10px 20px; border-radius: 8px; z-index: 10001;">
                                    <i class="fa-solid fa-magnifying-glass-minus"
                                        style="color: #fff; font-size: 24px; cursor: pointer;" onclick="zoomOut()"></i>
                                    <i class="fa-solid fa-magnifying-glass-plus"
                                        style="color: #fff; font-size: 24px; cursor: pointer;" onclick="zoomIn()"></i>
                                </div>
                            </div>

                            <div
                                style="width: 100%; background: #111; padding: 15px 0; display: flex; justify-content: center; z-index: 10001;">
                                <div style="display: flex; gap: 10px; overflow-x: auto; max-width: 90%; padding-bottom: 5px;"
                                    class="modal-thumb-scroll">

                                    <div class="modal-thumb-item"
                                        style="border: 2px solid #C92127; width: 80px; height: 80px; flex-shrink: 0; cursor: pointer; background: white; border-radius: 4px; padding: 2px;"
                                        onclick="changeModalImage(this, '${pageContext.request.contextPath}/${book.imageUrl}', 0)">
                                        <img src="${pageContext.request.contextPath}/${book.imageUrl}"
                                            style="width: 100%; height: 100%; object-fit: contain;">
                                    </div>

                                    <c:forEach items="${bookImages}" var="img" varStatus="status">
                                        <div class="modal-thumb-item"
                                            style="border: 2px solid transparent; width: 80px; height: 80px; flex-shrink: 0; cursor: pointer; background: white; border-radius: 4px; padding: 2px;"
                                            onclick="changeModalImage(this, '${pageContext.request.contextPath}/${img.imageUrl}', ${status.index + 1})">
                                            <img src="${pageContext.request.contextPath}/${img.imageUrl}"
                                                style="width: 100%; height: 100%; object-fit: contain;">
                                        </div>
                                    </c:forEach>

                                </div>
                            </div>
                        </div>

                        <div id="addressModalOverlay" class="address-modal-overlay" style="display: none;">
                            <div class="address-modal-box">
                                <h4
                                    style="text-align: center; margin-top: 0; margin-bottom: 25px; font-size: 18px; color: #333;">
                                    Chọn địa chỉ giao hàng của bạn</h4>

                                <label class="address-radio-label">
                                    <input type="radio" name="address_type" value="existing"
                                        onchange="toggleAddressFields()">
                                    <span class="radio-custom"></span>
                                    Giao hàng đến <span style="color: #777; margin-left: 5px;"> Phường Bến Nghé, Quận 1,
                                        Hồ Chí Minh</span>
                                </label>

                                <label class="address-radio-label" style="margin-bottom: 15px;">
                                    <input type="radio" name="address_type" value="new" checked
                                        onchange="toggleAddressFields()">
                                    <span class="radio-custom"></span>
                                    Giao hàng đến địa chỉ khác
                                </label>

                                <div id="newAddressFields" style="padding-left: 30px;">
                                    <div class="select-group">
                                        <label>Tỉnh/Thành Phố</label>
                                        <select id="provinceSelect">
                                            <option>Chọn tỉnh/thành Phố</option>
                                        </select>
                                    </div>
                                    <div class="select-group">
                                        <label>Quận/Huyện</label>
                                        <select id="districtSelect">
                                            <option>Chọn quận/huyện</option>
                                        </select>
                                    </div>
                                    <div class="select-group" style="margin-bottom: 0;">
                                        <label>Phường/Xã</label>
                                        <select id="wardSelect">
                                            <option>Chọn phường/xã</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="address-modal-actions">
                                    <button class="btn-cancel" onclick="closeAddressModal()">Hủy</button>
                                    <button class="btn-confirm" onclick="confirmAddress()">Xác nhận</button>
                                </div>
                            </div>
                        </div>

                        <div class="modal fade" id="addToCollectionModal" tabindex="-1">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title fw-bold"><i
                                                class="fa-solid fa-bookmark text-danger me-2"></i>Lưu sách vào Bộ sưu
                                            tập</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <p class="text-muted mb-3">Sách: <strong>${book.title}</strong></p>
                                        <c:choose>
                                            <c:when test="${empty myCollections}">
                                                <div class="text-center py-4">
                                                    <p class="text-muted">Bạn chưa có giá sách nào!</p>
                                                    <a href="${pageContext.request.contextPath}/my-collections"
                                                        class="btn btn-sm btn-danger">Tạo giá sách mới</a>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/my-collections"
                                                    method="POST">
                                                    <input type="hidden" name="action" value="addBook">
                                                    <input type="hidden" name="bookId" value="${book.id}">

                                                    <label class="form-label fw-bold">Chọn giá sách:</label>
                                                    <div class="list-group mb-3">
                                                        <c:forEach var="c" items="${myCollections}">
                                                            <label class="list-group-item d-flex gap-2">
                                                                <input class="form-check-input flex-shrink-0"
                                                                    type="radio" name="collectionId" value="${c.id}"
                                                                    required>
                                                                <span>
                                                                    <span style="color: ${c.coverColor};"><i
                                                                            class="fa-solid fa-swatchbook me-1"></i></span>
                                                                    ${c.name}
                                                                    <small class="text-muted d-block"
                                                                        style="font-size: 12px;">Đang có ${c.totalBooks}
                                                                        cuốn</small>
                                                                </span>
                                                            </label>
                                                        </c:forEach>
                                                    </div>

                                                    <div class="text-end mt-3">
                                                        <button type="button" class="btn btn-light border"
                                                            data-bs-dismiss="modal">Hủy</button>
                                                        <button type="submit" class="btn text-white fw-bold"
                                                            style="background-color: #C92127;">Lưu lại</button>
                                                    </div>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="modal fade" id="reportReviewModal" tabindex="-1">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title fw-bold"><i
                                                class="fa-solid fa-triangle-exclamation text-warning me-2"></i>Báo Cáo
                                            Vi Phạm</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <form id="reportReviewForm">
                                        <div class="modal-body">
                                            <input type="hidden" name="action" value="report">
                                            <input type="hidden" name="reviewId" id="report_review_id" value="">

                                            <input type="hidden" name="pid" value="${book.id}">

                                            <p class="text-muted mb-3" style="font-size: 14px;">Tại sao bạn muốn báo cáo
                                                bình luận này?</p>

                                            <div class="form-check mb-2">
                                                <input class="form-check-input report-radio" type="radio" name="reason"
                                                    value="Nội dung rác, spam" id="r1" checked>
                                                <label class="form-check-label" for="r1">Nội dung rác, spam</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input report-radio" type="radio" name="reason"
                                                    value="Chứa từ ngữ chửi bậy, thô tục" id="r2">
                                                <label class="form-check-label" for="r2">Chứa từ ngữ chửi bậy, thô
                                                    tục</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input report-radio" type="radio" name="reason"
                                                    value="Không liên quan đến sản phẩm" id="r3">
                                                <label class="form-check-label" for="r3">Không liên quan đến sách
                                                    này</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input report-radio" type="radio" name="reason"
                                                    value="Lừa đảo, chứa link độc hại" id="r4">
                                                <label class="form-check-label" for="r4">Lừa đảo, chứa link độc
                                                    hại</label>
                                            </div>

                                            <div class="form-check mb-2">
                                                <input class="form-check-input report-radio" type="radio" name="reason"
                                                    value="Khác" id="r5">
                                                <label class="form-check-label" for="r5">Vi phạm khác...</label>
                                            </div>

                                            <div id="customReasonDiv"
                                                style="display: none; margin-top: 10px; padding-left: 24px;">
                                                <textarea class="form-control" id="customReasonInput" rows="2"
                                                    placeholder="Vui lòng mô tả chi tiết lý do..."></textarea>
                                            </div>

                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-light border"
                                                data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn text-white fw-bold"
                                                style="background-color: #f39c12;">Gửi Báo Cáo</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <%-- MODAL BÁO CÁO CHO HỎI ĐÁP & THẢO LUẬN --%>
                            <div class="modal fade" id="reportDiscussionModal" tabindex="-1">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title fw-bold"><i
                                                    class="fa-solid fa-triangle-exclamation text-warning me-2"></i>Báo
                                                Cáo Vi Phạm</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <form id="reportDiscussionForm">
                                            <div class="modal-body">
                                                <input type="hidden" name="action" value="report">
                                                <input type="hidden" name="reportType" id="report_type" value="">
                                                <input type="hidden" name="targetId" id="report_target_id" value="">

                                                <input type="hidden" name="pid" value="${book.id}">

                                                <p class="text-muted mb-3" style="font-size: 14px;">Tại sao bạn muốn báo
                                                    cáo nội dung này?</p>

                                                <div class="form-check mb-2">
                                                    <input class="form-check-input disc-report-radio" type="radio"
                                                        name="reason" value="Nội dung rác, spam" id="dr1" checked>
                                                    <label class="form-check-label" for="dr1">Nội dung rác, spam</label>
                                                </div>
                                                <div class="form-check mb-2">
                                                    <input class="form-check-input disc-report-radio" type="radio"
                                                        name="reason" value="Chứa từ ngữ chửi bậy, thô tục" id="dr2">
                                                    <label class="form-check-label" for="dr2">Chứa từ ngữ chửi bậy, thô
                                                        tục</label>
                                                </div>
                                                <div class="form-check mb-2">
                                                    <input class="form-check-input disc-report-radio" type="radio"
                                                        name="reason" value="Không liên quan đến sản phẩm" id="dr3">
                                                    <label class="form-check-label" for="dr3">Không liên quan đến sách
                                                        này</label>
                                                </div>
                                                <div class="form-check mb-2">
                                                    <input class="form-check-input disc-report-radio" type="radio"
                                                        name="reason" value="Lừa đảo, chứa link độc hại" id="dr4">
                                                    <label class="form-check-label" for="dr4">Lừa đảo, chứa link độc
                                                        hại</label>
                                                </div>
                                                <div class="form-check mb-2">
                                                    <input class="form-check-input disc-report-radio" type="radio"
                                                        name="reason" value="Khác" id="dr5">
                                                    <label class="form-check-label" for="dr5">Vi phạm khác...</label>
                                                </div>

                                                <div id="customDiscReasonDiv"
                                                    style="display: none; margin-top: 10px; padding-left: 24px;">
                                                    <textarea class="form-control" name="customReason"
                                                        id="customDiscReasonInput" rows="2"
                                                        placeholder="Vui lòng mô tả chi tiết lý do..."></textarea>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-light border"
                                                    data-bs-dismiss="modal">Hủy</button>
                                                <button type="submit" class="btn text-white fw-bold"
                                                    style="background-color: #f39c12;">Gửi Báo Cáo</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                    </main>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        function changeImage(element, imageUrl) {
                            // 1. Thay đổi nguồn ảnh của ảnh chính (ảnh to)
                            document.getElementById('mainImage').src = imageUrl;

                            // 2. Xóa viền đỏ ở tất cả các ảnh nhỏ
                            var allThumbs = document.querySelectorAll('.thumb-item');
                            allThumbs.forEach(function (thumb) {
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
                        window.onload = function () {
                            // 1. Quét tất cả ảnh nhỏ trong Modal để nạp vào danh sách
                            let thumbs = document.querySelectorAll('.modal-thumb-item img');
                            thumbs.forEach((img) => {
                                galleryImages.push(img.src);
                            });

                            // 2. Lắng nghe sự kiện bàn phím
                            document.addEventListener('keydown', function (event) {
                                // Chỉ bắt sự kiện khi Modal đang mở
                                if (document.getElementById('fullscreenGalleryModal').style.display === 'flex') {
                                    if (event.key === "ArrowLeft") { prevImage(); }
                                    if (event.key === "ArrowRight") { nextImage(); }
                                    if (event.key === "Escape") { closeFullscreenGallery(); }
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
    // 3. Xử lý Gửi Form báo cáo
    document.getElementById('reportDiscussionForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const form = e.target;
        const data = new URLSearchParams(new FormData(form));
        
        // Nếu chọn "Khác" thì gộp lý do
        if(data.get('reason') === 'Khác'){
            data.set('reason', data.get('customReason'));
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

    // =========================================================
    // JS: TỰ ĐỘNG CUỘN ĐẾN BÌNH LUẬN KHI BẤM TỪ THÔNG BÁO TỚI
    // =========================================================
    window.addEventListener('load', function() {
        const hash = window.location.hash; // Lấy phần #... trên URL
        
        if (hash && (hash.startsWith('#reply-box-') || hash.startsWith('#review-box-'))) {
            const targetEl = document.querySelector(hash);
            
            if (targetEl) {
                // 1. Tìm cái thẻ div cha đang chứa câu trả lời này (mặc định nó đang bị display: none)
                const parentSection = targetEl.closest('[id^="replies-section-"]');
                
                // 2. Mở khóa ẩn, cho nó hiện ra
                if (parentSection) {
                    parentSection.style.display = 'block';
                }
                
                // 3. Cuộn mượt mà đến giữa màn hình và tạo hiệu ứng nhấp nháy
                setTimeout(() => {
                    targetEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    
                    // Thêm class bôi vàng 
                    const innerBox = targetEl.querySelector('div[style*="flex: 1"]'); // Lấy cái hộp nội dung bên trong
                    if(innerBox) {
                        innerBox.classList.add('highlight-target');
                    } else {
                        targetEl.classList.add('highlight-target');
                    }
                }, 300); // Đợi 300ms cho DOM render xong
            }
        }
    });
    // =================================================================
// 1. CẤU HÌNH API GHN (Hệ thống thật)
// =================================================================
const GHN_TOKEN = '79a7c86a-1ef8-11f1-a3ea-4e2619480a9f'; 
const GHN_SHOP_ID = 6322897; 
const SHOP_DISTRICT_ID = 3440; 
const GHN_URL = 'https://online-gateway.ghn.vn/shiip/public-api/master-data';

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
                            allThumbs.forEach(function (thumb) { thumb.style.borderColor = "transparent"; });
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
                            selects.forEach(function (select) {
                                select.disabled = !isNewAddressChecked;
                            });
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
                        $(document).ready(function () {
                            $('#addressModalOverlay').on('change', 'select, input[type="radio"]', function () {
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
                            star.addEventListener("click", function () {
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

                        document.getElementById('reviewForm').addEventListener('submit', function (e) {
                            // Chặn reload trang
                            e.preventDefault();

                            const form = this;
                            const ratingVal = document.getElementById("ratingValue").value;
                            const commentVal = form.querySelector('textarea[name="comment"]').value.trim();

                            // =========================================================
                            // [THÊM MỚI] XỬ LÝ EX 1: CHƯA CHỌN SAO
                            // =========================================================
                            if (!ratingVal || ratingVal === "") {
                                alert("Vui lòng chọn số sao đánh giá!");
                                return; // Dừng lại, không chạy tiếp lệnh gửi
                            }

                            // =========================================================
                            // [THÊM MỚI] XỬ LÝ EX 2: ĐỂ TRỐNG NỘI DUNG
                            // =========================================================
                            if (commentVal === '') {
                                alert("Vui lòng chia sẻ cảm nhận của bạn về cuốn sách này!");
                                form.querySelector('textarea[name="comment"]').focus();
                                return; // Dừng lại, không chạy tiếp
                            }
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
                                    if (response.status === 401) {
                                        alert("Phiên đăng nhập đã hết hạn. Vui lòng tải lại trang để đăng nhập!");
                                        throw new Error("Unauthorized");
                                    }
                                    if (!response.ok) {
                                        throw new Error("Lỗi hệ thống");
                                    }
                                    return response.json(); // ĐỌC DỮ LIỆU TRẢ VỀ DƯỚI DẠNG JSON
                                })
                                .then(data => {
                                    if (data && data.success) {
                                        toggleReviewForm(); // Đóng form

                                        // LẤY ID THẬT TỪ DATABASE DO SERVLET GỬI VỀ
                                        const realReviewId = data.reviewId;

                                        const rating = parseInt(formData.get('rating'));
                                        const comment = formData.get('comment');
                                        const userName = '${sessionScope.user.username}';
                                        const avatarChar = userName ? userName.substring(0, 1).toUpperCase() : 'U';

                                        let starsHtml = '';
                                        for (let i = 1; i <= 5; i++) {
                                            if (i <= rating) starsHtml += '<i class="fa-solid fa-star"></i>';
                                            else starsHtml += '<i class="fa-regular fa-star" style="color: #ddd;"></i>';
                                        }

                                        // VẼ HTML MỚI: KÈM LUÔN NÚT 3 CHẤM CÓ HOẠT ĐỘNG 100% VỚI ID THẬT
                                        const newReviewHtml =
                                            '<div class="review-item" id="review-box-' + realReviewId + '" style="animation: fadeIn 0.5s;">' +
                                            '<div class="reviewer-info" style="position: relative;">' +
                                            '<div class="reviewer-avatar">' + avatarChar + '</div>' +
                                            '<div>' +
                                            '<div class="reviewer-name">' + userName + '</div>' +
                                            '<div class="review-date">Vừa xong</div>' +
                                            '</div>' +

                                            // NÚT 3 CHẤM XỊN ĐÃ CÓ ID THẬT
                                            '<div class="dropdown" style="position: absolute; right: 0; top: 0;">' +
                                            '<button class="btn btn-sm btn-light" type="button" data-bs-toggle="dropdown" style="background: transparent; border: none; font-size: 18px; color: #888;">' +
                                            '<i class="fa-solid fa-ellipsis-vertical"></i>' +
                                            '</button>' +
                                            '<ul class="dropdown-menu dropdown-menu-end shadow-sm">' +
                                            '<li><a class="dropdown-item" href="javascript:void(0)" onclick="openEditReview(' + realReviewId + ')"><i class="fa-solid fa-pen-to-square me-2 text-primary"></i> Sửa bình luận</a></li>' +
                                            '<li><hr class="dropdown-divider"></li>' +
                                            '<li>' +
                                            '<form class="delete-review-form" style="margin: 0;">' +
                                            '<input type="hidden" name="action" value="delete">' +
                                            '<input type="hidden" name="reviewId" value="' + realReviewId + '">' +
                                            '<input type="hidden" name="pid" value="${book.id}">' +
                                            '<button type="submit" class="dropdown-item text-danger"><i class="fa-solid fa-trash-can me-2"></i> Xóa bình luận</button>' +
                                            '</form>' +
                                            '</li>' +
                                            '</ul>' +
                                            '</div>' +
                                            '</div>' +

                                            '<div id="review-content-display-' + realReviewId + '">' +
                                            '<div class="review-stars">' + starsHtml + '</div>' +
                                            '<div class="review-content">' + comment + '</div>' +
                                            '</div>' +

                                            // FORM EDIT ẨN (Cũng dùng ID thật)
                                            '<div id="review-edit-form-' + realReviewId + '" style="display: none; background: #f9f9f9; padding: 15px; border-radius: 8px; margin-top: 10px; border: 1px dashed #ccc;">' +
                                            '<form class="edit-review-form">' +
                                            '<input type="hidden" name="action" value="update">' +
                                            '<input type="hidden" name="reviewId" value="' + realReviewId + '">' +
                                            '<input type="hidden" name="pid" value="${book.id}">' +
                                            '<div style="font-weight: bold; margin-bottom: 5px; font-size: 13px;">Đánh giá lại:</div>' +
                                            '<select name="rating" class="form-select form-select-sm mb-2" style="width: 150px;">' +
                                            '<option value="5" ' + (rating == 5 ? 'selected' : '') + '>⭐⭐⭐⭐⭐ (Tuyệt vời)</option>' +
                                            '<option value="4" ' + (rating == 4 ? 'selected' : '') + '>⭐⭐⭐⭐ (Tốt)</option>' +
                                            '<option value="3" ' + (rating == 3 ? 'selected' : '') + '>⭐⭐⭐ (Bình thường)</option>' +
                                            '<option value="2" ' + (rating == 2 ? 'selected' : '') + '>⭐⭐ (Tệ)</option>' +
                                            '<option value="1" ' + (rating == 1 ? 'selected' : '') + '>⭐ (Rất tệ)</option>' +
                                            '</select>' +
                                            '<textarea name="comment" class="form-control" rows="2" required>' + comment + '</textarea>' +
                                            '<div style="margin-top: 10px; text-align: right;">' +
                                            '<button type="button" class="btn btn-sm btn-light border" onclick="cancelEditReview(' + realReviewId + ')">Hủy</button> ' +
                                            '<button type="submit" class="btn btn-sm text-white" style="background-color: #C92127;">Lưu thay đổi</button>' +
                                            '</div>' +
                                            '</form>' +
                                            '</div>' +
                                            '</div>';

                                        const listContainer = document.getElementById('reviewListContainer');
                                        if (listContainer.innerHTML.includes('fa-comment-dots')) {
                                            listContainer.innerHTML = '';
                                        }
                                        listContainer.insertAdjacentHTML('afterbegin', newReviewHtml);
                                    }
                                })
                                .catch(error => {
                                    console.error('Lỗi:', error);
                                    // alert("Không thể kết nối đến máy chủ!"); 
                                })
                                .finally(() => {
                                    submitBtn.innerText = originalBtnText;
                                    submitBtn.disabled = false;
                                });
                        });

                        function openEditReview(reviewId) {
                            // Giấu đi phần hiển thị bình thường
                            document.getElementById('review-content-display-' + reviewId).style.display = 'none';
                            // Mở cái form sửa lên
                            document.getElementById('review-edit-form-' + reviewId).style.display = 'block';
                        }

                        function cancelEditReview(reviewId) {
                            // Giấu form sửa đi
                            document.getElementById('review-edit-form-' + reviewId).style.display = 'none';
                            // Trả lại phần hiển thị bình thường
                            document.getElementById('review-content-display-' + reviewId).style.display = 'block';
                        }

                        // --- MA THUẬT AJAX CHO SỬA & XÓA BÌNH LUẬN ---
                        document.getElementById('reviewListContainer').addEventListener('submit', function (e) {

                            // 1. XỬ LÝ NÚT XÓA
                            if (e.target.classList.contains('delete-review-form')) {
                                e.preventDefault(); // Chặn giật trang
                                if (!confirm('Bạn có chắc muốn xóa bình luận này không?')) return;

                                const form = e.target;
                                const reviewId = form.querySelector('input[name="reviewId"]').value;
                                const data = new URLSearchParams(new FormData(form));

                                fetch('${pageContext.request.contextPath}/review', {
                                    method: 'POST', body: data, headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                                })
                                    .then(res => res.json())
                                    .then(result => {
                                        if (result.success) {
                                            // Hiệu ứng mờ dần cực mượt trước khi xóa
                                            const box = document.getElementById('review-box-' + reviewId);
                                            box.style.transition = "all 0.4s ease-out";
                                            box.style.opacity = "0";
                                            box.style.transform = "translateX(20px)";
                                            setTimeout(() => box.remove(), 400);
                                        } else {
                                            alert("Có lỗi xảy ra, không thể xóa!");
                                        }
                                    });
                            }

                            // 2. XỬ LÝ NÚT LƯU SỬA CHỮA
                            if (e.target.classList.contains('edit-review-form')) {
                                e.preventDefault(); // Chặn giật trang

                                const form = e.target;
                                const reviewId = form.querySelector('input[name="reviewId"]').value;
                                const formData = new FormData(form);
                                const data = new URLSearchParams(formData);

                                const submitBtn = form.querySelector('button[type="submit"]');
                                const originalText = submitBtn.innerText;
                                submitBtn.innerText = "Đang lưu...";
                                submitBtn.disabled = true;

                                fetch('${pageContext.request.contextPath}/review', {
                                    method: 'POST', body: data, headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                                })
                                    .then(res => res.json())
                                    .then(result => {
                                        if (result.success) {
                                            const newRating = parseInt(formData.get('rating'));
                                            const newComment = formData.get('comment');

                                            let starsHtml = '';
                                            for (let i = 1; i <= 5; i++) {
                                                if (i <= newRating) starsHtml += '<i class="fa-solid fa-star"></i>';
                                                else starsHtml += '<i class="fa-regular fa-star" style="color: #ddd;"></i>';
                                            }

                                            // Cập nhật lại HTML bên ngoài
                                            const displayDiv = document.getElementById('review-content-display-' + reviewId);
                                            displayDiv.querySelector('.review-stars').innerHTML = starsHtml;
                                            displayDiv.querySelector('.review-content').innerText = newComment;

                                            // Đóng form
                                            cancelEditReview(reviewId);
                                        } else {
                                            alert("Có lỗi xảy ra, không thể cập nhật!");
                                        }
                                    })
                                    .finally(() => {
                                        submitBtn.innerText = originalText;
                                        submitBtn.disabled = false;
                                    });
                            }
                        });

                        // Mở Modal Tố Cáo và gán ID (Reset lại form mỗi khi mở)
                        function openReportModal(reviewId) {
                            document.getElementById('report_review_id').value = reviewId;
                            document.getElementById('reportReviewForm').reset();
                            document.getElementById('customReasonDiv').style.display = 'none';

                            var myModal = new bootstrap.Modal(document.getElementById('reportReviewModal'));
                            myModal.show();
                        }

                        // Xử lý hiệu ứng Ẩn/Hiện ô nhập "Lý do khác"
                        const reportRadios = document.querySelectorAll('.report-radio');
                        const customReasonDiv = document.getElementById('customReasonDiv');
                        const customReasonInput = document.getElementById('customReasonInput');

                        reportRadios.forEach(radio => {
                            radio.addEventListener('change', function () {
                                if (this.value === 'Khác') {
                                    customReasonDiv.style.display = 'block';
                                    customReasonInput.focus();
                                } else {
                                    customReasonDiv.style.display = 'none';
                                    customReasonInput.value = ''; // Xóa chữ nếu đổi ý chọn mục có sẵn
                                }
                            });
                        });

                        // Xử lý gửi Form Tố cáo bằng AJAX
                        document.getElementById('reportReviewForm').addEventListener('submit', function (e) {
                            e.preventDefault();

                            const form = this;
                            const formData = new FormData(form);

                            // Lấy lại phần tử input một cách chắc chắn nhất
                            const reasonInput = document.getElementById('customReasonInput');

                            // KIỂM TRA LOGIC "KHÁC" TRƯỚC KHI GỬI
                            if (formData.get('reason') === 'Khác') {
                                // Chắc chắn reasonInput tồn tại mới lấy value
                                if (reasonInput) {
                                    const customText = reasonInput.value.trim();
                                    if (customText === '') {
                                        alert("Vui lòng nhập chi tiết lý do bạn muốn báo cáo!");
                                        reasonInput.focus();
                                        return; // Chặn không cho gửi nếu chưa nhập chữ
                                    }
                                    // Tráo đổi dữ liệu: Biến "Khác" thành "Khác: [Nội dung khách gõ]"
                                    formData.set('reason', 'Khác: ' + customText);
                                }
                            }

                            const data = new URLSearchParams(formData);
                            const submitBtn = form.querySelector('button[type="submit"]');
                            const originalText = submitBtn.innerText;

                            submitBtn.innerText = "Đang gửi...";
                            submitBtn.disabled = true;

                            fetch('${pageContext.request.contextPath}/review', {
                                method: 'POST', body: data, headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                            })
                                .then(res => {
                                    // Thêm kiểm tra lỗi mạng/server để bắt bệnh dễ hơn
                                    if (!res.ok) {
                                        throw new Error('Network response was not ok');
                                    }
                                    return res.json();
                                })
                                .then(result => {
                                    if (result.success) {
                                        alert("Cảm ơn bạn! Báo cáo vi phạm đã được gửi đến quản trị viên.");
                                        // Tắt modal một cách an toàn (tránh lỗi null)
                                        const modalEl = document.getElementById('reportReviewModal');
                                        const modal = bootstrap.Modal.getInstance(modalEl);
                                        if (modal) {
                                            modal.hide();
                                        } else {
                                            // Dự phòng nếu getInstance thất bại
                                            let newModal = new bootstrap.Modal(modalEl);
                                            newModal.hide();
                                        }
                                    } else {
                                        alert("Có lỗi xảy ra, không thể gửi báo cáo! Vui lòng thử lại.");
                                    }
                                })
                                .catch(error => {
                                    console.error('Lỗi khi gửi báo cáo:', error);
                                    alert("Không thể kết nối với máy chủ. Vui lòng kiểm tra mạng!");
                                })
                                .finally(() => {
                                    submitBtn.innerText = originalText;
                                    submitBtn.disabled = false;
                                });
                        });

                        // Bật tắt Form Hỏi Đáp
                        function toggleQAForm() {
                            const form = document.getElementById("qaFormSection");
                            form.style.display = (form.style.display === "none" || form.style.display === "") ? "block" : "none";
                        }

                        // Xử lý gửi Form Hỏi Đáp bằng AJAX
                        document.getElementById('discussionForm').addEventListener('submit', function (e) {
                            e.preventDefault();

                            const form = this;
                            const formData = new FormData(form);
                            const submitBtn = form.querySelector('button[type="submit"]');
                            const originalText = submitBtn.innerText;

                            submitBtn.innerText = "Đang gửi...";
                            submitBtn.disabled = true;

                            const data = new URLSearchParams(formData);

                            fetch('${pageContext.request.contextPath}/discussion', {
                                method: 'POST',
                                body: data,
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                            })
                                .then(res => {
                                    if (res.status === 401) throw new Error("Unauthorized");
                                    return res.json();
                                })
                                .then(result => {
                                    if (result && result.success) {
                                        toggleQAForm(); // Gập form lại

                                        // Lấy dữ liệu để vẽ giao diện ngay lập tức
                                        const title = formData.get('discussionTitle');
                                        const content = formData.get('discussionContent');
                                        const tag = formData.get('topicTag');
                                        const isSpoiler = formData.get('hasSpoiler') !== null;
                                        const userName = '${sessionScope.user.username}';
                                        const avatarChar = userName ? userName.substring(0, 1).toUpperCase() : 'U';

                                        // Render Badge
                                        let badgeHtml = '<span class="badge bg-light text-dark border">' + tag + '</span>';
                                        if (isSpoiler) badgeHtml += ' <span class="badge bg-danger ms-1">SPOILER</span>';

                                        // Render Content (Xử lý hiệu ứng che mờ Spoiler)
                                        let contentHtml = '';
                                        if (isSpoiler) {
                                            contentHtml =
                                                '<div class="spoiler-box" style="background: #ffe6e6; padding: 10px; border-radius: 4px; border: 1px dashed #ff9999; cursor: pointer; text-align: center; color: #C92127; font-weight: bold; font-size: 13px;" onclick="this.nextElementSibling.style.display=\'block\'; this.style.display=\'none\';">' +
                                                '<i class="fa-solid fa-eye-slash me-1"></i> Nội dung bị ẩn vì chứa Spoiler. Bấm vào để xem.' +
                                                '</div>' +
                                                '<p class="text-muted" style="font-size: 14px; display: none;">' + content + '</p>';
                                        } else {
                                            contentHtml = '<p class="text-muted" style="font-size: 14px;">' + content + '</p>';
                                        }

                                        // Dựng cục HTML
                                        const newHtml =
                                            '<div class="discussion-item" style="border: 1px solid #f0f0f0; padding: 15px; border-radius: 8px; margin-bottom: 15px; animation: fadeIn 0.5s;">' +
                                            '<div class="d-flex justify-content-between align-items-start mb-2">' +
                                            '<div class="d-flex align-items-center gap-2">' +
                                            '<div style="width: 35px; height: 35px; background: #e0e0e0; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; color: #555;">' + avatarChar + '</div>' +
                                            '<div>' +
                                            '<div style="font-weight: bold; color: #333; font-size: 14px;">' + userName + '</div>' +
                                            '<div style="font-size: 12px; color: #999;">Vừa xong</div>' +
                                            '</div>' +
                                            '</div>' +
                                            '<div>' + badgeHtml + '</div>' +
                                            '</div>' +
                                            '<h6 class="fw-bold mt-2" style="color: #2489F4;">' + title + '</h6>' +
                                            contentHtml +
                                            '<div class="mt-2 text-end">' +
                                            '<span style="font-size: 13px; font-weight: bold; color: #666;"><i class="fa-regular fa-comments me-1"></i> 0 Trả lời</span>' +
                                            '</div>' +
                                            '</div>';

                                        const listContainer = document.getElementById('qaListContainer');
                                        if (listContainer.innerHTML.includes('fa-clipboard-question')) {
                                            listContainer.innerHTML = ''; // Xóa dòng chữ "Chưa có câu hỏi"
                                        }
                                        listContainer.insertAdjacentHTML('afterbegin', newHtml);
                                        form.reset();
                                    } else {
                                        alert(result.message || "Lỗi khi gửi câu hỏi!"); // [ĐÃ SỬA Ở ĐÂY]
                                    }
                                })
                                .catch(err => {
                                    if (err.message === "Unauthorized") alert("Vui lòng đăng nhập để gửi câu hỏi!");
                                    else alert("Lỗi kết nối!");
                                })
                                .finally(() => {
                                    submitBtn.innerText = originalText;
                                    submitBtn.disabled = false;
                                });
                        });

                        // JS 1: Mở/Đóng khu vực Trả lời
                        function toggleReplies(discussionId) {
                            const sec = document.getElementById('replies-section-' + discussionId);
                            sec.style.display = (sec.style.display === 'none' || sec.style.display === '') ? 'block' : 'none';
                        }

                        // JS 1: Dời Form nhập liệu và "Ghi nhớ" người đang được tag
                        function replyToUser(discussionId, targetUsername, btnElement) {
                            const section = document.getElementById('replies-section-' + discussionId);
                            if (!section) return;

                            const form = section.querySelector('.discussion-reply-form');
                            const inputField = form.querySelector('input[name="replyContent"]');
                            const targetReplyBox = btnElement.closest('.reply-item-container') || btnElement.closest('#discussion-display-' + discussionId);

                            const currentLoggedInUser = '${sessionScope.user != null ? sessionScope.user.username : ""}';

                            if (targetReplyBox) targetReplyBox.insertAdjacentElement('afterend', form);

                            if (currentLoggedInUser === targetUsername) {
                                // TỰ TRẢ LỜI: Không hiện chữ @ lên ô input, nhưng LƯU NGẦM vào data-hidden-tag
                                inputField.value = '';
                                form.setAttribute('data-hidden-tag', '@' + targetUsername + ' ');
                                form.removeAttribute('data-tag');
                            } else {
                                // TRẢ LỜI NGƯỜI KHÁC: Hiện chữ @ và lưu vào data-tag
                                const tagText = '@' + targetUsername + ' ';
                                inputField.value = tagText;
                                form.setAttribute('data-tag', tagText);
                                form.removeAttribute('data-hidden-tag');
                            }
                            inputField.focus();
                        }

                        // ==========================================
                        // JS: MỞ / ĐÓNG FORM SỬA CÂU HỎI
                        // ==========================================
                        function openEditDiscussion(discussionId) {
                            document.getElementById('discussion-display-' + discussionId).style.display = 'none';
                            document.getElementById('discussion-edit-form-' + discussionId).style.display = 'block';
                        }

                        function openEditReply(replyId) {
                            document.getElementById('reply-display-' + replyId).style.display = 'none';
                            document.getElementById('reply-edit-form-' + replyId).style.display = 'block';
                        }
                        function cancelEditReply(replyId) {
                            document.getElementById('reply-edit-form-' + replyId).style.display = 'none';
                            document.getElementById('reply-display-' + replyId).style.display = 'block';
                        }

                        function cancelEditDiscussion(discussionId) {
                            document.getElementById('discussion-edit-form-' + discussionId).style.display = 'none';
                            document.getElementById('discussion-display-' + discussionId).style.display = 'block';
                        }

                        // ==========================================
                        // JS: TỔNG TRẠM XỬ LÝ MỌI FORM SUBMIT (TRẢ LỜI, SỬA, XÓA)
                        // ==========================================
                        document.getElementById('qaListContainer').addEventListener('submit', function (e) {
                            e.preventDefault(); // Chặn load lại trang cho tất cả các form trong khu vực này
                            const form = e.target;

                            // ---------------------------------------------------------
                            // NHÁNH 1: XỬ LÝ FORM GỬI CÂU TRẢ LỜI (Kèm logic Tag ẩn/hiện)
                            // ---------------------------------------------------------
                            if (form.classList.contains('discussion-reply-form')) {
                                const discussionId = form.querySelector('input[name="discussionId"]').value;
                                const inputField = form.querySelector('input[name="replyContent"]');

                                let rawContent = inputField.value.trim();
                                if (!rawContent) return;

                                // MÁNH KHÓE: Lén chèn cái "tag ẩn" vào trước văn bản để gửi xuống Database
                                const hiddenTag = form.getAttribute('data-hidden-tag');
                                let contentToSend = rawContent;
                                if (hiddenTag) {
                                    contentToSend = hiddenTag + rawContent;
                                }

                                const data = new URLSearchParams(new FormData(form));
                                data.set('replyContent', contentToSend);

                                const submitBtn = form.querySelector('button[type="submit"]');
                                const originalTxt = submitBtn.innerText;
                                submitBtn.disabled = true;
                                submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i>';

                                fetch('${pageContext.request.contextPath}/discussion', {
                                    method: 'POST', body: data, headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                                })
                                    .then(res => res.json())
                                    .then(result => {
                                        if (result.success) {
                                            const userName = '${sessionScope.user.username}';
                                            const avatar = userName ? userName.substring(0, 1).toUpperCase() : 'U';

                                            let escapedContent = rawContent.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
                                            let isNested = false;
                                            let formattedContent = escapedContent;

                                            const expectedTag = form.getAttribute('data-tag');
                                            if (expectedTag && escapedContent.startsWith(expectedTag.trim())) {
                                                isNested = true;
                                                formattedContent = escapedContent.replace(expectedTag.trim(), '<span style="color: #2489F4; font-weight: bold;">' + expectedTag.trim() + '</span>');
                                            } else if (hiddenTag) {
                                                isNested = true;
                                            }

                                            const nestedClass = isNested ? 'nested-reply' : '';
                                            const avatarClass = isNested ? 'avatar-nested' : 'avatar-normal';
                                            const padding = isNested ? '8px 10px' : '10px 12px';
                                            const nameSize = isNested ? '12px' : '13px';
                                            const txtSize = isNested ? '13px' : '13.5px';

                                            // Lấy ID bình luận mới do Server trả về để gắn vào các thẻ HTML
                                            const rId = result.replyId;

                                            // Vẽ HTML bao gồm cả nội dung, form sửa ẩn và MENU 3 CHẤM
                                            const newReply =
                                                '<div class="reply-item-container d-flex gap-2 mb-3 ' + nestedClass + '" id="reply-box-' + rId + '" style="animation: fadeIn 0.4s;">' +
                                                '<div class="' + avatarClass + '" style="background: #ddd; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-weight: bold; color: #555;">' + avatar + '</div>' +
                                                '<div style="flex: 1; background: #f9f9f9; padding: ' + padding + '; border-radius: 8px; border: 1px solid #e1f5fe; position: relative;">' +

                                                // 1. MENU DẤU 3 CHẤM
                                                '<div class="dropdown" style="position: absolute; right: 5px; top: 5px;">' +
                                                '<button class="btn btn-sm btn-light p-0" type="button" data-bs-toggle="dropdown" style="background: transparent; border: none; color: #888; width: 24px; height: 24px; display: flex; align-items: center; justify-content: center;"><i class="fa-solid fa-ellipsis-vertical"></i></button>' +
                                                '<ul class="dropdown-menu dropdown-menu-end shadow-sm" style="font-size: 13px;">' +
                                                '<li><a class="dropdown-item text-primary" href="javascript:void(0)" onclick="openEditReply(' + rId + ')"><i class="fa-solid fa-pen-to-square me-2"></i> Sửa</a></li>' +
                                                '<li><form class="delete-reply-form" style="margin: 0;"><input type="hidden" name="action" value="deleteReply"><input type="hidden" name="replyId" value="' + rId + '"><button type="submit" class="dropdown-item text-danger"><i class="fa-solid fa-trash-can me-2"></i> Xóa</button></form></li>' +
                                                '</ul>' +
                                                '</div>' +

                                                // 2. KHU VỰC HIỂN THỊ CHỮ
                                                '<div id="reply-display-' + rId + '">' +
                                                '<div style="font-weight: bold; font-size: ' + nameSize + '; color: #2489F4; display: flex; align-items: center; padding-right: 20px;">' + userName + ' <span style="font-weight: normal; color: #999; font-size: 11px; margin-left: 8px;">Vừa xong</span> <a href="javascript:void(0)" onclick="replyToUser(' + discussionId + ', \'' + userName + '\', this)" style="font-size: 11px; color: #2489F4; text-decoration: none; margin-left: 10px; font-weight: normal;"><i class="fa-solid fa-reply"></i> Trả lời</a></div>' +
                                                '<div id="reply-content-text-' + rId + '" style="font-size: ' + txtSize + '; color: #444; margin-top: 5px; line-height: 1.4;">' + formattedContent + '</div>' +
                                                '</div>' +

                                                // 3. FORM SỬA (MẶC ĐỊNH ẨN)
                                                '<div id="reply-edit-form-' + rId + '" style="display: none; margin-top: 5px;">' +
                                                '<form class="edit-reply-form">' +
                                                '<input type="hidden" name="action" value="updateReply"><input type="hidden" name="replyId" value="' + rId + '">' +
                                                '<textarea name="replyContent" class="form-control form-control-sm mb-2" rows="2" required>' + escapedContent + '</textarea>' +
                                                '<div class="text-end"><button type="button" class="btn btn-sm btn-light border py-1 px-2" style="font-size: 12px;" onclick="cancelEditReply(' + rId + ')">Hủy</button> <button type="submit" class="btn btn-sm text-white fw-bold py-1 px-2" style="background-color: #f5a623; font-size: 12px;">Lưu</button></div>' +
                                                '</form>' +
                                                '</div>' +

                                                '</div>' +
                                                '</div>';

                                            form.insertAdjacentHTML('beforebegin', newReply);

                                            let countSpan = document.getElementById('reply-count-txt-' + discussionId);
                                            if (countSpan) countSpan.innerText = parseInt(countSpan.innerText) + 1;

                                            form.reset();
                                            form.removeAttribute('data-tag');
                                            form.removeAttribute('data-hidden-tag');
                                            document.getElementById('reply-list-' + discussionId).appendChild(form);
                                        } else alert(result.message || "Lỗi khi gửi trả lời!"); // [ĐÃ SỬA Ở ĐÂY]
                                    })
                                    .finally(() => {
                                        submitBtn.disabled = false;
                                        submitBtn.innerHTML = '<i class="fa-solid fa-paper-plane me-1"></i>Gửi';
                                    });
                            }

                            // ---------------------------------------------------------
                            // NHÁNH 2: XỬ LÝ FORM XÓA CÂU HỎI
                            // ---------------------------------------------------------
                            else if (form.classList.contains('delete-discussion-form')) {
                                if (!confirm('Bạn có chắc muốn xóa vĩnh viễn câu hỏi này cùng các câu trả lời?')) return;

                                const discussionId = form.querySelector('input[name="discussionId"]').value;
                                const data = new URLSearchParams(new FormData(form));

                                fetch('${pageContext.request.contextPath}/discussion', { method: 'POST', body: data })
                                    .then(res => res.json())
                                    .then(result => {
                                        if (result.success) {
                                            const box = document.getElementById('discussion-box-' + discussionId);
                                            box.style.transition = "all 0.4s"; box.style.opacity = "0"; box.style.transform = "translateX(20px)";
                                            setTimeout(() => box.remove(), 400);
                                        } else alert("Có lỗi xảy ra, không thể xóa!");
                                    });
                            }

                            // ---------------------------------------------------------
                            // NHÁNH 3: XỬ LÝ FORM SỬA (UPDATE) CÂU HỎI
                            // ---------------------------------------------------------
                            else if (form.classList.contains('edit-discussion-form')) {
                                const discussionId = form.querySelector('input[name="discussionId"]').value;
                                const formData = new FormData(form);
                                const submitBtn = form.querySelector('button[type="submit"]');
                                const originalTxt = submitBtn.innerText;

                                submitBtn.innerText = "Đang lưu..."; submitBtn.disabled = true;

                                fetch('${pageContext.request.contextPath}/discussion', {
                                    method: 'POST', body: new URLSearchParams(formData)
                                })
                                    .then(res => res.json())
                                    .then(result => {
                                        if (result.success) {
                                            const displayBox = document.getElementById('discussion-display-' + discussionId);
                                            displayBox.querySelector('.display-title').innerText = formData.get('discussionTitle');
                                            displayBox.querySelector('.display-topic-tag').innerText = formData.get('topicTag');

                                            const isSpoiler = formData.get('hasSpoiler') !== null;
                                            const contentArea = displayBox.querySelector('.display-content-area');
                                            const newContent = formData.get('discussionContent');

                                            if (isSpoiler) {
                                                if (!displayBox.querySelector('.display-spoiler-tag')) {
                                                    displayBox.querySelector('.display-topic-tag').insertAdjacentHTML('afterend', ' <span class="badge bg-danger ms-1 display-spoiler-tag">SPOILER</span>');
                                                }
                                                contentArea.innerHTML = '<div class="spoiler-box" style="background: #ffe6e6; padding: 10px; border-radius: 4px; border: 1px dashed #ff9999; cursor: pointer; text-align: center; color: #C92127; font-weight: bold; font-size: 13px;" onclick="this.nextElementSibling.style.display=\'block\'; this.style.display=\'none\';"><i class="fa-solid fa-eye-slash me-1"></i> Nội dung bị ẩn vì chứa Spoiler. Bấm vào để xem.</div><p class="text-muted display-content" style="font-size: 14px; display: none;">' + newContent + '</p>';
                                            } else {
                                                const spoilerTag = displayBox.querySelector('.display-spoiler-tag');
                                                if (spoilerTag) spoilerTag.remove();
                                                contentArea.innerHTML = '<p class="text-muted display-content" style="font-size: 14px;">' + newContent + '</p>';
                                            }
                                            cancelEditDiscussion(discussionId);
                                        } else alert("Lỗi khi lưu thay đổi!");
                                    })
                                    .finally(() => { submitBtn.innerText = originalTxt; submitBtn.disabled = false; });
                            }// ---------------------------------------------------------
                            // NHÁNH 4: XỬ LÝ XÓA CÂU TRẢ LỜI
                            // ---------------------------------------------------------
                            else if (form.classList.contains('delete-reply-form')) {
                                if (!confirm('Bạn có chắc muốn xóa bình luận này?')) return;
                                const replyId = form.querySelector('input[name="replyId"]').value;
                                fetch('${pageContext.request.contextPath}/discussion', { method: 'POST', body: new URLSearchParams(new FormData(form)) })
                                    .then(res => res.json())
                                    .then(result => {
                                        if (result.success) {
                                            const box = document.getElementById('reply-box-' + replyId);
                                            box.style.transition = "all 0.4s"; box.style.opacity = "0"; box.style.transform = "translateX(20px)";
                                            setTimeout(() => box.remove(), 400);
                                        } else alert("Có lỗi xảy ra!");
                                    });
                            }

                            // ---------------------------------------------------------
                            // NHÁNH 5: XỬ LÝ SỬA CÂU TRẢ LỜI
                            // ---------------------------------------------------------
                            else if (form.classList.contains('edit-reply-form')) {
                                const replyId = form.querySelector('input[name="replyId"]').value;
                                const content = form.querySelector('textarea[name="replyContent"]').value;
                                const submitBtn = form.querySelector('button[type="submit"]');
                                const originalTxt = submitBtn.innerText;
                                submitBtn.innerText = "Lưu..."; submitBtn.disabled = true;

                                fetch('${pageContext.request.contextPath}/discussion', { method: 'POST', body: new URLSearchParams(new FormData(form)) })
                                    .then(res => res.json())
                                    .then(result => {
                                        if (result.success) {
                                            // Update Text hiển thị (Chống XSS cơ bản)
                                            const escapedContent = content.replace(/</g, "&lt;").replace(/>/g, "&gt;");
                                            document.getElementById('reply-content-text-' + replyId).innerHTML = escapedContent;
                                            cancelEditReply(replyId);
                                        } else alert("Lỗi khi lưu thay đổi!");
                                    })
                                    .finally(() => { submitBtn.innerText = originalTxt; submitBtn.disabled = false; });
                            }
                        });

                        // ==========================================
                        // JS: BÁO CÁO VI PHẠM (HỎI ĐÁP)
                        // ==========================================

                        // 1. Hàm bật Modal
                        function openReportModal(type, targetId) {
                            // Gắn dữ liệu vào form ẩn
                            document.getElementById('report_type').value = type;
                            document.getElementById('report_target_id').value = targetId;

                            // Reset form
                            document.getElementById('reportDiscussionForm').reset();
                            document.getElementById('customDiscReasonDiv').style.display = 'none';

                            // Bật Modal bằng Bootstrap API
                            var myModal = new bootstrap.Modal(document.getElementById('reportDiscussionModal'));
                            myModal.show();
                        }

                        // 2. Ẩn/hiện ô nhập lý do Khác
                        document.querySelectorAll('.disc-report-radio').forEach(radio => {
                            radio.addEventListener('change', function () {
                                if (this.value === 'Khác') {
                                    document.getElementById('customDiscReasonDiv').style.display = 'block';
                                    document.getElementById('customDiscReasonInput').required = true;
                                } else {
                                    document.getElementById('customDiscReasonDiv').style.display = 'none';
                                    document.getElementById('customDiscReasonInput').required = false;
                                }
                            });
                        });

                        // 3. Xử lý Gửi Form báo cáo
                        document.getElementById('reportDiscussionForm').addEventListener('submit', function (e) {
                            e.preventDefault();
                            const form = e.target;
                            const data = new URLSearchParams(new FormData(form));

                            // Nếu chọn "Khác" thì gộp lý do
                            if (data.get('reason') === 'Khác') {
                                data.set('reason', data.get('customReason'));
                            }

                            const submitBtn = form.querySelector('button[type="submit"]');
                            submitBtn.innerText = "Đang gửi..."; submitBtn.disabled = true;

                            fetch('${pageContext.request.contextPath}/discussion', {
                                method: 'POST', body: data
                            })
                                .then(res => res.json())
                                .then(result => {
                                    if (result.success) {
                                        alert("Cảm ơn bạn! Báo cáo đã được gửi tới Quản trị viên.");
                                        bootstrap.Modal.getInstance(document.getElementById('reportDiscussionModal')).hide();
                                    } else {
                                        alert("Có lỗi xảy ra, vui lòng thử lại sau.");
                                    }
                                })
                                .finally(() => {
                                    submitBtn.innerText = "Gửi Báo Cáo";
                                    submitBtn.disabled = false;
                                });
                        });

                        // =========================================================
                        // JS: TỰ ĐỘNG CUỘN ĐẾN BÌNH LUẬN KHI BẤM TỪ THÔNG BÁO TỚI
                        // =========================================================
                        window.addEventListener('load', function () {
                            const hash = window.location.hash; // Lấy phần #... trên URL

                            if (hash && hash.startsWith('#reply-box-')) {
                                const targetEl = document.querySelector(hash);

                                if (targetEl) {
                                    // 1. Tìm cái thẻ div cha đang chứa câu trả lời này (mặc định nó đang bị display: none)
                                    const parentSection = targetEl.closest('[id^="replies-section-"]');

                                    // 2. Mở khóa ẩn, cho nó hiện ra
                                    if (parentSection) {
                                        parentSection.style.display = 'block';
                                    }

                                    // 3. Cuộn mượt mà đến giữa màn hình và tạo hiệu ứng nhấp nháy
                                    setTimeout(() => {
                                        targetEl.scrollIntoView({ behavior: 'smooth', block: 'center' });

                                        // Thêm class bôi vàng 
                                        const innerBox = targetEl.querySelector('div[style*="flex: 1"]'); // Lấy cái hộp nội dung bên trong
                                        if (innerBox) {
                                            innerBox.classList.add('highlight-target');
                                        } else {
                                            targetEl.classList.add('highlight-target');
                                        }
                                    }, 300); // Đợi 300ms cho DOM render xong
                                }
                            }
                        });
                        // =================================================================
                        // 1. CẤU HÌNH API GHN (Hệ thống thật)
                        // =================================================================
                        const GHN_TOKEN = '79a7c86a-1ef8-11f1-a3ea-4e2619480a9f';
                        const GHN_SHOP_ID = 6322897;
                        const SHOP_DISTRICT_ID = 3440;
                        const GHN_URL = 'https://online-gateway.ghn.vn/shiip/public-api/master-data';

                        let isProvinceLoaded = false;

                        // =================================================================
                        // 2. HÀM MỞ & ĐÓNG MODAL CỦA BẠN
                        // =================================================================
                        function openAddressModal() {
                            // Hiển thị modal
                            document.getElementById('addressModalOverlay').style.display = 'flex'; // Hoặc 'block' tùy CSS của bạn

                            // Gọi API tải Tỉnh/Thành phố (Chỉ gọi 1 lần để đỡ lag)
                            if (!isProvinceLoaded) {
                                loadGHNProvinces();
                                isProvinceLoaded = true;
                            }
                        }

                        function closeAddressModal() {
                            document.getElementById('addressModalOverlay').style.display = 'none';
                        }

                        // =================================================================
                        // 3. XỬ LÝ SỰ KIỆN KHI BẤM "XÁC NHẬN"
                        // =================================================================
                        function confirmAddress() {
                            // Xem người dùng đang chọn Radio button nào
                            let addressType = document.querySelector('input[name="address_type"]:checked').value;

                            let toDistrictId = null;
                            let toWardCode = null;
                            let displayText = "";

                            if (addressType === 'existing') {
                                // NẾU CHỌN ĐỊA CHỈ CÓ SẴN (Phường Bến Nghé, Quận 1, HCM)
                                // Đây là mã cứng của GHN cho Quận 1 - P.Bến Nghé
                                toDistrictId = 1442;
                                toWardCode = "20101";
                                displayText = "Phường Bến Nghé, Quận 1, Hồ Chí Minh";
                            } else {
                                // NẾU CHỌN ĐỊA CHỈ MỚI TỪ DROPDOWN
                                toDistrictId = $('#districtSelect').find(':selected').data('id');
                                toWardCode = $('#wardSelect').find(':selected').data('code');

                                let cityName = $('#provinceSelect').val();
                                let districtName = $('#districtSelect').val();
                                let wardName = $('#wardSelect').val();

                                if (!toDistrictId || !toWardCode) {
                                    alert("Vui lòng chọn đầy đủ Tỉnh/Huyện/Xã!");
                                    return;
                                }
                                displayText = wardName + ", " + districtName + ", " + cityName;
                            }

                            // Đóng Modal
                            closeAddressModal();

                            // Thay đổi text hiển thị trên giao diện chi tiết SP
                            document.getElementById('displayAddressText').innerText = displayText;

                            // Đổi hiển thị phí ship thành Loading...
                            document.getElementById('displayShippingFee').innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i>';
                            document.getElementById('expectedDeliveryText').innerHTML = 'Dự kiến giao: <strong>Đang tính toán...</strong>';

                            // Gọi API tính tiền và ngày giao
                            calculateQuickShippingGHN(toDistrictId, toWardCode);
                        }

                        // =================================================================
                        // 4. API TẢI TỈNH / HUYỆN / XÃ VÀO DROPDOWN
                        // =================================================================
                        $(document).ready(function () {
                            const $city = $("#provinceSelect");
                            const $district = $("#districtSelect");
                            const $ward = $("#wardSelect");

                            // Lắng nghe sự thay đổi TỈNH -> Tải HUYỆN
                            $city.change(function () {
                                let provinceId = $(this).find(':selected').data('id');
                                $district.html('<option value="" selected disabled>Đang tải dữ liệu...</option>');
                                $ward.html('<option value="" selected disabled>Chọn phường/xã</option>');

                                if (provinceId) {
                                    fetch(GHN_URL + '/district?province_id=' + provinceId, { headers: { 'token': GHN_TOKEN } })
                                        .then(res => res.json())
                                        .then(data => {
                                            if (data.code === 200 && data.data) {
                                                let options = '<option value="" selected disabled>Chọn quận/huyện</option>';
                                                data.data.forEach(item => {
                                                    options += '<option value="' + item.DistrictName + '" data-id="' + item.DistrictID + '">' + item.DistrictName + '</option>';
                                                });
                                                $district.html(options);
                                            }
                                        });
                                }
                            });

                            // Lắng nghe sự thay đổi HUYỆN -> Tải XÃ
                            $district.change(function () {
                                let districtId = $(this).find(':selected').data('id');
                                $ward.html('<option value="" selected disabled>Đang tải dữ liệu...</option>');

                                if (districtId) {
                                    fetch(GHN_URL + '/ward?district_id=' + districtId, { headers: { 'token': GHN_TOKEN } })
                                        .then(res => res.json())
                                        .then(data => {
                                            if (data.code === 200 && data.data) {
                                                let options = '<option value="" selected disabled>Chọn phường/xã</option>';
                                                data.data.forEach(item => {
                                                    options += '<option value="' + item.WardName + '" data-code="' + item.WardCode + '">' + item.WardName + '</option>';
                                                });
                                                $ward.html(options);
                                            }
                                        });
                                }
                            });
                        });

                        function loadGHNProvinces() {
                            fetch(GHN_URL + '/province', { headers: { 'token': GHN_TOKEN } })
                                .then(res => res.json())
                                .then(data => {
                                    if (data.code === 200 && data.data) {
                                        let options = '<option value="" selected disabled>Chọn tỉnh/thành phố</option>';
                                        data.data.forEach(item => {
                                            options += '<option value="' + item.ProvinceName + '" data-id="' + item.ProvinceID + '">' + item.ProvinceName + '</option>';
                                        });
                                        $("#provinceSelect").html(options);
                                    }
                                })
                                .catch(err => console.error("Lỗi API Tỉnh GHN:", err));
                        }

                        // =================================================================
                        // 5. HÀM TÍNH TOÁN PHÍ SHIP VÀ THỜI GIAN ĐỘC LẬP
                        // =================================================================
                        async function calculateQuickShippingGHN(toDistrictId, toWardCode) {
                            try {
                                // GỌI LẤY PHÍ SHIP
                                const feeRes = await fetch('https://online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/fee', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/json', 'token': GHN_TOKEN },
                                    body: JSON.stringify({
                                        "service_type_id": 2,
                                        "from_district_id": SHOP_DISTRICT_ID,
                                        "to_district_id": parseInt(toDistrictId),
                                        "to_ward_code": String(toWardCode),
                                        "weight": 500, // Khối lượng quyển sách (500g)
                                        "length": 20, "width": 15, "height": 10
                                    })
                                });
                                const feeData = await feeRes.json();
                                if (feeData.code === 200) {
                                    const feeFormatted = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(feeData.data.total);
                                    document.getElementById('displayShippingFee').innerText = feeFormatted;
                                }

                                // GỌI API LẤY THỜI GIAN GIAO HÀNG
                                const timeRes = await fetch('https://online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/leadtime', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/json', 'token': GHN_TOKEN, 'ShopId': String(GHN_SHOP_ID) },
                                    body: JSON.stringify({
                                        "from_district_id": SHOP_DISTRICT_ID,
                                        "to_district_id": parseInt(toDistrictId),
                                        "to_ward_code": String(toWardCode),
                                        "service_type_id": 2 // <--- THÊM DÒNG NÀY ĐỂ GHN BIẾT LÀ GIAO TIÊU CHUẨN
                                    })
                                });
                                const timeData = await timeRes.json();

                                if (timeData.code === 200) {
                                    let leadTimeUnix = timeData.data.leadtime;

                                    // CODE BẢO HIỂM: Nếu GHN lỗi trả về 0 hoặc null, tự động cộng 3 ngày từ hôm nay
                                    if (!leadTimeUnix || leadTimeUnix === 0) {
                                        leadTimeUnix = Math.floor(Date.now() / 1000) + (3 * 24 * 60 * 60);
                                    }

                                    const dateObj = new Date(leadTimeUnix * 1000);
                                    const days = ['Chủ nhật', 'Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm', 'Thứ sáu', 'Thứ bảy'];
                                    const dayName = days[dateObj.getDay()];
                                    const dateString = String(dateObj.getDate()).padStart(2, '0') + '/' + String(dateObj.getMonth() + 1).padStart(2, '0');

                                    document.getElementById('expectedDeliveryText').innerHTML = "Dự kiến giao: <strong>" + dayName + " - " + dateString + "</strong>";
                                }

                            } catch (error) {
                                console.error("Lỗi Fetch Detail:", error);
                                document.getElementById('displayShippingFee').innerText = "Không tính được phí";
                            }
                        }
                    </script>
                </body>

                </html>