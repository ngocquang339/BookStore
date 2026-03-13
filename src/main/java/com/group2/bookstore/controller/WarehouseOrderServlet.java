package com.group2.bookstore.controller;

import com.group2.bookstore.constant.OrderStatus;
import com.group2.bookstore.dal.WarehouseOrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "WarehouseOrderServlet", urlPatterns = { "/warehouse/orders" })
public class WarehouseOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        WarehouseOrderDAO dao = new WarehouseOrderDAO();
        
        // Nhận tham số tìm kiếm và lọc
        String search = request.getParameter("search");
        String statusParam = request.getParameter("status");
        int status = (statusParam != null && !statusParam.isEmpty()) ? Integer.parseInt(statusParam) : 0;

        // Nếu có request View Modal Detail
        String viewIdStr = request.getParameter("viewId");
        if (viewIdStr != null && !viewIdStr.isEmpty()) {
            int viewId = Integer.parseInt(viewIdStr);
            request.setAttribute("orderDetails", dao.getOrderDetails(viewId));
            request.setAttribute("selectedOrderId", viewId);
            request.setAttribute("selectedOrderStatus", request.getParameter("viewStatus"));
        }

        request.setAttribute("orderList", dao.getOrdersForWarehouse(search, status));
        request.setAttribute("currentSearch", search);
        request.setAttribute("currentStatus", status);
        
        request.getRequestDispatcher("/view/warehouse/warehouse_order_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        WarehouseOrderDAO dao = new WarehouseOrderDAO();
        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");

        try {
            if (orderIdStr != null) {
                int orderId = Integer.parseInt(orderIdStr);

                if ("ship".equals(action)) {
                    // Xuất kho (chuyển sang Shipping và trừ tồn kho)
                    dao.shipOrder(orderId);
                    request.getSession().setAttribute("successMessage", "Đã xuất kho và chuyển cho đơn vị vận chuyển!");
                } 
                else if ("cancel".equals(action)) {
                    dao.updateOrderStatus(orderId, OrderStatus.CANCELLED);
                    request.getSession().setAttribute("successMessage", "Đã cập nhật trạng thái Hủy đơn hàng!");
                }
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", e.getMessage());
        }

        // Redirect lại để tránh submit form nhiều lần
        response.sendRedirect(request.getContextPath() + "/warehouse/orders");
    }
}