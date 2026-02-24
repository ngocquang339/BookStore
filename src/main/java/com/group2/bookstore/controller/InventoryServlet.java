package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.model.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "InventoryServlet", urlPatterns = {"/warehouse/inventory"})
public class InventoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        BookDAO dao = new BookDAO();
        com.group2.bookstore.dal.CategoryDAO cDao = new com.group2.bookstore.dal.CategoryDAO();
        
        String keyword = request.getParameter("keyword");
        String author = request.getParameter("author");
        String publisher = request.getParameter("publisher");
        String categoryIdStr = request.getParameter("categoryId"); // Lấy cid từ form

        if (keyword == null) keyword = "";
        
        int cid = 0;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try { cid = Integer.parseInt(categoryIdStr); } catch (Exception e) {}
        }

        // ĐÃ SỬA: Truyền biến cid vào hàm thay vì số 0
        List<Book> list = dao.getBooks(keyword, cid, author, publisher, 0, 999999999, "book_id", "DESC", true);

        // Truyền data sang JSP
        request.setAttribute("listC", cDao.getAllCategories()); // Thêm list Thể loại
        request.setAttribute("listA", dao.getAllAuthors());
        request.setAttribute("listP", dao.getAllPublishers());
        request.setAttribute("listB", list);
        
        request.getRequestDispatcher("/view/warehouse/inventory_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}