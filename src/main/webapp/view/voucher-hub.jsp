<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kho Mã Giảm Giá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .hub-banner {
            background: linear-gradient(to right, #ff416c, #ff4b2b);
            color: white;
            padding: 40px 0;
            text-align: center;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        .v-card {
            border: 1px dashed #ff4b2b;
            border-radius: 8px;
            padding: 15px;
            background: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            transition: transform 0.2s;
        }
        .v-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(255, 75, 43, 0.2);
        }
    </style>
</head>
<body>
    <jsp:include page="component/header.jsp" />

    <div class="container mt-4">
        <div class="hub-banner">
            <h1>🎉 TRUNG TÂM MÃ GIẢM GIÁ 🎉</h1>
            <p>Lưu ngay kẻo lỡ - Mua sắm thả ga không lo về giá</p>
        </div>

        <div class="row">
            <c:forEach items="${listVouchers}" var="v">
                <div class="col-md-4 col-sm-6 mb-4">
                    <div class="v-card text-center">
                        <h4 class="text-danger fw-bold">
                            <c:choose>
                                <c:when test="${v.discountPercent > 0}">Giảm ${v.discountPercent}%</c:when>
                                <c:otherwise>Giảm <fmt:formatNumber value="${v.discountAmount}" type="number" pattern="#,###"/>đ</c:otherwise>
                            </c:choose>
                        </h4>
                        <p class="text-muted mb-2">Đơn tối thiểu <fmt:formatNumber value="${v.minOrderValue}" type="number" pattern="#,###"/>đ</p>
                        <p class="small text-primary mb-3">HSD: <fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy"/></p>
                        <%-- [THÊM MỚI]: Nút Chi tiết điều khoản --%>
                        <a href="javascript:void(0)" class="text-primary mb-3 d-inline-block" style="font-size: 13px; text-decoration: none; font-weight: 500;" 
                           onclick="showVoucherDetails('${v.code}', ${v.discountPercent}, ${v.discountAmount}, ${v.minOrderValue}, '<fmt:formatDate value="${v.endDate}" pattern="dd/MM/yyyy HH:mm"/>')">
                           Chi tiết điều khoản
                        </a>
                        <button class="btn btn-danger w-100 fw-bold" onclick="saveVoucher('${v.id}')">
                            LƯU MÃ NGAY
                        </button>
                    </div>
                </div>
            </c:forEach>
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
                <div class="modal-body p-4 text-start">
                    <h4 id="modalVoucherTitle" class="text-danger fw-bold text-center mb-3"></h4>
                    <ul class="list-group list-group-flush" style="font-size: 15px;">
                        <li class="list-group-item px-0"><strong>Mã Code:</strong> <span id="modalVoucherCode" class="text-primary fw-bold"></span></li>
                        <li class="list-group-item px-0"><strong>Điều kiện:</strong> Áp dụng cho đơn hàng có giá trị từ <span id="modalMinOrder" class="text-danger fw-bold"></span>đ trở lên.</li>
                        <li class="list-group-item px-0"><strong>Hạn sử dụng:</strong> <span id="modalEndDate"></span></li>
                        <li class="list-group-item px-0"><strong>Áp dụng:</strong> Toàn bộ sản phẩm sách trên BookStore. Mỗi tài khoản chỉ được sử dụng 1 lần. Không áp dụng cùng lúc với các chương trình khuyến mãi khác.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1055;">
        <div id="systemToast" class="toast align-items-center text-white border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body fw-bold" id="toastMessage">
                    </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hàm mở Modal Chi tiết
        function showVoucherDetails(code, discountPercent, discountAmount, minOrder, endDate) {
            document.getElementById('modalVoucherCode').innerText = code;
            
            // Xử lý in chữ tiêu đề cho đẹp
            let titleText = "";
            if (discountPercent > 0) {
                titleText = "Giảm " + discountPercent + "%";
            } else {
                titleText = "Giảm " + Number(discountAmount).toLocaleString('vi-VN') + "đ";
            }
            document.getElementById('modalVoucherTitle').innerText = titleText;
            
            document.getElementById('modalMinOrder').innerText = Number(minOrder).toLocaleString('vi-VN');
            document.getElementById('modalEndDate').innerText = endDate;
            
            var modal = new bootstrap.Modal(document.getElementById('voucherDetailModal'));
            modal.show();
        }

        // Hàm Lưu Mã (Đã được nâng cấp dùng Toast)
        function saveVoucher(voucherId) {
            fetch('${pageContext.request.contextPath}/save-voucher', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'voucherId=' + voucherId
            })
            .then(response => response.text())
            .then(result => {
                if (result === 'UNAUTHORIZED') {
                    alert('Bạn cần đăng nhập để lưu mã!');
                    window.location.href = '${pageContext.request.contextPath}/login';
                } else if (result === 'EXISTED') {
                    showToast('⚠️ Bạn đã lưu mã này rồi, hãy kiểm tra Ví Voucher!', 'bg-warning', 'text-dark');
                } else if (result === 'SUCCESS') {
                    showToast('<i class="fa-solid fa-circle-check me-2"></i> Lưu mã thành công! Mã đã nằm trong Ví.', 'bg-success', 'text-white');
                } else {
                    showToast('❌ Hệ thống đang bận, vui lòng thử lại sau.', 'bg-danger', 'text-white');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('❌ Lỗi kết nối mạng.', 'bg-danger', 'text-white');
            });
        }

        // Hàm tiện ích bật Toast
        function showToast(message, bgColorClass, textColorClass) {
            let toastEl = document.getElementById('systemToast');
            let toastMsg = document.getElementById('toastMessage');
            
            // Reset class màu sắc
            toastEl.className = 'toast align-items-center border-0 ' + bgColorClass;
            toastMsg.className = 'toast-body fw-bold ' + textColorClass;
            toastMsg.innerHTML = message;
            
            // Bật Toast
            var toast = new bootstrap.Toast(toastEl, { delay: 3000 });
            toast.show();
        }
    </script>
</body>
</html>