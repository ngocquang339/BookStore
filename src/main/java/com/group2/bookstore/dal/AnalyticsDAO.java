package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AnalyticsDAO extends DBContext {

    public List<String> getSmartBusinessAdvice() {
        List<String> adviceList = new ArrayList<>();

        try (Connection conn = getConnection()) {
            
            // RULE 1: Fast-Selling but Low Stock (Selling > 5 in last 7 days, but stock < 10)
            String sqlRestock = "SELECT b.title, b.stock_quantity, SUM(od.quantity) as recent_sales " +
                                "FROM Books b " +
                                "JOIN OrderDetails od ON b.book_id = od.book_id " +
                                "JOIN Orders o ON od.order_id = o.order_id " +
                                "WHERE o.order_date >= DATEADD(day, -7, GETDATE()) AND o.status = 3 " +
                                "GROUP BY b.title, b.stock_quantity " +
                                "HAVING SUM(od.quantity) >= 5 AND b.stock_quantity <= 10";
            
            try (PreparedStatement ps = conn.prepareStatement(sqlRestock);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    adviceList.add("🔥 Hot Item Alert: '" + rs.getString("title") + "' sold " + 
                                   rs.getInt("recent_sales") + " copies this week but only has " + 
                                   rs.getInt("stock_quantity") + " left in stock. Consider restocking immediately.");
                }
            }

            // RULE 2: Dead Stock (Aggregated Summary + Top 3 Worst Offenders)
            
            // First, just COUNT how many books are dead stock
            String sqlDeadStockCount = "SELECT COUNT(*) as total_dead FROM Books " +
                                       "WHERE stock_quantity > 20 AND book_id NOT IN (" +
                                       "  SELECT DISTINCT od.book_id FROM OrderDetails od " +
                                       "  JOIN Orders o ON od.order_id = o.order_id " +
                                       "  WHERE o.order_date >= DATEADD(day, -30, GETDATE())" +
                                       ")";
            
            int totalDeadStock = 0;
            try (PreparedStatement ps = conn.prepareStatement(sqlDeadStockCount);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalDeadStock = rs.getInt("total_dead");
                }
            }

            // If we have dead stock, print ONE summary warning, and then list ONLY the top 3 worst ones
            if (totalDeadStock > 0) {
                adviceList.add("📦 Store-wide Inventory Warning: You have " + totalDeadStock + " different book titles with high stock that haven't sold a single copy in 30 days. Consider a clearance sale event!");
                
                // Now get just the top 3 worst offenders, ordered by whoever has the HIGHEST stock
                // Added 'price DESC' to the ORDER BY clause
                String sqlDeadStockTop3 = "SELECT TOP 3 title, stock_quantity, price FROM Books " +
                                          "WHERE stock_quantity > 20 AND book_id NOT IN (" +
                                          "  SELECT DISTINCT od.book_id FROM OrderDetails od " +
                                          "  JOIN Orders o ON od.order_id = o.order_id " +
                                          "  WHERE o.order_date >= DATEADD(day, -30, GETDATE())" +
                                          ") ORDER BY stock_quantity DESC, price DESC"; 
                
                try (PreparedStatement ps = conn.prepareStatement(sqlDeadStockTop3);
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        // Let's also format the price into the advice so the manager knows how much money is trapped!
                        long trappedValue = rs.getInt("stock_quantity") * (long)rs.getDouble("price");
                        
                        adviceList.add("📉 High-Value Dead Stock: '" + rs.getString("title") + "' has " + 
                                       rs.getInt("stock_quantity") + " copies sitting unsold. " +
                                       "That is " + String.format("%,d đ", trappedValue) + " in trapped capital. " +
                                       "Discount this immediately!");
                    }
                }
            }

            // RULE 3: Top Performing Category
            String sqlTopCategory = "SELECT TOP 1 c.category_name, SUM(od.quantity * od.price) as revenue " +
                                    "FROM Categories c " +
                                    "JOIN Books b ON c.category_id = b.category_id " +
                                    "JOIN OrderDetails od ON b.book_id = od.book_id " +
                                    "JOIN Orders o ON od.order_id = o.order_id " +
                                    "WHERE o.status = 3 AND o.order_date >= DATEADD(day, -30, GETDATE()) " +
                                    "GROUP BY c.category_name " +
                                    "ORDER BY revenue DESC";
            
                                    // RULE 4: Top 3 VIP Customers (Last 30 Days) + Favorite Categories
            String sqlTopCustomers = "SELECT TOP 3 u.user_id, u.fullname, SUM(o.total_amount) as total_spent " +
                                     "FROM Users u " +
                                     "JOIN Orders o ON u.user_id = o.user_id " +
                                     "WHERE o.status = 3 AND o.order_date >= DATEADD(day, -30, GETDATE()) " +
                                     "GROUP BY u.user_id, u.fullname " +
                                     "ORDER BY total_spent DESC";

            try (PreparedStatement psTopUsers = conn.prepareStatement(sqlTopCustomers);
                 ResultSet rsTopUsers = psTopUsers.executeQuery()) {
                
                int rank = 1; // Keep track of whether they are 1st, 2nd, or 3rd
                
                // Use a WHILE loop to process all 3 top customers
                while (rsTopUsers.next()) {
                    int topUserId = rsTopUsers.getInt("user_id");
                    String topUserName = rsTopUsers.getString("fullname");
                    double totalSpent = rsTopUsers.getDouble("total_spent");

                    // Find this specific user's favorite category
                    String sqlFavCategory = "SELECT TOP 1 c.category_name, SUM(od.quantity) as items_bought " +
                                            "FROM OrderDetails od " +
                                            "JOIN Orders o ON od.order_id = o.order_id " +
                                            "JOIN Books b ON od.book_id = b.book_id " +
                                            "JOIN Categories c ON b.category_id = c.category_id " +
                                            "WHERE o.user_id = ? AND o.status = 3 " +
                                            "GROUP BY c.category_name " +
                                            "ORDER BY items_bought DESC";
                    
                    try (PreparedStatement psFavCat = conn.prepareStatement(sqlFavCategory)) {
                        psFavCat.setInt(1, topUserId);
                        try (ResultSet rsFavCat = psFavCat.executeQuery()) {
                            
                            String favoriteCategory = "mixed genres";
                            if (rsFavCat.next()) {
                                favoriteCategory = rsFavCat.getString("category_name");
                            }
                            
                            // Generate the smart advice using their rank!
                            String medal = rank == 1 ? "🥇" : (rank == 2 ? "🥈" : "🥉");
                            
                            adviceList.add(medal + " VIP Tier " + rank + ": '" + topUserName + "' spent " + 
                                           String.format("%,.0f đ", totalSpent) + " recently. " +
                                           "Target them with a personalized email featuring new '" + favoriteCategory + "' arrivals.");
                            rank++;
                        }
                    }
                }
            }
            
            try (PreparedStatement ps = conn.prepareStatement(sqlTopCategory);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    adviceList.add("🏆 Trend Insight: " + rs.getString("category_name") + 
                                   " is your most profitable category this month. " +
                                   "Update your homepage banner to feature these books!");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // If everything is perfect and no rules trigger
        if (adviceList.isEmpty()) {
            adviceList.add("✅ Your inventory and sales are perfectly balanced. Keep up the good work!");
        }

        return adviceList;
    }
}