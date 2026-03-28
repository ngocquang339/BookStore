package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.WarehouseOrderDAO;
import com.group2.bookstore.model.ReturnRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/warehouse/return-process")
public class ReturnProcessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        WarehouseOrderDAO dao = new WarehouseOrderDAO();

        try {
            dao.updateReturnRequestStatus(orderId, 3);
        } catch (Exception e) {
            e.printStackTrace();
        }

        List<ReturnRequest> items = dao.getReturnOrderDetails(orderId);
        request.setAttribute("items", items);

        if (!items.isEmpty()) {
            request.setAttribute("orderInfo", items.get(0));
        }

        request.setAttribute("orderId", orderId);

        request.getRequestDispatcher("/view/warehouse/return_inspection.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String orderIdStr = request.getParameter("orderId");
        String qcAction = request.getParameter("qcAction");

        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Lỗi dữ liệu: Không tìm thấy mã đơn hàng!");
            response.sendRedirect("returns");
            return;
        }

        int orderId = Integer.parseInt(orderIdStr);
        WarehouseOrderDAO dao = new WarehouseOrderDAO();

        try {
            // Chỉ xử lý khi hành động là "PASS" (Nhập kho thành công)
            if ("PASS".equals(qcAction)) {
                dao.processQualityControl(orderId, qcAction, null);

                request.getSession().setAttribute("successMessage",
                        "Đã nhập kho hàng hoàn trả thành công! Chờ Admin hoàn tiền.");
            } else {
                request.getSession().setAttribute("errorMessage",
                        "Hành động không hợp lệ!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage",
                    "Lỗi xử lý kiểm hàng: " + e.getMessage());
        }

        response.sendRedirect("returns");
    }
}