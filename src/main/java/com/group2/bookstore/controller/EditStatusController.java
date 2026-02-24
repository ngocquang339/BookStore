package com.group2.bookstore.controller;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.model.Order;
import com.group2.bookstore.model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/edit-status")
public class EditStatusController extends HttpServlet {

    // Hiển thị trang chỉnh sửa
    @Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    HttpSession session = req.getSession();
    User user = (User) session.getAttribute("user");

    if (user == null || user.getRole() != 3) {
        resp.sendRedirect(req.getContextPath() + "/login");
        return;
    }

    try {
        int orderId = Integer.parseInt(req.getParameter("id"));
        OrderDAO dao = new OrderDAO();
        
        // Bắt buộc phải có dòng này để lấy toàn bộ thông tin (Tên khách, Ngày đặt, Tổng tiền...)
        Order order = dao.getOrderById(orderId); 
        
        if (order == null) {
            resp.sendRedirect("dashboard");
            return;
        }
        
        req.setAttribute("order", order);
        req.getRequestDispatcher("/view/edit-status.jsp").forward(req, resp);
    } catch (Exception e) {
        resp.sendRedirect("dashboard");
    }
}

    // Xử lý khi bấm nút "Lưu" ở trang chỉnh sửa
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            int newStatus = Integer.parseInt(req.getParameter("newStatus"));

            OrderDAO dao = new OrderDAO();
            dao.updateOrderStatus(orderId, newStatus);

            // Cập nhật xong thì đá về lại dashboard
            resp.sendRedirect("dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("dashboard");
        }
    }
}