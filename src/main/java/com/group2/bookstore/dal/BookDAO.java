package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.Category;
import com.group2.bookstore.model.BookImage;

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

    public List<Book> getRandomBook(int roleId, int quantity) {
        List<Book> list = new ArrayList<>();
        String sql;

        // LOGIC: If Admin (1), show all. If Guest/User, only show Active (1)
        if (roleId == 1) {
            sql = "SELECT TOP " + quantity + " * FROM Books ORDER BY NEWID()";
        } else {
            sql = "SELECT TOP " + quantity + " * FROM Books ORDER BY NEWID()";
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

    public List<BookImage> getBookImage(int bookId){
        List<BookImage> list = new ArrayList<>();
        String sql = "Select * from BookImages where book_id = ?";
         try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)){
                    ps.setInt(1, bookId);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        list.add(new BookImage(
                            rs.getInt("image_id"),
                            rs.getInt("book_id"),
                            rs.getString("image_url")
                        ));
                    }
                }
                catch(Exception e){
                    e.printStackTrace();
                }
        return list;
    }

    public List<Category> getCategories() {
    List<Category> list = new ArrayList<>();
    // Giả sử bảng Categories có các cột: category_id, category_name, category_image
    // Nếu bảng bạn chưa có cột ảnh, bạn có thể hardcode ảnh trong Java hoặc thêm cột vào DB sau.
    String sql = "SELECT * FROM Categories"; 
    
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
         
        while (rs.next()) {
            list.add(new Category(
                rs.getInt(1), // ID
                rs.getString(2), // Name
                rs.getString(3),// Image (Nếu DB chưa có cột này thì để null hoặc string rỗng)
                rs.getString(4)  
            ));
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

    // 6. Search Books (Đã sửa để dùng cho cả Admin lẫn User)
    public List<Book> searchBooks(String keyword, int roleId) {
        List<Book> list = new ArrayList<>();
        String sql;

        // --- LOGIC MỚI ---
        // 1. Dùng LOWER(...) để không phân biệt hoa thường.
        // 2. Kiểm tra roleId: Admin (1) thấy hết, Khách chỉ thấy sách Active (1).
        if (roleId == 1) {
            // Admin: Tìm tất cả
            sql = "SELECT * FROM Books WHERE LOWER(title) LIKE LOWER(?)";
        } else {
            // Khách/User: Chỉ tìm sách đang hiện (is_active = 1)
            sql = "SELECT * FROM Books WHERE LOWER(title) LIKE LOWER(?) AND is_active = 1";
        }

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
        } catch (Exception e) {
            e.printStackTrace();
        }
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
   
    public List<Book> getBooks(String keyword, int cid, String author, String publisher, double minPrice, double maxPrice, String sortBy, String sortOrder, boolean isAdmin) {
        List<Book> list = new ArrayList<>();
        
        // ĐÃ SỬA: Thêm LEFT JOIN thứ 2 để lấy location_code
        StringBuilder sql = new StringBuilder("SELECT b.*, c.category_name, l.location_code FROM Books b "
                + "LEFT JOIN Categories c ON b.category_id = c.category_id "
                + "LEFT JOIN Warehouse_Locations l ON b.location_id = l.location_id "
                + "WHERE 1=1 ");
        List<Object> params = new ArrayList<>(); 

        if (!isAdmin) {
            sql.append(" AND b.is_active = 1 ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND LOWER(b.title) LIKE LOWER(?) ");
            params.add("%" + keyword.trim() + "%");
        }
        if (cid > 0) {
            sql.append(" AND b.category_id = ? ");
            params.add(cid);
        }
        if (author != null && !author.trim().isEmpty()) {
            sql.append(" AND LOWER(b.author) LIKE LOWER(?) ");
            params.add("%" + author.trim() + "%");
        }
        if (publisher != null && !publisher.trim().isEmpty()) {
            sql.append(" AND LOWER(b.publisher) LIKE LOWER(?) ");
            params.add("%" + publisher.trim() + "%");
        }
        if (maxPrice > 0) {
            sql.append(" AND b.price BETWEEN ? AND ? ");
            params.add(minPrice);
            params.add(maxPrice);
        } else if (minPrice > 0) {
            sql.append(" AND b.price >= ? ");
            params.add(minPrice);
        }

        if (sortBy != null && !sortBy.isEmpty()) {
            if (sortBy.equals("price") || sortBy.equals("title") || sortBy.equals("stock_quantity") || sortBy.equals("book_id")) {
                sql.append(" ORDER BY b.").append(sortBy);
                sql.append("DESC".equalsIgnoreCase(sortOrder) ? " DESC" : " ASC");
            }
        } else {
            sql.append(" ORDER BY b.book_id DESC");
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Book b = new Book();
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setPrice(rs.getDouble("price"));
                try { b.setPublisher(rs.getString("publisher")); } catch (Exception e) {}
                b.setImageUrl(rs.getString("image")); 
                b.setDescription(rs.getString("description"));
                b.setStockQuantity(rs.getInt("stock_quantity"));
                b.setCategoryId(rs.getInt("category_id"));
                
                // ĐÃ SỬA: Lấy thêm tên category từ DB
                try { b.setCategoryName(rs.getString("category_name")); } catch (Exception e) {}
                try { b.setLocationCode(rs.getString("location_code")); } catch (Exception e) {}
                try { b.setActive(rs.getBoolean("is_active")); } catch (Exception e) {}

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

        // Try-Catch blocks for optional columns (in case older queries don't select
        // them)
        try {
            b.setActive(rs.getBoolean("is_active"));
        } catch (SQLException e) {
        }
        try {
            b.setImportPrice(rs.getDouble("import_price"));
        } catch (SQLException e) {
        }

        return b;
    }

    public List<Book> getRandomBook() {
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
    // Lấy danh sách sách sắp hết hàng (Low Stock)
    public List<Book> getLowStockBooks(int threshold) {
        List<Book> list = new ArrayList<>();
        // JOIN với Categories để lấy được tên thể loại như hàm getBooks
        String sql = "SELECT b.*, c.category_name FROM Books b "
                   + "LEFT JOIN Categories c ON b.category_id = c.category_id "
                   + "WHERE b.stock_quantity <= ? "
                   + "ORDER BY b.stock_quantity ASC";
                   
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, threshold);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Book b = new Book();
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setPrice(rs.getDouble("price"));
                try { b.setPublisher(rs.getString("publisher")); } catch (Exception e) {}
                b.setImageUrl(rs.getString("image")); 
                b.setStockQuantity(rs.getInt("stock_quantity"));
                b.setCategoryId(rs.getInt("category_id"));
                try { b.setCategoryName(rs.getString("category_name")); } catch (Exception e) {}
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
