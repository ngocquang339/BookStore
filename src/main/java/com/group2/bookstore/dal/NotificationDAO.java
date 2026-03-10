package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.AdminNotification;

public class NotificationDAO extends DBContext {

    // 1. Get all unread notifications
    public List<AdminNotification> getUnreadNotifications() {
        List<AdminNotification> list = new ArrayList<>();
        String sql = "SELECT notification_id, order_id, message FROM AdminNotifications WHERE is_read = 0 ORDER BY created_at ASC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(new AdminNotification(
                    rs.getInt("notification_id"),
                    rs.getInt("order_id"),
                    rs.getString("message")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Mark a specific notification as Read
    public void markAsRead(int notificationId) {
        String sql = "UPDATE AdminNotifications SET is_read = 1 WHERE notification_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 3. Insert a new notification when an order is placed
    public void insertNotification(int orderId, String message) {
        // Assuming your DB handles the created_at timestamp automatically
        String sql = "INSERT INTO AdminNotifications (order_id, message, is_read) VALUES (?, ?, 0)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setString(2, message);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error inserting notification: " + e.getMessage());
        }
    }
}