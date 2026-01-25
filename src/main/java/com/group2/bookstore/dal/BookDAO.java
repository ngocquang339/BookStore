package com.group2.bookstore.dal;

import com.group2.bookstore.model.Book;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookDAO extends DBContext { // Đảm bảo extends DBContext nếu class cha có getConnection

    // 1. Get Top 4 Newest Books (For Homepage)
    public List<Book> getNewArrivals(int roleId) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT TOP 4 * FROM Books ORDER BY book_id DESC";
        

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Get Random Books (ĐÃ SỬA: Thay NEWID() bằng book_id DESC để không bị nhảy vị trí)
    public List<Book> getRandomBook() {
        List<Book> list = new ArrayList<>();
        
        // SỬA Ở ĐÂY: Dùng ORDER BY book_id DESC để danh sách cố định
        String sql = "SELECT TOP 10 * FROM Books ORDER BY book_id DESC"; 
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Get Top 4 Best Sellers
    public List<Book> getBestSellers() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT TOP 4 * FROM Books ORDER BY sold_quantity DESC";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. Get Book by ID
    public Book getBookById(int id) {
        String sql = "SELECT * FROM Books WHERE book_id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToBook(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 5. Get Related Books
    public List<Book> getRelatedBooks(int categoryId, int currentBookId) {
        List<Book> list = new ArrayList<>();
       String sql = "SELECT TOP 4 * FROM Books WHERE category_id = ? AND book_id != ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, currentBookId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 6. Search Books (Admin Scope Logic)
    public List<Book> searchBooks(String keyword, int roleId) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM Books WHERE title LIKE ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 7. Filter Books (Advanced Search for Warehouse/Admin)
    public List<Book> getBooks(String keyword, int cid, boolean onlyLowStock) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM Books WHERE 1=1 ";

        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND title LIKE ? ";
        }
        if (cid > 0) {
            sql += " AND category_id = ? ";
        }
        if (onlyLowStock) {
            sql += " AND stock_quantity < 5 ";
        }

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            int index = 1;
            if (keyword != null && !keyword.isEmpty()) {
                st.setString(index++, "%" + keyword + "%");
            }
            if (cid > 0) {
                st.setInt(index++, cid);
            }
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 8. Update Stock (For Warehouse)
    public void updateStock(int bookId, int newQuantity) {
        String sql = "UPDATE Books SET stock_quantity = ? WHERE book_id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, newQuantity);
            st.setInt(2, bookId);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // HELPER: Map ResultSet to Book Object (Giữ nguyên hàm này cho gọn code)
    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setId(rs.getInt("book_id"));
        b.setTitle(rs.getString("title"));
        b.setAuthor(rs.getString("author"));
        b.setPrice(rs.getDouble("price"));
        b.setDescription(rs.getString("description"));
        b.setImage(rs.getString("image")); // Đảm bảo tên cột trong DB là 'image'
        b.setStockQuantity(rs.getInt("stock_quantity"));
        
        // Kiểm tra xem cột có tồn tại không trước khi lấy (tránh lỗi nếu query thiếu cột)
        try { b.setSoldQuantity(rs.getInt("sold_quantity")); } catch (SQLException e) {}
        b.setCategoryId(rs.getInt("category_id"));
        
        try { b.setActive(rs.getBoolean("is_active")); } catch (SQLException e) {}
        try { b.setImportPrice(rs.getDouble("import_price")); } catch (SQLException e) {}
        
        return b;
    }
}