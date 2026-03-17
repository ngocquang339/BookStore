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

    <script>
        function copyCode(code) {
            navigator.clipboard.writeText(code).then(() => {
                alert("Đã copy mã: " + code);
            });
        }
    </script>
</body>
</html>