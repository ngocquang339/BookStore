package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.Category;

public class CategoryDAO extends DBContext {

    // Hàm lấy tất cả danh mục (FIXED: Plugged the connection leak!)
    public List<Category> getCategories() {
        List<Category> list = new ArrayList<>();
        // Tên bảng trong DB của bạn là Categories
        String sql = "SELECT * FROM Categories where parent_id is null"; // Lấy danh mục cha (nếu có phân cấp)

        // Using try-with-resources to automatically close connections
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category(
                        rs.getInt("category_id"), // Tên cột chính xác trong DB
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
        // Added category_image to the query
        String sql = "INSERT INTO Categories (category_name, description, parent_id, category_image) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription());

            if (c.getParentId() != null) {
                ps.setInt(3, c.getParentId());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            
            // Handle the image URL
            ps.setString(4, c.getImageUrl()); 

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateCategory(Category c) {
        // Added category_image to the query
        String sql = "UPDATE Categories SET category_name = ?, description = ?, parent_id = ?, category_image = ? WHERE category_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription());

            if (c.getParentId() != null) {
                ps.setInt(3, c.getParentId());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            
            // Handle the image URL
            ps.setString(4, c.getImageUrl());
            ps.setInt(5, c.getId());
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        // Order by parent_id so parents show up before children
        String sql = "SELECT * FROM Categories ORDER BY parent_id ASC, category_name ASC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category(
                        rs.getInt("category_id"),
                        rs.getString("category_name"),
                        rs.getString("category_image"),
                        rs.getString("description")
                );

                // Safely grab the parent_id (handling SQL NULLs)
                int parentId = rs.getInt("parent_id");
                if (!rs.wasNull()) {
                    c.setParentId(parentId);
                }

                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Check if any books are currently assigned to this category
    public boolean hasBooks(int categoryId) {
        String sql = "SELECT COUNT(*) FROM Books WHERE category_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

// Check if a Parent has any Children before deleting
    public boolean hasChildren(int parentId) {
        String sql = "SELECT COUNT(*) FROM Categories WHERE parent_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void deleteCategory(int id) {
        String sql = "DELETE FROM Categories WHERE category_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Category getCategoryById(int id) {
    String sql = "SELECT * FROM Categories WHERE category_id = ?";
    try (Connection conn = getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("category_id"));
                c.setName(rs.getString("category_name"));
                
                // CRITICAL FIX: Make sure this column name matches your DB exactly
                c.setImageUrl(rs.getString("category_image")); 
                
                c.setDescription(rs.getString("description"));

                // Safely handle the parent_id
                int parentId = rs.getInt("parent_id");
                if (!rs.wasNull()) {
                    c.setParentId(parentId);
                }
                return c;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

    
}
