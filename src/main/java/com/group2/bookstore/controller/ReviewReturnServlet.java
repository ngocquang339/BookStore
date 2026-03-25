package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.concurrent.CompletableFuture;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.dal.ReturnRequestDAO;
import com.group2.bookstore.model.Order;
import com.group2.bookstore.model.ReturnRequest;
import com.group2.bookstore.util.EmailUtility;

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
        
        System.out.println("[SERVLET DEBUG] Review Page requested for ID: " + idParam);

        if (idParam != null) {
            ReturnRequestDAO dao = new ReturnRequestDAO();
            ReturnRequest returnReq = dao.getReturnById(Integer.parseInt(idParam));

            if (returnReq != null) {
                System.out.println("[SERVLET DEBUG] Success! Found return request, sending to JSP.");
                request.setAttribute("req", returnReq);
                request.getRequestDispatcher("/view/admin/review-return.jsp").forward(request, response);
                return;
            } else {
                System.out.println("[SERVLET DEBUG] FAILED: DAO returned null for ID: " + idParam);
            }
        }
        
        System.out.println("[SERVLET DEBUG] Redirecting back to /admin/returns list...");
        response.sendRedirect(request.getContextPath() + "/admin/returns");
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    int returnId = Integer.parseInt(request.getParameter("returnId"));
    int newStatus = Integer.parseInt(request.getParameter("status"));
    String adminNote = request.getParameter("adminNote");
    String customerEmail = request.getParameter("customerEmail");

    ReturnRequestDAO dao = new ReturnRequestDAO();

    if ((newStatus == 2 || newStatus == 4 || newStatus == 6) && (adminNote == null || adminNote.trim().isEmpty())) {
        adminNote = "Admin decision applied.";
    }

    ReturnRequest originalReq = dao.getReturnById(returnId);

    // Lấy User ID từ Order
    OrderDAO orderDao = new OrderDAO();
    Order relatedOrder = orderDao.getOrderById(originalReq.getOrderId());
    int userId = (relatedOrder != null) ? relatedOrder.getUserId() : 0;

    double amountToEmail = 0.0;

    if (newStatus == 5 || newStatus == 7) {
        // --- WALLET REFUND LOGIC ---
        double refundAmount = Double.parseDouble(request.getParameter("refundAmount"));

        if (refundAmount > originalReq.getMaxRefundableAmount()) {
            refundAmount = originalReq.getMaxRefundableAmount();
        }

        // Call our new atomic transaction method!
        boolean success = dao.processWalletRefund(returnId, originalReq.getOrderId(), newStatus, 
                                                  originalReq.getBookId(), originalReq.getQuantity(), 
                                                  userId, refundAmount, adminNote);

        if (!success) {
            response.sendRedirect(request.getContextPath() + "/admin/returns/review?id=" + returnId + "&error=refund_failed");
            return;
        }

        amountToEmail = refundAmount;

    } else {
        // --- STANDARD STATUS UPDATE ---
        dao.updateReturnStatus(returnId, newStatus, adminNote);
    }

    // ==========================================
    // ASYNC EMAIL NOTIFICATIONS
    // ==========================================
    final String finalEmail = customerEmail;
    final String finalReason = adminNote;
    final double finalRefund = amountToEmail;

    if (finalEmail != null && !finalEmail.trim().isEmpty()) {
        CompletableFuture.runAsync(() -> {
            switch (newStatus) {
                case 2:
                    EmailUtility.sendActionRequiredEmail(finalEmail, finalReason);
                    break;
                case 4: 
                case 6: 
                    EmailUtility.sendRejectionEmail(finalEmail, finalReason);
                    break;
                case 5:
                case 7:
                    boolean customerKeepsItem = (newStatus == 7);
                    // Updated to send a specific "Money added to Website Wallet" email
                    EmailUtility.sendRefundSuccessEmail(finalEmail, finalRefund, customerKeepsItem, finalReason); 
                    break;
            }
        });
    }

    response.sendRedirect(request.getContextPath() + "/admin/returns");
}
}