package com.group2.bookstore.controller;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staff-dashboard")
public class StaffControllerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra đúng quyền Staff (Role = 3)
        if (user == null || user.getRole() != 3) { 
            resp.sendRedirect(req.getContextPath() + "/login"); 
            return;
        }

        OrderDAO dao = new OrderDAO();
        
        // Lấy số liệu thống kê hôm nay
        double[] todaySummary = dao.getTodaySummary();
        req.setAttribute("todayTotalOrders", (int) todaySummary[0]);
        req.setAttribute("todayPending", (int) todaySummary[1]);
        req.setAttribute("todayRevenue", todaySummary[2]);
        
        // Chuyển hướng sang giao diện thẻ Grid
        req.getRequestDispatcher("/view/staff-dashboard.jsp").forward(req, resp);
    }
}