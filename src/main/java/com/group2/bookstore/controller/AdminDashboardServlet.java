package com.group2.bookstore.controller;

import java.io.IOException;

import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. SECURITY CHECK: Is the user logged in AND an Admin?
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // If user is null (not logged in) OR Role is not 1 (not Admin)
        if (user == null || user.getRole() != 1) {
            // Kick them back to the login page or home page
            response.sendRedirect(request.getContextPath() + "/login?error=access_denied");
            return;
        }

        // 2. If Admin, forward to the dashboard JSP
        // Note the path includes "/view/admin/"
        request.getRequestDispatcher("/view/admin/dashboard.jsp").forward(request, response);
    }
}