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

        // 1. Phân quyền: Kiểm tra xem có phải là Sale Staff không (Ví dụ Role 2 là Sale)
        if (user == null || user.getRole() !=3) { 
            resp.sendRedirect(req.getContextPath() + "/login"); // Đá về trang login nếu không phải Sale
            return;
        }

        OrderDAO dao = new OrderDAO();
        List<Order> listOrders;
        
        // 2. Lấy tham số trạng thái từ URL (mặc định là 1 - Chờ xử lý)
        String statusRaw = req.getParameter("status");
        if(statusRaw ==null || statusRaw.equals("all")){
            listOrders=dao.getAllOrders();
            req.setAttribute("currentStatus", "all");
        }
        else {
            int status=Integer.parseInt(statusRaw);
            listOrders=dao.getOrdersByStatus(status);
            req.setAttribute("currentStatus", status);
        }
        req.setAttribute("orders", listOrders);
        req.getRequestDispatcher("/view/dashboard.jsp").forward(req, resp);
    }

    // Xử lý cập nhật trạng thái đơn hàng
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int orderId = Integer.parseInt(req.getParameter("orderId"));
        int newStatus = Integer.parseInt(req.getParameter("newStatus"));
        
        OrderDAO dao = new OrderDAO();
        dao.updateOrderStatus(orderId, newStatus);
        
        // Quay lại trang dashboard sau khi update
        resp.sendRedirect("dashboard?status=" + (newStatus - 1)); // Quay lại tab cũ hoặc tab mới tùy logic
    }
}