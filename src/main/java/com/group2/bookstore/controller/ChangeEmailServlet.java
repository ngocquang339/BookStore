package com.group2.bookstore.controller;

import com.group2.bookstore.dal.UserDAO; 
import jakarta.servlet.http.HttpServletRequest;
import com.group2.bookstore.util.EmailUtility;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import com.group2.bookstore.model.User;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter; // Thêm thư viện này

@WebServlet(name = "ChangeEmailServlet", urlPatterns = { "/change-email" })
public class ChangeEmailServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Cấu hình trả về JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String newEmail = request.getParameter("new_email");
        HttpSession session = request.getSession();
        User u  = (User) session.getAttribute("user");
        
        if (u == null) {
            out.write("{\"success\": false, \"message\": \"Vui lòng đăng nhập lại!\"}");
            return;
        }
        
        String oldEmail = u.getEmail();
        
        // 2. Validate email format
        if (newEmail == null || newEmail.trim().isEmpty() || !newEmail.contains("@") || newEmail.length() > 100) {
            out.write("{\"success\": false, \"message\": \"Email không hợp lệ!\"}");
            return;
        }

        // 3. Trùng với email HIỆN TẠI
        if(newEmail.equals(oldEmail)) {
            out.write("{\"success\": false, \"message\": \"Email mới không được trùng với email hiện tại!\"}");
            return;
        }

        // 4. Email đã bị người khác dùng
        UserDAO dao = new UserDAO();
        User existingUser = dao.checkEmailExist(newEmail);
        if (existingUser != null) {
            out.write("{\"success\": false, \"message\": \"Email này đã được sử dụng bởi một tài khoản khác!\"}");
            return;
        }

        
        String otp = EmailUtility.getRandomOTP();
        EmailUtility.sendEmail(newEmail, otp);

        session.setAttribute("tempEmail", newEmail);
        session.setAttribute("otp", otp); 
        session.setAttribute("otp_time", System.currentTimeMillis()); // Lưu thời gian tạo OTP 1 phút
        
        out.write("{\"success\": true}");
    }
}