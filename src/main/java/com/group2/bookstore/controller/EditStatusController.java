package com.group2.bookstore.controller;

import java.io.IOException;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.model.Order;
import com.group2.bookstore.model.User;

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
        // 1. Lấy tham số trực tiếp từ URL (Không gọi DAO nữa)
        int orderId = Integer.parseInt(req.getParameter("id"));
        int currentStatus = Integer.parseInt(req.getParameter("status")); // Lấy thêm cái này
        
        // 2. Tạo một đối tượng Order tạm thời để chứa dữ liệu
        Order order = new Order();
        order.setId(orderId);
        order.setStatus(currentStatus);
        
        // 3. Gửi sang trang JSP
        req.setAttribute("order", order);
        req.getRequestDispatcher("/view/edit-status.jsp").forward(req, resp);
        
    } catch (Exception e) {
        // Nếu lỗi tham số, quay về dashboard
        e.printStackTrace();
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
            dao.updateStatus(orderId, newStatus);

            // Cập nhật xong thì đá về lại dashboard
            resp.sendRedirect("dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("dashboard");
        }
    }
}