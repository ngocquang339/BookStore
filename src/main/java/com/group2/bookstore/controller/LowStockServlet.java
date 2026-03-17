package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.dal.CategoryDAO;
import com.group2.bookstore.model.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "LowStockServlet", urlPatterns = {"/warehouse/low-stock"})
public class LowStockServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookDAO dao = new BookDAO();
        CategoryDAO cDao = new CategoryDAO();

        // ===== FILTER =====
        String keyword = request.getParameter("keyword");
        String publisher = request.getParameter("publisher");
        String categoryRaw = request.getParameter("categoryId");

        int categoryId = 0;
        try {
            if (categoryRaw != null) {
                categoryId = Integer.parseInt(categoryRaw);
            }
        } catch (Exception e) {}

        int threshold = 15;

        List<Book> list = dao.getLowStockBooks(keyword, categoryId, publisher, threshold);

        request.setAttribute("listC", cDao.getAllCategories());
        request.setAttribute("listP", dao.getAllPublishers());

        request.setAttribute("listB", list);

        request.getRequestDispatcher("/view/warehouse/low_stock_list.jsp")
               .forward(request, response);
    }
}