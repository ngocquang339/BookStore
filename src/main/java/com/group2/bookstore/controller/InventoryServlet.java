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
        
        String search = request.getParameter("search");
        String cate = request.getParameter("cid");
        int cid = (cate == null || cate.isEmpty()) ? 0 : Integer.parseInt(cate);

        BookDAO dao = new BookDAO();
        // false ở cuối nghĩa là KHÔNG PHẢI chỉ lấy low stock -> Lấy tất cả
        List<Book> list = dao.getBooks(search, cid, false);

        request.setAttribute("listB", list);
        request.getRequestDispatcher("/view/warehouse/inventory_list.jsp").forward(request, response);
    }
}