package com.group2.bookstore.dal;

import com.group2.bookstore.model.Review;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO extends DBContext {

    // 1. Lấy tất cả đánh giá (Kèm tên User và tên Sách)
    public List<Review> getAllReviews() {
        List<Review> list = new ArrayList<>();
        // JOIN bảng để lấy tên người dùng và tên sách
        String sql = "SELECT r.*, u.username, b.title " +
                     "FROM Review r " +
                     "JOIN Users u ON r.user_id = u.user_id " +
                     "JOIN Books b ON r.book_id = b.book_id " +
                     "ORDER BY r.create_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("review_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setBookId(rs.getInt("book_id"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setCreateAt(rs.getDate("create_at"));
                
                // Set dữ liệu từ bảng Users và Books
                r.setUsername(rs.getString("username"));
                r.setBookTitle(rs.getString("title"));
                
                list.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Xóa đánh giá (Dành cho Staff)
    public void deleteReview(int reviewId) {
        String sql = "DELETE FROM Review WHERE review_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}