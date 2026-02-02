package com.group2.bookstore.dal;

import com.group2.bookstore.model.Book;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

    // Thay thế hàm getBooks cũ trong BookDAO.java
    public List<Book> getBooks(String keyword, int cid, String author, String publisher, double minPrice,
            double maxPrice, String sortBy, String sortOrder) {
        List<Book> list = new ArrayList<>();

        // Mặc định chỉ lấy sách đang hoạt động (is_active = 1)
        StringBuilder sql = new StringBuilder("SELECT * FROM Books WHERE is_active = 1 ");
        List<Object> params = new ArrayList<>();

        // 1. Tìm theo tên sách (Không phân biệt hoa thường)
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND LOWER(title) LIKE LOWER(?) ");
            params.add("%" + keyword.trim() + "%");
        }

        // 2. Tìm theo Danh mục (category_id)
        if (cid > 0) {
            sql.append(" AND category_id = ? ");
            params.add(cid);
        }

        // 3. Tìm theo Tác giả (Gần đúng)
        if (author != null && !author.trim().isEmpty()) {
            sql.append(" AND LOWER(author) LIKE LOWER(?) ");
            params.add("%" + author.trim() + "%");
        }

        // 4. Tìm theo Nhà xuất bản (Nếu có)
        if (publisher != null && !publisher.trim().isEmpty()) {
            sql.append(" AND LOWER(publisher) LIKE LOWER(?) ");
            params.add("%" + publisher.trim() + "%");
        }

        // 5. Tìm theo Giá tiền
        if (minPrice > 0 && maxPrice > 0) {
            sql.append(" AND price BETWEEN ? AND ? ");
            params.add(minPrice);
            params.add(maxPrice);
        } else if (minPrice > 0) {
            sql.append(" AND price >= ? ");
            params.add(minPrice);
        } else if (maxPrice > 0) {
            sql.append(" AND price <= ? ");
            params.add(maxPrice);
        }

        // 6. Sắp xếp
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            switch (sortBy) {
                case "price":
                    sql.append(" ORDER BY price ");
                    break;
                case "title":
                    sql.append(" ORDER BY title ");
                    break;
                case "stock":
                    sql.append(" ORDER BY stock_quantity ");
                    break;
                default:
                    sql.append(" ORDER BY book_id ");
                    break;
            }
            if ("DESC".equalsIgnoreCase(sortOrder)) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
        } else {
            sql.append(" ORDER BY book_id DESC"); // Mặc định sách mới nhất lên đầu
        }

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Gán giá trị cho các dấu ?
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
                b.setImageUrl(rs.getString("image")); // Khớp với cột [image] trong DB
                b.setDescription(rs.getString("description"));
                b.setStockQuantity(rs.getInt("stock_quantity"));
                b.setPublisher(rs.getString("publisher"));
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

    // 2. Thêm hàm lấy danh sách Publisher duy nhất

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
}
