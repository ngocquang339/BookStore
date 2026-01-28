package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.model.Book;
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
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        String qtyStr = request.getParameter("quantity"); // Nhận số lượng từ ô nhập

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart != null && idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                
                // Lấy thông tin sách để check tồn kho
                BookDAO dao = new BookDAO();
                Book bookInDb = dao.getBookById(id);
                int stock = (bookInDb != null) ? bookInDb.getStockQuantity() : 0;

                for (int i = 0; i < cart.size(); i++) {
                    CartItem item = cart.get(i);
                    if (item.getBook().getId() == id) {
                        
                        // 1. TĂNG SỐ LƯỢNG (Nút +)
                        if ("inc".equals(action)) {
                            if (item.getQuantity() < stock) {
                                item.setQuantity(item.getQuantity() + 1);
                            } else {
                                session.setAttribute("message", "Kho chỉ còn " + stock + " sản phẩm!");
                                session.setAttribute("messageType", "danger");
                            }
                        } 
                        // 2. GIẢM SỐ LƯỢNG (Nút -)
                        else if ("dec".equals(action)) {
                            if (item.getQuantity() > 1) {
                                item.setQuantity(item.getQuantity() - 1);
                            } else {
                                cart.remove(i);
                            }
                        } 
                        // 3. XÓA SẢN PHẨM (Nút thùng rác)
                        else if ("remove".equals(action)) {
                            cart.remove(i);
                        }
                        // 4. NHẬP SỐ LƯỢNG TRỰC TIẾP (MỚI)
                        else if ("update".equals(action) && qtyStr != null) {
                            try {
                                int newQty = Integer.parseInt(qtyStr);
                                if (newQty <= 0) {
                                    session.setAttribute("message", "Số lượng phải lớn hơn 0!");
                                    session.setAttribute("messageType", "danger");
                                } else if (newQty > stock) {
                                    session.setAttribute("message", "Số lượng vượt quá tồn kho (Còn: " + stock + ")!");
                                    session.setAttribute("messageType", "danger");
                                    // Có thể set lại số lượng bằng max kho nếu muốn: item.setQuantity(stock);
                                } else {
                                    item.setQuantity(newQty); // Cập nhật số lượng mới -> Giá tự động đổi
                                }
                            } catch (NumberFormatException e) {
                                // Người dùng nhập chữ -> Bỏ qua
                            }
                        }
                        break;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Lưu lại giỏ hàng và reload trang
        session.setAttribute("cart", cart);
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}