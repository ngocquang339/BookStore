package com.group2.bookstore.controller;

import com.group2.bookstore.dal.CartDAO;
import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.CartItem;
import com.group2.bookstore.model.User;
import java.io.IOException;
import java.util.List;
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
        request.getRequestDispatcher("view/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String u = request.getParameter("username");
        String p = request.getParameter("password");

        // 1. Kiểm tra đầu vào rỗng
        if (u == null || u.trim().isEmpty() || p == null || p.trim().isEmpty()) {
            request.setAttribute("mess", "Không được để trống thông tin!");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
            return;
        }

        // 2. Gọi DAO để kiểm tra tài khoản
        UserDAO dao = new UserDAO();
        User account = dao.checkLogin(u, p);

        if (account == null) {
            // Đăng nhập thất bại
            request.setAttribute("mess", "Thông tin đăng nhập không chính xác!");
            request.getRequestDispatcher("view/Login.jsp").forward(request, response);
        } else {
            // Đăng nhập thành công
            HttpSession session = request.getSession();
            session.setAttribute("user", account);

            // ============================================================
            // [MỚI] TÍNH NĂNG GỘP GIỎ HÀNG (SESSION -> DATABASE)
            // ============================================================
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

            if (role == 4) {
                // Warehouse Role (Thủ kho)
                response.sendRedirect("warehouse/dashboard");
            } 
            else if (role == 1) {
                // Admin Role (Quản trị viên)
                response.sendRedirect("admin/dashboard");
            } 
            else {
                // Customer Role (Khách hàng) -> Về trang chủ
                response.sendRedirect("home");
            }
        }
    }
}