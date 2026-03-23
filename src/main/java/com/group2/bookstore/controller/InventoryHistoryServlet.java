package com.group2.bookstore.controller;

import com.group2.bookstore.dal.InventoryHistoryDAO;
import com.group2.bookstore.model.InventoryHistory;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "InventoryHistoryServlet", urlPatterns = {"/warehouse/inventory-history"})
public class InventoryHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        // 1. Nhận các tham số Lọc, Sắp xếp, Phân trang
        String filterType = request.getParameter("filter");
        String sortBy = request.getParameter("sortBy");
        String sortDir = request.getParameter("sortDir");
        String pageStr = request.getParameter("page");
        
        // 2. Set giá trị mặc định nếu không có
        if (sortBy == null) sortBy = "date";
        if (sortDir == null) sortDir = "DESC";
        
        int page = 1;
        int pageSize = 10; // Hiện 10 dòng mỗi trang
        if (pageStr != null && !pageStr.isEmpty()) {
            try { page = Integer.parseInt(pageStr); } catch (Exception e) {}
        }

        // 3. Lấy data từ DAO
        InventoryHistoryDAO dao = new InventoryHistoryDAO();
        
        int totalRecords = dao.getTotalHistoryCount(filterType);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        
        // Tránh lỗi trang không tồn tại
        if (page > totalPages && totalPages > 0) page = totalPages;
        
        List<InventoryHistory> historyList = dao.getHistory(filterType, sortBy, sortDir, page, pageSize);
        
        // 4. Đẩy data sang JSP
        request.setAttribute("historyList", historyList);
        request.setAttribute("currentFilter", filterType);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortDir", sortDir);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/view/warehouse/inventory_history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}