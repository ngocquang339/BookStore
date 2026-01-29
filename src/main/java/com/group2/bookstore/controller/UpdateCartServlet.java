package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.dal.CartDAO; // Import mới
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
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        String qtyStr = request.getParameter("quantity");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user"); // Lấy user
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart != null && idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                
                // Logic xử lý số lượng (Giữ nguyên logic cũ để tính toán newQty)
                // ... (Bạn có thể copy lại đoạn check tồn kho ở câu trả lời trước) ...
                // Ở đây mình viết gọn logic update DB:

                int newQuantity = -1; // -1 nghĩa là không đổi/hoặc xóa
                boolean isRemove = false;

                // Tìm item trong list để lấy số lượng hiện tại
                for (CartItem item : cart) {
                    if (item.getBook().getId() == id) {
                        if ("inc".equals(action)) newQuantity = item.getQuantity() + 1;
                        if ("dec".equals(action)) newQuantity = item.getQuantity() - 1;
                        if ("update".equals(action) && qtyStr != null) newQuantity = Integer.parseInt(qtyStr);
                        if ("remove".equals(action)) isRemove = true;
                        
                        // Check tồn kho ở đây (nếu cần thiết)
                        // ...
                        break;
                    }
                }

                // CẬP NHẬT DATABASE (NẾU LOGIN)
                if (user != null) {
                    CartDAO cartDao = new CartDAO();
                    if (isRemove || newQuantity == 0) {
                        cartDao.removeItem(user.getId(), id);
                    } else if (newQuantity > 0) {
                        cartDao.updateQuantity(user.getId(), id, newQuantity);
                    }
                    // Load lại từ DB để đồng bộ
                    session.setAttribute("cart", cartDao.getCartByUserId(user.getId()));
                
                } else {
                    // CẬP NHẬT SESSION (NẾU GUEST) - Giữ nguyên logic cũ của bạn
                    // (Bạn copy lại logic for loop update session ở bài trước vào đây)
                    // ...
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}