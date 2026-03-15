package com.group2.bookstore.controller;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.User;
import com.group2.bookstore.util.EmailUtility;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/forgot-password-api")
public class ForgotPasswordApiServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Cấu hình trả về kiểu JSON để AJAX Javascript hiểu được
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        HttpSession session = request.getSession();

        // TRƯỜNG HỢP 1: YÊU CẦU GỬI OTP VỀ EMAIL
        if ("send".equals(action)) {
            UserDAO dao = new UserDAO();
            User user = dao.checkEmailExist(email);
            
            if (user == null) {
                // Email chưa đăng ký tài khoản nào
                response.getWriter().write("{\"success\": false, \"message\": \"Email này chưa được đăng ký trong hệ thống!\"}");
                return;
            }

            // Nếu Email tồn tại -> Dùng công cụ có sẵn tạo và gửi OTP
            String otp = EmailUtility.getRandomOTP();
            EmailUtility.sendEmail(email, otp);

            // Lưu OTP vào Session (gắn thêm chữ "forgot_" để không bị lẫn với OTP lúc đăng ký)
            session.setAttribute("forgot_otp_" + email, otp);
            // THÊM DÒNG NÀY: Lưu lại chính xác mốc thời gian (Mili-giây) OTP được tạo ra
            session.setAttribute("forgot_otp_time_" + email, System.currentTimeMillis());
            
            response.getWriter().write("{\"success\": true}");
        } 
        
        // TRƯỜNG HỢP 2: YÊU CẦU KIỂM TRA OTP KHÁCH NHẬP CÓ ĐÚNG KHÔNG
        else if ("verify".equals(action)) {
            String userOtp = request.getParameter("otp");
            String serverOtp = (String) session.getAttribute("forgot_otp_" + email);

            if (serverOtp != null && serverOtp.equals(userOtp)) {
                // Trùng khớp -> Thành công -> Cấp quyền cho giao diện mở ô mật khẩu
                response.getWriter().write("{\"success\": true}");
            } else {
                // Sai OTP
                response.getWriter().write("{\"success\": false}");
            }
        }
    }
}