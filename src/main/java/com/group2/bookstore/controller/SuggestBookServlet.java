package com.group2.bookstore.controller;

import java.util.List;
import com.group2.bookstore.model.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.group2.bookstore.dal.BookDAO;
@WebServlet(name = "SuggestBookServlet", urlPatterns = { "/suggest-book" })
public class SuggestBookServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BookDAO dao = new BookDAO();
        
        // Gọi 50 cuốn sách ra để làm trang "Xem tất cả"
        List<Book> allSuggestedBooks = dao.getRandomBook(2, 300); 
        
        // Đẩy dữ liệu sang file JSP mới
        request.setAttribute("allSuggestedBooks", allSuggestedBooks);
        request.getRequestDispatcher("view/suggest.jsp").forward(request, response);
    }

   
}
