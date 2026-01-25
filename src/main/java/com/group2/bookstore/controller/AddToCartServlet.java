package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO; // Đã mở comment dòng này
import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.CartItem;
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
        
        // 1. Lấy Session hiện tại
        HttpSession session = request.getSession();

        try {
            String idStr = request.getParameter("id");
            
            // Chỉ xử lý khi có ID hợp lệ
            if (idStr != null && !idStr.isEmpty()) {
                int bookId = Integer.parseInt(idStr);

                // 2. Lấy giỏ hàng từ Session (nếu chưa có thì tạo mới)
                List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
                if (cart == null) {
                    cart = new ArrayList<>();
                }

                // 3. Kiểm tra sản phẩm đã có trong giỏ chưa
                boolean found = false;
                for (CartItem item : cart) {
                    if (item.getBook().getId() == bookId) {
                        item.setQuantity(item.getQuantity() + 1); // Tăng số lượng
                        found = true;
                        break;
                    }
                }

                // 4. Nếu chưa có, gọi DB lấy sách thật và thêm vào giỏ
                if (!found) {
                    BookDAO bookDAO = new BookDAO();
                    Book book = bookDAO.getBookById(bookId); // Gọi hàm vừa viết trong DAO

                    if (book != null) {
                        cart.add(new CartItem(book, 1));
                    } else {
                        System.out.println("Lỗi: Không tìm thấy sách có ID = " + bookId);
                    }
                }

                // 5. Cập nhật lại giỏ hàng vào Session
                session.setAttribute("cart", cart);

                // 6. Thông báo thành công
                session.setAttribute("message", "Đã thêm sản phẩm vào giỏ hàng thành công!");
                session.setAttribute("messageType", "success");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("message", "Lỗi: ID sản phẩm không hợp lệ!");
            session.setAttribute("messageType", "danger");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Đã xảy ra lỗi hệ thống!");
            session.setAttribute("messageType", "danger");
        }

        // 7. Chuyển hướng về trang chủ
        response.sendRedirect(request.getContextPath() + "/home");
    }
}