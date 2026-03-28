package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.List;

import com.group2.bookstore.dal.PurchaseOrderDAO;
import com.group2.bookstore.model.PurchaseOrder;
import com.group2.bookstore.model.PurchaseOrderDetail;
import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/admin/po", "/admin/po/review"})
public class AdminManagePOServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        PurchaseOrderDAO dao = new PurchaseOrderDAO();

        if ("/admin/po/review".equals(path)) {
            // --- XEM CHI TIẾT ĐỂ DUYỆT ---
            String poIdParam = request.getParameter("id");
            if (poIdParam != null) {
                int poId = Integer.parseInt(poIdParam);
                PurchaseOrder po = dao.getPurchaseOrderById(poId);
                List<PurchaseOrderDetail> details = dao.getPoDetailsForReceive(poId);
                
                request.setAttribute("po", po);
                request.setAttribute("details", details);
                request.getRequestDispatcher("/view/admin/review-po.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/po");
            }
        } else {
            // --- DANH SÁCH ĐƠN HÀNG (Mặc định hiện Pending) ---
            String statusParam = request.getParameter("status");
            // Mặc định là 0 (Pending) nếu không truyền gì, để admin dễ thấy việc cần làm
            Integer status = (statusParam == null || statusParam.isEmpty()) ? 0 : Integer.parseInt(statusParam);
            // Nếu chọn "all" (-1) thì load tất cả
            if (status == -1) status = null; 

            int page = 1;
            int pageSize = 10;
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }

            List<PurchaseOrder> poList = dao.getPurchaseOrders(null, status, page, pageSize);
            int totalRecords = dao.countPurchaseOrders(null, status);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            request.setAttribute("poList", poList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentStatus", status != null ? status : -1);

            request.getRequestDispatcher("/view/admin/manage-po.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        int poId = Integer.parseInt(request.getParameter("poId"));
        
        // Lấy admin user từ session
        User adminUser = (User) request.getSession().getAttribute("user");
        if(adminUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        boolean success = false;

        if ("approve".equals(action)) {
            success = dao.approvePO(poId, adminUser.getId());
            if (success) {
                request.getSession().setAttribute("successMsg", "Đã duyệt đơn nhập kho thành công!");
            }
        } else if ("reject".equals(action)) {
            String reason = request.getParameter("rejectReason");
            success = dao.rejectPO(poId, adminUser.getId(), reason);
            if (success) {
                request.getSession().setAttribute("errorMsg", "Đã từ chối đơn nhập kho.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/po");
    }
}