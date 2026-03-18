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

@WebServlet(name = "AdminViewPODetailServlet", urlPatterns = {"/admin/po-detail"})
public class AdminViewPODetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Security Check
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || user.getRole() != 1) { // 1 = Admin
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int poId = Integer.parseInt(request.getParameter("poId"));
            PurchaseOrderDAO dao = new PurchaseOrderDAO();

            // 2. Fetch Header & Items
            PurchaseOrder po = dao.getPurchaseOrderById(poId);
            List<PurchaseOrderDetail> items = dao.getPoDetailsForReceive(poId);

            // 3. Send to JSP
            request.setAttribute("order", po);
            request.setAttribute("items", items);
            request.getRequestDispatcher("/view/admin/view-purchase-order-detail.jsp").forward(request, response);
            
        } catch (Exception e) {
            response.sendRedirect("view-po?error=invalid_id");
        }
    }
}