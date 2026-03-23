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
        
        try {
            // ============================================================
            // [BỔ SUNG EX 1] XÓA CACHE TRÌNH DUYỆT (CHỐNG NÚT BACK)
            // ============================================================
            // Ép trình duyệt không được lưu lại trang này vào bộ nhớ tạm.
            // Nếu khách bấm nút Back, trình duyệt buộc phải hỏi lại Server và sẽ bị đuổi ra Login.
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // Dành cho HTTP 1.1
            response.setHeader("Pragma", "no-cache"); // Dành cho HTTP 1.0
            response.setDateHeader("Expires", 0); // Dành cho Proxies

            // 1. Hủy Session hiện tại
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }

            // ============================================================
            // 2. Xóa Cookie "Remember Me" (SỬA LỖI ĐỒNG BỘ TÊN COOKIE)
            // ============================================================
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    // Đã sửa lại đúng tên Cookie bạn tạo ở LoginServlet
                    if (cookie.getName().equals("rememberedUser") || cookie.getName().equals("rememberedPass")) {
                        cookie.setMaxAge(0); // Set thời gian sống = 0 để xóa ngay lập tức
                        cookie.setPath("/"); // Phải có dòng này để đảm bảo xóa sạch cookie trên toàn bộ trang web
                        response.addCookie(cookie);
                    }
                }
            }

            // 3. Chuyển hướng người dùng về trang chủ
            response.sendRedirect("home");

        } catch (Exception e) {
            // ============================================================
            // [BỔ SUNG EX 2] BẮT LỖI HỦY SESSION THẤT BẠI
            // ============================================================
            e.printStackTrace(); // Ghi log lỗi cho Developer
            
            // Trả về trang đăng nhập kèm thông báo lỗi như tài liệu yêu cầu
            request.setAttribute("mess", "Unable to logout at this time. Please try again.");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}