package com.group2.bookstore.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "WarehouseDashboardServlet", urlPatterns = {"/warehouse/dashboard"})
public class WarehouseDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng đến file JSP giao diện
        request.getRequestDispatcher("/view/warehouse/dashboard.jsp").forward(request, response);
    }
}