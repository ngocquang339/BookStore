package com.group2.bookstore.dal;

import com.group2.bookstore.model.Book; // Nhớ đảm bảo class Book đã có (như bài trước)
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO extends DBContext {

    // Sửa lại dòng khai báo hàm: thêm tham số String sort
    public List<Book> getBooks(String keyword, int cid, String author, String col, String order) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM Books WHERE 1=1 ";

        // --- FILTER ---
        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND title LIKE ? ";
        }
        if (cid > 0) {
            sql += " AND category_id = ? ";
        }
        if (author != null && !author.isEmpty()) {
            sql += " AND author = ? ";
        }

        // --- SORT (Thêm logic cho category và publisher) ---
        String orderBy = " ORDER BY book_id ASC"; 
        
        if (col != null && order != null) {
            if (!order.equalsIgnoreCase("ASC") && !order.equalsIgnoreCase("DESC")) {
                order = "ASC";
            }
            switch (col) {
                case "title": orderBy = " ORDER BY title " + order; break;
                case "author": orderBy = " ORDER BY author " + order; break;
                case "stock": orderBy = " ORDER BY stock_quantity " + order; break;
                case "price": orderBy = " ORDER BY price " + order; break;
                
                // THÊM 2 CASE MỚI Ở ĐÂY:
                case "category": orderBy = " ORDER BY category_id " + order; break; 
                case "publisher": orderBy = " ORDER BY publisher " + order; break; 
                
                default: break;
            }
        }
        sql += orderBy;

        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            int index = 1;
            if (keyword != null && !keyword.isEmpty()) {
                st.setString(index++, "%" + keyword + "%");
            }
            if (cid > 0) {
                st.setInt(index++, cid);
            }
            if (author != null && !author.isEmpty()) {
                st.setString(index++, author);
            }
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Book b = new Book(
                    rs.getInt("book_id"),
                    rs.getString("title"),
                    rs.getString("author"),
                    rs.getDouble("price"),
                    rs.getInt("stock_quantity"),
                    rs.getString("image"),
                    rs.getInt("category_id"),
                    rs.getString("description"),
                    rs.getString("publisher") // <--- LẤY CỘT PUBLISHER TỪ DB
                );
                list.add(b);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    public List<String> getAllAuthors() {
        List<String> authors = new ArrayList<>();
        // Query lấy các tác giả khác nhau, bỏ qua giá trị null
        String sql = "SELECT DISTINCT author FROM Books WHERE author IS NOT NULL";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                authors.add(rs.getString("author"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return authors;
    }
}