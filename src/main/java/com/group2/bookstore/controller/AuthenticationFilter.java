package com.group2.bookstore.controller; // Sửa lại package cho đúng với project của bạn

import com.group2.bookstore.model.User; // Nhớ import model User của bạn
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

// KHAI BÁO NHỮNG ĐƯỜNG LINK CẦN BẢO VỆ Ở ĐÂY
@WebFilter(urlPatterns = {"/update-profile", "/address", "/logout", "/support", "/my-collections", "/user/voucher-wallet", "/change-password", "/checkout", "/my-orders", "/my-comments", "/notifications"}) 
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo Filter (không cần viết gì)
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        // 1. KIỂM TRA ĐĂNG NHẬP
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (!isLoggedIn) {
            // Nếu chưa đăng nhập -> Đá về trang Login kèm thông báo
            req.setAttribute("mess", "Vui lòng đăng nhập để truy cập trang này!");
            res.sendRedirect("login"); // Chuyển hướng về trang Login
            return; // Dừng lại, không cho đi tiếp
        }

        // 2. NẾU ĐÃ ĐĂNG NHẬP -> GẮN BÙA CHỐNG CACHE (ĐỂ CHỐNG NÚT BACK KHI LOGOUT)
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        res.setHeader("Pragma", "no-cache"); // HTTP 1.0
        res.setDateHeader("Expires", 0); // Proxies

        // 3. MỞ CỔNG CHO ĐI TIẾP VÀO SERVLET
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Hủy Filter (không cần viết gì)
    }
}