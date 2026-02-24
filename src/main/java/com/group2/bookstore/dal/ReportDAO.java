package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

public class ReportDAO extends DBContext {

    // 1. Get Revenue Per Day (Dynamic Date Range)
    // Returns a Map: "2026-01-20" -> 500000.0
    public Map<String, Double> getRevenueByDate(String fromDate, String toDate) {
        Map<String, Double> map = new LinkedHashMap<>();
        
        // SQL: Sum total_amount for Completed orders (status=3) grouped by Date
        String sql = "SELECT CAST(order_date AS DATE) as date, SUM(total_amount) as total " +
                     "FROM Orders " +
                     "WHERE status = 3 " + 
                     "AND order_date BETWEEN ? AND ? + ' 23:59:59' " +
                     "GROUP BY CAST(order_date AS DATE) ORDER BY date";
                     
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fromDate);
            ps.setString(2, toDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("date"), rs.getDouble("total"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
    }

    // 2. Get Order Status Counts (For Doughnut Chart)
    // Returns int array: [Pending, Shipping, Completed, Cancelled]
    public int[] getOrderStatusCounts(String fromDate, String toDate) {
        int[] counts = {0, 0, 0, 0}; // 0=Pending, 1=Shipping, 2=Completed, 3=Cancelled
        
        String sql = "SELECT status, COUNT(*) as count FROM Orders " +
                     "WHERE order_date BETWEEN ? AND ? + ' 23:59:59' " +
                     "GROUP BY status";
                     
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fromDate);
            ps.setString(2, toDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int status = rs.getInt("status");
                // MAP YOUR DB STATUS ID TO ARRAY INDEX HERE:
                // Assuming: 1=Pending, 2=Shipping, 3=Completed, 0=Cancelled
                if (status == 1) counts[0] = rs.getInt("count");      // Pending -> Index 0
                else if (status == 2) counts[1] = rs.getInt("count"); // Shipping -> Index 1
                else if (status == 3) counts[2] = rs.getInt("count"); // Completed -> Index 2
                else if (status == 0) counts[3] = rs.getInt("count"); // Cancelled -> Index 3
            }
        } catch (Exception e) { e.printStackTrace(); }
        return counts;
    }

    // 3. Get Top 5 Best Sellers (For the SELECTED PERIOD)
    // We join OrderDetails to count actual sales in this specific date range
    public Map<String, Integer> getTopSellers(String fromDate, String toDate) {
        Map<String, Integer> map = new LinkedHashMap<>();
        
        String sql = "SELECT TOP 5 b.title, SUM(od.quantity) as sold " +
                     "FROM OrderDetails od " +
                     "JOIN Orders o ON od.order_id = o.order_id " +
                     "JOIN Books b ON od.book_id = b.book_id " +
                     "WHERE o.status = 3 " + // Only count Completed orders
                     "AND o.order_date BETWEEN ? AND ? + ' 23:59:59' " +
                     "GROUP BY b.title " +
                     "ORDER BY sold DESC";
                     
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fromDate);
            ps.setString(2, toDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("title"), rs.getInt("sold"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
    }
}