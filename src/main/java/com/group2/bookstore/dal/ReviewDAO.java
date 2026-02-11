package com.group2.bookstore.dal;

import com.group2.bookstore.model.Review;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO extends DBContext {

    // 1. Lấy tất cả đánh giá (Kèm tên khách và tên sách)
    public List<Review> getAllReviews() {
        List<Review> list = new ArrayList<>();
        // JOIN 3 bảng để lấy thông tin đầy đủ
        String sql = "SELECT r.review_id, r.rating, r.comment, r.create_at, r.user_id, r.book_id, " +
                     "u.username, b.title " +
                     "FROM Review r " +
                     "JOIN Users u ON r.user_id = u.user_id " +
                     "JOIN Books b ON r.book_id = b.book_id " +
                     "ORDER BY r.create_at DESC"; // Mới nhất lên đầu
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Review r = new Review(
                    rs.getInt("review_id"),
                    rs.getInt("rating"),
                    rs.getString("comment"),
                    rs.getDate("create_at"),
                    rs.getInt("user_id"),
                    rs.getInt("book_id"),
                    rs.getString("username"), // Lấy tên khách
                    rs.getString("title")     // Lấy tên sách
                );
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Xóa đánh giá (Dành cho Staff khi thấy spam/vi phạm)
    public void deleteReview(int reviewId) {
        String sql = "DELETE FROM Review WHERE review_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}