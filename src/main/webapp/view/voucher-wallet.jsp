<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Ví Voucher của tôi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/voucher.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css"> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>

<style>
        /* Hiệu ứng xám xịt cho Voucher đã dùng / hết hạn */
        .disabled-voucher {
            opacity: 0.6;
            filter: grayscale(100%); /* Biến toàn bộ màu mè thành trắng đen */
        }
        .btn-disabled {
            background: #ccc !important;
            color: #666 !important;
            cursor: not-allowed !important;
            border: none !important;
        }
    </style>
<body>
    <jsp:include page="component/header.jsp" />

    <div class="container user-profile-layout">
        
        <div class="sidebar" style="width: 250px; flex-shrink: 0; background: #fff; padding: 15px; border-radius: 8px;">
            <jsp:include page="component/sidebar.jsp" />
        </div>

        <div class="main-content">
            <h2 class="wallet-title">Ví voucher</h2>
            
            <div class="voucher-tabs">
                <div class="tab active">Voucher của tôi</div>
            </div>

            <div class="voucher-grid">
                <c:choose>
                    <c:when test="${empty wallet}">
                        <div class="empty-wallet">Ví của bạn hiện chưa có mã giảm giá nào.</div>
                    </c:when>
                    <c:otherwise>
                        <%-- Lấy thời gian hiện tại của hệ thống để so sánh Hạn sử dụng --%>
                        <jsp:useBean id="now" class="java.util.Date"/>

                        <c:forEach items="${wallet}" var="uv">
                            
                            <%-- BIẾN KIỂM TRA TRẠNG THÁI --%>
                            <c:set var="isExpired" value="${uv.voucher.endDate.time lt now.time}" />
                            <c:set var="isDisabled" value="${uv.used or isExpired}" />

                            <%-- NẾU BỊ DISABLE THÌ GẮN THÊM CLASS 'disabled-voucher' --%>
                            <div class="voucher-card ${isDisabled ? 'disabled-voucher' : ''}">
                                <div class="voucher-left">
                                    <div class="ticket-icon">🎟️</div>
                                </div>
                                
                                <div class="voucher-right">
                                    <div class="v-header">
                                        <div class="v-title">
                                            <c:choose>
                                                <c:when test="${uv.voucher.discountPercent > 0}">
                                                    Mã Giảm ${uv.voucher.discountPercent}%
                                                </c:when>
                                                <c:otherwise>
                                                    Mã Giảm <fmt:formatNumber value="${uv.voucher.discountAmount}" type="number" pattern="#,###"/>đ
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <div class="v-condition">
                                        Đơn hàng từ <fmt:formatNumber value="${uv.voucher.minOrderValue}" type="number" pattern="#,###"/>đ
                                    </div>
                                    
                                    <div class="v-code-box">
                                        <span class="v-code" id="code_${uv.voucher.code}">${uv.voucher.code}</span>
                                    </div>
                                    
                                    <div class="v-footer">
                                        <div class="v-date">HSD: <fmt:formatDate value="${uv.voucher.endDate}" pattern="dd/MM/yyyy"/></div>

                                        <a href="javascript:void(0)" class="text-primary mt-1 d-inline-block" style="font-size: 13px; text-decoration: none;" 
                                        onclick="showVoucherDetails('${uv.voucher.code}', ${uv.voucher.discountPercent}, ${uv.voucher.discountAmount}, ${uv.voucher.minOrderValue}, '<fmt:formatDate value="${uv.voucher.endDate}" pattern="dd/MM/yyyy HH:mm"/>')">
                                        Chi tiết điều khoản
                                        </a>
                                        
                                        <%-- ĐỔI NÚT DỰA VÀO TRẠNG THÁI --%>
                                        <c:choose>
                                            <c:when test="${uv.used}">
                                                <button class="btn-copy btn-disabled" disabled>Đã dùng</button>
                                            </c:when>
                                            <c:when test="${isExpired}">
                                                <button class="btn-copy btn-disabled" disabled>Hết hạn</button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn-copy" onclick="copyCode('${uv.voucher.code}')">Copy mã</button>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <jsp:include page="component/footer.jsp" />
    <div class="modal fade" id="voucherDetailModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-ticket me-2"></i>Điều khoản Voucher</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <h4 id="modalVoucherTitle" class="text-danger fw-bold text-center mb-3"></h4>
                    <ul class="list-group list-group-flush" style="font-size: 15px;">
                        <li class="list-group-item px-0"><strong>Mã Code:</strong> <span id="modalVoucherCode" class="text-primary fw-bold"></span></li>
                        <li class="list-group-item px-0"><strong>Điều kiện:</strong> Áp dụng cho đơn hàng có giá trị từ <span id="modalMinOrder" class="text-danger fw-bold"></span>đ trở lên.</li>
                        <li class="list-group-item px-0"><strong>Hạn sử dụng:</strong> <span id="modalEndDate"></span></li>
                        <li class="list-group-item px-0"><strong>Áp dụng:</strong> Toàn bộ sản phẩm sách trên BookStore. Mỗi tài khoản chỉ được sử dụng 1 lần. Không áp dụng cùng lúc với các chương trình khuyến mãi khác (ngoại trừ F-Point).</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1055;">
        <div id="copyToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body fw-bold">
                    <i class="fa-solid fa-circle-check me-2"></i> Đã sao chép mã: <span id="toastCode"></span>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Hàm Copy Code (Sử dụng Bootstrap Toast)
        function copyCode(code) {
            navigator.clipboard.writeText(code).then(() => {
                // Nhét mã code vào cái Toast
                document.getElementById('toastCode').innerText = code;
                // Gọi Toast lên
                var toastEl = document.getElementById('copyToast');
                var toast = new bootstrap.Toast(toastEl, { delay: 2000 }); // Hiện 2 giây rồi tự tắt
                toast.show();
            }).catch(err => {
                console.error("Lỗi copy: ", err);
            });
        }

        // Hàm mở Modal Chi tiết (Truyền dữ liệu vào Popup rồi bật nó lên)
        function showVoucherDetails(code, discountPercent, discountAmount, minOrder, endDate) {
            document.getElementById('modalVoucherCode').innerText = code;
            
            // Xử lý in chữ tiêu đề cho đẹp:
            let titleText = "";
            if (discountPercent > 0) {
                titleText = "Giảm " + discountPercent + "%";
            } else {
                // Format số tiền thành dạng 100.000đ
                titleText = "Giảm " + Number(discountAmount).toLocaleString('vi-VN') + "đ";
            }
            document.getElementById('modalVoucherTitle').innerText = titleText;
            
            // Format tiền đơn tối thiểu
            document.getElementById('modalMinOrder').innerText = Number(minOrder).toLocaleString('vi-VN');
            document.getElementById('modalEndDate').innerText = endDate;
            
            // Gọi Modal lên
            var modal = new bootstrap.Modal(document.getElementById('voucherDetailModal'));
            modal.show();
        }
    </script>
</body>
</html>