package com.group2.bookstore.controller;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.model.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

// Tên Servlet đổi thành GuestProductDetailServlet để quản lý code
@WebServlet(name = "GuestProductDetailServlet", urlPatterns = {"/product-detail"})
public class GuestProductDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idRaw = request.getParameter("id");
        
        try {
            int id = Integer.parseInt(idRaw);
            BookDAO dao = new BookDAO();
            Book b = dao.getBookById(id);
            
            if (b == null) {
                response.sendRedirect("home");
            } else {
                request.setAttribute("book", b);
                
                // QUAN TRỌNG: Chuyển hướng sang file JSP mới đã đổi tên
                request.getRequestDispatcher("view/GuestProductDetail.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }
}