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
            
            // Hứng tham số Tìm kiếm & Sắp xếp từ URL
            String search = request.getParameter("search");
            String sort = request.getParameter("sort");
            
            // Khởi tạo giá trị mặc định nếu khách mới vào lần đầu
            if (search == null) search = "";
            if (sort == null) sort = "newest";

            CollectionDAO dao = new CollectionDAO();
            Collection collection = dao.getCollectionById(collectionId);
            
            if (collection == null || (!collection.isPublic() && collection.getUserId() != user.getId())) {
                response.sendRedirect(request.getContextPath() + "/my-collections");
                return;
            }

            // GỌI HÀM DAO MỚI ĐÃ NÂNG CẤP (Truyền thêm search và sort)
            List<Book> books = dao.getBooksByCollectionId(collectionId, search, sort);
            
            request.setAttribute("collection", collection);
            request.setAttribute("booksInCollection", books);
            
            // Giữ lại trạng thái trên giao diện để nó không bị mất chữ khi load lại trang
            request.setAttribute("paramSearch", search);
            request.setAttribute("paramSort", sort);
            
            request.getRequestDispatcher("view/CollectionDetail.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/my-collections");
        }
    }
}