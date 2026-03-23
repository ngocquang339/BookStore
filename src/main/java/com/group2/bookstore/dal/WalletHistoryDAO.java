package com.group2.bookstore.dal;

import com.group2.bookstore.model.WalletHistory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class WalletHistoryDAO extends DBContext {

    // Lấy toàn bộ lịch sử giao dịch ví của 1 User (Sắp xếp mới nhất lên đầu)
    public List<WalletHistory> getHistoryByUserId(int userId) {
        List<WalletHistory> list = new ArrayList<>();
        String sql = "SELECT * FROM Wallet_History WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WalletHistory wh = new WalletHistory();
                    wh.setTransactionId(rs.getInt("transaction_id"));
                    wh.setUserId(rs.getInt("user_id"));
                    wh.setAmount(rs.getDouble("amount"));
                    wh.setTransactionType(rs.getString("transaction_type"));
                    wh.setDescription(rs.getNString("description")); // Dùng getNString hỗ trợ Tiếng Việt
                    wh.setOrderId(rs.getInt("order_id"));
                    wh.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    list.add(wh);
                }
            }
        } catch (Exception e) {
            System.err.println("=== LỖI KHI LẤY LỊCH SỬ VÍ: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Hàm lưu lịch sử biến động ví
    public void insertHistory(WalletHistory wh) {
        String sql = "INSERT INTO Wallet_History (user_id, amount, transaction_type, description, order_id, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, wh.getUserId());
            ps.setDouble(2, wh.getAmount());
            ps.setString(3, wh.getTransactionType());
            ps.setNString(4, wh.getDescription());
            
            // Xử lý nếu order_id bằng 0 thì lưu NULL vào DB
            if (wh.getOrderId() > 0) {
                ps.setInt(5, wh.getOrderId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}