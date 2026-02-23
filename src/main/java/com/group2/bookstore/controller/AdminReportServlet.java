package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import com.group2.bookstore.dal.ReportDAO;
import com.group2.bookstore.model.Book;

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
        
        ReportDAO dao = new ReportDAO();

        // 1. PREPARE REVENUE DATA (Last 7 Days)
        // Ensure your ReportDAO has the 'getLast7DaysRevenue' method!
        Map<String, Double> revenueMap = dao.getLast7DaysRevenue();
        
        // Reverse so the graph goes Oldest -> Newest
        List<String> dates = new ArrayList<>(revenueMap.keySet());
        Collections.reverse(dates); 
        
        StringBuilder dateLabels = new StringBuilder();
        StringBuilder revenueData = new StringBuilder();

        for (String date : dates) {
            dateLabels.append("'").append(date).append("',");
            revenueData.append(revenueMap.get(date)).append(",");
        }

        // 2. PREPARE TOP SELLING DATA
        List<Book> topBooks = dao.getTopSellingBooks();
        StringBuilder bookLabels = new StringBuilder();
        StringBuilder bookData = new StringBuilder();

        for (Book b : topBooks) {
            String cleanTitle = b.getTitle().replace("'", "\\'"); // Escape quotes
            if (cleanTitle.length() > 20) cleanTitle = cleanTitle.substring(0, 20) + "..."; // Shorten title
            
            bookLabels.append("'").append(cleanTitle).append("',");
            bookData.append(b.getSoldQuantity()).append(",");
        }

        // 3. SEND TO JSP
        request.setAttribute("chartDates", dateLabels.toString());
        request.setAttribute("chartRevenue", revenueData.toString());
        
        request.setAttribute("chartBooks", bookLabels.toString());
        request.setAttribute("chartSold", bookData.toString());
        
        request.getRequestDispatcher("/view/admin/report-dashboard.jsp").forward(request, response);
    }
}