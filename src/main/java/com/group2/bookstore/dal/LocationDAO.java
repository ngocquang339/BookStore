package com.group2.bookstore.dal;

import com.group2.bookstore.model.Location;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class LocationDAO extends DBContext {

    // 1. Lấy danh sách vị trí (JOIN với Categories để lấy tên thể loại)
    public List<Location> getAllLocations() {
        List<Location> list = new ArrayList<>();
        String sql = "SELECT l.*, c.category_name FROM Warehouse_Locations l "
                   + "LEFT JOIN Categories c ON l.category_id = c.category_id "
                   + "ORDER BY l.location_code ASC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Location(
                    rs.getInt("location_id"),
                    rs.getString("zone"),
                    rs.getString("rack"),
                    rs.getString("shelf"),
                    rs.getString("location_code"),
                    rs.getInt("category_id"),
                    rs.getString("category_name"),
                    rs.getString("description")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 2. Thêm mới vị trí
    public void addLocation(Location l) throws Exception {
        String sql = "INSERT INTO Warehouse_Locations (zone, rack, shelf, category_id, description) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, l.getZone().toUpperCase());
            ps.setString(2, l.getRack());
            ps.setString(3, l.getShelf());
            if (l.getCategoryId() > 0) ps.setInt(4, l.getCategoryId());
            else ps.setNull(4, Types.INTEGER);
            ps.setString(5, l.getDescription());
            ps.executeUpdate();
        } catch (java.sql.SQLException e) { throw new Exception("Lỗi DB: " + e.getMessage()); }
    }

    public void updateLocation(Location l) throws Exception {
        String sql = "UPDATE Warehouse_Locations SET zone=?, rack=?, shelf=?, category_id=?, description=? WHERE location_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, l.getZone().toUpperCase());
            ps.setString(2, l.getRack());
            ps.setString(3, l.getShelf());
            if (l.getCategoryId() > 0) ps.setInt(4, l.getCategoryId());
            else ps.setNull(4, Types.INTEGER);
            ps.setString(5, l.getDescription());
            ps.setInt(6, l.getId());
            ps.executeUpdate();
        } catch (java.sql.SQLException e) { throw new Exception("Lỗi DB: " + e.getMessage()); }
    }

    public void deleteLocation(int id) throws Exception {
        String sql = "DELETE FROM Warehouse_Locations WHERE location_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (java.sql.SQLException e) { 
            if (e.getErrorCode() == 547) throw new Exception("Không thể xóa kệ này vì đang có sách nằm trên kệ!");
            throw new Exception("Lỗi DB: " + e.getMessage()); 
        }
    }
}