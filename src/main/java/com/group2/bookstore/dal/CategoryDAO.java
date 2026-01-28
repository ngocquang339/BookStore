package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.Category;

public class CategoryDAO {
    
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        // Make sure table name is correct (Categories or Category?)
        String sql = "SELECT * FROM Categories"; 
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                // FIXED: Using exact column names from your image
                int id = rs.getInt("category_id");
                String name = rs.getString("category_name");
                
                list.add(new Category(id, name));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}