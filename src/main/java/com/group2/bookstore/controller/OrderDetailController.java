package com.group2.bookstore.controller;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.model.Order;
import com.group2.bookstore.model.OrderDetail;
import com.group2.bookstore.model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/order-detail")
public class OrderDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra quyền Sale Staff (Role = 3)
        if (user == null || user.getRole() != 3) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy ID đơn hàng từ URL
            int orderId = Integer.parseInt(req.getParameter("id"));
            OrderDAO dao = new OrderDAO();
            
            // Lấy thông tin chung của đơn hàng
            Order order = dao.getOrderById(orderId);
            // Lấy danh sách các cuốn sách trong đơn hàng
            List<OrderDetail> listDetails = dao.getOrderDetails(orderId);
            
            if (order == null) {
                resp.sendRedirect("dashboard");
                return;
            }
            
            // Gửi dữ liệu sang JSP
            req.setAttribute("order", order);
            req.setAttribute("listDetails", listDetails);
            
            req.getRequestDispatcher("/view/order-detail.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("dashboard");
        }
    }
}