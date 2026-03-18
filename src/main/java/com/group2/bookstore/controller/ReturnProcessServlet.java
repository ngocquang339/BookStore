package com.group2.bookstore.controller;

import com.group2.bookstore.constant.OrderStatus;
import com.group2.bookstore.dal.WarehouseOrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/warehouse/return-process")
public class ReturnProcessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        WarehouseOrderDAO dao = new WarehouseOrderDAO();
        
        // Cập nhật trạng thái sang 9 (Received/Inspecting) khi bắt đầu kiểm
        try { 
            dao.updateOrderStatus(orderId, OrderStatus.RETURN_RECEIVED); 
        } catch(Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("orderInfo", dao.getOrderCustomerInfo(orderId));
        request.setAttribute("items", dao.getOrderDetails(orderId));
        
        // THÊM DÒNG NÀY ĐỂ TRUYỀN ID SANG JSP (Fix lỗi chuỗi rỗng)
        request.setAttribute("orderId", orderId); 

        request.getRequestDispatcher("/view/warehouse/return_inspection.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        
        // Kiểm tra an toàn để tránh lỗi Exception nếu form bị lỗi truyền thiếu ID
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Lỗi dữ liệu: Không tìm thấy mã đơn hàng!");
            response.sendRedirect("returns");
            return;
        }

        int orderId = Integer.parseInt(orderIdStr);
        WarehouseOrderDAO dao = new WarehouseOrderDAO();
        
        try {
            // Thực hiện cộng kho và hoàn tất (Status 10)
            dao.confirmReturnToStock(orderId); 
            request.getSession().setAttribute("successMessage", "Đã nhập kho hàng hoàn trả thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi nhập kho: " + e.getMessage());
        }
        
        response.sendRedirect("returns");
    }
}