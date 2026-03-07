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

// ĐƯỜNG DẪN NÀY PHẢI KHỚP 100% VỚI BIẾN returnUrl ĐÃ GỬI SANG VNPAY
@WebServlet("/vnpay-return")
public class VnpayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        
        // 1. Lấy mã kết quả từ VNPAY (00 là thành công)
        String vnp_ResponseCode = req.getParameter("vnp_ResponseCode");
        String vnp_TransactionNo = req.getParameter("vnp_TransactionNo");

        if ("00".equals(vnp_ResponseCode)) {
            // === THANH TOÁN THÀNH CÔNG ===
            
            // 2. Lấy dữ liệu tạm đã lưu ở Session bên CheckoutServlet ra
            User user = (User) session.getAttribute("user");
            List<CartItem> checkoutCart = (List<CartItem>) session.getAttribute("pending_checkoutCart");
            String receiverName = (String) session.getAttribute("pending_receiverName");
            String shippingAddress = (String) session.getAttribute("pending_shippingAddress");
            String phone = (String) session.getAttribute("pending_phone");
            Double grandTotal = (Double) session.getAttribute("pending_grandTotal");
            
            // 3. Gọi DAO lưu đơn hàng vào Database
            OrderDAO orderDAO = new OrderDAO();
            try {
                // Lưu phương thức là VNPAY kèm mã giao dịch để dễ tra soát
                String paymentMethod = "VNPAY (Mã GD: " + vnp_TransactionNo + ")";
                orderDAO.createOrder(user, checkoutCart, receiverName, shippingAddress, phone, grandTotal, paymentMethod);
                
                // 4. Xóa những món đã thanh toán khỏi giỏ hàng chính trong Session
                List<CartItem> mainCart = (List<CartItem>) session.getAttribute("cart");
                if (mainCart != null && checkoutCart != null) {
                    for (CartItem purchasedItem : checkoutCart) {
                        mainCart.removeIf(item -> item.getBook().getId() == purchasedItem.getBook().getId());
                    }
                }

                // 5. Cập nhật lại giỏ hàng và dọn dẹp biến tạm
                session.setAttribute("cart", mainCart);
                session.removeAttribute("pending_checkoutCart");
                session.removeAttribute("pending_receiverName");
                session.removeAttribute("pending_shippingAddress");
                session.removeAttribute("pending_phone");
                session.removeAttribute("pending_grandTotal");
                session.removeAttribute("checkoutCart");
                session.removeAttribute("grandTotal");

                // 6. Thông báo và đưa về trang chủ
                session.setAttribute("successMsg", "Thanh toán thành công! Mã giao dịch: " + vnp_TransactionNo);
                resp.sendRedirect(req.getContextPath() + "/home");

            } catch (Exception e) {
                e.printStackTrace();
                resp.getWriter().println("Lỗi khi lưu đơn hàng: " + e.getMessage());
            }
        } else {
            // === THANH TOÁN THẤT BẠI HOẶC HỦY ===
            session.setAttribute("errorMsg", "Giao dịch không thành công. Bạn đã hủy thanh toán hoặc có lỗi xảy ra.");
            resp.sendRedirect(req.getContextPath() + "/checkout");
        }
    }
}