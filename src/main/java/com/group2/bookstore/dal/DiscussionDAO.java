package com.group2.bookstore.dal;

import com.group2.bookstore.model.Discussion;
import com.group2.bookstore.model.DiscussionReply;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DiscussionDAO extends DBContext {

    // 1. Lấy danh sách Thảo luận (ĐÃ SỬA LỖI BỊ NULL)
    public List<Discussion> getDiscussionsByBookId(int bookId) {
        List<Discussion> list = new ArrayList<>();
        String sql = "SELECT d.*, u.username, " +
                     "(SELECT COUNT(*) FROM Discussion_Replies dr WHERE dr.discussion_id = d.discussion_id) AS reply_count " +
                     "FROM Discussions d JOIN Users u ON d.user_id = u.user_id WHERE d.book_id = ? ORDER BY d.created_at DESC";
                     
        // BƯỚC 1: Quét lấy danh sách Câu hỏi trước
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Discussion d = new Discussion();
                    d.setDiscussionId(rs.getInt("discussion_id"));
                    d.setBookId(rs.getInt("book_id"));
                    d.setUserId(rs.getInt("user_id"));
                    d.setDiscussionTitle(rs.getString("discussion_title"));
                    d.setDiscussionContent(rs.getString("discussion_content"));
                    d.setHasSpoiler(rs.getBoolean("has_spoiler"));
                    d.setTopicTag(rs.getString("topic_tag"));
                    d.setCreatedAt(rs.getDate("created_at"));
                    d.setUsername(rs.getString("username"));
                    d.setReplyCount(rs.getInt("reply_count"));
                    
                    list.add(d);
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }

        // BƯỚC 2: Chạy vòng lặp nhét Câu trả lời vào từng Câu hỏi
        // Làm tách biệt thế này SQL Server sẽ không bao giờ báo lỗi đụng độ Connection
        for (Discussion d : list) {
            List<DiscussionReply> replies = getRepliesByDiscussionId(d.getDiscussionId());
            d.setReplies(replies);
        }

        return list;
    }

    // 2. Tạo một câu hỏi/thảo luận mới (Sử dụng cho tính năng AJAX)
    public int createDiscussion(int bookId, int userId, String title, String content, boolean hasSpoiler, String topicTag) {
        String sql = "INSERT INTO Discussions (book_id, user_id, discussion_title, discussion_content, has_spoiler, topic_tag) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
                     
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, bookId);
            ps.setInt(2, userId);
            ps.setString(3, title);
            ps.setString(4, content);
            ps.setBoolean(5, hasSpoiler);
            ps.setString(6, topicTag);
            
            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1); // Trả về ID vừa tạo
                }
            }
        } catch (Exception e) {
            System.err.println("❌❌❌ LỖI TẠI createDiscussion: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    // 1. Lấy danh sách Câu trả lời của 1 Chủ đề
    public List<DiscussionReply> getRepliesByDiscussionId(int discussionId) {
        List<DiscussionReply> list = new ArrayList<>();
        String sql = "SELECT r.*, u.username FROM Discussion_Replies r JOIN Users u ON r.user_id = u.user_id WHERE r.discussion_id = ? ORDER BY r.created_at ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, discussionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DiscussionReply r = new DiscussionReply();
                    r.setReplyId(rs.getInt("reply_id"));
                    r.setDiscussionId(rs.getInt("discussion_id"));
                    r.setUserId(rs.getInt("user_id"));
                    r.setReplyContent(rs.getString("reply_content"));
                    r.setCreatedAt(rs.getDate("created_at"));
                    r.setUsername(rs.getString("username"));
                    list.add(r);
                }
            }
        } catch (Exception e) { 
            System.err.println("❌❌❌ LỖI TẠI getRepliesByDiscussionId: " + e.getMessage());
            e.printStackTrace(); }
        return list;
    }

    // 1. THAY THẾ hàm createReply cũ bằng hàm này (Để trả về ID vừa tạo):
    public int createReply(int discussionId, int userId, String replyContent) {
        String sql = "INSERT INTO Discussion_Replies (discussion_id, user_id, reply_content) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, discussionId); ps.setInt(2, userId); ps.setString(3, replyContent);
            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) return rs.getInt(1); }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    // 2. THÊM 2 hàm này vào cuối file:
    public boolean deleteReply(int replyId, int userId) {
        String sql = "DELETE FROM Discussion_Replies WHERE reply_id = ? AND user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, replyId); ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateReply(int replyId, int userId, String replyContent) {
        String sql = "UPDATE Discussion_Replies SET reply_content = ? WHERE reply_id = ? AND user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, replyContent); ps.setInt(2, replyId); ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 5. Xóa câu hỏi (Chỉ xóa khi đúng ID câu hỏi và ID người đăng)
    public boolean deleteDiscussion(int discussionId, int userId) {
        // Lưu ý: Do trong DB ta đã cài ON DELETE CASCADE ở bảng Replies, 
        // nên khi xóa câu hỏi, các câu trả lời sẽ tự động bị xóa theo. Rất nhàn!
        String sql = "DELETE FROM Discussions WHERE discussion_id = ? AND user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, discussionId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 6. Sửa câu hỏi
    public boolean updateDiscussion(int discussionId, int userId, String title, String content, boolean hasSpoiler, String topicTag) {
        String sql = "UPDATE Discussions SET discussion_title = ?, discussion_content = ?, has_spoiler = ?, topic_tag = ? " +
                     "WHERE discussion_id = ? AND user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setBoolean(3, hasSpoiler);
            ps.setString(4, topicTag);
            ps.setInt(5, discussionId);
            ps.setInt(6, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 7. Lưu báo cáo vi phạm (Dùng chung cho cả Câu hỏi và Câu trả lời)
    public boolean reportViolation(int reporterId, String reportType, int targetId, String reason) {
        String sql = "INSERT INTO Discussion_Reports (reporter_id, report_type, target_id, reason) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reporterId);
            ps.setString(2, reportType); // Nhận giá trị 'discussion' hoặc 'reply'
            ps.setInt(3, targetId);      // Nhận discussionId hoặc replyId
            ps.setString(4, reason);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return false;
    }
}