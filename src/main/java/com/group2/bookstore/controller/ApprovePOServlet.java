package com.group2.bookstore.controller;

import java.io.IOException;

import com.group2.bookstore.dal.PurchaseOrderDAO;
import com.group2.bookstore.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ApprovePOServlet", urlPatterns = {"/admin/approve-po"})
public class ApprovePOServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User admin = (User) request.getSession().getAttribute("user");
        if (admin == null || admin.getRole() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int poId = Integer.parseInt(request.getParameter("poId"));
        PurchaseOrderDAO dao = new PurchaseOrderDAO();

        // Use your existing DAO method: status 0 -> 1
        boolean success = dao.approvePO(poId, admin.getId());

        if (success) {
            // Redirect back to the warehouse list or admin list
            response.sendRedirect("view-po?msg=approved");
        } else {
            response.sendRedirect("po-detail?poId=" + poId + "&error=failed");
        }
    }
}