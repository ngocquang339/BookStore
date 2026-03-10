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

    // --- ĐÃ NÂNG CẤP: NHẬN THAM SỐ INT VÀ CHỐNG RÒ RỈ RAM ---
    public List<Review> getReviewsByStar(int starValue) {
        List<Review> list = new ArrayList<>();

        // Cấu trúc SQL đã được fix chuẩn tên bảng (Review) và khóa ngoại (user_id,
        // book_id)
        String sql = "SELECT r.review_id, r.user_id, r.book_id, r.rating, r.comment, r.create_at, r.staff_reply, " +
                "u.username, u.email, b.title AS book_title " +
                "FROM Review r " +
                "JOIN Users u ON r.user_id = u.user_id " +
                "JOIN Books b ON r.book_id = b.book_id ";
        // Quy ước: starValue = 0 nghĩa là "Lấy tất cả", từ 1-5 là lọc theo sao
        if (starValue >= 1 && starValue <= 5) {
            sql += " WHERE r.rating = ? ";
        }
        sql += " ORDER BY r.create_at DESC";

        // Sử dụng Try-with-resources để tự động đóng Connection và PreparedStatement
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            // Nếu có điều kiện lọc sao, truyền giá trị vào dấu ?
            if (starValue >= 1 && starValue <= 5) {
                ps.setInt(1, starValue);
            }

            // Mở ResultSet cũng phải đưa vào Try-with-resources
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setReviewId(rs.getInt("review_id"));
                    r.setUserId(rs.getInt("user_id"));
                    r.setBookId(rs.getInt("book_id"));
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setCreateAt(rs.getDate("create_at"));
                    r.setUsername(rs.getString("username"));
                    r.setEmail(rs.getString("email"));
                    r.setBookTitle(rs.getString("book_title"));
                    r.setStaffReply(rs.getString("staff_reply"));
                    list.add(r);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi SQL khi lọc Review: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public void updateStaffReply(int reviewId, String replyText) {
        String sql = "UPDATE Review SET staff_reply = ? WHERE review_id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, replyText);
            ps.setInt(2, reviewId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Hàm 1: Lưu đánh giá mới vào Database
    public boolean insertReview(int userId, int bookId, int rating, String comment) {
        String sql = "INSERT INTO Review (user_id, book_id, rating, comment) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ps.setInt(3, rating);
            ps.setString(4, comment);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hàm 2: Lấy danh sách đánh giá của 1 cuốn sách (kèm tên người đánh giá)
    public List<Review> getReviewsByBookId(int bookId) {
        List<Review> list = new ArrayList<>();
        // Nối bảng Review với Users để lấy username
        String sql = "SELECT r.*, u.username, u.email FROM Review r " +
                "JOIN Users u ON r.user_id = u.user_id " +
                "WHERE r.book_id = ? " +
                "ORDER BY r.create_at DESC"; // Xếp mới nhất lên đầu

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("review_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setBookId(rs.getInt("book_id"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setCreateAt(rs.getDate("create_at"));

                // Thuộc tính phụ từ bảng Users
                r.setUsername(rs.getString("username"));
                try {
                    r.setEmail(rs.getString("email"));
                } catch (Exception e) {
                }

                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 1. HÀM MỚI: Lấy danh sách các cuốn sách đã có đánh giá (để đưa lên thanh lọc)
    public List<Review> getDistinctReviewedBooks() {
        List<Review> list = new ArrayList<>();
        // Dùng DISTINCT để lấy ra các sách không bị trùng lặp
        String sql = "SELECT DISTINCT r.book_id, b.title AS book_title " +
                "FROM Review r JOIN Books b ON r.book_id = b.book_id " +
                "ORDER BY b.title ASC";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Review r = new Review();
                r.setBookId(rs.getInt("book_id"));
                r.setBookTitle(rs.getString("book_title"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. SỬA HÀM CŨ: Đổi tên thành getFilteredReviews và nhận thêm tham số bookId
    public List<Review> getFilteredReviews(int starValue, int bookId) {
        List<Review> list = new ArrayList<>();

        // Dùng Trick "WHERE 1=1" để dễ dàng cộng chuỗi điều kiện
        StringBuilder sql = new StringBuilder(
                "SELECT r.review_id, r.user_id, r.book_id, r.rating, r.comment, r.create_at, r.staff_reply, " +
                        "u.username, u.email, b.title AS book_title " +
                        "FROM Review r " +
                        "JOIN Users u ON r.user_id = u.user_id " +
                        "JOIN Books b ON r.book_id = b.book_id " +
                        "WHERE 1=1 ");

        // Lọc theo Sao
        if (starValue >= 1 && starValue <= 5) {
            sql.append(" AND r.rating = ? ");
        }
        // Lọc theo Sách
        if (bookId > 0) {
            sql.append(" AND r.book_id = ? ");
        }
        sql.append(" ORDER BY r.create_at DESC");

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1; // Biến đếm vị trí dấu ?
            if (starValue >= 1 && starValue <= 5) {
                ps.setInt(paramIndex++, starValue);
            }
            if (bookId > 0) {
                ps.setInt(paramIndex++, bookId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setReviewId(rs.getInt("review_id"));
                    r.setUserId(rs.getInt("user_id"));
                    r.setBookId(rs.getInt("book_id"));
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setCreateAt(rs.getDate("create_at"));
                    r.setUsername(rs.getString("username"));
                    r.setEmail(rs.getString("email"));
                    r.setBookTitle(rs.getString("book_title"));
                    r.setStaffReply(rs.getString("staff_reply"));
                    list.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}