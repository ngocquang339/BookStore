package com.group2.bookstore.controller;

import com.group2.bookstore.dal.OrderDAO;
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

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        
        // 1. Kiểm tra đăng nhập
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Kiểm tra giỏ hàng rỗng
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        req.getRequestDispatcher("/view/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        // Bảo vệ hệ thống
        if (user == null || cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // 1. Lấy dữ liệu người dùng nhập
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String paymentMethod = req.getParameter("paymentMethod");

        boolean hasError = false;

        // ==========================================
        // 2. LOGIC KIỂM TRA (VALIDATION BẰNG JAVA)
        // ==========================================
        
        // A. Kiểm tra Họ tên
        if (fullname != null) {
            if (fullname.matches(".*\\d.*")) { 
                req.setAttribute("nameError", "Họ tên không được bao gồm chữ số.");
                hasError = true;
            } else if (fullname.trim().length() > 50) { 
                req.setAttribute("nameError", "Họ và tên không hợp lệ (vượt quá 50 ký tự).");
                hasError = true;
            }
        }

        // B. Kiểm tra Số điện thoại
        if (phone != null) {
            if (phone.matches(".*\\D.*")) { // Có ký tự không phải số
                req.setAttribute("phoneError", "Số điện thoại chỉ được nhập chữ số.");
                hasError = true;
            } else if (!phone.matches("^0\\d{9}$")) { // Không đúng định dạng 10 số đầu 0
                req.setAttribute("phoneError", "Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0.");
                hasError = true;
            }
        }

        // C. Kiểm tra Địa chỉ
        if (address != null && address.trim().length() > 100) {
            req.setAttribute("addressError", "Địa chỉ không hợp lệ (vượt quá 100 ký tự).");
            hasError = true;
        }

        // ==========================================
        // 3. XỬ LÝ NẾU CÓ LỖI XẢY RA
        // ==========================================
        if (hasError) {
            // Giữ lại dữ liệu người dùng vừa nhập để không bị mất
            req.setAttribute("fullnameInput", fullname);
            req.setAttribute("phoneInput", phone);
            req.setAttribute("addressInput", address);
            
            // Forward về lại trang checkout để hiển thị lỗi
            req.getRequestDispatcher("/view/checkout.jsp").forward(req, resp);
            return; // Đảm bảo DỪNG CODE tại đây, không lưu đơn hàng rác
        }

        // ==========================================
        // 4. XỬ LÝ LƯU ĐƠN HÀNG THÀNH CÔNG
        // ==========================================
        try {
            Double grandTotal = (Double) session.getAttribute("grandTotal");
            if (grandTotal == null) {
                grandTotal = 0.0;
                for (CartItem item : cart) {
                    grandTotal += item.getQuantity() * item.getBook().getPrice();
                }
            }

            OrderDAO dao = new OrderDAO();
            dao.createOrder(user, cart, address, phone, grandTotal, paymentMethod);

            // Xóa giỏ hàng
            session.removeAttribute("cart");
            session.removeAttribute("grandTotal");

            // Chuyển hướng sang trang mua thành công hoặc trang chủ
            req.getSession().setAttribute("successMsg", "Đặt hàng thành công!");
            resp.sendRedirect(req.getContextPath() + "/home");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("addressError", "Hệ thống đang bận, vui lòng thử lại sau!");
            req.getRequestDispatcher("/view/checkout.jsp").forward(req, resp);
        }
    }
}