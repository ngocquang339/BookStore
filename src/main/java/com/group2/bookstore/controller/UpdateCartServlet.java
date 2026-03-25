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

    // VAI TRÒ: QUẢN LÝ (TĂNG, GIẢM, XÓA, UPDATE) SẢN PHẨM TRONG GIỎ HÀNG
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        String action = request.getParameter("action"); // inc, dec, remove, update
        String idStr = request.getParameter("id");
        
        if (idStr == null || cart == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        try {
            int bookId = Integer.parseInt(idStr);
            Book bookInDb = new BookDAO().getBookById(bookId);
            int stock = (bookInDb != null) ? bookInDb.getStockQuantity() : 0;

            for (int i = 0; i < cart.size(); i++) {
                CartItem item = cart.get(i);
                if (item.getBook().getId() == bookId) {
                    boolean isRemoved = false;

                    if ("inc".equals(action)) {
                        if (item.getQuantity() < stock) {
                            item.setQuantity(item.getQuantity() + 1);
                        } else {
                            // Cập nhật câu báo lỗi chuẩn giống hệt video
                            session.setAttribute("cartError", "Sản phẩm '" + bookInDb.getTitle() + "' đã vượt quá số lượng tồn kho!");
                        }
                    } 
                    else if ("dec".equals(action)) {
                        if (item.getQuantity() > 1) {
                            item.setQuantity(item.getQuantity() - 1);
                        } else {
                            // Không xóa sản phẩm, chỉ báo lỗi nếu số lượng đã là 1 mà cố tình nhấn giảm
                            session.setAttribute("cartError", "Số lượng tối thiểu phải là 1!");
                        }
                    } 
                    else if ("remove".equals(action)) {
                        cart.remove(i);
                        if (user != null) new CartDAO().removeItem(user.getId(), bookId);
                        isRemoved = true;
                    }
                    else if ("update".equals(action)) {
                        try {
                            int newQty = Integer.parseInt(request.getParameter("quantity"));
                            if (newQty < 1) {
                                session.setAttribute("cartError", "Số lượng tối thiểu phải là 1!");
                                item.setQuantity(1);
                            } else if (newQty > stock) {
                                // Thông báo lỗi đầy đủ giống trong video
                                session.setAttribute("cartError", "Sản phẩm '" + bookInDb.getTitle() + "' đã vượt quá số lượng tồn kho!");
                                item.setQuantity(stock);
                            } else {
                                item.setQuantity(newQty);
                            }
                        } catch (Exception e) {
                            session.setAttribute("cartError", "Số lượng không hợp lệ!");
                        }
                    }

                    // Đồng bộ dữ liệu Database nếu người dùng đã đăng nhập và sản phẩm chưa bị xóa
                    if (!isRemoved && user != null) {
                        new CartDAO().updateQuantity(user.getId(), bookId, item.getQuantity());
                    }
                    break;
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        session.setAttribute("cart", cart);
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}