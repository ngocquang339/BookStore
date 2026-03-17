package com.group2.bookstore.controller;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.model.Order;
import com.group2.bookstore.model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders-management")
public class SaleController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        // Chỉ cho phép Sale Staff (Role = 3) truy cập
        if (user == null || user.getRole() != 3) { 
            resp.sendRedirect(req.getContextPath() + "/login"); 
            return;
        }

        OrderDAO dao = new OrderDAO();
        
        // 1. Nhận các tham số tìm kiếm và sắp xếp
        String sortBy = req.getParameter("sortBy");
        String sortOrder = req.getParameter("sortOrder");
        String searchQuery = req.getParameter("searchQuery"); 
        
        if (sortBy == null) sortBy = "date";
        if (sortOrder == null) sortOrder = "desc";
        if (searchQuery == null) searchQuery = ""; 

        // 2. Nhận tham số phân trang (Mặc định là trang 1)
        String pageRaw = req.getParameter("page");
        int page = (pageRaw == null || pageRaw.isEmpty()) ? 1 : Integer.parseInt(pageRaw);
        int pageSize = 10;

        // 3. XỬ LÝ LỌC TRẠNG THÁI VÀ GỌI HÀM DAO GỘP
        String statusRaw = req.getParameter("status");
        // Quy ước: Nếu không chọn gì hoặc chọn "all" thì gán status = -1 để DAO hiểu là lấy tất cả
        int status = (statusRaw == null || statusRaw.equals("all")) ? -1 : Integer.parseInt(statusRaw);
        
        List<Order> listOrders = dao.getOrdersBySalePaginated(status, sortBy, sortOrder, searchQuery, page);
        int totalOrders = dao.countOrdersBySale(status, searchQuery);
        
        // 4. Tính toán số trang để vẽ dãy nút bấm 1, 2, 3...
        int endPage = totalOrders / pageSize;
        if (totalOrders % pageSize != 0) {
            endPage++;
        }

        // 5. Lấy dữ liệu thống kê tổng quan trong ngày
        double[] todaySummary = dao.getTodaySummary();
        req.setAttribute("todayTotalOrders", (int) todaySummary[0]);
        req.setAttribute("todayPending", (int) todaySummary[1]);
        req.setAttribute("todayRevenue", todaySummary[2]);

        // 6. Đẩy toàn bộ dữ liệu và trạng thái hiện tại về JSP
        // Dùng toán tử 3 ngôi để trả lại chữ "all" cho giao diện nhận diện đúng tab màu xanh
        req.setAttribute("currentStatus", status == -1 ? "all" : status);
        req.setAttribute("currentSortBy", sortBy);
        req.setAttribute("currentSortOrder", sortOrder);
        req.setAttribute("currentSearch", searchQuery); 
        req.setAttribute("orders", listOrders);
        req.setAttribute("currentPage", page);
        req.setAttribute("endPage", endPage);
        
        req.getRequestDispatcher("/view/dashboard.jsp").forward(req, resp);
    }
}