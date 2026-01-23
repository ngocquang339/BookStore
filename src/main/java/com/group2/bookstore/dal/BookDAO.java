package com.group2.bookstore.dal;
import com.group2.bookstore.model.Book; // Nhớ đảm bảo class Book đã có (như bài trước)
import java.sql.*;

import com.group2.bookstore.model.Book;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.Book;

public class BookDAO {

    // 1. Get Top 4 Newest Books (For Homepage)
    // Update this method to accept roleId
public List<Book> getNewArrivals(int roleId) {
    List<Book> list = new ArrayList<>();
    String sql;
    
    // 1. Choose the Query based on Role
    if (roleId == 1) {
        sql = "SELECT TOP 4 * FROM Books ORDER BY book_id DESC";
    } else {
        sql = "SELECT TOP 4 * FROM Books WHERE is_active = 1 ORDER BY book_id DESC";
    }
    
    // 2. EXECUTE THE QUERY (This part was missing!)
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
         
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(mapResultSetToBook(rs));
public class BookDAO extends DBContext{
    public List<Book> getRandomBook(){
        List<Book> list = new ArrayList<>();
        String sql = "Select TOP 10 * from Books ORDER BY NEWID()";
        try {
        Connection conn = getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Book b = new Book();
            b.setId(rs.getInt("book_id"));
            b.setTitle(rs.getString("title"));
            b.setPrice(rs.getDouble("price"));
            b.setImageUrl(rs.getString("image")); // Tên cột ảnh trong DB
            b.setAuthor(rs.getString("author"));
            list.add(b);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    return list;
}

    // 2. Get Top 4 Best Sellers (For Homepage)
    public List<Book> getBestSellers() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT TOP 4 * FROM Books WHERE is_active = 1 ORDER BY sold_quantity DESC";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 3. Get Book by ID (For Detail Page)
    public Book getBookById(int id) {
        String sql = "SELECT * FROM Books WHERE book_id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToBook(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 4. Get Related Books (Same Category, Exclude Current Book)
    public List<Book> getRelatedBooks(int categoryId, int currentBookId) {
        List<Book> list = new ArrayList<>();
        // Get 4 random books from same category, excluding the one we are looking at
        String sql = "SELECT TOP 4 * FROM Books WHERE category_id = ? AND book_id != ? AND is_active = 1";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, currentBookId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Helper method to avoid repeating mapping code
    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setId(rs.getInt("book_id"));
        b.setTitle(rs.getString("title"));
        b.setAuthor(rs.getString("author"));
        b.setPrice(rs.getDouble("price"));
        b.setDescription(rs.getString("description"));
        b.setImage(rs.getString("image"));
        b.setStockQuantity(rs.getInt("stock_quantity"));
        b.setSoldQuantity(rs.getInt("sold_quantity"));
        b.setCategoryId(rs.getInt("category_id"));
        b.setActive(rs.getBoolean("is_active"));
        b.setImportPrice(rs.getDouble("import_price"));
        return b;
    }

    /**
     * Search books by title with Role-Based Access Control.
     * @param keyword  The text to search for
     * @param roleId   The ID of the user (0 for Guest, 1 for Admin, 2 for User)
     * @return List of matching books
     */
    public List<Book> searchBooks(String keyword, int roleId) {
        List<Book> list = new ArrayList<>();
        String sql;
        
        // =========================================================
        // IMPLEMENTATION 2 LOGIC: ADMIN SEARCH SCOPE
        // =========================================================
        
        // Case 1: Admin (Role 1) - Can see ALL books (Hidden, Out of Stock, etc.)
        if (roleId == 1) {
            sql = "SELECT * FROM Books WHERE title LIKE ?";
        } 
        // Case 2: Guest/Normal User - Can ONLY see Active books (is_active = 1)
        else {
            sql = "SELECT * FROM Books WHERE title LIKE ? AND is_active = 1";
        }

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Allow partial matching (e.g., "Harry" finds "Harry Potter")
            ps.setString(1, "%" + keyword + "%");
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Book b = new Book();
                
                // Map Basic Fields
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setPrice(rs.getDouble("price"));
                b.setDescription(rs.getString("description"));
                b.setImage(rs.getString("image"));
                b.setStockQuantity(rs.getInt("stock_quantity"));
                b.setSoldQuantity(rs.getInt("sold_quantity"));
                b.setPublisher(rs.getString("publisher"));
                b.setIsbn(rs.getString("ISBN"));
                b.setCategoryId(rs.getInt("category_id"));
                
                // Map New Admin Fields
                b.setActive(rs.getBoolean("is_active"));
                
                // Only Admins need to see Import Price, but we map it anyway
                // (The JSP will decide whether to show it or not)
                b.setImportPrice(rs.getDouble("import_price"));

                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
    return list;
    }

        // Hàm đa năng: Lấy sách, có Search, có Filter Category, có Lọc hàng sắp hết
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
                sql += " AND stock_quantity < 5 "; // Quy ước dưới 5 là sắp hết
            }

            try {
                PreparedStatement st = getConnection().prepareStatement(sql);
                int index = 1;
                if (keyword != null && !keyword.isEmpty()) {
                    st.setString(index++, "%" + keyword + "%");
                }
                if (cid > 0) {
                    st.setInt(index++, cid);
                }
                ResultSet rs = st.executeQuery();
                while (rs.next()) {
                    // Map dữ liệu từ DB sang Object Book (cấu trúc theo bài trước)
                    Book b = new Book(
                        rs.getInt("book_id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getDouble("price"),
                        rs.getInt("stock_quantity"),
                        rs.getString("image"),
                        rs.getInt("category_id"),
                        rs.getString("description")
                    );
                    list.add(b);
                }
            } catch (Exception e) { e.printStackTrace(); }
            return list;
        }

        // Hàm cập nhật số lượng (Cho trang Update Stock)
        public void updateStock(int bookId, int newQuantity) {
            String sql = "UPDATE Books SET stock_quantity = ? WHERE book_id = ?";
            try {
                PreparedStatement st = getConnection().prepareStatement(sql);
                st.setInt(1, newQuantity);
                st.setInt(2, bookId);
                st.executeUpdate();
            } catch (Exception e) { e.printStackTrace(); }
        }
    }
