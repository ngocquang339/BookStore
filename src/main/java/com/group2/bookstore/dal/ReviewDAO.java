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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Xóa đánh giá (Dành cho Staff)
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

    // --- NÂNG CẤP: LỌC REVIEW THEO SỐ SAO ---
    public List<Review> getReviewsByStar(String starFilter) {
        List<Review> list = new ArrayList<>();

        // Dùng JOIN để lấy tên khách hàng (từ bảng Users) và tên sách (từ bảng Books)
        // (Lưu ý:Hãy kiểm tra tên bảng và tên cột u.id, b.id xem đã khớp với DB chưa nhé)
        String sql = "SELECT r.review_id, r.user_id, r.book_id, r.rating, r.comment, r.create_at, " +
                "u.username, b.title AS book_title " +
                "FROM Reviews r " +
                "JOIN Users u ON r.user_id = u.id " +
                "JOIN Books b ON r.book_id = b.id ";

        if (starFilter != null && !starFilter.isEmpty() && !starFilter.equals("all")) {
            sql += " WHERE r.rating = ? ";
        }
        sql += " ORDER BY r.create_at DESC";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            if (starFilter != null && !starFilter.isEmpty() && !starFilter.equals("all")) {
                ps.setInt(1, Integer.parseInt(starFilter));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("review_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setBookId(rs.getInt("book_id"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setCreateAt(rs.getDate("create_at"));
                r.setUsername(rs.getString("username"));
                r.setBookTitle(rs.getString("book_title"));

                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}