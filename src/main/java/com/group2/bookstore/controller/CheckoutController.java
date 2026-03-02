package com.group2.bookstore.controller;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.model.CartItem;
import com.group2.bookstore.model.User;
import java.io.IOException;
import java.util.ArrayList;
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
        
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // 1. NHẬN DANH SÁCH ID SẢN PHẨM KHÁCH ĐÃ TÍCH CHỌN TỪ FORM
        String[] selectedItems = req.getParameterValues("selectedItems");
        
        // 2. NẾU KHÁCH KHÔNG TÍCH MÓN NÀO MÀ BẤM THANH TOÁN -> ĐUỔI VỀ KÈM BÁO LỖI
        if (selectedItems == null || selectedItems.length == 0) {
            session.setAttribute("cartError", "Vui lòng tích chọn ít nhất 1 sản phẩm để thanh toán!");
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // 3. TẠO GIỎ HÀNG CHỜ THANH TOÁN (Chỉ chứa các món đã tích)
        List<CartItem> checkoutCart = new ArrayList<>();
        double checkoutTotal = 0.0;

        for (String idStr : selectedItems) {
            try {
                int bookId = Integer.parseInt(idStr);
                for (CartItem item : cart) {
                    // Nếu ID sách trong giỏ chính khớp với ID khách đã tích chọn
                    if (item.getBook().getId() == bookId) {
                        checkoutCart.add(item);
                        checkoutTotal += (item.getQuantity() * item.getBook().getPrice());
                        break;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 4. LƯU GIỎ HÀNG TẠM VÀO SESSION ĐỂ TRANG CHECKOUT.JSP HIỂN THỊ
        session.setAttribute("checkoutCart", checkoutCart);
        session.setAttribute("grandTotal", checkoutTotal); // Ghi đè tổng tiền mới

        req.getRequestDispatcher("/view/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        
        // Lấy giỏ hàng CHỜ THANH TOÁN (chỉ chứa các món đã chọn)
        List<CartItem> checkoutCart = (List<CartItem>) session.getAttribute("checkoutCart");
        List<CartItem> mainCart = (List<CartItem>) session.getAttribute("cart");

        if (user == null || checkoutCart == null || checkoutCart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String paymentMethod = req.getParameter("paymentMethod");

        boolean hasError = false;

        // VALIDATION (Kiểm tra dữ liệu)
        if (fullname != null) {
            if (fullname.matches(".*\\d.*")) { 
                req.setAttribute("nameError", "Họ tên không được bao gồm chữ số.");
             hasError = true; 
            }
            else if (fullname.trim().length() > 50) { 
                req.setAttribute("nameError", "Họ và tên không hợp lệ (vượt quá 50 ký tự)."); 
                hasError = true; 
            }
        }

        if (phone != null) {
            if (phone.matches(".*\\D.*")) { req.setAttribute("phoneError", "Số điện thoại chỉ được nhập chữ số."); hasError = true; }
            else if (!phone.matches("^0\\d{9}$")) { req.setAttribute("phoneError", "Số điện thoại phải gồm đúng 10 chữ số và bắt đầu bằng số 0."); hasError = true; }
        }

        if (address != null && address.trim().length() > 100) {
            req.setAttribute("addressError", "Địa chỉ không hợp lệ (vượt quá 100 ký tự)."); hasError = true;
        }

        // NẾU LỖI -> TRẢ VỀ CHECKOUT
        if (hasError) {
            req.setAttribute("fullnameInput", fullname);
            req.setAttribute("phoneInput", phone);
            req.setAttribute("addressInput", address);
            req.getRequestDispatcher("/view/checkout.jsp").forward(req, resp);
            return;
        }

        // NẾU THÀNH CÔNG -> LƯU ĐƠN HÀNG
        try {
            Double grandTotal = (Double) session.getAttribute("grandTotal");
            OrderDAO dao = new OrderDAO();
            
            // Lưu những món trong checkoutCart vào DB
            dao.createOrder(user, checkoutCart, address, phone, grandTotal, paymentMethod);

            // LOGIC QUAN TRỌNG: Chỉ xóa những món đã thanh toán khỏi giỏ hàng gốc
            if (mainCart != null) {
                for (CartItem purchasedItem : checkoutCart) {
                    mainCart.removeIf(item -> item.getBook().getId() == purchasedItem.getBook().getId());
                }
            }

            // Cập nhật lại giỏ hàng chính, dọn dẹp biến tạm
            session.setAttribute("cart", mainCart);
            session.removeAttribute("checkoutCart");
            session.removeAttribute("grandTotal");

            req.getSession().setAttribute("successMsg", "Đặt hàng thành công!");
            resp.sendRedirect(req.getContextPath() + "/home");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("addressError", "Hệ thống đang bận, vui lòng thử lại sau!");
            req.getRequestDispatcher("/view/checkout.jsp").forward(req, resp);
        }
    }
}