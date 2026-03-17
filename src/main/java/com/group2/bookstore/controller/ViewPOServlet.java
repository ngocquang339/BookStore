package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.group2.bookstore.dal.PurchaseOrderDAO;
import com.group2.bookstore.model.PurchaseOrder;

@WebServlet("/warehouse/view-po")
public class ViewPOServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Lấy các tham số tìm kiếm và lọc từ URL
        String searchSupplier = request.getParameter("searchSupplier");
        String statusParam = request.getParameter("status");
        String pageParam = request.getParameter("page");

        // 2. Xử lý dữ liệu đầu vào
        Integer status = null;
        if (statusParam != null && !statusParam.isEmpty()) {
            try {
                status = Integer.parseInt(statusParam);
            } catch (NumberFormatException e) {
                // Bỏ qua nếu lỗi
            }
        }

        int page = 1;
        int pageSize = 10; // Hiển thị 10 đơn hàng 1 trang
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                // Bỏ qua nếu lỗi
            }
        }

        // 3. Gọi DAO lấy dữ liệu
        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        
        List<PurchaseOrder> poList = dao.getPurchaseOrders(searchSupplier, status, page, pageSize);
        int totalRecords = dao.countPurchaseOrders(searchSupplier, status);
        
        // Tính tổng số trang
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // 4. Đẩy dữ liệu ra JSP
        request.setAttribute("poList", poList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchSupplier", searchSupplier);
        request.setAttribute("currentStatus", status);

        request.getRequestDispatcher("/view/warehouse/view_purchase_order.jsp").forward(request, response);
    }
}