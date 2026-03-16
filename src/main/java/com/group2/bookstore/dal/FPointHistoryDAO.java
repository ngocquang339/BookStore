package com.group2.bookstore.dal;

import com.group2.bookstore.model.FPointHistory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class FPointHistoryDAO extends DBContext {

    // HÀM LƯU LỊCH SỬ CỘNG/TRỪ ĐIỂM
    public boolean insertLog(FPointHistory log) {
        String sql = "INSERT INTO FPoint_History (user_id, customer_info, action_type, amount, reason, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, log.getUserId());
            ps.setString(2, log.getCustomerInfo());
            ps.setString(3, log.getActionType());
            ps.setInt(4, log.getAmount());
            ps.setNString(5, log.getReason()); // setNString hỗ trợ tiếng Việt có dấu
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("Lỗi khi lưu lịch sử F-Point: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // HÀM LẤY DANH SÁCH LỊCH SỬ (Đưa lên bảng UI)
    public List<FPointHistory> getAllHistory() {
        List<FPointHistory> list = new ArrayList<>();
        // Lấy lịch sử mới nhất lên đầu tiên
        String sql = "SELECT * FROM FPoint_History ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                FPointHistory h = new FPointHistory();
                h.setHistoryId(rs.getInt("history_id"));
                h.setUserId(rs.getInt("user_id"));
                h.setCustomerInfo(rs.getString("customer_info"));
                h.setActionType(rs.getString("action_type"));
                h.setAmount(rs.getInt("amount"));
                h.setReason(rs.getString("reason"));
                h.setCreatedAt(rs.getTimestamp("created_at"));
                
                list.add(h);
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy danh sách F-Point: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
public List<FPointHistory> getFilteredHistory(String startDate, String endDate, String type) {
    List<FPointHistory> list = new ArrayList<>();
    
    // Khởi tạo câu query gốc
    StringBuilder sql = new StringBuilder("SELECT * FROM FPoint_History WHERE 1=1 ");
    List<Object> params = new ArrayList<>();

    // Nếu có chọn "Từ ngày"
    if (startDate != null && !startDate.trim().isEmpty()) {
        sql.append(" AND CAST(created_at AS DATE) >= ? ");
        params.add(startDate);
    }
    
    // Nếu có chọn "Đến ngày"
    if (endDate != null && !endDate.trim().isEmpty()) {
        sql.append(" AND CAST(created_at AS DATE) <= ? ");
        params.add(endDate);
    }
    
    // Nếu có chọn "Chỉ cộng" hoặc "Chỉ trừ"
    if (type != null && (type.equals("add") || type.equals("sub"))) {
        sql.append(" AND action_type = ? ");
        params.add(type);
    }
    
    sql.append(" ORDER BY created_at DESC");

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
         
        // Truyền các tham số vào dấu ? tương ứng
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                FPointHistory h = new FPointHistory();
                h.setHistoryId(rs.getInt("history_id"));
                h.setUserId(rs.getInt("user_id"));
                h.setCustomerInfo(rs.getString("customer_info"));
                h.setActionType(rs.getString("action_type"));
                h.setAmount(rs.getInt("amount"));
                h.setReason(rs.getString("reason"));
                h.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(h);
            }
        }
    } catch (Exception e) {
        System.err.println("Lỗi khi lọc danh sách F-Point: " + e.getMessage());
        e.printStackTrace();
    }
    return list;
}
}