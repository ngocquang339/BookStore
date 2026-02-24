package com.group2.bookstore.controller;

import java.io.IOException;

import com.group2.bookstore.dal.CategoryDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminCategoryServlet", urlPatterns = {"/admin/category/add"})
public class AdminCategoryServlet extends HttpServlet {

    // 1. Show the Form
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/admin/add-category.jsp").forward(request, response);
    }

    // 2. Handle the Form Submission
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8"); // Important for Vietnamese text
        
        // A. Get Data
        String name = request.getParameter("name");
        String description = request.getParameter("description"); // New Field
        
        // B. Validation & Save
        if (name != null && !name.trim().isEmpty()) {
            CategoryDAO dao = new CategoryDAO();
            // Call the updated method
            dao.insertCategory(name, description);
        }
        
        // C. Redirect back to Product Manager (so they can use the new category immediately)
        response.sendRedirect(request.getContextPath() + "/admin/product/list");
    }
}