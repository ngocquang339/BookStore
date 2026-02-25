package com.group2.bookstore.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.Map;

import com.group2.bookstore.dal.ReportDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminReportServlet", urlPatterns = {"/admin/reports"})
public class AdminReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Handle Date Range (Default to Last 7 Days if null)
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        
        if (fromDate == null || fromDate.isEmpty()) {
            LocalDate today = LocalDate.now();
            toDate = today.toString();
            fromDate = today.minusDays(6).toString(); // Last 7 days
        }

        ReportDAO dao = new ReportDAO();

        // 2. Fetch Data from DAO
        Map<String, Double> revenueMap = dao.getRevenueByDate(fromDate, toDate);
        int[] statusCounts = dao.getOrderStatusCounts(fromDate, toDate);
        Map<String, Integer> topSellers = dao.getTopSellers(fromDate, toDate);

        // 3. Calculate Summary Cards (Totals)
        double totalRevenue = 0;
        for (double val : revenueMap.values()) {
            totalRevenue += val;
        }

        int totalOrders = 0;
        for (int count : statusCounts) {
            totalOrders += count;
        }
        
        int completedOrders = statusCounts[2]; // Index 2 is Completed

        // 4. Format Data for Chart.js (Build JSON-like strings)
        
        // A. REVENUE CHART
        StringBuilder dateLabels = new StringBuilder("[");
        StringBuilder revenueData = new StringBuilder("[");
        for (Map.Entry<String, Double> entry : revenueMap.entrySet()) {
            dateLabels.append("'").append(entry.getKey()).append("',");
            revenueData.append(entry.getValue()).append(",");
        }
        // Remove trailing comma
        if (dateLabels.length() > 1) dateLabels.setLength(dateLabels.length() - 1);
        if (revenueData.length() > 1) revenueData.setLength(revenueData.length() - 1);
        dateLabels.append("]");
        revenueData.append("]");

        // B. BEST SELLERS CHART
        StringBuilder bookLabels = new StringBuilder("[");
        StringBuilder bookData = new StringBuilder("[");
        for (Map.Entry<String, Integer> entry : topSellers.entrySet()) {
            String cleanTitle = entry.getKey().replace("'", "\\'"); // Escape quotes
            if (cleanTitle.length() > 20) cleanTitle = cleanTitle.substring(0, 20) + "..."; // Truncate
            
            bookLabels.append("'").append(cleanTitle).append("',");
            bookData.append(entry.getValue()).append(",");
        }
        if (bookLabels.length() > 1) bookLabels.setLength(bookLabels.length() - 1);
        if (bookData.length() > 1) bookData.setLength(bookData.length() - 1);
        bookLabels.append("]");
        bookData.append("]");

        // 5. Send Attributes to JSP
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        
        // Summary Cards
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("completedOrders", completedOrders);
        
        // Charts Data
        request.setAttribute("dateLabels", dateLabels.toString());
        request.setAttribute("revenueData", revenueData.toString());
        request.setAttribute("statusCounts", Arrays.toString(statusCounts)); // "[1, 0, 5, 2]"
        request.setAttribute("bookLabels", bookLabels.toString());
        request.setAttribute("bookData", bookData.toString());

        // Make sure this path matches your file structure
        request.getRequestDispatcher("/view/admin/report-dashboard.jsp").forward(request, response);
    }
}