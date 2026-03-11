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
                        <c:forEach items="${wallet}" var="uv">
                            <div class="voucher-card">
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
                                        <a href="#" class="v-detail-link">Chi tiết</a>
                                    </div>
                                    
                                    <div class="v-condition">
                                        Đơn hàng từ <fmt:formatNumber value="${uv.voucher.minOrderValue}" type="number" pattern="#,###"/>đ
                                    </div>
                                    
                                    <div class="v-code-box">
                                        <span class="v-code" id="code_${uv.voucher.code}">${uv.voucher.code}</span>
                                    </div>
                                    
                                    <div class="v-footer">
                                        <div class="v-date">HSD: <fmt:formatDate value="${uv.voucher.endDate}" pattern="dd/MM/yyyy"/></div>
                                        <button class="btn-copy" onclick="copyCode('${uv.voucher.code}')">Copy mã</button>
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