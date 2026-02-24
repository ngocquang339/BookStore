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

// Map đúng với href="low-stock" trong dashboard.jsp
@WebServlet(name = "LowStockServlet", urlPatterns = {"/warehouse/low-stock"})
public class LowStockServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        BookDAO dao = new BookDAO();
        
        // Cài đặt mức cảnh báo hết hàng là 10 (có thể đổi thành 5 hoặc 20 tùy nhóm)
        int threshold = 15; 
        
        List<Book> list = dao.getLowStockBooks(threshold);

        request.setAttribute("listB", list);
        request.setAttribute("threshold", threshold);
        
        // Điều hướng sang file JSP mới
        request.getRequestDispatcher("/view/warehouse/low_stock_list.jsp").forward(request, response);
    }
}