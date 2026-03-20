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

    // 1. Tạo thông báo mới
    public void createNotification(int targetUserId, String message, String link) {
        String sql = "INSERT INTO Notifications (user_id, message, link) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, targetUserId);
            ps.setString(2, message);
            ps.setString(3, link);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 2. Lấy số lượng thông báo chưa đọc để hiển thị lên cục màu đỏ ở cái chuông
    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE user_id = ? AND is_read = 0";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
    
    // 3. Hàm phụ trợ: Lấy UserID dựa vào Username (Cần thiết vì lúc gõ tag chỉ có chữ @username)
    public int getUserIdByUsername(String username) {
        String sql = "SELECT user_id FROM Users WHERE username = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1; // Không tìm thấy
    }

    // 4. Lấy danh sách thông báo mới nhất (VD: 10 cái)
    public java.util.List<com.group2.bookstore.model.Notification> getTopNotifications(int userId, int limit) {
        java.util.List<com.group2.bookstore.model.Notification> list = new java.util.ArrayList<>();
        String sql = "SELECT TOP " + limit + " * FROM Notifications WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.group2.bookstore.model.Notification n = new com.group2.bookstore.model.Notification();
                    n.setId(rs.getInt("notification_id"));
                    n.setUserId(rs.getInt("user_id"));
                    n.setMessage(rs.getString("message"));
                    n.setLink(rs.getString("link"));
                    n.setIsRead(rs.getBoolean("is_read")); // Trong SQL Server kiểu BIT lấy ra bằng getBoolean
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(n);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 5. Đánh dấu thông báo là ĐÃ ĐỌC
    public void markAsReaded(int notificationId) {
        String sql = "UPDATE Notifications SET is_read = 1 WHERE notification_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Đếm tổng số thông báo của User
    public int getTotalNotifications(int userId) {
        String sql = "SELECT COUNT(*) FROM Notifications WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // Lấy thông báo theo Trang (Paging)
    public java.util.List<com.group2.bookstore.model.Notification> getNotificationsPaging(int userId, int page, int pageSize) {
        java.util.List<com.group2.bookstore.model.Notification> list = new java.util.ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = "SELECT * FROM Notifications WHERE user_id = ? ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.group2.bookstore.model.Notification n = new com.group2.bookstore.model.Notification();
                    n.setId(rs.getInt("notification_id"));
                    n.setUserId(rs.getInt("user_id"));
                    n.setMessage(rs.getString("message"));
                    n.setLink(rs.getString("link"));
                    n.setIsRead(rs.getBoolean("is_read"));
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(n);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 6. Xóa một thông báo
    public void deleteNotification(int notificationId) {
        String sql = "DELETE FROM Notifications WHERE notification_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 7. Xóa TẤT CẢ thông báo của một User
    public void deleteAllNotifications(int userId) {
        String sql = "DELETE FROM Notifications WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    // Hàm tạo thông báo mới
    public void insertNotification(int userId, String message, String link) {
        String sql = "INSERT INTO Notifications (user_id, message, link, is_read, created_at) " +
                     "VALUES (?, ?, ?, 0, GETDATE())";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, userId);
            ps.setNString(2, message); 
            ps.setString(3, link); // Dùng cột link
            
            ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("Lỗi khi tạo thông báo: " + e.getMessage());
            e.printStackTrace();
        }
    }
}