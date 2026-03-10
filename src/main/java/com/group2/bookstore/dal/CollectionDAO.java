package com.group2.bookstore.dal;

import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.Collection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CollectionDAO extends DBContext {

    // =======================================================================
    // 1. CREATE (Tạo bộ sưu tập mới)
    // =======================================================================
    public boolean createCollection(Collection c) {
        String sql = "INSERT INTO Collections (user_id, collection_name, description, is_public, cover_color) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, c.getUserId());
            ps.setString(2, c.getName());
            ps.setString(3, c.getDescription());
            ps.setBoolean(4, c.isPublic());
            ps.setString(5, c.getCoverColor());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =======================================================================
    // 2. READ (Lấy danh sách bộ sưu tập của 1 User - Kèm tổng số sách)
    // =======================================================================
    public List<Collection> getCollectionsByUserId(int userId) {
        List<Collection> list = new ArrayList<>();
        // Câu SQL này cực "ăn điểm" vì có dùng Subquery để đếm số lượng sách bên trong
        String sql = "SELECT c.*, "
                   + "(SELECT COUNT(*) FROM Collection_Books cb WHERE cb.collection_id = c.collection_id) AS total_books "
                   + "FROM Collections c "
                   + "WHERE c.user_id = ? "
                   + "ORDER BY c.created_at DESC";
                   
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Collection c = new Collection();
                    c.setId(rs.getInt("collection_id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setName(rs.getString("collection_name"));
                    c.setDescription(rs.getString("description"));
                    c.setPublic(rs.getBoolean("is_public"));
                    c.setCoverColor(rs.getString("cover_color"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    c.setTotalBooks(rs.getInt("total_books")); // Gán tổng số sách
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy 1 bộ sưu tập cụ thể theo ID (Dùng khi ấn vào xem chi tiết hoặc sửa)
    public Collection getCollectionById(int collectionId) {
        String sql = "SELECT * FROM Collections WHERE collection_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collectionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Collection c = new Collection();
                    c.setId(rs.getInt("collection_id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setName(rs.getString("collection_name"));
                    c.setDescription(rs.getString("description"));
                    c.setPublic(rs.getBoolean("is_public"));
                    c.setCoverColor(rs.getString("cover_color"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =======================================================================
    // 3. UPDATE (Cập nhật thông tin bộ sưu tập)
    // =======================================================================
    public boolean updateCollection(Collection c) {
        String sql = "UPDATE Collections SET collection_name = ?, description = ?, is_public = ?, cover_color = ? WHERE collection_id = ? AND user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription());
            ps.setBoolean(3, c.isPublic());
            ps.setString(4, c.getCoverColor());
            ps.setInt(5, c.getId());
            ps.setInt(6, c.getUserId()); // Khóa bảo mật: Chỉ chủ sở hữu mới được sửa
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =======================================================================
    // 4. DELETE (Xóa bộ sưu tập)
    // =======================================================================
    public boolean deleteCollection(int collectionId, int userId) {
        String sql = "DELETE FROM Collections WHERE collection_id = ? AND user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collectionId);
            ps.setInt(2, userId); // Tránh việc user này xóa mượn ID xóa của user khác
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =======================================================================
    // CÁC HÀM THAO TÁC VỚI BẢNG TRUNG GIAN (Thêm/Bớt sách vào Giá sách)
    // =======================================================================
    
    // Khách hàng bấm: "Lưu vào Giá sách"
    public boolean addBookToCollection(int collectionId, int bookId) {
        String sql = "INSERT INTO Collection_Books (collection_id, book_id) VALUES (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collectionId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            // Sẽ quăng lỗi nếu sách đã tồn tại trong mảng này rồi (do Primary Key kép), 
            // bỏ qua hoặc return false là được.
            System.out.println("Sách đã tồn tại trong bộ sưu tập này.");
        }
        return false;
    }

    // Khách hàng bấm: "Xóa khỏi Giá sách"
    public boolean removeBookFromCollection(int collectionId, int bookId) {
        String sql = "DELETE FROM Collection_Books WHERE collection_id = ? AND book_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, collectionId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}