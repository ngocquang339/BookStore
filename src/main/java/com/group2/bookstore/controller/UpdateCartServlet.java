package com.group2.bookstore.controller;

import com.group2.bookstore.model.CartItem;
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
        
        String action = request.getParameter("action"); // inc (tăng), dec (giảm), remove (xóa)
        String idStr = request.getParameter("id");      // ID sách cần xử lý

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart != null && idStr != null) {
            try {
                int id = Integer.parseInt(idStr);

                // Duyệt qua giỏ hàng để tìm sản phẩm cần sửa
                for (int i = 0; i < cart.size(); i++) {
                    CartItem item = cart.get(i);
                    
                    if (item.getBook().getId() == id) {
                        // 1. Xử lý TĂNG số lượng
                        if ("inc".equals(action)) {
                            item.setQuantity(item.getQuantity() + 1);
                        } 
                        // 2. Xử lý GIẢM số lượng
                        else if ("dec".equals(action)) {
                            if (item.getQuantity() > 1) {
                                item.setQuantity(item.getQuantity() - 1);
                            } else {
                                // Nếu còn 1 mà bấm giảm -> Xóa luôn
                                cart.remove(i);
                            }
                        } 
                        // 3. Xử lý XÓA hẳn
                        else if ("remove".equals(action)) {
                            cart.remove(i);
                        }
                        break; // Tìm thấy và xử lý xong thì thoát vòng lặp
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Cập nhật lại giỏ hàng vào Session
        session.setAttribute("cart", cart);

        // Quay trở lại trang giỏ hàng
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}