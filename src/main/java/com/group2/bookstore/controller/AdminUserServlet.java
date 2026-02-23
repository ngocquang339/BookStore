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
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminUserServlet", urlPatterns = {"/admin/users", "/admin/users/add", "/admin/users/ban"})
public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        // CASE 1: Show the "Add User" Form
        // CASE 1: Ban/Unban User (Quick Action)
        // CASE 1: Ban/Unban User
        if (path.equals("/admin/users/ban")) {
            try {
                int targetUserId = Integer.parseInt(request.getParameter("id")); // The ID coming from the URL
                int currentStatus = Integer.parseInt(request.getParameter("status"));

                // --- 1. GET CURRENT LOGGED-IN ADMIN ---
                HttpSession session = request.getSession();
                User currentUser = (User) session.getAttribute("user");

                // --- 2. SECURITY CHECK: PREVENT SELF-BAN ---
                if (currentUser != null && currentUser.getId() == targetUserId) {
                    // If trying to ban yourself, stop and show error
                    response.sendRedirect(request.getContextPath() + "/admin/users?error=self_ban");
                    return;
                }
                // -------------------------------------------

                int newStatus = (currentStatus == 1) ? 0 : 1;

                UserDAO dao = new UserDAO();
                dao.updateUserStatus(targetUserId, newStatus);

                response.sendRedirect(request.getContextPath() + "/admin/users?msg=updated");
            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
        }

        // CASE 2: Show "Add User" Form
        if (path.equals("/admin/users/add")) {
            request.getRequestDispatcher("/view/admin/user-form.jsp").forward(request, response);
            return;
        }

        // CASE 3: List Users (Default)
        UserDAO dao = new UserDAO();
        List<User> list = dao.getAllUsers();
        request.setAttribute("listUsers", list);
        request.getRequestDispatcher("/view/admin/manage-users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        // CASE 3: Process the "Add User" Form
        if (path.equals("/admin/users/add")) {
            try {
                String username = request.getParameter("username");
                String email = request.getParameter("email");

                UserDAO dao = new UserDAO();

                // Validation: Check if username exists
                if (dao.checkUsernameExists(username)) {
                    request.setAttribute("error", "Username already exists!");
                    request.getRequestDispatcher("/view/admin/user-form.jsp").forward(request, response);
                    return;
                }

                // Create User Object
                User u = new User();
                u.setUsername(username);
                u.setPassword(request.getParameter("password")); // Ideally hash this
                u.setFullname(request.getParameter("fullname"));
                u.setEmail(email);
                u.setPhone_number(request.getParameter("phone"));
                u.setAddress(request.getParameter("address"));
                u.setRole(Integer.parseInt(request.getParameter("role")));

                dao.addUser(u);

                // Success -> Go back to list
                response.sendRedirect(request.getContextPath() + "/admin/users?msg=created");

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/admin/users?error=fail");
            }
        }
    }
}
