<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chính sách bảo mật - MINDBOOK</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    
    <style>
        body {
            background-color: #f5f5f5;
        }
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
        }
        .policy-content p, .policy-content li {
            color: #555;
            font-size: 15px;
            line-height: 1.7;
            text-align: justify;
        }
        .policy-content ul {
            padding-left: 20px;
        }
        .policy-content li {
            margin-bottom: 8px;
        }
    </style>
</head>
<body>

    <%-- Gọi header --%>
    <jsp:include page="/view/component/header.jsp" />

    <div class="container mt-5">
        <div class="policy-wrapper">
            <h2 class="policy-title"><i class="fa-solid fa-shield-halved me-2"></i> CHÍNH SÁCH BẢO MẬT THÔNG TIN CÁ NHÂN KHÁCH HÀNG</h2>
            
            <div class="policy-content">
                <h4 class="policy-section-title">1. Mục đích và phạm vi thu thập</h4>
                <p>
                    Để truy cập và sử dụng một số dịch vụ tại <strong>MINDBOOK</strong>, bạn có thể sẽ được yêu cầu đăng ký với chúng tôi thông tin cá nhân (Email, Họ tên, Số ĐT liên lạc…). Mọi thông tin khai báo phải đảm bảo tính chính xác và hợp pháp. <strong>MINDBOOK</strong> không chịu mọi trách nhiệm liên quan đến pháp luật của thông tin khai báo.
                </p>
                <p>
                    Chúng tôi cũng có thể thu thập thông tin về số lần viếng thăm, bao gồm số trang bạn xem, số links (liên kết) bạn click và những thông tin khác liên quan đến việc kết nối đến site <strong>MINDBOOK</strong>. Chúng tôi cũng thu thập các thông tin mà trình duyệt Web (Browser) bạn sử dụng mỗi khi truy cập vào <strong>MINDBOOK</strong>, bao gồm: địa chỉ IP, loại Browser, ngôn ngữ sử dụng, thời gian và những địa chỉ mà Browser truy xuất đến.
                </p>

                <h4 class="policy-section-title">2. Phạm vi sử dụng thông tin</h4>
                <p>
                    <strong>MINDBOOK</strong> thu thập và sử dụng thông tin cá nhân bạn với mục đích phù hợp và hoàn toàn tuân thủ nội dung của "Chính sách bảo mật" này.
                </p>
                <p>
                    Khi cần thiết, chúng tôi có thể sử dụng những thông tin này để liên hệ trực tiếp với bạn dưới các hình thức như: gửi thư ngỏ, đơn đặt hàng, thư cảm ơn, sms, thông tin về kỹ thuật và bảo mật…
                </p>

                <h4 class="policy-section-title">3. Thời gian lưu trữ thông tin</h4>
                <p>
                    Dữ liệu cá nhân của Thành viên sẽ được lưu trữ cho đến khi có yêu cầu hủy bỏ hoặc tự thành viên đăng nhập và thực hiện hủy bỏ. Còn lại trong mọi trường hợp thông tin cá nhân thành viên sẽ được bảo mật trên máy chủ của <strong>MINDBOOK</strong>.
                </p>

                <h4 class="policy-section-title">4. Địa chỉ của đơn vị thu thập và quản lý thông tin cá nhân</h4>
                <ul>
                    <li><strong>Công Ty Cổ Phần Thương Mại MINDBOOK</strong></li>
                    <li><strong>Địa chỉ:</strong> Khu Công nghệ cao Hòa Lạc, Thạch Thất, Hà Nội</li>
                    <li><strong>Điện thoại:</strong> 1900 1508 - <strong>Email:</strong> hotro@mindbook.com</li>
                </ul>

                <h4 class="policy-section-title">5. Phương tiện và công cụ để người dùng tiếp cận và chỉnh sửa dữ liệu cá nhân của mình</h4>
                <p>
                    Hiện website chưa triển khai trang quản lý thông tin cá nhân của thành viên, vì thế việc tiếp cận và chỉnh sửa dữ liệu cá nhân dựa vào yêu cầu của khách hàng bằng cách hình thức sau:
                </p>
                <ul>
                    <li>Gọi điện thoại đến tổng đài chăm sóc khách hàng <strong>1900 1508</strong>, bằng nghiệp vụ chuyên môn xác định thông tin cá nhân và nhân viên tổng đài sẽ hỗ trợ chỉnh sửa thay người dùng.</li>
                    <li>Để lại bình luận hoặc gửi góp ý trực tiếp từ website <strong>MINDBOOK</strong>, quản trị viên kiểm tra thông tin và xem xét nội dung bình luận có phù hợp với pháp luật và chính sách của <strong>MINDBOOK</strong> hay không.</li>
                </ul>

                <h4 class="policy-section-title">6. Cam kết bảo mật thông tin cá nhân khách hàng</h4>
                <ul>
                    <li>Thông tin cá nhân của thành viên trên <strong>MINDBOOK</strong> được chúng tôi cam kết bảo mật tuyệt đối theo chính sách bảo vệ thông tin cá nhân của <strong>MINDBOOK</strong>. Việc thu thập và sử dụng thông tin của mỗi thành viên chỉ được thực hiện khi có sự đồng ý của khách hàng đó trừ những trường hợp pháp luật có quy định khác.</li>
                    <li>Không sử dụng, không chuyển giao, cung cấp hay tiết lộ cho bên thứ 3 nào về thông tin cá nhân của thành viên khi không có sự cho phép đồng ý từ thành viên.</li>
                    <li>Trong trường hợp máy chủ lưu trữ thông tin bị hacker tấn công dẫn đến mất mát dữ liệu cá nhân thành viên, <strong>MINDBOOK</strong> sẽ có trách nhiệm thông báo vụ việc cho cơ quan chức năng điều tra xử lý kịp thời và thông báo cho thành viên được biết.</li>
                    <li>Bảo mật tuyệt đối mọi thông tin giao dịch trực tuyến của Thành viên bao gồm thông tin hóa đơn kế toán chứng từ số hóa tại khu vực dữ liệu trung tâm an toàn cấp 1 của <strong>MINDBOOK</strong>.</li>
                </ul>
            </div>
        </div>
    </div>

    <%-- Gọi footer --%>
    <jsp:include page="/view/component/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>