package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.CartDAO;
import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.CartItem;
import com.group2.bookstore.model.User;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = { "/login" })
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("rememberedUser".equals(cookie.getName())) {
                        request.setAttribute("savedUser", cookie.getValue());
                    }
                }
            }
            BookDAO dao = new BookDAO();
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            int roleId = 0;
            if(currentUser != null){
                roleId = currentUser.getRole();
            }
            List<Book> list = dao.getRandomBook(roleId, 20);
            request.setAttribute("suggestedBooks", list);
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String u = request.getParameter("username");
        String p = request.getParameter("password");

        
        if (u == null || u.trim().isEmpty() || p == null || p.trim().isEmpty() || u.contains(" ") || p.contains(" ") || u.length() < 1  || u.length() > 50|| p.length() < 3 || p.length() > 50) {
            request.setAttribute("mess", "Thông tin không hợp lệ!");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        
        UserDAO dao = new UserDAO();
        User account = dao.checkLogin(u, p);

        if (account == null) {
            
            request.setAttribute("mess", "Thông tin đăng nhập không chính xác!");
            System.out.println("===> DEBUG: Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
        } else {
            System.out.println("===> DEBUG: Đăng nhập thành công! Role của người này là: " + account.getRole());
            if (account.getStatus() == 0) { 
                request.setAttribute("mess", "Tài khoản của bạn đã bị khóa! Vui lòng liên hệ Admin để được hỗ trợ.");
                request.getRequestDispatcher("view/Login.jsp").forward(request, response);
                return; 
            }
            
            HttpSession session = request.getSession();
            
            session.setAttribute("user", account);
            String remember = request.getParameter("remember");
            if ("true".equals(remember)) {
                
                Cookie userCookie = new Cookie("rememberedUser", u);
                userCookie.setMaxAge(60 * 60 * 24 * 7); 
                response.addCookie(userCookie);
            } else {
                Cookie userCookie = new Cookie("rememberedUser", "");
                userCookie.setMaxAge(0);
                response.addCookie(userCookie);
            }

            
            try {
                CartDAO cartDao = new CartDAO();
                
                // A. Lấy giỏ hàng tạm (Lúc khách chưa đăng nhập)
                List<CartItem> sessionCart = (List<CartItem>) session.getAttribute("cart");
                
                // B. Nếu có hàng trong giỏ tạm -> Đẩy hết vào Database của User này
                if (sessionCart != null && !sessionCart.isEmpty()) {
                    for (CartItem item : sessionCart) {
                        // Hàm này tự xử lý: Chưa có thì Insert, Có rồi thì Update cộng dồn
                        cartDao.addToCart(account.getId(), item); 
                    }
                }
                
                // C. Lấy lại giỏ hàng đầy đủ từ Database lên Session để hiển thị
                // (Bao gồm cả món cũ trong DB và món mới vừa thêm)
                List<CartItem> dbCart = cartDao.getCartByUserId(account.getId());
                session.setAttribute("cart", dbCart);
                
            } catch (Exception e) {
                e.printStackTrace(); // Ghi log lỗi nếu có vấn đề với giỏ hàng
            }
            // ============================================================

            // 3. Phân quyền và Chuyển hướng (Redirect based on Role)
            int role = account.getRole();

            if (role == 2) {
                response.sendRedirect("warehouse/dashboard");
            } 
            
            else {
                response.sendRedirect("home");
            }
        }
    }
}