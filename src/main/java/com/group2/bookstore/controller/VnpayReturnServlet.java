package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.dal.VoucherDAO; 
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

@WebServlet("/vnpay-return")
public class VnpayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        
        String vnp_ResponseCode = req.getParameter("vnp_ResponseCode");
        String vnp_TransactionNo = req.getParameter("vnp_TransactionNo");

        // Lôi dữ liệu tạm đã lưu ra để xử lý
        User user = (User) session.getAttribute("user");
        List<CartItem> checkoutCart = (List<CartItem>) session.getAttribute("pending_checkoutCart");
        
        if ("00".equals(vnp_ResponseCode)) {
            // ================= THANH TOÁN THÀNH CÔNG =================
            
            // 1. TRẢ LẠI KHO 1 NHỊP
            BookDAO bookDAO = new BookDAO();
            bookDAO.updateStockForCheckout(checkoutCart, true); 
            
            String receiverName = (String) session.getAttribute("pending_receiverName");
            String shippingAddress = (String) session.getAttribute("pending_shippingAddress");
            String phone = (String) session.getAttribute("pending_phone");
            Double grandTotal = (Double) session.getAttribute("pending_grandTotal");
            
            OrderDAO orderDAO = new OrderDAO();
            try {
                // 2. GỌI TẠO ĐƠN
                String paymentMethod = "VNPAY (Mã GD: " + vnp_TransactionNo + ")";
                int orderStatus = 2; // Đã duyệt
                
                // ==========================================================
                // [MỚI THÊM]: Lấy Voucher ID và Tiền giảm giá từ Session ra
                // ==========================================================
                Integer pendingVoucherId = (Integer) session.getAttribute("pending_voucherId");
                int voucherId = (pendingVoucherId != null) ? pendingVoucherId : 0;
                
                Double pendingDiscount = (Double) session.getAttribute("pending_discount");
                java.math.BigDecimal discountAmount = (pendingDiscount == null) ? java.math.BigDecimal.ZERO : java.math.BigDecimal.valueOf(pendingDiscount);
                
                // TRUYỀN THÊM voucherId VÀ discountAmount VÀO HÀM NÀY
                orderDAO.createOrder(user, checkoutCart, receiverName, shippingAddress, phone, grandTotal, paymentMethod, orderStatus, voucherId, discountAmount);
                // ==========================================================
                
                // 3. XÉ VOUCHER NẾU KHÁCH CÓ DÙNG
                if (voucherId > 0) {
                    VoucherDAO voucherDAO = new VoucherDAO();
                    voucherDAO.markVoucherAsUsed(user.getId(), voucherId);
                }
                // ===============================================================
                //TỰ ĐỘNG CỘNG ĐIỂM F-POINT (CHỈ ÁP DỤNG VNPAY)
                // ===============================================================
                int totalQuantity = 0;
                if (checkoutCart != null) {
                    for (CartItem item : checkoutCart) {
                        totalQuantity += item.getQuantity();
                    }
                }

                int earnedPoints = totalQuantity * 10; // Quy tắc: 1 cuốn = 10 điểm
                if (earnedPoints > 0) {
                    com.group2.bookstore.dal.FPointHistoryDAO historyDAO = new com.group2.bookstore.dal.FPointHistoryDAO();
                    String customerInfo = "@" + user.getUsername() + " (#" + user.getId() + ")";
                    // Ghi chú rõ ràng là thanh toán qua VNPAY
                    String reason = "Tích điểm tự động (Mua " + totalQuantity + " cuốn sách - VNPAY)";
                    
                    com.group2.bookstore.model.FPointHistory log = new com.group2.bookstore.model.FPointHistory(
                            user.getId(), customerInfo, "add", earnedPoints, reason);
                    historyDAO.insertLog(log);
                }
                // 4. Xóa những món đã mua khỏi session giỏ hàng hiện tại
                List<CartItem> mainCart = (List<CartItem>) session.getAttribute("cart");
                if (mainCart != null && checkoutCart != null) {
                    for (CartItem purchasedItem : checkoutCart) {
                        mainCart.removeIf(item -> item.getBook().getId() == purchasedItem.getBook().getId());
                    }
                }
                session.setAttribute("cart", mainCart);

                // Dọn dẹp session tạm
                clearPendingSession(session);

                session.setAttribute("successMsg", "Thanh toán thành công! Mã giao dịch: " + vnp_TransactionNo);
                resp.sendRedirect(req.getContextPath() + "/home");

            } catch (Exception e) {
                e.printStackTrace();
                resp.getWriter().println("Lỗi khi lưu đơn hàng: " + e.getMessage());
            }
            
        } else {
            // ================= THANH TOÁN THẤT BẠI HOẶC HỦY BỎ =================
            
            if (checkoutCart != null) {
                BookDAO bookDAO = new BookDAO();
                bookDAO.updateStockForCheckout(checkoutCart, true); // true = Cộng lại kho
            }

            // Dọn dẹp session tạm
            clearPendingSession(session);

            session.setAttribute("errorMsg", "Giao dịch không thành công. Bạn đã hủy thanh toán hoặc có lỗi xảy ra.");
            resp.sendRedirect(req.getContextPath() + "/checkout");
        }
    }

    // Hàm phụ giúp dọn dẹp Session cho code sạch sẽ
    private void clearPendingSession(HttpSession session) {
        session.removeAttribute("pending_checkoutCart");
        session.removeAttribute("pending_receiverName");
        session.removeAttribute("pending_shippingAddress");
        session.removeAttribute("pending_phone");
        session.removeAttribute("pending_grandTotal");
        session.removeAttribute("pending_paymentMethod");
        session.removeAttribute("pending_voucherId"); 
        session.removeAttribute("pending_discount"); // [MỚI THÊM]: Dọn luôn biến tiền giảm giá
        session.removeAttribute("checkoutCart");
        session.removeAttribute("grandTotal");
    }
}