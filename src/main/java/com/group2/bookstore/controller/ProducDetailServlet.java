package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.model.Book;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/detail"})
public class ProducDetailServlet extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get the Book ID from the URL (e.g., detail?id=5)
        String idRaw = request.getParameter("pid");
        
        if (idRaw == null || idRaw.isEmpty()) {
            response.sendRedirect("home"); // Invalid ID -> Go Home
            return;
        }

        try {
            int id = Integer.parseInt(idRaw);
            BookDAO dao = new BookDAO();
            
            // 2. Get the Main Book
            Book book = dao.getBookById(id);
            
            if (book == null) {
                response.sendRedirect("home"); // Book not found
                return;
            }

            // 3. Get Related Books (Same Category)
            List<Book> relatedBooks = dao.getRelatedBooks(book.getCategoryId(), id);

            // 4. Send data to JSP
            request.setAttribute("book", book);
            request.setAttribute("relatedBooks", relatedBooks);
            
            request.getRequestDispatcher("view/product-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }
}
