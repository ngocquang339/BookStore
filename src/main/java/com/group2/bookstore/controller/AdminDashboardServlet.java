package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.AdminDashboardDAO;
import com.group2.bookstore.dal.NotificationDAO;
import com.group2.bookstore.model.AdminNotification;
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
        
        // 1. SECURITY CHECK
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole() != 1) {
            response.sendRedirect(request.getContextPath() + "/login?error=access_denied");
            return;
        }

        // 2. GET STATISTICS (The new part)
        try {
            AdminDashboardDAO dao = new AdminDashboardDAO();
            
            int totalBooks = dao.countTotalProducts();
            int totalOrders = dao.countTotalOrders();
            double totalRevenue = dao.getTotalRevenue();
            int totalCustomers = dao.countTotalCustomers();

            // Send data to JSP
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalCustomers", totalCustomers);
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Fetch unread notifications for the dashboard feed
NotificationDAO notificationDAO = new NotificationDAO();
List<AdminNotification> dashboardAlerts = notificationDAO.getUnreadNotifications();
request.setAttribute("dashboardAlerts", dashboardAlerts);

        // 3. Forward to the dashboard JSP
        request.getRequestDispatcher("/view/admin/dashboard.jsp").forward(request, response);
    }
}