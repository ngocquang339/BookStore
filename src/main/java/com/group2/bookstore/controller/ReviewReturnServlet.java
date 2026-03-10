package com.group2.bookstore.controller;

import java.io.IOException;

import com.group2.bookstore.dal.ReturnRequestDAO;
import com.group2.bookstore.model.ReturnRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ReviewReturnServlet", urlPatterns = {"/admin/returns/review"})
public class ReviewReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            ReturnRequestDAO dao = new ReturnRequestDAO();
            ReturnRequest returnReq = dao.getReturnById(Integer.parseInt(idParam));
            
            if (returnReq != null) {
                request.setAttribute("req", returnReq);
                request.getRequestDispatcher("/view/admin/review-return.jsp").forward(request, response);
                return;
            }
        }
        // If no ID or invalid ID, send them back to the list
        response.sendRedirect(request.getContextPath() + "/admin/returns");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int returnId = Integer.parseInt(request.getParameter("returnId"));
        int newStatus = Integer.parseInt(request.getParameter("status"));
        String adminNote = request.getParameter("adminNote");
        
        ReturnRequestDAO dao = new ReturnRequestDAO();

        // Server-side validation for mandatory notes
        if ((newStatus == 2 || newStatus == 4 || newStatus == 6) && (adminNote == null || adminNote.trim().isEmpty())) {
            adminNote = "Admin decision applied."; 
        }

        if (newStatus == 5 || newStatus == 7) {
            // --- FINANCIAL REFUND LOGIC ---
            double refundAmount = Double.parseDouble(request.getParameter("refundAmount"));
            String bankRef = request.getParameter("bankReference");
            
            com.group2.bookstore.model.User admin = (com.group2.bookstore.model.User) request.getSession().getAttribute("user");
            String adminUsername = admin.getUsername(); 
            
            // Fetch the original request to get the Book ID, Quantity, and Max Refund
            ReturnRequest originalReq = dao.getReturnById(returnId);
            
            if (refundAmount > originalReq.getMaxRefundableAmount()) {
                refundAmount = originalReq.getMaxRefundableAmount();
            }
            
            // Execute the secure transaction (Now includes Inventory logic!)
            boolean success = dao.processRefund(
                returnId, 
                newStatus, 
                originalReq.getBookId(), 
                originalReq.getQuantity(), 
                adminUsername, 
                refundAmount, 
                bankRef, 
                adminNote
            );
            
            if (!success) {
                response.sendRedirect(request.getContextPath() + "/admin/returns/review?id=" + returnId + "&error=refund_failed");
                return;
            }
            
        } else {
            // --- STANDARD STATUS UPDATE (e.g., Status 2, 3, 4, 6) ---
            dao.updateReturnStatus(returnId, newStatus, adminNote);
            
            // If you wanted to do something specific for Status 4 (Failed QC), 
            // the system natively ignores inventory here, so your damaged goods are safe!
        }

        // Redirect back to the main list
        response.sendRedirect(request.getContextPath() + "/admin/returns");
    }
}