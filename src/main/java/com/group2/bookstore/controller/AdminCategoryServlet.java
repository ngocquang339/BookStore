package com.group2.bookstore.controller;

import java.io.IOException;
import com.group2.bookstore.dal.CategoryDAO;
import com.group2.bookstore.model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminCategoryServlet", urlPatterns = {"/admin/category/add"})
public class AdminCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Show the form when they click the "Add Category" button
        request.getRequestDispatcher("/view/admin/category-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 1. Get the data from the form
        String name = request.getParameter("name");
        String description = request.getParameter("description"); 

        // 2. Create object and save to database
        Category c = new Category();
        c.setName(name);
        c.setDescription(description); // If your model/DB doesn't use description, just delete this line
        
        CategoryDAO dao = new CategoryDAO();
        dao.insertCategory(c);
        
        // 3. Redirect back to the product list to see the new category in the dropdown
        response.sendRedirect(request.getContextPath() + "/admin/product/list?msg=CategoryAdded");
    }
}
