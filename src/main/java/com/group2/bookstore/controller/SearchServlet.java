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

// Map đường dẫn /search
@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy từ khóa (keyword)
        request.setCharacterEncoding("UTF-8");
        String txt = request.getParameter("txt"); // lấy từ input name="txt" bên JSP
        
        // 2. Gọi DAO
        BookDAO dao = new BookDAO();
        List<Book> list;
        
        // Nếu từ khóa rỗng thì hiện tất cả, ngược lại thì tìm kiếm
        if (txt == null || txt.trim().isEmpty()) {
             list = dao.getAllBooks();
        } else {
             list = dao.searchBooks(txt);
        }

        // 3. Đẩy dữ liệu về JSP
        request.setAttribute("listBooks", list);
        request.setAttribute("txtS", txt); // Lưu lại từ khóa để hiển thị lại trên ô input

        // 4. Forward về trang Home
        request.getRequestDispatcher("view/Home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // POST cũng xử lý như GET
    }
}