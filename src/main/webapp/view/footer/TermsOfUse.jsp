<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Điều khoản sử dụng - MindBook</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

        <style>
            body {
                background-color: #fff;
                color: #333;
                font-family: Arial, sans-serif;
            }

            /* Breadcrumb CSS */
            .breadcrumb-container {
                background-color: #f5f5f5;
                padding: 10px 0;
                margin-bottom: 30px;
            }

            .breadcrumb {
                margin: 0;
                font-size: 14px;
            }

            .breadcrumb a {
                color: #333;
                text-decoration: none;
            }

            .breadcrumb a:hover {
                color: #C92127;
            }

            .breadcrumb-item.active {
                color: #C92127;
                font-weight: 500;
            }

            /* Sidebar CSS */
            .policy-sidebar {
                border: 1px solid #eee;
                padding: 0;
            }

            .policy-sidebar-header {
                background-color: #f8f8f8;
                padding: 12px 15px;
                border-bottom: 1px solid #eee;
            }

            .policy-sidebar-header h5 {
                margin: 0;
                font-size: 16px;
                font-weight: 700;
                color: #333;
                text-transform: uppercase;
            }

            .policy-sidebar-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .policy-sidebar-list li {
                border-bottom: 1px solid #eee;
            }

            .policy-sidebar-list li:last-child {
                border-bottom: none;
            }

            .policy-sidebar-list li a {
                display: block;
                padding: 12px 15px;
                color: #555;
                text-decoration: none;
                font-size: 14px;
                transition: 0.3s;
            }

            .policy-sidebar-list li a:hover {
                color: #C92127;
                padding-left: 20px;
            }

            .policy-sidebar-list li a.active {
                color: #C92127;
                font-weight: bold;
                background-color: #fffafb;
            }

            /* Content CSS */
            .policy-content h2 {
                font-size: 22px;
                font-weight: bold;
                color: #333;
                text-transform: uppercase;
                margin-bottom: 20px;
            }

            .policy-content h4 {
                font-size: 16px;
                font-weight: bold;
                color: #333;
                margin-top: 25px;
                margin-bottom: 15px;
            }

            .policy-content p {
                font-size: 14px;
                line-height: 1.6;
                color: #555;
                margin-bottom: 15px;
                text-align: justify;
            }

            .policy-content ul {
                padding-left: 20px;
                font-size: 14px;
                line-height: 1.6;
                color: #555;
                margin-bottom: 15px;
            }

            .policy-content ul li {
                margin-bottom: 8px;
            }
        </style>
    </head>

    <body>

        <jsp:include page="/view/component/header.jsp" />

        <div class="breadcrumb-container">
            <div class="container">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Điều khoản sử dụng</li>
                    </ol>
                </nav>
            </div>
        </div>
<div class="container mb-5">
    <div class="row">

        <div class="col-md-9">
            <div class="policy-content">
                <h2>ĐIỀU KHOẢN SỬ DỤNG</h2>
                <p>Chào mừng Quý khách đến với website <strong>MindBook Store</strong>. Xin vui lòng đọc kỹ các điều khoản và điều kiện dưới đây trước khi sử dụng dịch vụ hoặc mua sắm trên hệ thống website của chúng tôi.</p>

                <h4>1. Chấp nhận điều khoản</h4>
                <p>Khi Quý khách truy cập vào trang web của chúng tôi, đồng nghĩa với việc Quý khách đã đồng ý với các điều khoản này. MindBook Store có quyền thay đổi, chỉnh sửa, thêm hoặc lược bỏ bất kỳ phần nào trong Điều khoản sử dụng vào bất cứ lúc nào. Các thay đổi có hiệu lực ngay khi được đăng trên trang web mà không cần thông báo trước. Việc Quý khách tiếp tục sử dụng trang web sau khi các thay đổi được đăng tải đồng nghĩa với việc Quý khách chấp nhận những thay đổi đó.</p>

                <h4>2. Hướng dẫn sử dụng website</h4>
                <ul>
                    <li>Khi truy cập vào website của chúng tôi, khách hàng phải đảm bảo đủ 18 tuổi, hoặc truy cập dưới sự giám sát của cha mẹ hay người giám hộ hợp pháp. Khách hàng đảm bảo có đầy đủ hành vi dân sự để thực hiện các giao dịch mua bán hàng hóa theo quy định hiện hành của pháp luật Việt Nam.</li>
                    <li>Quý khách có trách nhiệm cung cấp thông tin xác thực về bản thân khi đăng ký tài khoản và phải cập nhật nếu có bất kỳ thay đổi nào. Mỗi người truy cập phải có trách nhiệm bảo mật mật khẩu, tài khoản và hoạt động của mình trên web. Quý khách phải thông báo ngay cho chúng tôi biết khi tài khoản bị truy cập trái phép. Chúng tôi không chịu bất kỳ trách nhiệm nào, dù trực tiếp hay gián tiếp, đối với những thiệt hại hoặc mất mát gây ra do Quý khách không tuân thủ quy định bảo mật.</li>
                    <li>Nghiêm cấm sử dụng bất kỳ phần nào của trang web này với mục đích thương mại hoặc nhân danh bất kỳ đối tác thứ ba nào nếu không được chúng tôi cho phép bằng văn bản.</li>
                </ul>

                <h4>3. Ý kiến và đánh giá của khách hàng</h4>
                <p>Tất cả nội dung đánh giá, bình luận của Quý khách đều là tài sản của chúng tôi. Nếu chúng tôi phát hiện bất kỳ thông tin giả mạo, spam, dùng từ ngữ thô tục, bôi nhọ hoặc vi phạm thuần phong mỹ tục, chúng tôi sẽ khóa tài khoản của Quý khách ngay lập tức và gỡ bỏ bình luận mà không cần báo trước.</p>

                <h4>4. Chấp nhận đơn hàng và giá cả</h4>
                <ul>
                    <li>Chúng tôi có quyền từ chối hoặc hủy đơn hàng của Quý khách vì bất kỳ lý do gì liên quan đến lỗi kỹ thuật, gian lận, hoặc nghi ngờ đầu cơ tích trữ vào bất kỳ lúc nào.</li>
                    <li>MindBook cam kết sẽ cung cấp thông tin giá cả chính xác nhất cho người tiêu dùng. Tuy nhiên, đôi lúc vẫn có sai sót xảy ra, ví dụ như trường hợp giá sản phẩm không hiển thị chính xác trên trang web do lỗi hệ thống, tùy theo từng trường hợp chúng tôi sẽ liên hệ hướng dẫn hoặc thông báo hủy đơn hàng đó cho Quý khách.</li>
                </ul>

                <h4>5. Quyền sở hữu trí tuệ</h4>
                <p>Mọi quyền sở hữu trí tuệ (đã đăng ký hoặc chưa đăng ký), nội dung thông tin và tất cả các thiết kế, văn bản, đồ họa, phần mềm, hình ảnh, video, âm nhạc, biên dịch phần mềm và mã nguồn đều là tài sản của MindBook Store. Toàn bộ nội dung của trang web được bảo vệ bởi luật bản quyền của Việt Nam và các công ước quốc tế.</p>

                <h4>6. Thanh toán an toàn</h4>
                <p>Mọi khách hàng tham gia giao dịch tại MindBook Store qua thẻ tín dụng quốc tế, thẻ ATM nội địa hoặc VNPay đều được bảo mật thông tin bằng mã hóa. Chúng tôi cam kết không lưu trữ thông tin thẻ của Quý khách trên hệ thống của MindBook.</p>

                <h4>7. Giải quyết tranh chấp</h4>
                <p>Bất kỳ tranh cãi, khiếu nại hoặc tranh chấp phát sinh từ hoặc liên quan đến giao dịch tại MindBook hoặc các Điều khoản này đều sẽ được ưu tiên giải quyết bằng hình thức thương lượng, hòa giải. Trường hợp không thể thương lượng, sự việc sẽ được đưa ra giải quyết tại Tòa án có thẩm quyền tại Việt Nam theo quy định của pháp luật.</p>
            </div>
        </div>
        
    </div>
</div>

        <jsp:include page="/view/component/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>