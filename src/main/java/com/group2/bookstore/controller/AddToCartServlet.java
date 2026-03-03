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
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        if (cart == null) {
            cart = new ArrayList<>();
        }

        try {
            int bookId = Integer.parseInt(request.getParameter("id"));
            String action = request.getParameter("action"); // Lấy hành động (null, inc, dec, update, remove)
            
            BookDAO bookDAO = new BookDAO();
            Book book = bookDAO.getBookById(bookId);

            if (book != null) {
                int stock = book.getStockQuantity(); // Lấy số lượng tồn kho. (Sửa thành tên hàm tồn kho của bạn nếu khác)
                boolean found = false;

                // ==========================================
                // TRƯỜNG HỢP 1: THÊM MỚI (Bấm từ trang chủ / chi tiết)
                // ==========================================
                if (action == null || action.equals("add")) {
                    for (CartItem item : cart) {
                        if (item.getBook().getId() == bookId) {
                            if (item.getQuantity() + 1 > stock) {
                                session.setAttribute("message", "Sản phẩm đã đạt tối đa số lượng tồn kho!");
                                session.setAttribute("messageType", "danger");
                            } else {
                                item.setQuantity(item.getQuantity() + 1);
                                if (user != null) new CartDAO().updateQuantity(user.getId(), bookId, item.getQuantity());
                                session.setAttribute("message", "Đã thêm vào giỏ hàng!");
                                session.setAttribute("messageType", "success");
                            }
                            found = true; 
                            break;
                        }
                    }
                    if (!found) {
                        CartItem newItem = new CartItem(book, 1);
                        cart.add(newItem);
                        if (user != null) new CartDAO().addToCart(user.getId(), newItem);
                        session.setAttribute("message", "Đã thêm vào giỏ hàng!");
                        session.setAttribute("messageType", "success");
                    }
                    
                    session.setAttribute("cart", cart);
                    // Quay lại trang trước đó (Trang chủ hoặc trang chi tiết)
                    String referer = request.getHeader("referer");
                    response.sendRedirect(referer != null ? referer : "home");
                    return;
                } 
                
                // ==========================================
                // TRƯỜNG HỢP 2: CẬP NHẬT TỪ TRANG GIỎ HÀNG (inc, dec, update, remove)
                // ==========================================
                else {
                    for (int i = 0; i < cart.size(); i++) {
                        CartItem item = cart.get(i);
                        if (item.getBook().getId() == bookId) {
                            int currentQty = item.getQuantity();
                            
                            if ("inc".equals(action)) {
                                if (currentQty + 1 > stock) {
                                    session.setAttribute("cartError", "Sản phẩm '" + book.getTitle() + "' đã vượt quá số lượng tồn kho!");
                                } else {
                                    item.setQuantity(currentQty + 1);
                                }
                            } else if ("dec".equals(action)) {
                                if (currentQty - 1 < 1) {
                                    session.setAttribute("cartError", "Số lượng tối thiểu là 1!");
                                } else {
                                    item.setQuantity(currentQty - 1);
                                }
                            } else if ("update".equals(action)) {
                                int newQty = Integer.parseInt(request.getParameter("quantity"));
                                if (newQty < 1) {
                                    session.setAttribute("cartError", "Số lượng tối thiểu là 1!");
                                    item.setQuantity(1);
                                } else if (newQty > stock) {
                                    session.setAttribute("cartError", "Sản phẩm '" + book.getTitle() + "' đã vượt quá số lượng tồn kho!");
                                    item.setQuantity(stock);
                                } else {
                                    item.setQuantity(newQty);
                                }
                            } else if ("remove".equals(action)) {
                                cart.remove(i);
                                // Xóa khỏi DB (bạn cần viết hàm deleteCartItem trong CartDAO nếu chưa có)
                                // if (user != null) new CartDAO().deleteCartItem(user.getId(), bookId);
                                break; 
                            }
                            
                            // Lưu vào DB nếu đã đăng nhập và không phải hành động xóa
                            if (user != null && !"remove".equals(action)) {
                                new CartDAO().updateQuantity(user.getId(), bookId, item.getQuantity());
                            }
                            break; 
                        }
                    }
                    session.setAttribute("cart", cart);
                    // Xử lý xong ở giỏ hàng thì load lại trang giỏ hàng
                    response.sendRedirect("cart");
                    return;
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        response.sendRedirect("home");
    }
}