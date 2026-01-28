package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.Book;

public class BookDAO extends DBContext{

    // 1. Get Top 4 Newest Books (For Homepage)
    public List<Book> getNewArrivals() {
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

    public List<Book> getRandomBook(int roleId) {
        List<Book> list = new ArrayList<>();
        String sql;

        // LOGIC: If Admin (1), show all. If Guest/User, only show Active (1)
        if (roleId == 1) {
            sql = "SELECT TOP 10 * FROM Books ORDER BY NEWID()";
        } else {
            sql = "SELECT TOP 10 * FROM Books ORDER BY book_id DESC"; 
        }
        
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
    public List<String> getAllAuthors() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT author FROM Books WHERE author IS NOT NULL AND author <> '' ORDER BY author";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("author"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Lấy danh sách tất cả NXB (không trùng lặp)
    public List<String> getAllPublishers() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT publisher FROM Books WHERE publisher IS NOT NULL AND publisher <> '' ORDER BY publisher";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("publisher"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    // 3. Cập nhật hàm getBooks (Thêm tham số author, publisher, minPrice, maxPrice)
    public List<Book> getBooks(String keyword, int cid, String author, String publisher, double minPrice, double maxPrice, String sortBy, String sortOrder) {
        List<Book> list = new ArrayList<>();
        
        // Tạo câu SQL động dựa trên việc người dùng có nhập dữ liệu hay không
        StringBuilder sql = new StringBuilder("SELECT * FROM Books WHERE 1=1 ");
        List<Object> params = new ArrayList<>(); // Danh sách chứa các tham số ?

        // Filter: Từ khóa
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND title LIKE ? ");
            params.add("%" + keyword + "%");
        }
        // Filter: Category
        if (cid > 0) {
            sql.append(" AND category_id = ? ");
            params.add(cid);
        }
        // Filter: Author
        if (author != null && !author.trim().isEmpty()) {
            sql.append(" AND author = ? ");
            params.add(author);
        }
        // Filter: Publisher
        if (publisher != null && !publisher.trim().isEmpty()) {
            sql.append(" AND publisher = ? ");
            params.add(publisher);
        }
        // Filter: Price Range (Nếu maxPrice > 0 thì mới lọc)
        if (maxPrice > 0) {
            sql.append(" AND price BETWEEN ? AND ? ");
            params.add(minPrice);
            params.add(maxPrice);
        }

        // Sorting (Sắp xếp)
        if (sortBy != null && !sortBy.isEmpty()) {
            // Chỉ chấp nhận các cột hợp lệ để tránh SQL Injection
            if (sortBy.equals("price") || sortBy.equals("title") || sortBy.equals("stock_quantity")) {
                sql.append(" ORDER BY ").append(sortBy);
                if ("DESC".equalsIgnoreCase(sortOrder)) {
                    sql.append(" DESC");
                } else {
                    sql.append(" ASC");
                }
            }
        } else {
            sql.append(" ORDER BY book_id DESC"); // Mặc định sắp xếp mới nhất
        }

        

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            // Gán giá trị cho các dấu ?
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // mapResultSetToBook là hàm helper (nếu bạn chưa có thì dùng code set bình thường)
                Book b = new Book();
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setPublisher(rs.getString("publisher"));
                b.setPrice(rs.getDouble("price"));
                b.setStockQuantity(rs.getInt("stock_quantity"));
                b.setImageUrl(rs.getString("image"));
                b.setCategoryId(rs.getInt("category_id"));
                list.add(b);
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

    // --- CRUD OPERATIONS ---

    // 9. INSERT (Create)
    public void insertBook(Book b) {
        String sql = "INSERT INTO Books (title, author, price, description, image, stock_quantity, category_id, is_active, import_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());
            ps.setDouble(3, b.getPrice());
            ps.setString(4, b.getDescription());
            ps.setString(5, b.getImageUrl());
            ps.setInt(6, b.getStockQuantity());
            ps.setInt(7, b.getCategoryId());
            ps.setBoolean(8, b.isActive());
            ps.setDouble(9, b.getImportPrice());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 10. UPDATE (Edit)
    public void updateBook(Book b) {
        String sql = "UPDATE Books SET title=?, author=?, price=?, description=?, image=?, stock_quantity=?, category_id=?, is_active=?, import_price=? WHERE book_id=?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());
            ps.setDouble(3, b.getPrice());
            ps.setString(4, b.getDescription());
            ps.setString(5, b.getImageUrl()); // Handles the image filename
            ps.setInt(6, b.getStockQuantity());
            ps.setInt(7, b.getCategoryId());
            ps.setBoolean(8, b.isActive());
            ps.setDouble(9, b.getImportPrice());
            ps.setInt(10, b.getId());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 11. SOFT DELETE (Hide instead of remove)
    public void softDeleteBook(int id) {
        String sql = "UPDATE Books SET is_active = 0 WHERE book_id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 12. GET ALL BOOKS (For Admin Management)
    public List<Book> getAllBooksForAdmin() {
        List<Book> list = new ArrayList<>();
        // Note: No "WHERE is_active=1" because Admin needs to see hidden/draft books
        String sql = "SELECT * FROM Books ORDER BY book_id DESC"; 
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }




    // HELPER: Map ResultSet to Book Object
    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setId(rs.getInt("book_id"));
        b.setTitle(rs.getString("title"));
        b.setAuthor(rs.getString("author"));
        b.setPrice(rs.getDouble("price"));
        b.setDescription(rs.getString("description"));
        b.setImageUrl(rs.getString("image"));
        b.setStockQuantity(rs.getInt("stock_quantity"));
        b.setSoldQuantity(rs.getInt("sold_quantity"));
        b.setCategoryId(rs.getInt("category_id"));
        
        // Try-Catch blocks for optional columns (in case older queries don't select them)
        try { b.setActive(rs.getBoolean("is_active")); } catch (SQLException e) {}
        try { b.setImportPrice(rs.getDouble("import_price")); } catch (SQLException e) {}
        
        return b;
    }

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
}


