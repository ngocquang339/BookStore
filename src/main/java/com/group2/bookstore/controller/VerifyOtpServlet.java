package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.model.User;
import com.group2.bookstore.model.Book;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // 1. Lấy dữ liệu
        String userOtp = request.getParameter("Userotp");
        String serverOtp = (String) session.getAttribute("otp");
        Long otpTime = (Long) session.getAttribute("otp_time"); // Lấy thời gian tạo OTP (Do API lưu)
        User tempUser = (User) session.getAttribute("tempUser");
        String tempEmail = (String) session.getAttribute("tempEmail");
        String actionType = request.getParameter("action_type"); // Lấy cờ phân luồng (Đổi Email hay Đăng ký)

        // BẢO VỆ GIAO DIỆN: Nạp lại sách gợi ý
        com.group2.bookstore.dal.BookDAO bookDAO = new com.group2.bookstore.dal.BookDAO();
        request.setAttribute("suggestedBooks", bookDAO.getRandomBook(2, 20));

        // 2. KIỂM TRA HẠN SỬ DỤNG (60 GIÂY)
        long timeElapsed = 0;
        if (otpTime != null) {
            timeElapsed = System.currentTimeMillis() - otpTime;
        }

        if (otpTime == null || timeElapsed > 60000) {
            // Đã hết hạn -> Xóa sạch mã cũ
            session.removeAttribute("otp");
            session.removeAttribute("otp_time");
            
            if ("change_email".equals(actionType)) {
                request.setAttribute("otpEmailError", "Mã OTP đã hết hạn! Vui lòng nhấn gửi lại mã mới.");
                request.setAttribute("openVerifyEmail", "true"); 
                request.setAttribute("pendingEmail", tempEmail); 
                request.getRequestDispatcher("view/UserProfile.jsp").forward(request, response);
            } else {
                request.setAttribute("otpError", "Mã OTP đã hết hạn! Vui lòng lấy mã mới.");
                request.setAttribute("showOtpStep", "true");
                request.getRequestDispatcher("view/register.jsp").forward(request, response);
            }
            return; // Chặn không cho chạy tiếp xuống dưới
        }

        // 3. KIỂM TRA MÃ OTP CÓ ĐÚNG KHÔNG (Chỉ chạy khi mã CÒN HẠN)
        if (serverOtp == null || !serverOtp.equals(userOtp)) {
            // SAI MÃ
            if ("change_email".equals(actionType)) {
                request.setAttribute("otpEmailError", "Mã xác thực OTP không chính xác!");
                request.setAttribute("openVerifyEmail", "true"); 
                request.setAttribute("pendingEmail", tempEmail); 
                request.getRequestDispatcher("view/UserProfile.jsp").forward(request, response);
            } else {
                request.setAttribute("otpError", "Mã xác thực không đúng!");
                request.setAttribute("showOtpStep", "true"); 
                request.getRequestDispatcher("view/register.jsp").forward(request, response);
            }
            return;
        }

        // ==========================================
        // 4. MỌI THỨ OK -> THỰC HIỆN LƯU VÀO DB
        // ==========================================
        UserDAO dao = new UserDAO();
        
        if ("change_email".equals(actionType) && tempEmail != null) {
            User user = (User)session.getAttribute("user");
            user.setEmail(tempEmail);
            dao.updateUser(user);
            
            session.setAttribute("user", user); 
            request.setAttribute("mess", "Đổi email thành công!");
            request.setAttribute("status", "success");
            
            // Dọn dẹp
            session.removeAttribute("tempEmail");
            session.removeAttribute("otp");
            session.removeAttribute("otp_time");
            
            request.getRequestDispatcher("view/UserProfile.jsp").forward(request, response);
            return; 
        }
        
        // TRƯỜNG HỢP ĐĂNG KÝ
        if(tempUser != null) {
            dao.createUser(tempUser);
            session.removeAttribute("otp");
            session.removeAttribute("otp_time");
            session.removeAttribute("tempUser");
            session.removeAttribute("tempEmail");
            
            request.setAttribute("message", "Đăng ký thành công! Hãy đăng nhập.");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
        }
    }
}