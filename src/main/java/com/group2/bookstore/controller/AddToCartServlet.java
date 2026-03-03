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

        // 1. Lấy ID sách (Kèm bẫy lỗi nếu ID không hợp lệ)
        int bookId = 0;
        try {
            bookId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
            return;
        }

        // 2. Lấy số lượng (Mặc định là 1)
        int quantity = 1;
        String qtyRaw = request.getParameter("quantity");
        if (qtyRaw != null && !qtyRaw.isEmpty()) {
            try {
                quantity = Integer.parseInt(qtyRaw);
            } catch (Exception e) {
                quantity = 1;
            }
        }

        // 3. Lấy hành động (add, inc, dec, update, remove)
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "add"; // Mặc định là thêm mới
        }

        // 4. Khởi tạo/Lấy giỏ hàng từ Session
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        try {
            BookDAO bookDAO = new BookDAO();
            Book book = bookDAO.getBookById(bookId);
            CartDAO cartDao = new CartDAO();

            if (book != null) {
                int stock = book.getStockQuantity();
                boolean found = false;

                // ==========================================
                // TRƯỜNG HỢP 1: THÊM MỚI (Bấm từ trang chủ / chi tiết)
                // ==========================================
                if ("add".equals(action)) {
                    for (CartItem item : cart) {
                        if (item.getBook().getId() == bookId) {
                            // Cộng thêm số lượng mới vào số lượng cũ
                            int newTotalQty = item.getQuantity() + quantity;
                            
                            if (newTotalQty > stock) {
                                session.setAttribute("message", "Sản phẩm đã đạt tối đa số lượng tồn kho!");
                                session.setAttribute("messageType", "danger");
                            } else {
                                item.setQuantity(newTotalQty);
                                if (user != null) {
                                    cartDao.updateQuantity(user.getId(), bookId, item.getQuantity());
                                }
                                session.setAttribute("message", "Đã thêm vào giỏ hàng!");
                                session.setAttribute("messageType", "success");
                            }
                            found = true; 
                            break;
                        }
                    }

                    if (!found) {
                        // Rào lỗi nếu khách cố tình nhập số lượng mua lớn hơn kho ngay từ đầu
                        if (quantity > stock) {
                            quantity = stock;
                            session.setAttribute("message", "Chỉ còn " + stock + " sản phẩm trong kho!");
                            session.setAttribute("messageType", "warning");
                        } else {
                            session.setAttribute("message", "Đã thêm vào giỏ hàng!");
                            session.setAttribute("messageType", "success");
                        }
                        
                        CartItem newItem = new CartItem(book, quantity);
                        cart.add(newItem);
                        if (user != null) {
                            cartDao.addToCart(user.getId(), newItem);
                        }
                    }
                    
                    // Cập nhật lại session
                    session.setAttribute("cart", cart);

                    // XỬ LÝ TRẢ VỀ CHO MÀN HÌNH
                    String isAjax = request.getParameter("ajax");
                    if ("true".equals(isAjax)) {
                        // Nếu gọi từ AJAX -> Trả về số lượng loại sách trong giỏ và DỪNG LẠI
                        response.setContentType("text/plain");
                        response.getWriter().write(String.valueOf(cart.size()));
                        return; 
                    } else {
                        // Nếu không phải AJAX -> Quay lại trang vừa đứng
                        String referer = request.getHeader("referer");
                        response.sendRedirect(referer != null ? referer : "home");
                        return;
                    }
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
                                int newQty = quantity; // Lấy từ tham số quantity gửi lên
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
                                // Bỏ comment dòng bên dưới nếu bạn có hàm xóa trong Database
                                // if (user != null) cartDao.deleteCartItem(user.getId(), bookId);
                                break; 
                            }
                            
                            // Lưu vào DB nếu đã đăng nhập và không phải hành động xóa
                            if (user != null && !"remove".equals(action)) {
                                cartDao.updateQuantity(user.getId(), bookId, item.getQuantity());
                            }
                            break; 
                        }
                    }
                    session.setAttribute("cart", cart);
                    response.sendRedirect("cart"); // Trả thẳng về trang giỏ hàng
                    return;
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        
        // Dùng làm Fallback cuối cùng nếu mọi thứ bên trên không khớp
        response.sendRedirect("detail?id=" + bookId);
    }
}