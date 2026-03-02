package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.Book;
import com.group2.bookstore.model.BookImage;
import com.group2.bookstore.model.Category;

public class BookDAO extends DBContext {

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

            sql = "SELECT TOP " + quantity + " * FROM Books where is_active = 1 ORDER BY NEWID()";
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
                rs.getInt("category_id"), // ID
                rs.getString("category_name"), // Name
                rs.getString("category_image"),// Image (Nếu DB chưa có cột này thì để null hoặc string rỗng)
                rs.getString("description")  
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

    public List<Book> getBookByAuthor(String author) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM Books WHERE author = ?";
        try (Connection conn = new DBContext().getConnection();
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
    
    // 3. Cập nhật hàm getBooks (Thêm tham số author, publisher, minPrice, maxPrice)
    // Updated Method: Added 'boolean isAdmin' as the last parameter
    // 1. OVERLOADED METHOD (Protects other Servlets from crashing)
    public List<Book> getBooks(String keyword, int cid, String author, String publisher, double minPrice, double maxPrice, String sortBy, String sortOrder, boolean isAdmin) {
        return getBooks(keyword, cid, author, publisher, minPrice, maxPrice, sortBy, sortOrder, isAdmin, 1, 1000000);
    }

    // 2. MAIN PAGINATED METHOD (With Cover Image Subquery)
    public List<Book> getBooks(String keyword, int cid, String author, String publisher, double minPrice, double maxPrice, String sortBy, String sortOrder, boolean isAdmin, int index, int pageSize) {
        List<Book> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT b.*, c.category_name, " +
            "(SELECT TOP 1 bi.image_url FROM BookImages bi WHERE bi.book_id = b.book_id) AS cover_image " +
            "FROM Books b LEFT JOIN Categories c ON b.category_id = c.category_id WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>(); 

        if (!isAdmin) sql.append(" AND b.is_active = 1 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(b.title) LIKE LOWER(?) OR LOWER(b.author) LIKE LOWER(?) OR LOWER(b.supplier) LIKE LOWER(?)) OR LOWER(b.publisher) LIKE LOWER(?) ");
        
            // Truyền giá trị cho 3 dấu chấm hỏi
            String searchParam = "%" + keyword.trim() + "%";
            params.add(searchParam); // Cho title
            params.add(searchParam); // Cho author
            params.add(searchParam); // Cho supplier
            params.add(searchParam); // Cho publisher
        }
        if (cid > 0) {
            sql.append(" AND b.category_id = ? OR c.parent_id = ? ");
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

        if (sortBy != null && !sortBy.isEmpty() && (sortBy.equals("price") || sortBy.equals("title") || sortBy.equals("stock_quantity") || sortBy.equals("book_id"))) {
            sql.append(" ORDER BY b.").append(sortBy).append("DESC".equalsIgnoreCase(sortOrder) ? " DESC" : " ASC");
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
                b.setDescription(rs.getString("description"));
                b.setStockQuantity(rs.getInt("stock_quantity"));
                b.setCategoryId(rs.getInt("category_id"));
                b.setDescription(rs.getString("description"));
                b.setSupplier(rs.getString("supplier"));
                b.setYearOfPublish(rs.getInt("yearOfPublish"));
                b.setNumberPage(rs.getInt("number_page"));
                
                // --- ADDED THIS LINE ---
                // Map the subquery result to the coverImage property
                b.setCoverImage(rs.getString("cover_image"));
                
                // Add Admin fields
                try { b.setCategoryName(rs.getString("category_name")); } catch (Exception e) {}
                try { b.setActive(rs.getBoolean("is_active")); } catch (Exception e) {}
                list.add(b);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 3. COUNT METHOD (For Pagination Math)
    public int countBooks(String keyword, int cid, boolean isAdmin) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Books b WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (!isAdmin) sql.append(" AND b.is_active = 1 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND LOWER(b.title) LIKE LOWER(?) ");
            params.add("%" + keyword.trim() + "%");
        }
        if (cid > 0) {
            sql.append(" AND b.category_id = ? ");
            params.add(cid);
        }
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // 2. Lấy danh sách tất cả NXB (không trùng lặp)
    public List<String> getAllPublishers() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT publisher FROM Books WHERE publisher IS NOT NULL AND publisher <> '' ORDER BY publisher";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("publisher"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Cập nhật hàm getBooks (Thêm tham số author, publisher, minPrice, maxPrice)
    // Updated Method: Added 'boolean isAdmin' as the last parameter
    // ADD 'int index' to the parameters list
    // Updated getBooks method in BookDAO.java
public List<Book> getBooks(String keyword, int cid, String author, String publisher, double minPrice, double maxPrice, String sortBy, String sortOrder, boolean isAdmin, int index) {

    List<Book> list = new ArrayList<>();

    // Base SQL
    StringBuilder sql = new StringBuilder("SELECT b.*, c.category_name as cat_name ");
    sql.append("FROM Books b ");
    sql.append("LEFT JOIN Categories c ON b.category_id = c.category_id ");
    sql.append("WHERE 1=1 ");

    List<Object> params = new ArrayList<>();

    // --- FILTERS ---
    if (!isAdmin) {
        sql.append(" AND b.is_active = 1 ");
    }
    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append(" AND (LOWER(b.title) LIKE LOWER(?) OR LOWER(b.author) LIKE LOWER(?) OR LOWER(b.supplier) LIKE LOWER(?)) OR LOWER(b.publisher) LIKE LOWER(?) ");
        
        // Truyền giá trị cho 3 dấu chấm hỏi
        String searchParam = "%" + keyword.trim() + "%";
        params.add(searchParam); // Cho title
        params.add(searchParam); // Cho author
        params.add(searchParam); // Cho supplier
        params.add(searchParam); // Cho publisher
    }
    if (cid > 0) {
        // Tìm sách thuộc danh mục con (b.category_id) HOẶC danh mục cha (c.parent_id)
        sql.append(" AND (b.category_id = ? OR c.parent_id = ?) ");
        params.add(cid); 
        params.add(cid); 
    }
    if (author != null && !author.trim().isEmpty()) {
        sql.append(" AND b.author = ? ");
        params.add(author);
    }
    if (publisher != null && !publisher.trim().isEmpty()) {
        sql.append(" AND b.publisher = ? ");
        params.add(publisher);
    }
    if (maxPrice > 0) {
        sql.append(" AND b.price BETWEEN ? AND ? ");
        params.add(minPrice);
        params.add(maxPrice);
    }

    // --- SORTING (FIXED LOGIC) ---
    if (sortBy != null && !sortBy.isEmpty()) {
        
        // Case A: Sort by Category Name (Use 'c' alias)
        if (sortBy.equals("category_name")) {
            sql.append(" ORDER BY c.category_name");
        }
        // Case B: Sort by Book Columns (Use 'b' alias)
        else if (sortBy.equals("price") || sortBy.equals("title") || 
                 sortBy.equals("stock_quantity") || sortBy.equals("book_id") || 
                 sortBy.equals("is_active")) {
            sql.append(" ORDER BY b.").append(sortBy);
        } 
        // Case C: Fallback
        else {
            sql.append(" ORDER BY b.book_id");
        }

        // Apply ASC or DESC
        if ("ASC".equalsIgnoreCase(sortOrder)) {
            sql.append(" ASC");
        } else {
            sql.append(" DESC");
        }
    } else {
        sql.append(" ORDER BY b.book_id DESC"); // Default sort
    }

    // --- PAGINATION ---
    sql.append(" OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY");
    int offset = (index - 1) * 5;
    params.add(offset);

    try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Book b = new Book();
            b.setId(rs.getInt("book_id"));
            b.setTitle(rs.getString("title"));
            b.setAuthor(rs.getString("author"));
            b.setPublisher(rs.getString("publisher"));
            b.setPrice(rs.getDouble("price"));
            b.setStockQuantity(rs.getInt("stock_quantity"));
            b.setCategoryId(rs.getInt("category_id"));
            b.setImageUrl(rs.getString("image"));
            b.setCategoryName(rs.getString("cat_name"));
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
        String sql = "INSERT INTO Books (title, author, price, description, image, stock_quantity, category_id, is_active, import_price, publisher, supplier, yearOfPublish, number_page) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"; {
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

    // 10. UPDATE (Edit)
    public void updateBook(Book b) {
        String sql = "UPDATE Books SET title=?, author=?, price=?, description=?, image=?, stock_quantity=?, category_id=?, is_active=?, import_price=?, publisher=?, supplier=?, yearOfPublish=?, number_page=? WHERE book_id=?"; {
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getAuthor());
            ps.setDouble(3, b.getPrice());
            ps.setString(4, b.getDescription());
            ps.setString(5, b.getImageUrl()); // Handles the image filename
            ps.setInt(6, b.getStockQuantity());
            ps.setInt(7, b.getCategoryId());
            ps.setBoolean(8, b.isActive());
            ps.setDouble(9, b.getImportPrice());
            ps.setString(10, b.getPublisher());
            ps.setString(11, b.getSupplier());
            ps.setInt(12, b.getYearOfPublish());
            ps.setInt(13, b.getNumberPage());
            ps.setInt(14, b.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

    // 11. SOFT DELETE (Hide instead of remove)
    public void softDeleteBook(int id) {
        String sql = "UPDATE Books SET is_active = 0 WHERE book_id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 12. GET ALL BOOKS (For Admin Management)
    public List<Book> getAllBooksForAdmin() {
        List<Book> list = new ArrayList<>();
        // Note: No "WHERE is_active=1" because Admin needs to see hidden/draft books
        String sql = "SELECT * FROM Books ORDER BY book_id DESC";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countBooks(String keyword, int cid, String author, String publisher, double minPrice, double maxPrice, boolean isAdmin) {
        // 1. Start SQL with COUNT(*)
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Books b ");
        // Keeping the JOIN ensures the count matches exactly, even if filters involve category logic later
        sql.append("LEFT JOIN Categories c ON b.category_id = c.category_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // 2. Apply EXACT SAME Filters as getBooks
        if (!isAdmin) {
            sql.append(" AND b.is_active = 1 ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND b.title LIKE ? ");
            params.add("%" + keyword + "%");
        }
        if (cid > 0) {
            sql.append(" AND b.category_id = ? ");
            params.add(cid);
        }
        if (author != null && !author.trim().isEmpty()) {
            sql.append(" AND b.author = ? ");
            params.add(author);
        }
        if (publisher != null && !publisher.trim().isEmpty()) {
            sql.append(" AND b.publisher = ? ");
            params.add(publisher);
        }
        if (maxPrice > 0) {
            sql.append(" AND b.price BETWEEN ? AND ? ");
            params.add(minPrice);
            params.add(maxPrice);
        }

        // 3. Execute and Return Count
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
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
