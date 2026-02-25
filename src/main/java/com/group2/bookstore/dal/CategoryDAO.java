package com.group2.bookstore.dal;

import com.group2.bookstore.model.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends DBContext {

    // Hàm lấy tất cả danh mục
    public List<Category> getCategories() {
        List<Category> list = new ArrayList<>();
        // Tên bảng trong DB của bạn là Categories
        String sql = "SELECT * FROM Categories where parent_id is null"; // Lấy danh mục cha (nếu có phân cấp)
        
        try {
            Connection conn = new DBContext().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category(
                    rs.getInt("category_id"),   // Tên cột chính xác trong DB
                    rs.getString("category_name"), // Tên cột chính xác trong DB
                    rs.getString("category_image"),
                    rs.getString("description")
                );
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Updated method to include description
    public void insertCategory(String name, String description) {
        String sql = "INSERT INTO Categories (category_name, description) VALUES (?, ?)"; 
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, name);
            ps.setString(2, description); // New Field
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}