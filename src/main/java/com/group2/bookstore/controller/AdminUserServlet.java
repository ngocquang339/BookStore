package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.UserDAO;
import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminUserServlet", urlPatterns = {"/admin/users", "/admin/users/update"})
public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // LIST USERS
        UserDAO dao = new UserDAO();
        List<User> list = dao.getAllUsers();
        
        request.setAttribute("listUsers", list);
        request.getRequestDispatcher("/view/admin/manage-users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // UPDATE USER (Ban/Promote)
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            int status = Integer.parseInt(request.getParameter("status")); // 1 or 0
            int role = Integer.parseInt(request.getParameter("role"));     // 1, 2, 4
            
            UserDAO dao = new UserDAO();
            dao.updateUser(userId, status, role);
            
            // Redirect to list with success message
            response.sendRedirect(request.getContextPath() + "/admin/users?msg=success");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/users?error=fail");
        }
    }
}