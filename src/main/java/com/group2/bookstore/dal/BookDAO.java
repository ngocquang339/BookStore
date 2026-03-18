package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.BookImage;
import com.group2.bookstore.model.CartItem;
import com.group2.bookstore.model.Category;

public class BookDAO extends DBContext {

    // 1. Get Top 4 Newest Books (For Homepage)
    public List<Book> getNewArrivals() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT TOP 4 * FROM Books ORDER BY book_id DESC";

        try (Connection conn = getConnection();
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

    // 2. Get Random Books
    public List<Book> getRandomBook(int roleId, int quantity) {
        List<Book> list = new ArrayList<>();
        String sql;

        // LOGIC: If Admin (1), show all. If Guest/User, only show Active (1)
        if (roleId == 1) {
            sql = "SELECT TOP " + quantity + " * FROM Books ORDER BY NEWID()";
        } else {
            sql = "SELECT TOP " + quantity + " * FROM Books where is_active = 1 ORDER BY NEWID()";
        }

        try (Connection conn = getConnection();
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

    // 3. Get Book Images
    public List<BookImage> getBookImage(int bookId) {
        List<BookImage> list = new ArrayList<>();
        String sql = "Select * from BookImages where book_id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new BookImage(
                        rs.getInt("image_id"),
                        rs.getInt("book_id"),
                        rs.getString("image_url")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. Get Categories (FIXED: Restored the chopped-off try-catch block)
    public List<Category> getCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Categories";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Category(
                        rs.getInt("category_id"),
                        rs.getString("category_name"),
                        rs.getString("category_image"),
                        rs.getString("description")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 5. Get Best Sellers
    public List<Book> getBestSellers() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT TOP 4 * FROM Books ORDER BY sold_quantity DESC";

        try (Connection conn = getConnection();
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

    // 6. Get Book by ID
    public Book getBookById(int id) {
        String sql = "SELECT * FROM Books WHERE book_id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // 1. Catch the book object first
                Book b = mapResultSetToBook(rs);
                
                // 2. Fetch the gallery images and attach them!
                b.setDetailImages(getDetailImages(id));
                
                // 3. Now return the fully loaded book
                return b;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 7. Get Book By Author
    public List<Book> getBookByAuthor(String author) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM Books WHERE author = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, author);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 8. Get Related Books
    public List<Book> getRelatedBooks(int categoryId, int currentBookId) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT TOP 4 * FROM Books WHERE category_id = ? AND book_id != ?";

        try (Connection conn = getConnection();
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

    // 9. Search Books
    public List<Book> searchBooks(String keyword, int roleId) {
        List<Book> list = new ArrayList<>();
        String sql;

        if (roleId == 1) {
            sql = "SELECT * FROM Books WHERE LOWER(title) LIKE LOWER(?)";
        } else {
            sql = "SELECT * FROM Books WHERE LOWER(title) LIKE LOWER(?) AND is_active = 1";
        }

        try (Connection conn = getConnection();
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

    // 10. Get All Authors
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

    // 11. Get All Publishers
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

    // ==========================================
    // --- MASTER GET BOOKS METHODS ---
    // ==========================================

    // Overload 1: No pagination
    public List<Book> getBooks(String keyword, int cid, String author, String publisher, double minPrice,
            double maxPrice, String sortBy, String sortOrder, boolean isAdmin) {
        return getBooks(keyword, cid, author, publisher, minPrice, maxPrice, sortBy, sortOrder, isAdmin, 1, 1000000);
    }

    // Overload 2: Fixed 5 items per page
    public List<Book> getBooks(String keyword, int cid, String author, String publisher, double minPrice,
            double maxPrice, String sortBy, String sortOrder, boolean isAdmin, int index) {
        return getBooks(keyword, cid, author, publisher, minPrice, maxPrice, sortBy, sortOrder, isAdmin, index, 5);
    }

    // Overload 3: The Main Core Method (MERGED WITH TEAMMATE'S WAREHOUSE LOGIC)
    /* public List<Book> getBooks(String keyword, int cid, String author, String publisher, double minPrice,
            double maxPrice, String sortBy, String sortOrder, boolean isAdmin, int index, int pageSize) {
        List<Book> list = new ArrayList<>();

        // 1. TẠO BẢNG TẠM (CTE): Chỉ tìm ra "ID" của 20 cuốn sách thuộc trang hiện tại
        StringBuilder sql = new StringBuilder(
                "WITH PagedBooks AS ( " +
                        "   SELECT b.book_id " +
                        "   FROM Books b " +
                        "   LEFT JOIN Categories c ON b.category_id = c.category_id " +
                        "   WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (!isAdmin)
            sql.append(" AND b.is_active = 1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(
                    " AND ((LOWER(b.title) LIKE LOWER(?)) OR (LOWER(b.author) LIKE LOWER(?)) OR (LOWER(b.supplier) LIKE LOWER(?)) OR (LOWER(b.publisher) LIKE LOWER(?))) ");
            String searchParam = "%" + keyword.trim() + "%";
            params.add(searchParam);
            params.add(searchParam);
            params.add(searchParam);
            params.add(searchParam);
        }
        if (cid > 0) {
            sql.append(" AND (b.category_id = ? OR c.parent_id = ?) ");
            params.add(cid);
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

        // --- XỬ LÝ SẮP XẾP ---
        String orderClause = "";
        if (sortBy != null && !sortBy.isEmpty() && (sortBy.equals("price") || sortBy.equals("title")
                || sortBy.equals("stock_quantity") || sortBy.equals("book_id"))) {
            orderClause = " ORDER BY b." + sortBy + ("DESC".equalsIgnoreCase(sortOrder) ? " DESC" : " ASC");
        } else if ("category_name".equals(sortBy)) {
            orderClause = " ORDER BY c.category_name" + ("DESC".equalsIgnoreCase(sortOrder) ? " DESC" : " ASC");
        } else {
            orderClause = " ORDER BY b.book_id DESC";
        }
        sql.append(orderClause);

        // --- CẮT TRANG ---
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");
        sql.append(") "); // Kết thúc khối bảng tạm

        // 2. TRUY VẤN CHÍNH: Chỉ lấy thông tin nặng (như cover_image) cho đúng 20 cái
        // ID ở trên
        sql.append("SELECT b.*, c.category_name, l.location_code, " +
                "(SELECT TOP 1 bi.image_url FROM BookImages bi WHERE bi.book_id = b.book_id) AS cover_image " +
                "FROM PagedBooks pb " +
                "INNER JOIN Books b ON pb.book_id = b.book_id " +
                "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                "LEFT JOIN Warehouse_Locations l ON b.location_id = l.location_id ");
        sql.append(orderClause); // Sắp xếp lại lần nữa để đảm bảo thứ tự sau khi JOIN

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            for (Object param : params)
                ps.setObject(paramIndex++, param);

            // Truyền tham số cho OFFSET
            ps.setInt(paramIndex++, (index - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Book b = new Book();
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setPrice(rs.getDouble("price"));
                try {
                    b.setPublisher(rs.getString("publisher"));
                } catch (Exception e) {
                }
                b.setImageUrl(rs.getString("image"));
                b.setStockQuantity(rs.getInt("stock_quantity"));
                b.setCategoryId(rs.getInt("category_id"));
                b.setSupplier(rs.getString("supplier"));
                b.setYearOfPublish(rs.getInt("yearOfPublish"));
                b.setNumberPage(rs.getInt("number_page"));
                b.setCoverImage(rs.getString("cover_image"));

                try {
                    b.setCategoryName(rs.getString("category_name"));
                } catch (Exception e) {
                }
                try {
                    b.setActive(rs.getBoolean("is_active"));
                } catch (Exception e) {
                }
                try {
                    b.setLocationCode(rs.getString("location_code"));
                } catch (Exception e) {
                }

                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    } */

    // Overload 3: The Main Core Method (TEMPORARY BYPASS - WAREHOUSE DISABLED)
    public List<Book> getBooks(String keyword, int cid, String author, String publisher, double minPrice,
            double maxPrice, String sortBy, String sortOrder, boolean isAdmin, int index, int pageSize) {
        List<Book> list = new ArrayList<>();

        // BYPASS: Removed l.location_code and the Warehouse_Locations JOIN
        StringBuilder sql = new StringBuilder(
                "SELECT b.*, c.category_name, " +
                        "(SELECT TOP 1 bi.image_url FROM BookImages bi WHERE bi.book_id = b.book_id) AS cover_image " +
                        "FROM Books b " +
                        "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                        "WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();

        if (!isAdmin) sql.append(" AND b.is_active = 1 ");
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND ((LOWER(b.title) LIKE LOWER(?)) OR (LOWER(b.author) LIKE LOWER(?)) OR (LOWER(b.supplier) LIKE LOWER(?)) OR (LOWER(b.publisher) LIKE LOWER(?))) ");
            String searchParam = "%" + keyword.trim() + "%";
            params.add(searchParam); // title
            params.add(searchParam); // author
            params.add(searchParam); // supplier
            params.add(searchParam); // publisher
        }
        if (cid > 0) {
            sql.append(" AND (b.category_id = ? OR c.parent_id = ?) ");
            params.add(cid);
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

        if (sortBy != null && !sortBy.isEmpty() && (sortBy.equals("price") || sortBy.equals("title")
                || sortBy.equals("stock_quantity") || sortBy.equals("book_id"))) {
            sql.append(" ORDER BY b.").append(sortBy).append("DESC".equalsIgnoreCase(sortOrder) ? " DESC" : " ASC");
        } else if ("category_name".equals(sortBy)) {
            sql.append(" ORDER BY c.category_name").append("DESC".equalsIgnoreCase(sortOrder) ? " DESC" : " ASC");
        } else {
            sql.append(" ORDER BY b.book_id DESC");
        }

        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            for (Object param : params) ps.setObject(paramIndex++, param);

            ps.setInt(paramIndex++, (index - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);

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
                b.setSupplier(rs.getString("supplier"));
                b.setYearOfPublish(rs.getInt("yearOfPublish"));
                b.setNumberPage(rs.getInt("number_page"));
                b.setCoverImage(rs.getString("cover_image"));
                
                try { b.setCategoryName(rs.getString("category_name")); } catch (Exception e) {}
                try { b.setActive(rs.getBoolean("is_active")); } catch (Exception e) {}
                
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==========================================
    // --- COUNT BOOKS METHODS ---
    // ==========================================

    // Simple Count
    public int countBooks(String keyword, int cid, boolean isAdmin) {
        // FIXED: Added the LEFT JOIN to Categories so we can check parent_id
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Books b ");
        sql.append("LEFT JOIN Categories c ON b.category_id = c.category_id ");
        sql.append("WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();

        if (!isAdmin)
            sql.append(" AND b.is_active = 1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND LOWER(b.title) LIKE LOWER(?) ");
            params.add("%" + keyword.trim() + "%");
        }
        if (cid > 0) {
            // FIXED: Now checks both the direct category AND child categories
            sql.append(" AND (b.category_id = ? OR c.parent_id = ?) ");
            params.add(cid);
            params.add(cid);
        }

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Advanced Count (ĐÃ ĐƯỢC ĐỒNG BỘ LOGIC VỚI HÀM GETBOOKS)
    public int countBooks(String keyword, int cid, String author, String publisher, double minPrice, double maxPrice,
            boolean isAdmin) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Books b ");
        sql.append("LEFT JOIN Categories c ON b.category_id = c.category_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (!isAdmin)
            sql.append(" AND b.is_active = 1 ");

        // 1. Đồng bộ Keyword (Tìm cả title, author, supplier, publisher)
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(
                    " AND ((LOWER(b.title) LIKE LOWER(?)) OR (LOWER(b.author) LIKE LOWER(?)) OR (LOWER(b.supplier) LIKE LOWER(?)) OR (LOWER(b.publisher) LIKE LOWER(?))) ");
            String searchParam = "%" + keyword.trim() + "%";
            params.add(searchParam);
            params.add(searchParam);
            params.add(searchParam);
            params.add(searchParam);
        }

        // 2. Đồng bộ Category (Tính cả parent_id)
        if (cid > 0) {
            sql.append(" AND (b.category_id = ? OR c.parent_id = ?) ");
            params.add(cid);
            params.add(cid);
        }

        // 3. Đồng bộ Tác giả (Bỏ phân biệt hoa thường)
        if (author != null && !author.trim().isEmpty()) {
            sql.append(" AND LOWER(b.author) LIKE LOWER(?) ");
            params.add("%" + author.trim() + "%");
        }

        // 4. Đồng bộ NXB (Bỏ phân biệt hoa thường)
        if (publisher != null && !publisher.trim().isEmpty()) {
            sql.append(" AND LOWER(b.publisher) LIKE LOWER(?) ");
            params.add("%" + publisher.trim() + "%");
        }

        // 5. Đồng bộ Khoảng giá
        if (maxPrice > 0) {
            sql.append(" AND b.price BETWEEN ? AND ? ");
            params.add(minPrice);
            params.add(maxPrice);
        } else if (minPrice > 0) {
            sql.append(" AND b.price >= ? ");
            params.add(minPrice);
        }

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ==========================================
    // --- CRUD OPERATIONS ---
    // ==========================================

    public void updateStock(int bookId, int newQuantity) {
        String sql = "UPDATE Books SET stock_quantity = ? WHERE book_id = ?";
        try (Connection conn = getConnection();
                PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, newQuantity);
            st.setInt(2, bookId);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int insertBook(Book b) {
    String sql = "INSERT INTO Books (title, author, price, description, image, stock_quantity, category_id, is_active, import_price, publisher, supplier, yearOfPublish, number_page) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"; 
    
    int generatedId = 0; // This will hold the new ID

    // Notice the Statement.RETURN_GENERATED_KEYS added here!
    try (Connection conn = getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        
        ps.setString(1, b.getTitle());
        ps.setString(2, b.getAuthor());
        ps.setDouble(3, b.getPrice());
        ps.setString(4, b.getDescription());
        ps.setString(5, b.getImageUrl());
        ps.setInt(6, b.getStockQuantity());
        ps.setInt(7, b.getCategoryId());
        ps.setBoolean(8, b.isActive());
        ps.setDouble(9, b.getImportPrice());
        ps.setString(10, b.getPublisher());
        ps.setString(11, b.getSupplier());
        ps.setInt(12, b.getYearOfPublish());
        ps.setInt(13, b.getNumberPage());
        
        ps.executeUpdate();
        
        // Retrieve the auto-incrementing ID that SQL Server just created
        try (ResultSet rs = ps.getGeneratedKeys()) {
            if (rs.next()) {
                generatedId = rs.getInt(1);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    // Return the new ID back to the Servlet so it can save the detail images!
    return generatedId; 
}

    public void updateBook(Book b) {
        String sql = "UPDATE Books SET title=?, author=?, price=?, description=?, image=?, stock_quantity=?, category_id=?, is_active=?, import_price=?, publisher=?, supplier=?, yearOfPublish=?, number_page=? WHERE book_id=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());
            ps.setDouble(3, b.getPrice());
            ps.setString(4, b.getDescription());
            ps.setString(5, b.getImageUrl());
            ps.setInt(6, b.getStockQuantity());
            ps.setInt(7, b.getCategoryId());
            ps.setBoolean(8, b.isActive());
            ps.setDouble(9, b.getImportPrice());
            ps.setString(10, b.getPublisher());
            ps.setString(11, b.getSupplier());
            ps.setInt(12, b.getYearOfPublish());
            ps.setInt(13, b.getNumberPage());
            ps.setInt(14, b.getId());
            
            int rowsAffected = ps.executeUpdate();
            
            // If the database couldn't find the ID, force a crash!
            if (rowsAffected == 0) {
                throw new RuntimeException("ZERO ROWS UPDATED! Could not find book with ID: " + b.getId());
            }
            
        } catch (Exception e) {
            // INSTEAD OF SWALLOWING THE ERROR, FORCE A VISIBLE CRASH ON THE SCREEN!
            throw new RuntimeException("DATABASE UPDATE FAILED: " + e.getMessage(), e);
        }
    }

    public void softDeleteBook(int id) {
        String sql = "UPDATE Books SET is_active = 0 WHERE book_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Book> getAllBooksForAdmin() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM Books ORDER BY book_id DESC";
        try (Connection conn = getConnection();
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

    public List<Book> getLowStockBooks(String keyword, int categoryId, String publisher, int threshold) {
        List<Book> list = new ArrayList<>();

        String sql = "SELECT b.*, c.category_name " +
                "FROM Books b " +
                "LEFT JOIN Categories c ON b.category_id = c.category_id " +
                "WHERE b.stock_quantity <= ?";

        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND b.title LIKE ?";
        }
        if (categoryId > 0) {
            sql += " AND b.category_id = ?";
        }
        if (publisher != null && !publisher.isEmpty()) {
            sql += " AND b.publisher = ?";
        }

        sql += " ORDER BY b.stock_quantity ASC";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            int index = 1;

            ps.setInt(index++, threshold);

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }
            if (categoryId > 0) {
                ps.setInt(index++, categoryId);
            }
            if (publisher != null && !publisher.isEmpty()) {
                ps.setString(index++, publisher);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Book b = new Book();
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setPrice(rs.getDouble("price"));
                try {
                    b.setPublisher(rs.getString("publisher"));
                } catch (Exception e) {
                }
                b.setImageUrl(rs.getString("image"));
                b.setStockQuantity(rs.getInt("stock_quantity"));
                b.setCategoryId(rs.getInt("category_id"));
                try {
                    b.setCategoryName(rs.getString("category_name"));
                } catch (Exception e) {
                }

                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 1. Save a single detail image to the database
    public void insertDetailImage(int bookId, String imageUrl) {
        String sql = "INSERT INTO BookImages (book_id, image_url) VALUES (?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ps.setString(2, imageUrl);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error inserting detail image: " + e.getMessage());
        }
    }

    // 2. Fetch all detail images for a specific book (Used for the Edit page and Product Details page)
    public List<BookImage> getDetailImages(int bookId) {
    List<BookImage> images = new ArrayList<>();
    // Use the actual column names from your SQL Server table!
    String sql = "SELECT image_id, book_id, image_url FROM BookImages WHERE book_id = ?";
    
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, bookId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                BookImage img = new BookImage(
                    rs.getInt("image_id"),
                    rs.getInt("book_id"),
                    rs.getString("image_url")
                );
                images.add(img);
            }
        }
    } catch (Exception e) {
        System.out.println("Error fetching detail images: " + e.getMessage());
    }
    return images;
}

    // 3. Delete old detail images (Crucial for when an Admin updates a book's gallery)
    public void deleteDetailImages(int bookId) {
        String sql = "DELETE FROM BookImages WHERE book_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error deleting detail images: " + e.getMessage());
        }
    }

    public void deleteDetailImageById(int imageId) {
    String sql = "DELETE FROM BookImages WHERE image_id = ?";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, imageId);
        ps.executeUpdate();
    } catch (Exception e) {
        System.out.println("Error deleting specific detail image: " + e.getMessage());
    }
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
        b.setPublisher(rs.getString("publisher"));
        b.setSupplier(rs.getString("supplier"));
        b.setYearOfPublish(rs.getInt("yearOfPublish"));
        b.setNumberPage(rs.getInt("number_page"));

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

    // Hàm dùng riêng cho việc thanh toán (Trừ kho hoặc Hoàn kho)
    public void updateStockForCheckout(List<CartItem> cart, boolean isRestore) {
        // Nếu isRestore = true -> Cộng lại kho (Khách hủy đơn)
        // Nếu isRestore = false -> Trừ kho (Khách đang thanh toán)
        String sql = isRestore
                ? "UPDATE Books SET stock_quantity = stock_quantity + ? WHERE book_id = ?"
                : "UPDATE Books SET stock_quantity = stock_quantity - ? WHERE book_id = ?";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement st = conn.prepareStatement(sql)) {

            // Tắt auto commit để chạy Transaction (Đảm bảo an toàn dữ liệu)
            conn.setAutoCommit(false);

            for (CartItem item : cart) {
                st.setInt(1, item.getQuantity()); // Lấy số lượng khách mua
                st.setInt(2, item.getBook().getId()); // ID của cuốn sách
                st.addBatch(); // Thêm vào hàng đợi
            }

            st.executeBatch(); // Thực thi một loạt các lệnh Update cùng lúc
            conn.commit(); // Xác nhận lưu vào Database

        } catch (Exception e) {
            e.printStackTrace();
            // Lý tưởng nhất là log lỗi ở đây để theo dõi
        }
    }

    public List<Book> getBooksByName(String name) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM Books WHERE title LIKE ?";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
