package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminDashboardDAO extends DBContext {

    // 1. Count Total Books (Active + Hidden)
    public int countTotalProducts() {
        String sql = "SELECT COUNT(*) FROM Books";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 2. Count Total Orders
    public int countTotalOrders() {
        String sql = "SELECT COUNT(*) FROM Orders";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 3. Calculate Total Revenue
    // We sum up the total_amount of all orders EXCEPT Cancelled (Status 4)
    public double getTotalRevenue() {
        String sql = "SELECT SUM(total_amount) FROM Orders WHERE status != 4";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 4. Count Total Users (Customers)
    // Assuming Role 2 is Customer
    public int countTotalCustomers() {
        String sql = "SELECT COUNT(*) FROM Users WHERE role = 2";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}