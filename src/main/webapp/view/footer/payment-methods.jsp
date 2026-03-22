<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phương thức thanh toán - MINDBOOK</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    
    <style>
        body { background-color: #f5f5f5; }
        .policy-wrapper {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
            padding: 40px 50px;
            margin-bottom: 40px;
        }
        .policy-title {
            color: #C92127;
            font-weight: 800;
            text-transform: uppercase;
            margin-bottom: 30px;
            text-align: center;
        }
        .policy-section-title {
            color: #333;
            font-weight: bold;
            font-size: 18px;
            margin-top: 25px;
            margin-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .policy-section-title i {
            color: #C92127;
            font-size: 20px;
        }
        .policy-content p, .policy-content li {
            color: #555;
            font-size: 15px;
            line-height: 1.7;
            text-align: justify;
        }
        .policy-content ul { padding-left: 20px; }
        .policy-content li { margin-bottom: 8px; }
        
        .wallet-highlight {
            background-color: #fdf5f5;
            border: 1px solid #f0caca;
            border-left: 4px solid #C92127;
            padding: 15px 20px;
            margin-top: 15px;
            border-radius: 4px;
        }
    </style>
</head>
<body>

    <jsp:include page="/view/component/header.jsp" />

    <div class="container mt-5">
        <div class="policy-wrapper">
            <h2 class="policy-title"><i class="fa-solid fa-credit-card me-2"></i> PHƯƠNG THỨC THANH TOÁN</h2>
            
            <div class="policy-content">
                <p>Nhằm mang đến trải nghiệm mua sắm thuận tiện, an toàn và tối ưu nhất cho quý khách hàng, <strong>MINDBOOK</strong> hiện đang hỗ trợ 3 phương thức thanh toán chính sau đây:</p>

                <%-- Phương thức 1: COD --%>
                <h4 class="policy-section-title"><i class="fa-solid fa-hand-holding-dollar"></i> 1. Thanh toán tiền mặt khi nhận hàng (COD)</h4>
                <p>
                    Đây là phương thức thanh toán an toàn và quen thuộc nhất. Khách hàng sẽ chỉ thanh toán tiền mặt cho nhân viên giao hàng ngay sau khi nhận và kiểm tra sách.
                </p>
                <ul>
                    <li><strong>Phạm vi áp dụng:</strong> Giao hàng toàn quốc.</li>
                    <li><strong>Lưu ý:</strong> Vui lòng chuẩn bị sẵn số tiền tương ứng với giá trị đơn hàng để quá trình giao nhận diễn ra nhanh chóng. Trong trường hợp nhờ người nhận hộ, quý khách vui lòng dặn dò người nhận chuẩn bị tiền thanh toán.</li>
                </ul>

                <%-- Phương thức 2: VNPAY --%>
                <h4 class="policy-section-title"><i class="fa-solid fa-qrcode"></i> 2. Thanh toán trực tuyến qua cổng VNPAY</h4>
                <p>
                    Thanh toán nhanh chóng, không cần tiền mặt chỉ với thao tác quét mã QR trực tiếp trên website MINDBOOK thông qua cổng thanh toán VNPAY. 
                </p>
                <ul>
                    <li>Sử dụng ứng dụng Mobile Banking của hơn 40 ngân hàng tại Việt Nam hoặc ví điện tử VNPAY để quét mã.</li>
                    <li>Giao dịch được xác nhận hoàn tất ngay lập tức, đơn hàng sẽ được duyệt tự động.</li>
                    <li>An toàn, bảo mật tuyệt đối. Thường xuyên được áp dụng các chương trình ưu đãi, mã giảm giá trực tiếp từ VNPAY.</li>
                </ul>

                <%-- Phương thức 3: Ví MINDBOOK --%>
                <h4 class="policy-section-title"><i class="fa-solid fa-wallet"></i> 3. Thanh toán bằng Ví MINDBOOK</h4>
                <p>
                    <strong>Ví MINDBOOK</strong> là tài khoản thanh toán nội bộ dành riêng cho các thành viên của hệ thống. Đây là phương thức thanh toán <strong>tối ưu nhất, nhanh nhất</strong> dành cho những khách hàng yêu sách và thường xuyên mua sắm tại website.
                </p>
                <div class="wallet-highlight">
                    <p style="font-weight: bold; margin-bottom: 10px; color: #C92127;">Đặc quyền khi sử dụng Ví MINDBOOK:</p>
                    <ul style="margin-bottom: 0;">
                        <li><strong>Thanh toán 1 chạm:</strong> Không cần nhập thông tin thẻ hay quét mã phức tạp, tiền được trừ thẳng vào số dư ví ngay khi đặt hàng.</li>
                        <li><strong>Hoàn tiền siêu tốc:</strong> Trong trường hợp hủy đơn hoặc đổi trả hàng, số tiền hoàn lại sẽ được cộng lập tức vào Ví MINDBOOK, giúp quý khách có thể tiếp tục mua sắm ngay mà không phải chờ đợi ngân hàng xử lý.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/view/component/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>