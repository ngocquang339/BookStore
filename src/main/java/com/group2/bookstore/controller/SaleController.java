package com.group2.bookstore.controller;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.model.Order;
import com.group2.bookstore.model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders-management")
public class SaleController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole() != 3) { 
            resp.sendRedirect(req.getContextPath() + "/login"); 
            return;
        }

        OrderDAO dao = new OrderDAO();
        List<Order> listOrders;
        
        // 1. Nhận các tham số từ giao diện
        String sortBy = req.getParameter("sortBy");
        String sortOrder = req.getParameter("sortOrder");
        String searchQuery = req.getParameter("searchQuery"); 
        
        if (sortBy == null) sortBy = "date";
        if (sortOrder == null) sortOrder = "desc";
        if (searchQuery == null) searchQuery = ""; // Tránh lỗi null khi mới vào trang

        // 2. Lấy dữ liệu kèm theo từ khóa tìm kiếm
        String statusRaw = req.getParameter("status");
        if (statusRaw == null || statusRaw.equals("all")) {
            listOrders = dao.getAllOrdersBySale(sortBy, sortOrder, searchQuery);
            req.setAttribute("currentStatus", "all");
        } else {
            int status = Integer.parseInt(statusRaw);
            listOrders = dao.getOrdersByStatus(status, sortBy, sortOrder, searchQuery);
            req.setAttribute("currentStatus", status);
        }
        
        double[] todaySummary = dao.getTodaySummary();
        req.setAttribute("todayTotalOrders", (int) todaySummary[0]);
        req.setAttribute("todayPending", (int) todaySummary[1]);
        req.setAttribute("todayRevenue", todaySummary[2]);

        // 3. Đẩy dữ liệu về lại JSP
        req.setAttribute("currentSortBy", sortBy);
        req.setAttribute("currentSortOrder", sortOrder);
        req.setAttribute("currentSearch", searchQuery); 
        req.setAttribute("orders", listOrders);
        
        req.getRequestDispatcher("/view/dashboard.jsp").forward(req, resp);
    }
}