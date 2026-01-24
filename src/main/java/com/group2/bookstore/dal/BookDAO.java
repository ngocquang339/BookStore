package com.group2.bookstore.dal;

import com.group2.bookstore.model.Book;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BookDAO extends DBContext {

    // 1. Hàm lấy 10 sách ngẫu nhiên (Cho trang chủ)
    public List<Book> getRandomBook() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT TOP 10 * FROM Books ORDER BY book_id DESC";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Book(
                    rs.getInt("book_id"),
                    rs.getString("title"),
                    rs.getString("author"),
                    rs.getDouble("price"),
                    rs.getInt("stock_quantity"),
                    rs.getString("image"),
                    rs.getInt("category_id"),
                    rs.getString("description")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Hàm lấy sách có tìm kiếm và lọc (Cho trang Shop)
    public List<Book> getBooks(String keyword, int cid, boolean onlyLowStock) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM Books WHERE 1=1 ";
        if (keyword != null && !keyword.isEmpty()) sql += " AND title LIKE ? ";
        if (cid > 0) sql += " AND category_id = ? ";
        if (onlyLowStock) sql += " AND stock_quantity < 5 ";

        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            int index = 1;
            if (keyword != null && !keyword.isEmpty()) st.setString(index++, "%" + keyword + "%");
            if (cid > 0) st.setInt(index++, cid);
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Book(
                    rs.getInt("book_id"),
                    rs.getString("title"),
                    rs.getString("author"),
                    rs.getDouble("price"),
                    rs.getInt("stock_quantity"),
                    rs.getString("image"),
                    rs.getInt("category_id"),
                    rs.getString("description")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 3. Hàm cập nhật số lượng (Cho trang Update Stock)
    public void updateStock(int bookId, int newQuantity) {
        String sql = "UPDATE Books SET stock_quantity = ? WHERE book_id = ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, newQuantity);
            st.setInt(2, bookId);
            st.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 4. HÀM MỚI: Lấy chi tiết sách theo ID (Dùng cho Add To Cart)
    public Book getBookById(int id) {
        String sql = "SELECT * FROM Books WHERE book_id = ?";
        try {
            // Dùng getConnection() thay vì conn
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Book(
                    rs.getInt("book_id"),
                    rs.getString("title"),
                    rs.getString("author"),
                    rs.getDouble("price"),
                    rs.getInt("stock_quantity"),
                    rs.getString("image"),
                    rs.getInt("category_id"),
                    rs.getString("description")
                );
            }
        } catch (Exception e) { // Bắt Exception chung để an toàn
            System.out.println("Lỗi lấy sách theo ID: " + e);
        }
        return null;
    }
}