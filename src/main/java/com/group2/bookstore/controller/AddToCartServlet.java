package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.dal.CartDAO; // Import mới
import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.CartItem;
import com.group2.bookstore.model.User; // Import User
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        try {
            int bookId = Integer.parseInt(request.getParameter("id"));
            BookDAO bookDAO = new BookDAO();
            Book book = bookDAO.getBookById(bookId);

            if (book != null) {
                CartItem newItem = new CartItem(book, 1);

                if (user != null) {
                    // 1. Thêm vào DB
                    CartDAO cartDao = new CartDAO();
                    cartDao.addToCart(user.getId(), newItem);
                    
                    // 2. CẬP NHẬT LẠI SESSION TỪ DB (Đảm bảo dữ liệu mới nhất)
                    List<CartItem> updatedCart = cartDao.getCartByUserId(user.getId());
                    session.setAttribute("cart", updatedCart);
                } else {
                    // Logic cho khách vãng lai (Guest)
                    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
                    if (cart == null) cart = new ArrayList<>();
                    boolean found = false;
                    for (CartItem item : cart) {
                        if (item.getBook().getId() == bookId) {
                            item.setQuantity(item.getQuantity() + 1);
                            found = true; break;
                        }
                    }
                    if (!found) cart.add(newItem);
                    session.setAttribute("cart", cart);
                }
                session.setAttribute("message", "Đã thêm vào giỏ hàng!");
            }
        } catch (Exception e) { e.printStackTrace(); }
        response.sendRedirect("home");
    }
}