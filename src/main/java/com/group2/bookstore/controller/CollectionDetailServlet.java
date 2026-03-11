package com.group2.bookstore.controller;

import com.group2.bookstore.dal.CollectionDAO;
import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.Collection;
import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CollectionDetailServlet", urlPatterns = {"/collection-detail"})
public class CollectionDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int collectionId = Integer.parseInt(request.getParameter("id"));
            CollectionDAO dao = new CollectionDAO();
            
            // 1. Lấy thông tin cơ bản của bộ sưu tập đó (Tên, màu sắc...)
            Collection collection = dao.getCollectionById(collectionId);
            
            // Bảo mật: Nếu bộ sưu tập không tồn tại, hoặc nó là Private nhưng người xem không phải chủ nhân
            if (collection == null || (!collection.isPublic() && collection.getUserId() != user.getId())) {
                response.sendRedirect(request.getContextPath() + "/my-collections");
                return;
            }

            // 2. Lấy danh sách Sách nằm trong bộ sưu tập này
            List<Book> books = dao.getBooksByCollectionId(collectionId);
            
            request.setAttribute("collection", collection);
            request.setAttribute("booksInCollection", books);
            
            request.getRequestDispatcher("view/CollectionDetail.jsp").forward(request, response);
            
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/my-collections");
        }
    }
}