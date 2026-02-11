package com.group2.bookstore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.group2.bookstore.model.User;
import com.group2.bookstore.dal.UserDAO;

@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // 1. Lấy mã người dùng nhập và mã trong Session
        String userOtp = request.getParameter("userOtp");
        String serverOtp = (String) session.getAttribute("otp");
        User tempUser = (User) session.getAttribute("tempUser");

        // 2. Kiểm tra
        if (userOtp.equals(serverOtp)) {
            // --- THÀNH CÔNG ---
            
            // Gọi DAO để lưu tempUser vào Database chính thức
            UserDAO dao = new UserDAO();
            dao.createUser(tempUser);
            
            // Xóa session tạm
            session.removeAttribute("otp");
            session.removeAttribute("tempUser");
            
            // Thông báo và chuyển về Login
            request.setAttribute("message", "Đăng ký thành công! Hãy đăng nhập.");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            
        } else {
            // --- THẤT BẠI ---
            request.setAttribute("error", "Mã xác thực không đúng!");
            request.getRequestDispatcher("view/verify-otp.jsp").forward(request, response);
        }
    }
}