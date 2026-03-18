package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.ReturnReportDTO;
import com.group2.bookstore.model.ReturnRequest;

public class ReturnRequestDAO extends DBContext {

    public List<ReturnRequest> getAllReturns() {
        List<ReturnRequest> list = new ArrayList<>();
        // The JOIN pulls the human-readable names for the Admin dashboard
        String sql = "SELECT r.*, b.title AS book_title, u.username AS customer_name "
                + "FROM ReturnRequests r "
                + "JOIN Books b ON r.book_id = b.book_id "
                + "JOIN Orders o ON r.order_id = o.order_id "
                + "JOIN Users u ON o.user_id = u.user_id "
                + "ORDER BY r.created_at DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ReturnRequest req = new ReturnRequest();
                req.setReturnId(rs.getInt("return_id"));
                req.setOrderId(rs.getInt("order_id"));
                req.setBookId(rs.getInt("book_id"));
                req.setQuantity(rs.getInt("quantity"));
                req.setCustomerReason(rs.getString("customer_reason"));
                req.setReturnMethod(rs.getString("return_method"));
                req.setRefundPreference(rs.getString("refund_preference"));
                req.setStatus(rs.getInt("status"));
                req.setAdminNote(rs.getString("admin_note"));
                req.setCreatedAt(rs.getTimestamp("created_at"));

                // Set the extra JOIN fields
                req.setBookTitle(rs.getString("book_title"));
                req.setCustomerName(rs.getString("customer_name"));

                list.add(req);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 1. Fetch a single return request AND calculate max refund
    public ReturnRequest getReturnById(int returnId) {
        System.out.println("[DAO DEBUG] Executing getReturnById for ID: " + returnId);
        // We join OrderDetails to find the exact discounted price the customer paid for this specific book
        // ✨ NEW: Added u.email AS customer_email to support automated email notifications ✨
        String sql = "SELECT r.*, b.title AS book_title, u.username AS customer_name, u.email AS customer_email, "
           + "(od.price * r.quantity) AS max_refundable "
           + "FROM ReturnRequests r "
           + "LEFT JOIN Books b ON r.book_id = b.book_id "
           + "LEFT JOIN Orders o ON r.order_id = o.order_id "
           + "LEFT JOIN Users u ON o.user_id = u.user_id "
           + "LEFT JOIN OrderDetails od ON o.order_id = od.order_id AND r.book_id = od.book_id "
           + "WHERE r.return_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, returnId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    System.out.println("[DAO DEBUG] rs.next() is TRUE. Record found in database!");
                    ReturnRequest req = new ReturnRequest();
                    req.setReturnId(rs.getInt("return_id"));
                    req.setOrderId(rs.getInt("order_id"));
                    req.setBookId(rs.getInt("book_id"));
                    req.setQuantity(rs.getInt("quantity"));
                    req.setCustomerReason(rs.getString("customer_reason"));
                    req.setReturnMethod(rs.getString("return_method"));
                    req.setRefundPreference(rs.getString("refund_preference"));
                    req.setStatus(rs.getInt("status"));
                    req.setAdminNote(rs.getString("admin_note"));

                    // The banking details your teammate will insert
                    req.setBankName(rs.getString("bank_name"));
                    req.setAccountNumber(rs.getString("account_number"));
                    req.setAccountOwner(rs.getString("account_owner"));

                    req.setCreatedAt(rs.getTimestamp("created_at"));
                    req.setBookTitle(rs.getString("book_title"));
                    req.setCustomerName(rs.getString("customer_name"));

                    // ✨ NEW: Map the joined email to the object ✨
                    req.setUserEmail(rs.getString("customer_email"));

                    // The crucial financial validation number
                    req.setMaxRefundableAmount(rs.getDouble("max_refundable"));
                    System.out.println("[DAO DEBUG] Successfully mapped data to model. Returning object.");
                    return req;
                }else {
                    System.out.println("[DAO DEBUG] rs.next() is FALSE. No record found for ID: " + returnId);
                }
            }
        } catch (Exception e) {
            System.out.println("[DAO CRASH] An error occurred in getReturnById!");
        System.out.println("[DAO ERROR MESSAGE] " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // 2. Update the status and add the mandatory Admin Note
    public void updateReturnStatus(int returnId, int status, String adminNote) {
        String sql = "UPDATE ReturnRequests SET status = ?, admin_note = ? WHERE return_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setString(2, adminNote);
            ps.setInt(3, returnId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean processRefund(int returnId, int newStatus, int bookId, int quantity,
            String adminUsername, double refundAmount, String bankRef, String adminNote) {

        String updateStatusSql = "UPDATE ReturnRequests SET status = ?, admin_note = ? WHERE return_id = ?";
        
        // ✨ FIXED: Updated column names to match your SQL Server exactly ✨
        String insertLedgerSql = "INSERT INTO RefundTransactions (return_id, processed_by, refund_amount, bank_reference) VALUES (?, ?, ?, ?)";
        
        String updateInventorySql = "UPDATE Books SET stock_quantity = stock_quantity + ? WHERE book_id = ?";

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // START TRANSACTION

            // Query 1: Update Return Status
            try (PreparedStatement ps1 = conn.prepareStatement(updateStatusSql)) {
                ps1.setInt(1, newStatus);
                ps1.setString(2, adminNote);
                ps1.setInt(3, returnId);
                ps1.executeUpdate();
            }

            // Query 2: Insert Ledger / Refund Transaction
            try (PreparedStatement ps2 = conn.prepareStatement(insertLedgerSql)) {
                ps2.setInt(1, returnId);
                ps2.setString(2, adminUsername);
                ps2.setDouble(3, refundAmount);
                ps2.setString(4, bankRef);
                ps2.executeUpdate();
            }

            // =============================================================
            // ✨ Query 3: FEATURE 2 - CONDITIONAL INVENTORY RESTOCK ✨
            // =============================================================
            if (newStatus == 5) {
                // Status 5: Item returned in sellable condition -> ADD back to stock
                try (PreparedStatement ps3 = conn.prepareStatement(updateInventorySql)) {
                    ps3.setInt(1, quantity);
                    ps3.setInt(2, bookId);
                    ps3.executeUpdate();
                    System.out.println("[INVENTORY] Restocked " + quantity + " units for Book ID: " + bookId);
                }
            } else if (newStatus == 7) {
                // Status 7: Customer keeps the item -> NO restock
                System.out.println("[INVENTORY] Status 7 (Customer Keeps Item). No active stock added.");
            } else if (newStatus == 4) {
                // Status 4: Failed QC -> NO restock
                System.out.println("[INVENTORY] Status 4 (Failed QC). Item in warehouse but NOT added to active stock.");
            }

            conn.commit(); // COMMIT ALL QUERIES
            return true;

        } catch (Exception e) {
            System.out.println("[TRANSACTION ERROR] Rolling back refund process for Return ID: " + returnId);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    public List<ReturnReportDTO> getTopReturnedBooks(int limit) {
        List<ReturnReportDTO> list = new ArrayList<>();
        String sql = "SELECT TOP (?) b.title, b.author, COUNT(r.return_id) as return_count, "
                + "SUM(rt.refund_amount) as total_refunded_value "
                + "FROM ReturnRequests r "
                + "JOIN Books b ON r.book_id = b.book_id "
                + "LEFT JOIN RefundTransactions rt ON r.return_id = rt.return_id "
                + "GROUP BY b.title, b.author "
                + "ORDER BY return_count DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ReturnReportDTO dto = new ReturnReportDTO();
                dto.setBookTitle(rs.getString("title"));
                dto.setAuthor(rs.getString("author"));
                dto.setReturnCount(rs.getInt("return_count"));
                dto.setTotalRefunded(rs.getDouble("total_refunded_value"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void autoCancelStaleReturns() {
        
        String sql = "UPDATE ReturnRequests "
                + "SET status = 6, "
                + "    admin_note = 'System Auto-Cancel: Customer did not ship within 5 days' "
                + "WHERE status = 3 "
                + "AND DATEDIFF(DAY, approved_at, GETDATE()) >= 5";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                System.out.println("[SYSTEM] Auto-cancelled " + rowsAffected + " stale return requests.");
            }

        } catch (Exception e) {
            System.out.println("[SYSTEM ERROR] Failed to run auto-cancel job.");
            e.printStackTrace();
        }
    }

    // Inside ReturnDAO.java - the method where Admin approves the return
    public void approveReturnRequest(int returnId, String adminNote) {
        // We update the status AND stamp the current time!
        String sql = "UPDATE ReturnRequests SET status = 3, approved_at = GETDATE(), admin_note = ? WHERE return_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, adminNote);
            ps.setInt(2, returnId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
