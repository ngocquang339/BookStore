<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi - BookStore</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        /* CSS DÀNH RIÊNG CHO TRANG QUẢN LÝ ĐƠN HÀNG */
        .orders-wrapper {
            background-color: transparent; /* Bỏ background trắng tổng để các phần tử rời nhau */
        }

        /* 1. Phần Tab trạng thái */
        .order-tabs-container {
            background-color: #fff;
            border-radius: 8px;
            padding: 15px 10px 0 10px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        .order-tabs-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
            padding-left: 10px;
        }
        .order-tabs {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #eee;
            margin: 0;
            padding: 0;
            list-style: none;
        }
        .tab-item {
            flex: 1;
            text-align: center;
            text-decoration: none;
            color: #555;
            padding-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .tab-item:hover {
            color: #C92127;
        }
        .tab-item.active {
            color: #C92127;
            border-bottom: 2px solid #C92127;
            font-weight: 500;
        }
        .tab-item .count {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 2px;
        }
        .tab-item .label {
            font-size: 13px;
        }

        /* 2. Phần Thẻ Đơn hàng (Order Card) */
        .order-card {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 15px;
            margin-bottom: 15px;
        }
        .order-id {
            color: #2f80ed;
            font-weight: 500;
            text-decoration: none;
            font-size: 15px;
        }
        .order-id:hover { text-decoration: underline; }
        
        /* Badges trạng thái */
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
            margin-left: 10px;
        }
        .status-cancelled { background-color: #ffe5e5; color: #dc3545; }
        .status-success { background-color: #e6f8ec; color: #28a745; }
        .status-pending { background-color: #fff3cd; color: #ffc107; }

        .order-date { font-size: 13px; color: #777; }

        /* Thông tin sản phẩm */
        .order-product { display: flex; gap: 15px; }
        .order-product img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border: 1px solid #eee;
            border-radius: 4px;
        }
        .order-product-name {
            font-size: 14px;
            color: #333;
            margin-bottom: 5px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        /* Footer thẻ đơn hàng */
        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-top: 15px;
        }
        .total-items-text { font-size: 14px; color: #777; }
        .order-total-price { font-size: 15px; color: #333; margin-bottom: 15px; text-align: right;}
        .order-total-price strong { font-size: 18px; color: #333; }
        
        .order-actions button {
            padding: 8px 20px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            margin-left: 10px;
        }
        .btn-cancel-disabled {
            background-color: #fff;
            border: 1px solid #ccc;
            color: #999;
            cursor: not-allowed;
        }
        .btn-buy-again {
            background-color: #C92127;
            border: 1px solid #C92127;
            color: #fff;
            transition: 0.3s;
        }
        .btn-buy-again:hover { background-color: #a81b20; color: #fff; }
    </style>
</head>

<body>
    
    <jsp:include page="component/header.jsp" />

    <div class="container profile-container py-4">
        <div class="row">
            
            <div class="col-md-3">
                <jsp:include page="component/sidebar.jsp" />
            </div>

            <div class="col-md-9">
                <div class="orders-wrapper">
                    
                    <div class="order-tabs-container">
                        <div class="order-tabs-title">Đơn hàng của tôi</div>
                        <ul class="order-tabs">
                            <a href="?status=all" class="tab-item ${currentStatus == 'all' ? 'active' : ''}">
                                <div class="count">${countAll != null ? countAll : 0}</div> 
                                <div class="label">Tất cả</div>
                            </a>
                            <a href="?status=processing" class="tab-item ${currentStatus == 'processing' ? 'active' : ''}">
                                <div class="count">${countProcessing != null ? countProcessing : 0}</div>
                                <div class="label">Đang xử lý</div>
                            </a>
                            <a href="?status=shipping" class="tab-item ${currentStatus == 'shipping' ? 'active' : ''}">
                                <div class="count">${countShipping != null ? countShipping : 0}</div>
                                <div class="label">Đang giao</div>
                            </a>
                            <a href="?status=completed" class="tab-item ${currentStatus == 'completed' ? 'active' : ''}">
                                <div class="count">${countCompleted != null ? countCompleted : 0}</div>
                                <div class="label">Hoàn tất</div>
                            </a>
                            <a href="?status=cancelled" class="tab-item ${currentStatus == 'cancelled' ? 'active' : ''}">
                                <div class="count">${countCancelled != null ? countCancelled : 0}</div>
                                <div class="label">Bị hủy</div>
                            </a>
                        </ul>
                    </div>

                    <c:choose>
                        <%-- TRƯỜNG HỢP 1: KHÔNG CÓ ĐƠN HÀNG NÀO --%>
                        <c:when test="${empty listOrders}">
                            <div class="order-card text-center py-5">
                                <i class="fa-solid fa-receipt mb-3" style="font-size: 50px; color: #ccc;"></i>
                                <div style="font-size: 16px; color: #777;">Chưa có đơn hàng nào</div>
                            </div>
                        </c:when>

                        <%-- TRƯỜNG HỢP 2: CÓ ĐƠN HÀNG -> VÒNG LẶP --%>
                        <c:otherwise>
                            <c:forEach var="order" items="${listOrders}">
                                <div class="order-card">
                                    
                                    <div class="order-header">
                                        <div>
                                            <a href="#" class="order-id">#${order.id}</a>
                                            
                                            <%-- XỬ LÝ BADGE TRẠNG THÁI DỰA VÀO SỐ TRONG DB --%>
                                            <c:choose>
                                                <c:when test="${order.status == 0}">
                                                    <span class="status-badge status-cancelled">Bị hủy</span>
                                                </c:when>
                                                <c:when test="${order.status == 1}">
                                                    <span class="status-badge status-pending" style="background-color: #fff3cd; color: #856404;">Chờ thanh toán</span>
                                                </c:when>
                                                <c:when test="${order.status == 2}">
                                                    <span class="status-badge status-pending" style="background-color: #cce5ff; color: #004085;">Đang xử lý</span>
                                                </c:when>
                                                <c:when test="${order.status == 3}">
                                                    <span class="status-badge status-pending" style="background-color: #d1ecf1; color: #0c5460;">Đang giao</span>
                                                </c:when>
                                                <c:when test="${order.status == 4}">
                                                    <span class="status-badge status-success">Hoàn tất</span>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                        <div class="order-date">
                                            <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy - HH:mm" />
                                        </div>
                                    </div>

                                    <c:set var="totalItemsCount" value="0" />
                                    
                                    <c:forEach var="item" items="${order.details}">
                                        <c:set var="totalItemsCount" value="${totalItemsCount + item.quantity}" />
                                        
                                        <div class="order-product mt-3 pb-3 border-bottom" style="border-color: #f9f9f9 !important;">
                                            <img src="${pageContext.request.contextPath}/${item.book.imageUrl}" 
                                                 alt="${item.book.title}" 
                                                 onerror="this.src='https://placehold.co/80x80?text=No+Image'">
                                            <div class="d-flex justify-content-between w-100">
                                                <div style="padding-right: 15px;">
                                                    <div class="order-product-name">${item.book.title}</div>
                                                    <div class="text-muted" style="font-size: 13px;">Số lượng: x${item.quantity}</div>
                                                </div>
                                                <div class="text-end" style="min-width: 90px;">
                                                    <span style="font-weight: 500; color: #333;">
                                                        <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫"/>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <div class="order-footer mt-3">
                                        <div class="total-items-text">${totalItemsCount} sản phẩm</div>
                                        <div class="text-end">
                                            <div class="order-total-price" style="display: flex; flex-direction: column; align-items: flex-end; gap: 4px;">
                                                <c:choose>
                                                    <%-- TRƯỜNG HỢP 1: CÓ ÁP DỤNG VOUCHER --%>
                                                    <c:when test="${order.discountAmount > 0}">
                                                        <div style="font-size: 14px; color: #777;">
                                                            Tổng tiền hàng: 
                                                            <span style="color: #333; margin-left: 8px;">
                                                                <fmt:formatNumber value="${order.totalAmount + order.discountAmount}" type="currency" currencySymbol="₫"/>
                                                            </span>
                                                        </div>
                                                        <div style="font-size: 14px; color: #777;">
                                                            Voucher giảm giá: 
                                                            <span style="color: #28a745; font-weight: bold; margin-left: 8px;">
                                                                - <fmt:formatNumber value="${order.discountAmount}" type="currency" currencySymbol="₫"/>
                                                            </span>
                                                        </div>
                                                        <div style="margin-top: 4px; font-size: 15px;">
                                                            Thành tiền: 
                                                            <strong style="color: #C92127; font-size: 18px; margin-left: 8px;">
                                                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                                                            </strong>
                                                        </div>
                                                    </c:when>
                                                    
                                                    <%-- TRƯỜNG HỢP 2: KHÔNG CÓ VOUCHER (Giữ nguyên như cũ) --%>
                                                    <c:otherwise>
                                                        <div style="font-size: 15px;">
                                                            Tổng tiền: 
                                                            <strong style="color: #C92127; font-size: 18px; margin-left: 8px;">
                                                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                                                            </strong>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            
                                            <div class="order-actions text-end mt-3" style="display: flex; justify-content: flex-end; gap: 10px;">

                                                <div id="repurchase-data-${order.id}" style="display:none;">
                                                    <c:forEach var="item" items="${order.details}">
                                                        <input type="hidden" class="repurchase-book" data-id="${item.book.id}" data-qty="${item.quantity}">
                                                    </c:forEach>
                                                </div>

                                                <c:choose>
                                                    <%-- TRƯỜNG HỢP 1: ĐƠN ĐANG CHỜ / ĐANG XỬ LÝ -> CHO PHÉP HỦY --%>
                                                    <c:when test="${order.status == 1 || order.status == 2}">
                                                        <form action="${pageContext.request.contextPath}/my-orders" method="POST" style="margin: 0;">
                                                            <input type="hidden" name="action" value="cancel">
                                                            <input type="hidden" name="orderId" value="${order.id}">
                                                            <button type="submit" class="btn btn-outline-danger" style="padding: 8px 20px; font-size: 14px;" onclick="return confirm('Bạn chắc chắn muốn hủy đơn hàng này?');">Hủy đơn</button>
                                                        </form>
                                                        <!-- <button type="button" class="btn btn-buy-again" style="padding: 8px 20px; font-size: 14px; background: #C92127; color: white; border: none;" onclick="repurchaseOrder(${order.id})">Mua lại</button> -->
                                                    </c:when>

                                                    <%-- TRƯỜNG HỢP 2: ĐƠN ĐÃ GIAO (Hoàn tất) -> CHO PHÉP TRẢ HÀNG & MUA LẠI --%>
                                                    <c:when test="${order.status == 5}">
                                                        <button type="button" class="btn btn-outline-warning" 
                                                                style="padding: 8px 20px; font-size: 14px; border-color: #f39c12; color: #e67e22;"
                                                                data-bs-toggle="modal" data-bs-target="#returnOrderModal" onclick="openReturnModal(${order.id})">
                                                            Trả hàng / Hoàn tiền
                                                        </button>
                                                        <button type="button" class="btn btn-buy-again" style="padding: 8px 20px; font-size: 14px; background: #C92127; color: white; border: none;" onclick="repurchaseOrder(${order.id})">Mua lại</button>
                                                    </c:when>
                                                    <c:when test="${order.status == 4}">
                                                        <form action="${pageContext.request.contextPath}/my-orders" method="POST" style="margin: 0;">
                                                            <input type="hidden" name="action" value="confirm_receive">
                                                            <input type="hidden" name="orderId" value="${order.id}">
                                                            <button type="submit" class="btn btn-outline-success" 
                                                                    style="padding: 8px 20px; font-size: 14px; border-color: #28a745; color: #28a745;" 
                                                                    onclick="return confirm('Xác nhận bạn đã nhận được đơn hàng này?');">
                                                                Đã nhận hàng
                                                            </button>
                                                        </form>
                                                        
                                                        <button type="button" class="btn btn-buy-again" style="padding: 8px 20px; font-size: 14px; background: #C92127; color: white; border: none;" onclick="repurchaseOrder(${order.id})">Mua lại</button>
                                                    </c:when>
                                                    <%-- TRƯỜNG HỢP 3: CÁC TRẠNG THÁI CÒN LẠI -> CHỈ CHO MUA LẠI --%>
                                                    <c:otherwise>
                                                        <button type="button" class="btn btn-buy-again" style="padding: 8px 20px; font-size: 14px; background: #C92127; color: white; border: none;" onclick="repurchaseOrder(${order.id})">Mua lại</button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    
                    </div> 
            </div> 
        </div> 
    </div> 

    <div class="modal fade" id="returnOrderModal" tabindex="-1" aria-labelledby="returnOrderModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border-radius: 10px;">
      
      <div class="modal-header border-bottom-0 pb-0 mt-2">
        <h5 class="modal-title fw-bold" style="color: #e67e22;" id="returnOrderModalLabel">
            <i class="fa-solid fa-box-open me-2"></i> YÊU CẦU TRẢ HÀNG / HOÀN TIỀN
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <form action="${pageContext.request.contextPath}/staff/tickets" method="POST">
        <div class="modal-body px-4">
          
          <input type="hidden" name="orderId" id="modal_returnOrderId" value="">

          <p class="fw-bold text-dark mb-3">Vui lòng chọn lý do trả hàng: <span class="text-danger">*</span></p>

          <div class="form-check mb-2">
            <input class="form-check-input" type="radio" name="returnReason" id="reason1" value="Sản phẩm bị lỗi, trầy xước hoặc hư hỏng" required style="cursor: pointer;">
            <label class="form-check-label" for="reason1" style="cursor: pointer;">Sản phẩm bị lỗi, trầy xước hoặc hư hỏng</label>
          </div>
          
          <div class="form-check mb-2">
            <input class="form-check-input" type="radio" name="returnReason" id="reason2" value="Giao sai sản phẩm (sai tựa sách, sai tập...)" style="cursor: pointer;">
            <label class="form-check-label" for="reason2" style="cursor: pointer;">Giao sai sản phẩm (sai tựa sách, sai tập...)</label>
          </div>
          
          <div class="form-check mb-2">
            <input class="form-check-input" type="radio" name="returnReason" id="reason3" value="Sản phẩm không giống với mô tả" style="cursor: pointer;">
            <label class="form-check-label" for="reason3" style="cursor: pointer;">Sản phẩm không giống với mô tả</label>
          </div>
          
          <div class="form-check mb-2">
            <input class="form-check-input" type="radio" name="returnReason" id="reason4" value="Thiếu phụ kiện, quà tặng kèm" style="cursor: pointer;">
            <label class="form-check-label" for="reason4" style="cursor: pointer;">Thiếu phụ kiện, quà tặng kèm</label>
          </div>
          
          <div class="form-check mb-3">
            <input class="form-check-input" type="radio" name="returnReason" id="reason5" value="Lý do khác" style="cursor: pointer;">
            <label class="form-check-label" for="reason5" style="cursor: pointer;">Lý do khác</label>
          </div>

          <div class="mb-2 mt-3">
              <label for="returnNote" class="form-label text-muted small fw-bold">Chi tiết thêm (Bắt buộc/Tùy chọn):</label>
              <textarea class="form-control bg-light" id="returnNote" name="returnNote" rows="3" placeholder="Vui lòng cung cấp thêm chi tiết về tình trạng sản phẩm để shop hỗ trợ nhanh nhất..."></textarea>
          </div>

        </div>
        
        <div class="modal-footer border-top-0 pt-0 pb-4 px-4 d-flex justify-content-end gap-2">
          <button type="button" class="btn btn-light" data-bs-dismiss="modal" style="border: 1px solid #ccc; font-weight: 500;">Hủy bỏ</button>
          <button type="submit" class="btn text-white fw-bold" style="background-color: #e67e22;">Gửi Yêu Cầu</button>
        </div>
      </form>
      
    </div>
  </div>
</div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Hàm này được gọi khi khách bấm nút "Trả hàng / Hoàn tiền" ở từng đơn hàng
        function openReturnModal(orderId) {
            // Tìm cái thẻ input ẩn trong Modal và gán ID đơn hàng vào đó
            document.getElementById('modal_returnOrderId').value = orderId;
        }

        // Hàm Mua Lại (Chạy bất đồng bộ - Async)
async function repurchaseOrder(orderId) {
    // 1. Tìm cái kho dữ liệu ngầm của đơn hàng này
    let items = document.querySelectorAll('#repurchase-data-' + orderId + ' .repurchase-book');
    
    if(items.length === 0) return;

    // 2. Chạy vòng lặp lấy từng cuốn sách ném vào giỏ hàng
    for (let item of items) {
        let bookId = item.getAttribute('data-id');
        let qty = item.getAttribute('data-qty');
        
        // Gọi API AddToCart bằng lệnh ajax ngầm (Giống hệt nút Thêm vào giỏ)
        let url = "${pageContext.request.contextPath}/add-to-cart?id=" + bookId + "&quantity=" + qty + "&ajax=true";
        
        // Lệnh await giúp máy tính đợi thêm xong cuốn này mới thêm cuốn tiếp theo
        await fetch(url);
    }

    // 3. Sau khi thêm TẤT CẢ sách xong xuôi -> Nhảy thẳng sang trang Giỏ hàng
    window.location.href = '${pageContext.request.contextPath}/cart';
}
    </script>
</body>
</html>