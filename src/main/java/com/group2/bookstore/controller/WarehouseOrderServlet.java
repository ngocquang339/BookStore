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

    // 1. HÀM HỖ TRỢ: Xử lý ép kiểu cực kỳ an toàn
    // Nếu tham số bị rỗng, bị chữ "null", hoặc người dùng gõ bậy bạ -> tự động trả
    // về giá trị mặc định
    private int parseIntSafe(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty() || value.trim().equalsIgnoreCase("null")) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    // 2. HÀM DOGET ĐÃ ĐƯỢC TỐI ƯU
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        WarehouseOrderDAO dao = new WarehouseOrderDAO();

        // Nhận tham số search (nếu URL có chữ "null" thì chuyển thành rỗng)
        String search = request.getParameter("search");
        if (search == null || search.equalsIgnoreCase("null")) {
            search = "";
        }

        // Dùng hàm hỗ trợ để lấy status (nếu lỗi tự động gán = 0)
        int status = parseIntSafe(request.getParameter("status"), 0);

        // Xử lý khi bấm nút View (mở Modal)
        int viewId = parseIntSafe(request.getParameter("viewId"), 0);

        if (viewId > 0) {
            // Đẩy dữ liệu sang JSP
            request.setAttribute("orderDetails", dao.getOrderDetails(viewId));
            request.setAttribute("selectedOrderId", viewId);

            // Xử lý viewStatus an toàn
            int viewStatus = parseIntSafe(request.getParameter("viewStatus"), 0);
            if (viewStatus > 0) {
                request.setAttribute("selectedOrderStatus", viewStatus);
            }
        }

        // Lấy danh sách hiển thị
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
                } else if ("cancel".equals(action)) {
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