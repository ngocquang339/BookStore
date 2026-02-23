package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.group2.bookstore.model.Book;

public class ReportDAO extends DBContext {

    // 1. Get Revenue for the Last 7 Days
    // Returns a Map: Key="2023-10-25" -> Value=500.00
    public Map<String, Double> getLast7DaysRevenue() {
        Map<String, Double> map = new LinkedHashMap<>();
        
        // SQL: Get last 7 days, sum total_price, group by date
        String sql = "SELECT CAST(order_date AS DATE) as date, SUM(total_amount) as revenue " +
                     "FROM Orders " +
                     "WHERE status = 3 " + // Only count Completed/Delivered orders (Status 3)
                     "GROUP BY CAST(order_date AS DATE) " +
                     "ORDER BY date DESC"; // Get newest first

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            // We usually want to limit to 7 rows in Java or SQL (TOP 7)
            int count = 0;
            while (rs.next() && count < 7) {
                map.put(rs.getString("date"), rs.getDouble("revenue"));
                count++;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
    }

    // 2. Get Top 5 Best Selling Books
    public List<Book> getTopSellingBooks() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT TOP 5 * FROM Books ORDER BY sold_quantity DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Book b = new Book();
                b.setTitle(rs.getString("title"));
                b.setSoldQuantity(rs.getInt("sold_quantity"));
                list.add(b);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}