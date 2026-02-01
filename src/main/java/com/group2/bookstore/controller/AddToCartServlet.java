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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user"); // Kiểm tra đăng nhập

        try {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                int bookId = Integer.parseInt(idStr);
                
                // Lấy thông tin sách
                BookDAO bookDAO = new BookDAO();
                Book book = bookDAO.getBookById(bookId);

                if (book != null) {
                    CartItem newItem = new CartItem(book, 1);

                    // ==========================================
                    // LOGIC QUAN TRỌNG: CHECK LOGIN
                    // ==========================================
                    if (user != null) {
                        // 1. Nếu ĐÃ ĐĂNG NHẬP -> Lưu thẳng vào Database
                        CartDAO cartDao = new CartDAO();
                        cartDao.addToCart(user.getId(), newItem); // User.getId() tùy model của bạn
                        
                        // Cập nhật lại session để hiển thị ngay
                        session.setAttribute("cart", cartDao.getCartByUserId(user.getId()));
                        
                    } else {
                        // 2. Nếu CHƯA ĐĂNG NHẬP (GUEST) -> Lưu vào Session như cũ
                        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
                        if (cart == null) cart = new ArrayList<>();
                        
                        boolean found = false;
                        for (CartItem item : cart) {
                            if (item.getBook().getId() == bookId) {
                                item.setQuantity(item.getQuantity() + 1);
                                found = true;
                                break;
                            }
                        }
                        if (!found) cart.add(newItem);
                        session.setAttribute("cart", cart);
                    }

                    session.setAttribute("message", "Đã thêm vào giỏ hàng!");
                    session.setAttribute("messageType", "success");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/home");
    }
}