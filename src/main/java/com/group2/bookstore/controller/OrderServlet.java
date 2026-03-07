package com.group2.bookstore.controller;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.model.Order;
import com.group2.bookstore.model.User;
// Nhớ import các class Order và OrderDAO của bạn vào đây
// import com.group2.bookstore.dal.OrderDAO;
// import com.group2.bookstore.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderServlet", urlPatterns = {"/my-orders"})
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect("login"); // Đổi thành URL trang login của bạn
            return;
        }

        // 2. Lấy trạng thái đơn hàng từ URL (Mặc định là "all" nếu không có param)
        String status = request.getParameter("status");
        if (status == null || status.trim().isEmpty()) {
            status = "all";
        }

        // 3. GỌI DAO ĐỂ LẤY DỮ LIỆU
        OrderDAO orderDAO = new OrderDAO();
        List<Order> listOrders;
        
        if ("all".equals(status)) {
            // Lấy TẤT CẢ đơn hàng
            listOrders = orderDAO.getAllOrdersByUserId(user.getId());
        } else {
            // Chuyển đổi trạng thái dạng chữ (trên URL) sang số nguyên (trong DB)
            int dbStatus = -1;
            switch (status) {
                case "pending": dbStatus = 1; break;    // Chờ thanh toán
                case "processing": dbStatus = 2; break; // Đang xử lý
                case "shipping": dbStatus = 3; break;   // Đang giao
                case "completed": dbStatus = 4; break;  // Hoàn tất
                case "cancelled": dbStatus = 0; break;  // Bị hủy
            }
            // Gọi hàm lấy theo trạng thái
            listOrders = orderDAO.getOrdersByStatusForUser(user.getId(), dbStatus);
        }
        
        request.setAttribute("listOrders", listOrders);

        // 4. Đẩy trạng thái hiện tại sang JSP để bôi đỏ cái Tab đang được chọn
        request.setAttribute("currentStatus", status);

        // Chuyển hướng sang trang JSP
        request.getRequestDispatcher("view/MyOrders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Dùng cho chức năng Hủy đơn hàng hoặc Mua lại (sẽ làm sau)
    }
}
