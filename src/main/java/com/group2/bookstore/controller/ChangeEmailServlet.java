package com.group2.bookstore.controller;
import jakarta.servlet.http.HttpServletRequest;
import com.group2.bookstore.util.EmailUtility;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import com.group2.bookstore.model.User;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
@WebServlet(name = "ChangeEmailServlet", urlPatterns = { "/change-email" })
public class ChangeEmailServlet extends HttpServlet{
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String newEmail = request.getParameter("new_email");
        HttpSession session = request.getSession();
        User u  = (User) session.getAttribute("user");
        String oldEmail = u.getEmail();
        // 1. Validate email format
        if (newEmail == null || newEmail.trim().isEmpty() || !newEmail.contains("@") || newEmail.length() > 100) {
            request.setAttribute("error", "Email không hợp lệ!");
            request.getRequestDispatcher("view/change-email.jsp").forward(request, response);
            return;
        }

        if(newEmail.equals(oldEmail)) {
            request.setAttribute("error", "Email mới không được trùng với email cũ!");
            request.setAttribute("openVerifyEmail", "true");
            request.setAttribute("pendingEmail", newEmail);
            request.getRequestDispatcher("view/UserProfile.jsp").forward(request, response);
            return;
        }
    // 2. Tạo mã OTP
            String otp = EmailUtility.getRandomOTP();

            // 3. Gửi Email (Có thể mất 2-3 giây)
            EmailUtility.sendEmail(newEmail, otp);

            session.setAttribute("tempEmail", newEmail);
            session.setAttribute("otp", otp);
            // --- ĐÂY LÀ PHẦN QUAN TRỌNG NHẤT (CỜ HIỆU) ---
        
            // A. Báo hiệu mở Modal
            request.setAttribute("openVerifyEmail", "true"); 
            
            // B. Giữ lại email người dùng vừa nhập để điền lại vào ô
            request.setAttribute("pendingEmail", newEmail);
            
            // C. Thông báo
            request.setAttribute("mess", "Mã OTP đã được gửi! Vui lòng kiểm tra email.");
            request.setAttribute("status", "success");

            // D. Quay lại trang Profile (Dùng Forward để giữ attribute)
            request.getRequestDispatcher("view/UserProfile.jsp").forward(request, response); 
        }
}
