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
            
            // Lấy danh sách chi tiết các cuốn sách bị trả lại
            List<ReturnRequest> details = dao.getReturnOrderDetails(id);
            
            if (!details.isEmpty()) {
                // Lấy cuốn sách đầu tiên làm dữ liệu chung (Tên KH, Ngày đặt, Status) cho Header Modal
                request.setAttribute("selectedOrder", details.get(0));
                // Truyền toàn bộ danh sách để in ra bảng bên trong Modal
                request.setAttribute("details", details);
            }
        }
        
        request.setAttribute("returnList", dao.getReturnOrders(search, status));
        request.getRequestDispatcher("/view/warehouse/return_order_list.jsp").forward(request, response);
    }
}