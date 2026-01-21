package com.group2.bookstore.dal;

import com.group2.bookstore.model.Book;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BookDAO extends DBContext {

    // Hàm lấy tất cả sách (để hiển thị lúc mới vào Home)
    public List<Book> getAllBooks() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM Books";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Book(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("author"),
                    rs.getDouble("price"),
                    rs.getString("image"),
                    rs.getString("description")
                ));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    // Hàm tìm kiếm theo tên hoặc tác giả
    public List<Book> searchBooks(String keyword) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM Books WHERE title LIKE ? OR author LIKE ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            // Thêm % để tìm kiếm tương đối
            st.setString(1, "%" + keyword + "%");
            st.setString(2, "%" + keyword + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Book(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("author"),
                    rs.getDouble("price"),
                    rs.getString("image"),
                    rs.getString("description")
                ));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }
}