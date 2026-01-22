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