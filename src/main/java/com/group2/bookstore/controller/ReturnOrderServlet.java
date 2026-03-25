package com.group2.bookstore.controller;

import com.group2.bookstore.dal.WarehouseOrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/warehouse/returns")
public class ReturnOrderServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        WarehouseOrderDAO dao = new WarehouseOrderDAO();
        String search = request.getParameter("searchName");
        int status = 0;
        try {
            status = Integer.parseInt(request.getParameter("statusFilter"));
        } catch (Exception e) {
        }

        // Xử lý xem chi tiết (Modal)
        String viewId = request.getParameter("viewId");
        if (viewId != null) {
            int id = Integer.parseInt(viewId);
            request.setAttribute("selectedOrder", dao.getOrderCustomerInfo(id));
            // SỬA DÒNG NÀY: Dùng hàm mới lấy chi tiết từ bảng ReturnRequests
            request.setAttribute("details", dao.getReturnOrderDetails(id));
        }
        request.setAttribute("returnList", dao.getReturnOrders(search, status));
        request.getRequestDispatcher("/view/warehouse/return_order_list.jsp").forward(request, response);
    }
}