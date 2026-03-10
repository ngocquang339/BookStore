package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.concurrent.CompletableFuture;

import com.group2.bookstore.dal.ReturnRequestDAO;
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
        String customerEmail = request.getParameter("customerEmail");

        ReturnRequestDAO dao = new ReturnRequestDAO();

        if ((newStatus == 2 || newStatus == 4 || newStatus == 6) && (adminNote == null || adminNote.trim().isEmpty())) {
            adminNote = "Admin decision applied.";
        }

        // BIẾN LƯU TRỮ SỐ TIỀN ĐỂ GỬI EMAIL
        double amountToEmail = 0.0;

        if (newStatus == 5 || newStatus == 7) {
            // --- FINANCIAL REFUND LOGIC ---
            double refundAmount = Double.parseDouble(request.getParameter("refundAmount"));
            String bankRef = request.getParameter("bankReference");

            com.group2.bookstore.model.User admin = (com.group2.bookstore.model.User) request.getSession().getAttribute("user");

            ReturnRequest originalReq = dao.getReturnById(returnId);
            if (refundAmount > originalReq.getMaxRefundableAmount()) {
                refundAmount = originalReq.getMaxRefundableAmount();
            }

            boolean success = dao.processRefund(returnId, newStatus, originalReq.getBookId(), originalReq.getQuantity(), admin.getUsername(), refundAmount, bankRef, adminNote);

            if (!success) {
                response.sendRedirect(request.getContextPath() + "/admin/returns/review?id=" + returnId + "&error=refund_failed");
                return;
            }

            // Lưu lại số tiền chính xác để gửi vào email
            amountToEmail = refundAmount;

        } else {
            // --- STANDARD STATUS UPDATE ---
            dao.updateReturnStatus(returnId, newStatus, adminNote);
        }

        // ==========================================
        // ✨ TỰ ĐỘNG GỬI EMAIL THEO TRẠNG THÁI (BACKGROUND) ✨
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
                    case 4: // Failed QC
                    case 6: // Rejected Upfront
                        EmailUtility.sendRejectionEmail(finalEmail, finalReason);
                        break;
                    case 5:
                        // Hoàn tiền, đã thu hồi hàng (customerKeepsItem = false)
                        EmailUtility.sendRefundSuccessEmail(finalEmail, finalRefund, false, finalReason);
                        break;
                    case 7:
                        // Hoàn tiền, khách giữ lại hàng (customerKeepsItem = true)
                        EmailUtility.sendRefundSuccessEmail(finalEmail, finalRefund, true, finalReason);
                        break;
                    default:
                        System.out.println("Không có cấu hình gửi email cho trạng thái: " + newStatus);
                        break;
                }
            });
        }

        response.sendRedirect(request.getContextPath() + "/admin/returns");
    }
}
