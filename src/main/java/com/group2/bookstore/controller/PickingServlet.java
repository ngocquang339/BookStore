package com.group2.bookstore.controller;

import com.group2.bookstore.dal.WarehouseOrderDAO;
import com.group2.bookstore.model.User; // BẠN NHỚ THÊM IMPORT NÀY
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/warehouse/picking")
public class PickingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        WarehouseOrderDAO dao = new WarehouseOrderDAO();

        request.setAttribute("orderInfo", dao.getOrderCustomerInfo(orderId));
        request.setAttribute("pickingItems", dao.getOrderDetails(orderId));
        request.setAttribute("orderId", orderId);

        request.getRequestDispatcher("/view/warehouse/picking_list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        WarehouseOrderDAO dao = new WarehouseOrderDAO();

        try {
            // ================= LẤY USER ID TỪ SESSION =================
            // Ở đây tôi giả định khi Login, bạn lưu thông tin user vào session với tên là "account"
            // Nếu bạn dùng tên khác (ví dụ: "userLogin", "user"), hãy sửa lại chữ "account" cho đúng nhé.
            User loginUser = (User) request.getSession().getAttribute("user"); // ĐÚNG
            
            if (loginUser == null) {
                throw new Exception("Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại!");
            }
            
            int userId = loginUser.getId(); // Lấy ra ID của thủ kho
            // ==========================================================

            // Cập nhật hàm gọi: truyền thêm userId
            dao.confirmPicking(orderId, userId);

            request.getSession().setAttribute(
                    "successMessage",
                    "Picking completed successfully!"
            );

        } catch (Exception e) {

            request.getSession().setAttribute(
                    "errorMessage",
                    e.getMessage()
            );
        }

        response.sendRedirect(request.getContextPath() + "/warehouse/orders");
    }
}