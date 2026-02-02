package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.dal.CartDAO;
import com.group2.bookstore.model.Book;
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

@WebServlet("/update-cart")
public class UpdateCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action"); // inc, dec, remove, update
        String idStr = request.getParameter("id");
        String qtyStr = request.getParameter("quantity"); // Số lượng nhập trực tiếp

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user"); // Lấy thông tin người dùng
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                
                // 1. Lấy thông tin tồn kho để kiểm tra
                BookDAO bookDao = new BookDAO();
                Book bookInDb = bookDao.getBookById(id);
                int stock = (bookInDb != null) ? bookInDb.getStockQuantity() : 0;

                // Biến lưu trạng thái xử lý
                int newQuantity = -1; 
                boolean isRemove = false; 

                // 2. Tìm sản phẩm trong giỏ (Session) để lấy số lượng hiện tại
                // Dù là User hay Guest thì vẫn cần bước này để biết đang thao tác với cái gì
                CartItem currentItem = null;
                if (cart != null) {
                    for (CartItem item : cart) {
                        if (item.getBook().getId() == id) {
                            currentItem = item;
                            break;
                        }
                    }
                }

                if (currentItem != null) {
                    int currentQty = currentItem.getQuantity();

                    // --- LOGIC TÍNH TOÁN SỐ LƯỢNG MỚI ---
                    if ("inc".equals(action)) {
                        // Tăng 1
                        if (currentQty < stock) {
                            newQuantity = currentQty + 1;
                        } else {
                            session.setAttribute("message", "Kho chỉ còn " + stock + " sản phẩm!");
                            session.setAttribute("messageType", "danger");
                        }
                    } else if ("dec".equals(action)) {
                        // Giảm 1
                        if (currentQty > 1) {
                            newQuantity = currentQty - 1;
                        } else {
                            isRemove = true; // Giảm về 0 thì xóa
                        }
                    } else if ("remove".equals(action)) {
                        // Xóa
                        isRemove = true;
                    } else if ("update".equals(action) && qtyStr != null) {
                        // Nhập số trực tiếp
                        try {
                            int inputQty = Integer.parseInt(qtyStr);
                            if (inputQty <= 0) {
                                session.setAttribute("message", "Phải mua ít nhất 1 sản phẩm!");
                                session.setAttribute("messageType", "danger");
                            } else if (inputQty > stock) {
                                session.setAttribute("message", "Số lượng quá số lượng trong kho hàng (Kho còn: " + stock + ")!");
                                session.setAttribute("messageType", "danger");
                                // newQuantity = stock; // (Optional: Tự sửa thành max kho)
                            } else {
                                newQuantity = inputQty;
                            }
                        } catch (NumberFormatException e) {
                            // Nhập bậy thì bỏ qua
                        }
                    }

                    // --- 3. CẬP NHẬT DỮ LIỆU ---
                    
                    // TRƯỜNG HỢP A: ĐÃ ĐĂNG NHẬP (USER) -> GỌI DATABASE
                    if (user != null) {
                        CartDAO cartDao = new CartDAO();
                        if (isRemove) {
                            cartDao.removeItem(user.getId(), id); // Dùng getUser_id() nếu model của bạn đặt thế
                        } else if (newQuantity != -1) {
                            cartDao.updateQuantity(user.getId(), id, newQuantity);
                        }
                        
                        // Quan trọng: Load lại toàn bộ giỏ từ DB để đồng bộ Session
                        List<CartItem> updatedCart = cartDao.getCartByUserId(user.getId());
                        session.setAttribute("cart", updatedCart);
                    } 
                    // TRƯỜNG HỢP B: KHÁCH VÃNG LAI (GUEST) -> SỬA SESSION
                    else {
                        if (isRemove) {
                            cart.remove(currentItem);
                        } else if (newQuantity != -1) {
                            currentItem.setQuantity(newQuantity);
                        }
                        // Lưu lại Session
                        session.setAttribute("cart", cart);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Chuyển hướng về trang giỏ hàng
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}