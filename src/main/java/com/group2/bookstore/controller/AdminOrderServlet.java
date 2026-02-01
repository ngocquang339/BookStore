package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.model.Order;
import com.group2.bookstore.model.OrderDetail;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Map multiple URLs to this one Servlet
@WebServlet(name = "AdminOrderServlet", urlPatterns = {"/admin/order", "/admin/order/detail", "/admin/order/update"})
public class AdminOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        OrderDAO dao = new OrderDAO();

        // CASE 1: View Order Details (/admin/order/detail?id=5)
        if (path.equals("/admin/order/detail")) {
            try {
                int orderId = Integer.parseInt(request.getParameter("id"));
                
                // Get the Order Header (Who, When, Total)
                Order order = dao.getOrderById(orderId);
                
                // Get the Order Items (List of Books)
                List<OrderDetail> details = dao.getOrderDetails(orderId);
                
                request.setAttribute("order", order);
                request.setAttribute("details", details);
                
                request.getRequestDispatcher("/view/admin/order-detail.jsp").forward(request, response);
            } catch (Exception e) {
                // If ID is missing or bad, go back to list
                response.sendRedirect(request.getContextPath() + "/admin/order");
            }
        } 
        
        // CASE 2: List All Orders (Default: /admin/order)
        else {
            List<Order> list = dao.getAllOrders();
            request.setAttribute("listOrders", list);
            request.getRequestDispatcher("/view/admin/manage-orders.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        // CASE 3: Update Status (/admin/order/update)
        if (path.equals("/admin/order/update")) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                int status = Integer.parseInt(request.getParameter("status"));
                
                OrderDAO dao = new OrderDAO();
                dao.updateStatus(orderId, status);
                
                // Redirect back to the Detail page so admin can see the change immediately
                response.sendRedirect(request.getContextPath() + "/admin/order/detail?id=" + orderId);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/admin/order");
            }
        }
    }
}