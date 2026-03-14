package com.group2.bookstore.controller;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.List;

import java.io.IOException;

@WebServlet(name = "ChangePhoneServlet", urlPatterns = {"/change-phone"})
public class ChangePhoneServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập (Bảo mật cơ bản)
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int roleId = currentUser.getRole();

        BookDAO bookDAO = new BookDAO();
        List<Book> list = bookDAO.getRandomBook(roleId, 20);
        request.setAttribute("suggestedBooks", list);

        // 2. Lấy dữ liệu từ form gửi lên
        String verifyEmail = request.getParameter("verify_email");
        String otpCode = request.getParameter("otp_code");
        String newPhone = request.getParameter("new_phone");

        // 3. KIỂM TRA TRÙNG LẶP SỐ ĐIỆN THOẠI
        
        if (newPhone != null && newPhone.equals(currentUser.getPhone_number())) {
            // ĐỔI TÊN BIẾN THÀNH phoneErrorServer (Xóa biến mess và status)
            request.setAttribute("phoneErrorServer", "Số điện thoại mới không được trùng với số hiện tại!");
            request.setAttribute("openVerifyPhone", "true"); 
            request.setAttribute("pendingPhone", newPhone);  
            request.getRequestDispatcher("view/UserProfile.jsp").forward(request, response);
            return;
        }

        // 4. KIỂM TRA BẢO MẬT OTP VÀ HẠN SỬ DỤNG
        String serverOtp = (String) session.getAttribute("forgot_otp_" + verifyEmail);
        Long otpTime = (Long) session.getAttribute("forgot_otp_time_" + verifyEmail);
        
        // Tính toán thời gian trôi qua
        long currentTime = System.currentTimeMillis();
        long timeElapsed = 0;
        if (otpTime != null) {
            timeElapsed = currentTime - otpTime; // Tính ra mili-giây
        }

        // 4.1. Kiểm tra mã có đúng không?
        if (serverOtp == null || !serverOtp.equals(otpCode)) {
            request.setAttribute("otpError", "Mã xác thực OTP không chính xác!");
            request.setAttribute("openVerifyPhone", "true"); 
            request.setAttribute("pendingPhone", newPhone);
            request.getRequestDispatcher("view/UserProfile.jsp").forward(request, response);
            return;
        }

        // 4.2. Mã đúng rồi, nhưng ĐÃ QUÁ 1 PHÚT (60,000 mili-giây) CHƯA?
        if (otpTime == null || timeElapsed > 60000) {
            // Đã hết hạn -> Xóa luôn OTP cũ cho an toàn
            session.removeAttribute("forgot_otp_" + verifyEmail);
            session.removeAttribute("forgot_otp_time_" + verifyEmail);
            
            request.setAttribute("otpError", "Mã OTP đã hết hạn! Vui lòng nhấn gửi lại mã mới.");
            request.setAttribute("openVerifyPhone", "true"); 
            request.setAttribute("pendingPhone", newPhone);
            request.getRequestDispatcher("view/UserProfile.jsp").forward(request, response);
            return;
        }
        
        // Nếu code chạy được qua đây nghĩa là OTP VỪA ĐÚNG VỪA CÒN HẠN!

        UserDAO userDAO = new UserDAO();
        if (userDAO.isPhoneExist(newPhone)) {
            // ĐỔI TÊN BIẾN THÀNH phoneErrorServer
            request.setAttribute("phoneErrorServer", "Số điện thoại này đã được tài khoản khác sử dụng!");
            request.setAttribute("openVerifyPhone", "true"); 
            request.setAttribute("pendingPhone", newPhone);  
            request.getRequestDispatcher("view/UserProfile.jsp").forward(request, response);
            return; 
        }
        

        // Set số điện thoại mới cho User
        currentUser.setPhone_number(newPhone);
        
        // Gọi hàm update (Dùng chung hàm update profile mà bạn đã có)
        boolean isUpdated = userDAO.updateUser(currentUser);

        if (isUpdated) {
            // Cập nhật lại session để giao diện hiển thị ngay số mới
            session.setAttribute("user", currentUser);
            
            // Xóa mã OTP đi để chống dùng lại (Bảo mật)
            session.removeAttribute("forgot_otp_" + verifyEmail);

            // Báo thành công
            request.setAttribute("mess", "Cập nhật số điện thoại thành công!");
            request.setAttribute("status", "success");
        } else {
            // Lỗi DB
            request.setAttribute("mess", "Lỗi hệ thống! Không thể cập nhật số điện thoại.");
            request.setAttribute("status", "error");
        }

        // 6. Trả về trang Profile để hiện Toast thông báo
        request.getRequestDispatcher("view/UserProfile.jsp").forward(request, response);
    }
}