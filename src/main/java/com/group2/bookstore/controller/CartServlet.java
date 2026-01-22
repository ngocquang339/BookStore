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

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy giỏ hàng từ Session
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        // 2. Tính tổng tiền (Grand Total)
        double grandTotal = 0;
        int totalItems = 0;
        
        if (cart != null && !cart.isEmpty()) {
            for (CartItem item : cart) {
                grandTotal += item.getTotalPrice();
                totalItems += item.getQuantity();
            }
        }

        // 3. Gửi dữ liệu sang JSP
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("totalItems", totalItems);

        // 4. Chuyển hướng về trang giao diện
        // Sửa "cart.jsp" thành "/cart.jsp"
request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
}