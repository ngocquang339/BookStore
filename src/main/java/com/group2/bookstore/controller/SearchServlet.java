package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.BookDAO; // Import User model
import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String txtSearch = request.getParameter("txt");
        if (txtSearch == null) txtSearch = "";

        // 1. Check if user is Admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        boolean isAdmin = false;
        if (user != null && user.getRole() == 1) { // Assuming Role 1 is Admin
            isAdmin = true;
        }

        // 2. Call DAO with the new 'isAdmin' parameter
        BookDAO dao = new BookDAO();
        
        // Notice the 'isAdmin' (true/false) added at the very end
        List<Book> list = dao.getBooks(txtSearch, 0, null, null, 0, 0, null, null, isAdmin);
        
        request.setAttribute("listBooks", list);
        request.setAttribute("txtS", txtSearch);

        request.getRequestDispatcher("view/Search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}