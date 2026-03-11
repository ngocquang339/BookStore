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
                        
                        <button class="btn btn-danger w-100 fw-bold" onclick="saveVoucher('${v.id}')">
                            LƯU MÃ NGAY
                        </button>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <jsp:include page="component/footer.jsp" />

    <script>
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
                    alert('Bạn đã lưu mã này rồi, hãy kiểm tra Ví Voucher nhé!');
                } else if (result === 'SUCCESS') {
                    alert('Lưu mã thành công! Mã đã được thêm vào Ví.');
                } else {
                    alert('Hệ thống đang bận, vui lòng thử lại sau.');
                }
            })
            .catch(error => console.error('Error:', error));
        }
    </script>
</body>
</html>