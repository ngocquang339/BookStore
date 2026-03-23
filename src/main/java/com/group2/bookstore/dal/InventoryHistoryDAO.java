package com.group2.bookstore.dal;

import com.group2.bookstore.model.InventoryHistory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class InventoryHistoryDAO extends DBContext {

    // 1. Lấy tổng số dòng dữ liệu (phục vụ tính số trang)
    public int getTotalHistoryCount(String typeFilter) {
        String sql = "SELECT COUNT(*) FROM Inventory_History WHERE 1=1 ";
        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql += " AND transaction_type = ? ";
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (typeFilter != null && !typeFilter.isEmpty()) {
                ps.setString(1, typeFilter);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 2. Lấy dữ liệu có Lọc, Sắp xếp và Phân trang
    public List<InventoryHistory> getHistory(String typeFilter, String sortBy, String sortDir, int page, int pageSize) {
        List<InventoryHistory> list = new ArrayList<>();
        
        String sql = "SELECT h.history_id, h.book_id, h.transaction_type, h.quantity_changed, " +
                     "h.related_id, h.created_at, h.created_by, " +
                     "b.title AS book_title, u.username AS created_by_name " +
                     "FROM Inventory_History h " +
                     "JOIN Books b ON h.book_id = b.book_id " +
                     "LEFT JOIN Users u ON h.created_by = u.user_id " +
                     "WHERE 1=1 ";
                     
        // 2.1 Filter
        if (typeFilter != null && !typeFilter.isEmpty()) {
            sql += " AND h.transaction_type = ? ";
        }
        
        // 2.2 Sort (Chống SQL Injection bằng cách check chuỗi cứng)
        String orderCol = "h.created_at"; // Mặc định sắp xếp theo ngày
        if ("qty".equals(sortBy)) orderCol = "h.quantity_changed";
        else if ("book".equals(sortBy)) orderCol = "b.title";
        
        String dir = "ASC".equalsIgnoreCase(sortDir) ? "ASC" : "DESC"; // Mặc định DESC
        sql += " ORDER BY " + orderCol + " " + dir;

        // 2.3 Paging (Phân trang SQL Server 2012+)
        sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            
            if (typeFilter != null && !typeFilter.isEmpty()) {
                ps.setString(paramIndex++, typeFilter);
            }
            
            // Tham số cho Phân trang
            int offset = (page - 1) * pageSize;
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryHistory h = new InventoryHistory();
                    h.setHistoryId(rs.getInt("history_id"));
                    h.setBookId(rs.getInt("book_id"));
                    h.setTransactionType(rs.getString("transaction_type"));
                    h.setQuantityChanged(rs.getInt("quantity_changed"));
                    
                    int relatedId = rs.getInt("related_id");
                    h.setRelatedId(rs.wasNull() ? null : relatedId);
                    h.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    int createdBy = rs.getInt("created_by");
                    h.setCreatedBy(rs.wasNull() ? null : createdBy);
                    
                    h.setBookTitle(rs.getString("book_title"));
                    h.setCreatedByName(rs.getString("created_by_name"));

                    list.add(h);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}