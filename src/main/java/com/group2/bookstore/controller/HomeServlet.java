package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.BookDAO;
import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet; // <--- MISSING IMPORT
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "HomeController", urlPatterns = {"/home", "/search"})
// FIX BELOW: Add "extends HttpServlet"
public class HomeServlet extends HttpServlet { 
    
    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String path = request.getServletPath();
    BookDAO dao = new BookDAO();

    // 1. GET USER & ROLE
    HttpSession session = request.getSession();
    User currentUser = (User) session.getAttribute("user");
    
    int roleId = 0; 
    if (currentUser != null) {
        roleId = currentUser.getRole(); 
    }

    // 2. HANDLE REQUESTS
    
    // CASE A: SEARCH
    if (path.equals("/search")) {
        String keyword = request.getParameter("txt");
        List<Book> searchResults = dao.searchBooks(keyword, roleId);
        
        request.setAttribute("listBooks", searchResults);
        request.setAttribute("searchKeyword", keyword);
        
        // FIX: Must use FORWARD to keep the data visible
        request.getRequestDispatcher("view/Home.jsp").forward(request, response);
    } 
    
    // CASE B: HOMEPAGE
    else {
        List<Book> newArrivals = dao.getNewArrivals(roleId); 
        List<Book> bestSellers = dao.getBestSellers(); 

        request.setAttribute("newBooks", newArrivals);
        request.setAttribute("bestBooks", bestSellers);
        
       
        request.getRequestDispatcher("view/Home.jsp").forward(request, response);
    }
}
}
