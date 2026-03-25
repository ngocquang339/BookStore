<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giới thiệu - MINDBOOK</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    
    <style>
        body {
            background-color: #f5f5f5;
        }
        .about-wrapper {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
            padding: 40px 50px;
            margin-bottom: 40px;
        }
        .about-title {
            color: #C92127;
            font-weight: 800;
            text-transform: uppercase;
            margin-bottom: 30px;
            text-align: center;
        }
        .about-section-title {
            color: #C92127;
            font-weight: bold;
            font-size: 20px;
            margin-top: 30px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .about-content p {
            color: #444;
            font-size: 15.5px;
            line-height: 1.8;
            text-align: justify;
            margin-bottom: 15px;
        }
        .core-values {
            background-color: #fdfdfd;
            border-left: 4px solid #C92127;
            padding: 15px 20px;
            margin-top: 20px;
            border-radius: 0 8px 8px 0;
        }
        .core-values ul {
            list-style-type: none;
            padding-left: 0;
            margin-bottom: 0;
        }
        .core-values li {
            margin-bottom: 12px;
            font-size: 15.5px;
            color: #444;
        }
        .core-values li i {
            color: #C92127;
            margin-right: 10px;
            font-size: 18px;
        }
    </style>
</head>
<body>

    <%-- Gọi header --%>
    <jsp:include page="/view/component/header.jsp" />

    <div class="container mt-5">
        <div class="about-wrapper">
            <h2 class="about-title">GIỚI THIỆU VỀ MINDBOOK</h2>
            
            <div class="about-content">
                <p>
                    Chào mừng bạn đến với <strong>MINDBOOK</strong> – không gian tri thức dành cho những người yêu sách. Được thành lập với niềm đam mê bất tận dành cho những trang giấy, MINDBOOK không chỉ là một nhà sách trực tuyến, mà còn là người bạn đồng hành mang đến những giá trị tinh thần to lớn cho cộng đồng độc giả Việt Nam.
                </p>
                
                <p>
                    Chúng tôi tự hào cung cấp hàng ngàn tựa sách phong phú, từ văn học kinh điển, sách phát triển bản thân, kỹ năng sống, đến sách kinh tế, công nghệ và sách thiếu nhi. Tất cả đều được tuyển chọn kỹ lưỡng từ các nhà xuất bản uy tín hàng đầu.
                </p>

                <h4 class="about-section-title"><i class="fa-solid fa-eye"></i> Tầm nhìn</h4>
                <p>
                    Trở thành nền tảng phân phối sách trực tuyến hàng đầu và đáng tin cậy nhất tại Việt Nam. MINDBOOK hướng tới việc xây dựng một hệ sinh thái văn hóa đọc mạnh mẽ, nơi mọi người có thể dễ dàng tiếp cận với kho tàng tri thức nhân loại chỉ qua vài cú click chuột.
                </p>

                <h4 class="about-section-title"><i class="fa-solid fa-bullseye"></i> Sứ mệnh</h4>
                <p>
                    Mang tri thức đến gần hơn với mọi người. Chúng tôi cam kết xóa bỏ mọi rào cản về khoảng cách địa lý, giúp những cuốn sách chất lượng nhất đến tay độc giả trên mọi miền Tổ quốc một cách nhanh chóng, tiện lợi với chi phí hợp lý nhất.
                </p>

                <h4 class="about-section-title"><i class="fa-solid fa-gem"></i> Giá trị cốt lõi</h4>
                <div class="core-values">
                    <ul>
                        <li><i class="fa-solid fa-check-circle"></i> <strong>Sản phẩm chất lượng:</strong> 100% sách bản quyền, chất lượng in ấn tốt nhất.</li>
                        <li><i class="fa-solid fa-heart"></i> <strong>Dịch vụ tận tâm:</strong> Khách hàng là trung tâm trong mọi hoạt động của MINDBOOK. Lắng nghe và hỗ trợ hết mình.</li>
                        <li><i class="fa-solid fa-truck-fast"></i> <strong>Giao hàng siêu tốc:</strong> Đóng gói cẩn thận, vận chuyển nhanh chóng, an toàn đến tận tay người đọc.</li>
                        <li><i class="fa-solid fa-lightbulb"></i> <strong>Cải tiến không ngừng:</strong> Liên tục nâng cấp nền tảng công nghệ để mang lại trải nghiệm mua sắm tuyệt vời nhất.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <%-- Gọi footer --%>
    <jsp:include page="/view/component/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>