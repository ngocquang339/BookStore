package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.Category;

public class CategoryDAO extends DBContext {

    // Hàm lấy tất cả danh mục
    public List<Category> getCategories(){
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

    // Add this inside CategoryDAO.java
    public void insertCategory(Category c) {
        // Adjust the column names if your database uses different ones!
        String sql = "INSERT INTO Categories (category_name, description) VALUES (?, ?)"; 
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription()); // If you don't have a description column, remove this
            
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error inserting category: " + e.getMessage());
            e.printStackTrace();
        }
    }
}