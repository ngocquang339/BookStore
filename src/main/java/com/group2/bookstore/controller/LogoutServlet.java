package com.group2.bookstore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy phiên làm việc hiện tại (Session)
        // Tham số 'false' nghĩa là: Nếu chưa có session thì đừng tạo mới (vì sắp logout rồi tạo làm gì)
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // 2. Hủy session (Quan trọng nhất)
            // Lệnh này sẽ xóa sạch biến 'user' và mọi dữ liệu khác trong session
            session.invalidate();
        }

        // 3. Xóa Cookie "Remember Me" (Nếu bạn có làm chức năng Nhớ mật khẩu)
        // Nếu không làm chức năng Remember Me thì có thể bỏ qua bước 3 này
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("cuser") || cookie.getName().equals("cpass") || cookie.getName().equals("cremember")) {
                    cookie.setMaxAge(0); // Set thời gian sống = 0 để trình duyệt xóa ngay lập tức
                    response.addCookie(cookie);
                }
            }
        }

        // 4. Chuyển hướng người dùng về trang chủ hoặc trang đăng nhập
        response.sendRedirect("home");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
