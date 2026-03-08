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

@WebServlet("/dashboard")
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
        
        // 1. Nhận tham số sắp xếp từ URL
        String sortBy = req.getParameter("sortBy");
        String sortOrder = req.getParameter("sortOrder");
        
        // Gán giá trị mặc định lúc mới vào trang (Sắp xếp theo ngày, mới nhất lên đầu)
        if (sortBy == null) sortBy = "date";
        if (sortOrder == null) sortOrder = "desc";

        // 2. Lấy dữ liệu theo Tab trạng thái và Tham số sắp xếp
        String statusRaw = req.getParameter("status");
        if(statusRaw == null || statusRaw.equals("all")){
            listOrders = dao.getAllOrdersBySale(sortBy, sortOrder); // Gọi hàm MỚI
            req.setAttribute("currentStatus", "all");
        } else {
            int status = Integer.parseInt(statusRaw);
            listOrders = dao.getOrdersByStatus(status, sortBy, sortOrder); // Gọi hàm MỚI
            req.setAttribute("currentStatus", status);
        }
        
        // 3. Gửi ngược trạng thái sắp xếp hiện tại sang JSP để hiển thị icon Mũi tên
        req.setAttribute("currentSortBy", sortBy);
        req.setAttribute("currentSortOrder", sortOrder);
        req.setAttribute("orders", listOrders);
        req.getRequestDispatcher("/view/dashboard.jsp").forward(req, resp);
    }


}