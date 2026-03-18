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
        String sql = "SELECT r.*, b.title AS book_title, u.username AS customer_name " +
                     "FROM ReturnRequests r " +
                     "JOIN Books b ON r.book_id = b.book_id " +
                     "JOIN Orders o ON r.order_id = o.order_id " +
                     "JOIN Users u ON o.user_id = u.user_id " +
                     "ORDER BY r.created_at DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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
        // We join OrderDetails to find the exact discounted price the customer paid for this specific book
        String sql = "SELECT r.*, b.title AS book_title, u.username AS customer_name, " +
                     "(od.price * r.quantity) AS max_refundable " +
                     "FROM ReturnRequests r " +
                     "JOIN Books b ON r.book_id = b.book_id " +
                     "JOIN Orders o ON r.order_id = o.order_id " +
                     "JOIN Users u ON o.user_id = u.user_id " +
                     "JOIN OrderDetails od ON o.order_id = od.order_id AND r.book_id = od.book_id " +
                     "WHERE r.return_id = ?";
                     
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, returnId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
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
                    
                    // The crucial financial validation number
                    req.setMaxRefundableAmount(rs.getDouble("max_refundable"));
                    
                    return req;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 2. Update the status and add the mandatory Admin Note
    public void updateReturnStatus(int returnId, int status, String adminNote) {
        String sql = "UPDATE ReturnRequests SET status = ?, admin_note = ? WHERE return_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setString(2, adminNote);
            ps.setInt(3, returnId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 2. Process the financial refund securely using an ACID Transaction
    // Process the refund AND handle inventory securely
    public boolean processRefund(int returnId, int newStatus, int bookId, int quantity, 
                                 String adminUsername, double refundAmount, String bankRef, String adminNote) {
                                     
        String updateStatusSql = "UPDATE ReturnRequests SET status = ?, admin_note = ? WHERE return_id = ?";
        String insertLedgerSql = "INSERT INTO RefundTransactions (return_id, processed_by, refund_amount, bank_reference) VALUES (?, ?, ?, ?)";
        // NOTE: Check if your Books table uses 'quantity' or 'stock' for the column name!
        String updateInventorySql = "UPDATE Books SET stock_quantity = stock_quantity + ? WHERE book_id = ?"; 
        
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // START TRANSACTION
            
            // Query 1: Update Status (Works for both 5 and 7)
            try (PreparedStatement ps1 = conn.prepareStatement(updateStatusSql)) {
                ps1.setInt(1, newStatus);
                ps1.setString(2, adminNote);
                ps1.setInt(3, returnId);
                ps1.executeUpdate();
            }
            
            // Query 2: Insert Ledger
            try (PreparedStatement ps2 = conn.prepareStatement(insertLedgerSql)) {
                ps2.setInt(1, returnId);
                ps2.setString(2, adminUsername);
                ps2.setDouble(3, refundAmount);
                ps2.setString(4, bankRef);
                ps2.executeUpdate();
            }
            
            // Query 3: Conditional Inventory Restock!
            // Only add the book back if it is Status 5 (Returned in sellable condition)
            if (newStatus == 5) {
                try (PreparedStatement ps3 = conn.prepareStatement(updateInventorySql)) {
                    ps3.setInt(1, quantity);
                    ps3.setInt(2, bookId);
                    ps3.executeUpdate();
                }
            }
            
            conn.commit(); // COMMIT ALL QUERIES
            return true;
            
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (Exception ex) { ex.printStackTrace(); }
            }
        }
    }

    public List<ReturnReportDTO> getTopReturnedBooks(int limit) {
    List<ReturnReportDTO> list = new ArrayList<>();
    String sql = "SELECT TOP (?) b.title, b.author, COUNT(r.return_id) as return_count, " +
                 "SUM(rt.refund_amount) as total_refunded_value " +
                 "FROM ReturnRequests r " +
                 "JOIN Books b ON r.book_id = b.book_id " +
                 "LEFT JOIN RefundTransactions rt ON r.return_id = rt.return_id " +
                 "GROUP BY b.title, b.author " +
                 "ORDER BY return_count DESC";

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
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
}