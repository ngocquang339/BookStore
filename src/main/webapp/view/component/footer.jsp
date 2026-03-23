<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    /* CSS dành riêng cho Footer */
    .site-footer {
        background-color: #f8f9fa; /* Màu xám nhạt cực sang */
        padding: 50px 0 20px;
        font-size: 14px;
        color: #444;
        margin-top: 60px;
        border-top: 4px solid #C92127; /* Viền đỏ đặc trưng phía trên */
    }
    .footer-container {
        max-width: 1250px; /* Khớp với chiều rộng trang của bạn */
        margin: 0 auto;
        padding: 0 15px;
    }
    .footer-top {
        display: grid;
        grid-template-columns: 2fr 1fr 1fr 1fr; /* Chia 4 cột, cột đầu to gấp đôi */
        gap: 30px;
        margin-bottom: 40px;
    }
    .footer-col h4 {
        font-size: 16px;
        font-weight: bold;
        margin-bottom: 20px;
        color: #333;
        text-transform: uppercase;
    }
    .footer-col ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .footer-col ul li {
        margin-bottom: 12px;
    }
    .footer-col ul li a {
        color: #666;
        text-decoration: none;
        transition: color 0.3s, padding-left 0.3s;
    }
    .footer-col ul li a:hover {
        color: #C92127;
        padding-left: 5px; /* Hiệu ứng thụt lề nhẹ khi di chuột */
    }
    .footer-contact p {
        margin-bottom: 12px;
        line-height: 1.6;
        display: flex;
        align-items: flex-start;
        gap: 10px;
    }
    .footer-contact i {
        color: #C92127;
        font-size: 16px;
        margin-top: 3px;
    }
    
    /* Khu vực đăng ký nhận tin */
    .newsletter-box {
        display: flex;
        margin-top: 15px;
    }
    .newsletter-box input {
        flex: 1;
        padding: 10px 15px;
        border: 1px solid #ddd;
        border-radius: 6px 0 0 6px;
        outline: none;
    }
    .newsletter-box button {
        background: #C92127;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 0 6px 6px 0;
        cursor: pointer;
        font-weight: bold;
        transition: background 0.3s;
    }
    .newsletter-box button:hover {
        background: #a81c21;
    }

    /* Phần bản quyền dưới cùng */
    .footer-bottom {
        border-top: 1px solid #ddd;
        padding-top: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 15px;
    }
    .footer-social a {
        display: inline-flex;
        width: 36px;
        height: 36px;
        justify-content: center;
        align-items: center;
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 50%;
        color: #555;
        margin-right: 10px;
        transition: 0.3s;
        text-decoration: none;
    }
    .footer-social a:hover {
        background: #C92127;
        color: white;
        border-color: #C92127;
    }
</style>

<footer class="site-footer">
    <div class="footer-container">
        <div class="footer-top">
            
            <div class="footer-col footer-contact">
                <div style="font-size: 28px; font-weight: 900; color: #C92127; margin-bottom: 20px; letter-spacing: 1px;">
                    MINDBOOK
                </div>
                <p><i class="fa-solid fa-location-dot"></i> <span><strong>Địa chỉ:</strong> Khu công nghệ cao Hòa Lạc, Hà Nội</span></p>
                <p><i class="fa-solid fa-envelope"></i> <span><strong>Email:</strong> cskh@mindbook.com</span></p>
                <p><i class="fa-solid fa-phone"></i> <span><strong>Hotline:</strong> 1900 1234 (8h00 - 21h00)</span></p>
                
            </div>

<div class="footer-col">
    <h4>Dịch vụ khách hàng</h4>
    <ul>
        <li><a href="${pageContext.request.contextPath}/terms"><i class="fa-solid fa-angle-right" style="font-size:10px; margin-right:5px;"></i> Điều khoản sử dụng</a></li>
        
        <li><a href="${pageContext.request.contextPath}/privacy-policy"><i class="fa-solid fa-angle-right" style="font-size:10px; margin-right:5px;"></i> Chính sách bảo mật</a></li>
        <li><a href="${pageContext.request.contextPath}/payment-methods"><i class="fa-solid fa-angle-right" style="font-size:10px; margin-right:5px;"></i> Phương thức thanh toán</a></li>
    </ul>
</div>

            <div class="footer-col">
                <h4>Về MindBook</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/about-us"><i class="fa-solid fa-angle-right" style="font-size:10px; margin-right:5px;"></i> Giới thiệu MindBook</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Tài khoản của tôi</h4>
                <ul style="margin-bottom: 25px;">
                    <li><a href="${pageContext.request.contextPath}/login"><i class="fa-solid fa-angle-right" style="font-size:10px; margin-right:5px;"></i> Đăng nhập / Đăng ký</a></li>
                    <li><a href="${pageContext.request.contextPath}/my-orders"><i class="fa-solid fa-angle-right" style="font-size:10px; margin-right:5px;"></i> Lịch sử mua hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart"><i class="fa-solid fa-angle-right" style="font-size:10px; margin-right:5px;"></i> Giỏ hàng</a></li>
                </ul>
            </div>

        </div>

        <div class="footer-bottom">
            <div>&copy; 2026 <strong>MindBook Store</strong>. Tất cả các quyền được bảo lưu.</div>
            <div style="display: flex; gap: 10px; align-items: center;">
                <span style="font-weight: bold; color: #777;">Chấp nhận thanh toán:</span>
                <!-- COD -->
                <div style="display: flex; align-items: center; gap: 5px;">
                    <i class="fa-solid fa-money-bill-wave" style="font-size: 22px; color: #00b14f;"></i>
                </div>
                <!-- VNPay -->
                <div style="display: flex; align-items: center; gap: 5px;">
                    <img src="${pageContext.request.contextPath}/assets/image/PaymentMethod/VNPAY.jpg" alt="VNPay" style="height: 24px;">
                </div>
            </div>
        </div>
    </div>
</footer>