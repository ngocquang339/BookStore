package com.group2.bookstore.controller;

import java.io.IOException;
import java.util.concurrent.CompletableFuture;

import com.group2.bookstore.dal.OrderDAO;
import com.group2.bookstore.dal.ReturnRequestDAO;
import com.group2.bookstore.dal.VoucherDAO;
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

        // 1. FETCH ORIGINAL REQUEST EARLY (So we have access to refund preference later)
        ReturnRequest originalReq = dao.getReturnById(returnId);

        // BIẾN LƯU TRỮ SỐ TIỀN ĐỂ GỬI EMAIL
        double amountToEmail = 0.0;

        if (newStatus == 5 || newStatus == 7) {
            // --- FINANCIAL REFUND LOGIC ---
            double refundAmount = Double.parseDouble(request.getParameter("refundAmount"));
            String bankRef = request.getParameter("bankReference");

            com.group2.bookstore.model.User admin = (com.group2.bookstore.model.User) request.getSession().getAttribute("user");

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
        
        // Prepare final variables for the background thread
        final String finalEmail = customerEmail;
        final String finalReason = adminNote;
        final double finalRefund = amountToEmail;
        final String refundPreference = originalReq.getRefundPreference();
        
        // Grab the User ID from the related Order so we know whose wallet to put the voucher into!
        OrderDAO orderDao = new OrderDAO();
        Order relatedOrder = orderDao.getOrderById(originalReq.getOrderId());
        final int finalUserId = (relatedOrder != null) ? relatedOrder.getUserId() : 0;

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
                    case 7:
                        boolean customerKeepsItem = (newStatus == 7);
                        
                        // --- NEW STORE CREDIT VOUCHER LOGIC ---
                        if ("Store Credit".equalsIgnoreCase(refundPreference)) {
                            System.out.println("[SYSTEM] Generating Store Credit for User ID: " + finalUserId);
                            
                            // 1. Generate the voucher in the DB (Requires a new DAO instance for thread safety)
                            VoucherDAO asyncDao = new VoucherDAO();
                            String generatedCode = asyncDao.generateRefundVoucher(finalUserId, finalRefund);
                            
                            // 2. Send the specialized Store Credit Email
                            if (generatedCode != null) {
                                EmailUtility.sendStoreCreditEmail(finalEmail, finalRefund, generatedCode, customerKeepsItem, finalReason);
                            } else {
                                System.out.println("[SYSTEM ERROR] Voucher generation failed, falling back to standard email.");
                                EmailUtility.sendRefundSuccessEmail(finalEmail, finalRefund, customerKeepsItem, finalReason);
                            }
                        } else {
                            // Standard Bank Transfer Email
                            EmailUtility.sendRefundSuccessEmail(finalEmail, finalRefund, customerKeepsItem, finalReason);
                        }
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