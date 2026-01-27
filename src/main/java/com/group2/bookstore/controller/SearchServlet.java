package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.model.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;

@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            request.setCharacterEncoding("UTF-8");
        } catch (UnsupportedEncodingException e) {
            // UTF-8 should always be supported, but handle if it's not
            e.printStackTrace();
        }
        String txtSearch = request.getParameter("txt");
        if (txtSearch == null) {
            txtSearch = "";
        }

        // Gọi hàm DAO lấy sách
        BookDAO dao = new BookDAO();
        // Truyền đủ 8 tham số để khớp với BookDAO mới //SỬA MỚI
        List<Book> list = dao.getBooks(txtSearch, 0, null, null, 0, 0, null, null); //sửa  
        request.setAttribute("listBooks", list);
        request.setAttribute("txtS", txtSearch);

        // --- SỬA DÒNG NÀY ---
        // Chuyển hướng sang trang Search.jsp riêng biệt
        request.getRequestDispatcher("view/Search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
