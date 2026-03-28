<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ví BookStore của tôi - BookStore</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

    <style>
        /* Card hiển thị số dư */
        .wallet-balance-card {
            background: linear-gradient(135deg, #C92127 0%, #ff5e62 100%);
            border-radius: 15px;
            padding: 30px;
            color: white;
            box-shadow: 0 10px 20px rgba(201, 33, 39, 0.2);
            position: relative;
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        /* Hiệu ứng vòng tròn mờ trang trí trong thẻ Card */
        .wallet-balance-card::after {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }

        .wallet-balance-card::before {
            content: '';
            position: absolute;
            bottom: -30%;
            right: 15%;
            width: 150px;
            height: 150px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }

        /* Bảng sao kê */
        .transaction-table th {
            color: #555;
            font-size: 14px;
            text-transform: uppercase;
            font-weight: 600;
            background-color: #f8f9fa;
        }

        .transaction-table td {
            vertical-align: middle;
            font-size: 15px;
            color: #333;
        }

        .empty-wallet-state {
            text-align: center;
            padding: 60px 20px;
            background: #fff;
            border-radius: 12px;
            border: 1px dashed #ddd;
        }
    </style>
</head>

<body style="background-color: #f5f5f5;">

    <jsp:include page="component/header.jsp" />

    <div class="container profile-container py-4">
        <div class="row">
            
            <div class="col-md-3">
                <jsp:include page="component/sidebar.jsp" />
            </div>

            <div class="col-md-9">
                <div class="main-profile-content bg-white p-4" style="border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
                    
                    <div class="page-header mb-4">
                        <h4 class="fw-bold m-0" style="color: #333;">
                            <i class="fa-solid fa-wallet text-danger me-2"></i> Ví BookStore
                        </h4>
                        <p style="font-size: 14px; color: #666; margin-top: 5px;">Quản lý số dư hoàn tiền và lịch sử giao dịch của bạn</p>
                    </div>

                    <div class="wallet-balance-card">
                        <div class="d-flex justify-content-between align-items-center position-relative" style="z-index: 2;">
                            <div>
                                <h6 class="mb-2" style="color: rgba(255,255,255,0.8); font-size: 15px;">Tổng số dư khả dụng</h6>
                                <h2 class="fw-bold mb-0" style="font-size: 36px; letter-spacing: 1px;">
                    
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user.walletBalance}">
                                            <fmt:formatNumber value="${sessionScope.user.walletBalance}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </c:when>
                                        <c:otherwise>0đ</c:otherwise>
                                    </c:choose>
                                </h2>
                            </div>
                            <div>
                                <i class="fa-solid fa-coins fa-4x" style="color: rgba(255,255,255,0.3);"></i>
                            </div>
                        </div>
                    </div>

                    <h6 class="fw-bold mb-3"><i class="fa-solid fa-clock-rotate-left me-2 text-secondary"></i>Lịch sử giao dịch</h6>

                    <%-- 2. BẢNG LỊCH SỬ GIAO DỊCH --%>
                    <c:choose>
                        <c:when test="${empty walletHistoryList}">
                            <%-- Trạng thái rỗng --%>
                            <div class="empty-wallet-state mt-3">
                                <i class="fa-solid fa-money-bill-transfer text-muted mb-3" style="font-size: 50px; opacity: 0.3;"></i>
                                <h6 class="text-muted fw-bold">Chưa có giao dịch nào</h6>
                                <p class="text-muted mb-0" style="font-size: 14px;">Mọi lịch sử hoàn tiền hoặc thanh toán bằng ví sẽ được hiển thị tại đây.</p>
                            </div>
                        </c:when>
                        
                        <c:otherwise>
                            <%-- Bảng dữ liệu --%>
                            <div class="table-responsive">
                                <table class="table transaction-table table-hover">
                                    <thead>
                                        <tr>
                                            
                                            <th style="width: 35%;">Thời gian</th>
                                            <th style="width: 20%;">Biến động</th>
                                            <th style="width: 45%;">Nội dung chi tiết</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="h" items="${walletHistoryList}">
                                            <tr>
                                                
                                                
                                                <td style="font-size: 14px;">
                                                    <fmt:formatDate value="${h.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                </td>
                                                
                                                <td>
                                                    
                                                    <c:choose>
                                                        <c:when test="${h.amount > 0}">
                                                            <span class="text-success fw-bold" style="font-size: 16px;">
                                                                +<fmt:formatNumber value="${h.amount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-danger fw-bold" style="font-size: 16px;">
                                                                <fmt:formatNumber value="${h.amount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                                <td>
                                                    ${h.description}
                                                    
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
        </div>
    </div>

    <jsp:include page="component/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>