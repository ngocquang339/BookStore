package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.dal.CartDAO;
import com.group2.bookstore.model.Book;
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

@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {
    
    // VAI TRÒ: CHỈ XỬ LÝ VIỆC THÊM SẢN PHẨM MỚI TỪ TRANG CHI TIẾT
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Lấy thông tin từ trang Chi tiết sản phẩm
        int bookId;
        int quantity = 1;
        try {
            bookId = Integer.parseInt(request.getParameter("id"));
            String qStr = request.getParameter("quantity");
            if (qStr != null && !qStr.isEmpty()) {
                quantity = Integer.parseInt(qStr);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
            return;
        }

        // 2. Kiểm tra sách trong Database
        BookDAO bookDAO = new BookDAO();
        Book book = bookDAO.getBookById(bookId);
        if (book == null) {
            response.sendRedirect("home");
            return;
        }

        int stock = book.getStockQuantity();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        boolean found = false;
        // 3. Logic: Nếu đã có thì cộng dồn số lượng
        for (CartItem item : cart) {
            if (item.getBook().getId() == bookId) {
                int newQty = item.getQuantity() + quantity;
                if (newQty > stock) {
                    item.setQuantity(stock);
                    session.setAttribute("message", "Sản phẩm đạt giới hạn tồn kho!");
                    session.setAttribute("messageType", "warning");
                } else {
                    item.setQuantity(newQty);
                    session.setAttribute("message", "Đã cập nhật giỏ hàng!");
                    session.setAttribute("messageType", "success");
                }
                if (user != null) {
                    new CartDAO().updateQuantity(user.getId(), bookId, item.getQuantity());
                }
                found = true;
                break;
            }
        }

        // 4. Nếu chưa có thì thêm mới vào đầu danh sách
        if (!found) {
            if (quantity > stock) quantity = stock;
            CartItem newItem = new CartItem(book, quantity);
            cart.add(0, newItem); 
            if (user != null) {
                new CartDAO().addToCart(user.getId(), newItem);
            }
            session.setAttribute("message", "Đã thêm vào giỏ hàng!");
            session.setAttribute("messageType", "success");
        }

        session.setAttribute("cart", cart);

        // 5. Điều hướng trả về
        String purchase = request.getParameter("purchase");
        if ("1".equals(purchase)) {
            response.sendRedirect("cart");
        } else if ("true".equals(request.getParameter("ajax"))) {
            response.setContentType("text/plain");
            response.getWriter().write(String.valueOf(cart.size()));
        } else {
            String referer = request.getHeader("referer");
            response.sendRedirect(referer != null ? referer : "home");
        }
    }
}