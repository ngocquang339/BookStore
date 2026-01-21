package com.group2.bookstore.dal;

import com.group2.bookstore.model.Book; // Nhớ đảm bảo class Book đã có (như bài trước)
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO extends DBContext {

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
                        rs.getString("description"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
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
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Thêm vào BookDAO.java
    public void saveSearchHistory(String keyword, Integer userId) {
        // Chỉ lưu nếu từ khóa không rỗng
        if (keyword == null || keyword.trim().isEmpty())
            return;

        String sql = "INSERT INTO SearchHistory (keyword, user_id) VALUES (?, ?)";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setString(1, keyword);

            // Nếu user chưa đăng nhập (userId là null) thì set Null vào DB
            if (userId == null) {
                st.setNull(2, java.sql.Types.INTEGER);
            } else {
                st.setInt(2, userId);
            }

            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}