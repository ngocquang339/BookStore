package com.group2.bookstore.dal;

import com.group2.bookstore.model.Address;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO extends DBContext {

    // 1. Lấy tất cả địa chỉ của một User (Sắp xếp ưu tiên Địa chỉ mặc định lên đầu)
    public List<Address> getAddressesByUserId(int userId) {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT * FROM Addresses WHERE user_id = ? "
                   + "ORDER BY is_default_shipping DESC, address_id DESC";
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);){
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Address a = new Address();
                a.setId(rs.getInt("address_id"));
                a.setUserId(rs.getInt("user_id"));
                a.setFullName(rs.getString("fullname"));
                a.setPhone(rs.getString("phone"));
                a.setCountry(rs.getString("country"));
                a.setCity(rs.getString("city"));
                a.setDistrict(rs.getString("district"));
                a.setWard(rs.getString("ward"));
                a.setAddressDetail(rs.getString("address_detail"));
                a.setZipCode(rs.getString("zip_code"));
                a.setDefaultBilling(rs.getBoolean("is_default_billing"));
                a.setDefaultShipping(rs.getBoolean("is_default_shipping"));
                
                // Lấy thêm 2 cột mã GHN
                a.setDistrictId(rs.getInt("district_id"));
                a.setWardCode(rs.getString("ward_code"));
                
                list.add(a);
            }
        } catch (Exception e) {
            System.out.println("Error getAddressesByUserId: " + e.getMessage());
        }
        return list;
    }

    // 2. Lấy một địa chỉ cụ thể để nhét vào form Sửa (Edit)
    public Address getAddressById(int addressId, int userId) {
        String sql = "SELECT * FROM Addresses WHERE address_id = ? AND user_id = ?";
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);){
            ps.setInt(1, addressId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Address a = new Address();
                a.setId(rs.getInt("address_id"));
                a.setUserId(rs.getInt("user_id"));
                a.setFullName(rs.getString("fullname"));
                a.setPhone(rs.getString("phone"));
                a.setCountry(rs.getString("country"));
                a.setCity(rs.getString("city"));
                a.setDistrict(rs.getString("district"));
                a.setWard(rs.getString("ward"));
                a.setAddressDetail(rs.getString("address_detail"));
                a.setZipCode(rs.getString("zip_code"));
                a.setDefaultBilling(rs.getBoolean("is_default_billing"));
                a.setDefaultShipping(rs.getBoolean("is_default_shipping"));
                
                // Lấy thêm 2 cột mã GHN
                a.setDistrictId(rs.getInt("district_id"));
                a.setWardCode(rs.getString("ward_code"));
                
                return a;
            }
        } catch (Exception e) {
            System.out.println("Error getAddressById: " + e.getMessage());
        }
        return null;
    }

    // 3. Hàm phụ tước quyền mặc định: Xóa cờ mặc định của tất cả địa chỉ cũ
    public void clearDefaultFlags(int userId, boolean isClearBilling, boolean isClearShipping) {
        String sql = "UPDATE Addresses SET ";
        if (isClearBilling) sql += "is_default_billing = 0 ";
        if (isClearBilling && isClearShipping) sql += ", ";
        if (isClearShipping) sql += "is_default_shipping = 0 ";
        sql += "WHERE user_id = ?";
        
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Error clearDefaultFlags: " + e.getMessage());
        }
    }

    // 4. Thêm địa chỉ mới
    public boolean insertAddress(Address a) {
        if (a.isDefaultBilling() || a.isDefaultShipping()) {
            clearDefaultFlags(a.getUserId(), a.isDefaultBilling(), a.isDefaultShipping());
        }

        // Thêm district_id và ward_code vào câu lệnh INSERT
        String sql = "INSERT INTO Addresses (user_id, fullname, phone, country, city, "
                   + "district, ward, address_detail, zip_code, is_default_billing, is_default_shipping, district_id, ward_code) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                   
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, a.getUserId());
            ps.setString(2, a.getFullName());
            ps.setString(3, a.getPhone());
            ps.setString(4, a.getCountry());
            ps.setString(5, a.getCity());
            ps.setString(6, a.getDistrict());
            ps.setString(7, a.getWard());
            ps.setString(8, a.getAddressDetail());
            ps.setString(9, a.getZipCode());
            ps.setBoolean(10, a.isDefaultBilling());
            ps.setBoolean(11, a.isDefaultShipping());
            
            // Set thêm 2 biến mã GHN
            ps.setInt(12, a.getDistrictId());
            ps.setString(13, a.getWardCode());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error insertAddress: " + e.getMessage());
        }
        return false;
    }

    // 5. Cập nhật địa chỉ
    public boolean updateAddress(Address a) {
        if (a.isDefaultBilling() || a.isDefaultShipping()) {
            clearDefaultFlags(a.getUserId(), a.isDefaultBilling(), a.isDefaultShipping());
        }

        // Thêm district_id và ward_code vào câu lệnh UPDATE
        String sql = "UPDATE Addresses SET fullname=?, phone=?, country=?, city=?, "
                   + "district=?, ward=?, address_detail=?, zip_code=?, is_default_billing=?, is_default_shipping=?, "
                   + "district_id=?, ward_code=? "
                   + "WHERE address_id=? AND user_id=?";
                   
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)){
                
            ps.setString(1, a.getFullName());
            ps.setString(2, a.getPhone());
            ps.setString(3, a.getCountry());
            ps.setString(4, a.getCity());
            ps.setString(5, a.getDistrict());
            ps.setString(6, a.getWard());
            ps.setString(7, a.getAddressDetail());
            ps.setString(8, a.getZipCode());
            ps.setBoolean(9, a.isDefaultBilling());
            ps.setBoolean(10, a.isDefaultShipping());
            
            // Set thêm 2 biến mã GHN
            ps.setInt(11, a.getDistrictId());
            ps.setString(12, a.getWardCode());
            
            ps.setInt(13, a.getId());
            ps.setInt(14, a.getUserId());
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            System.out.println("Error updateAddress: " + e.getMessage());
        }
        return false;
    }

    // 6. Xóa địa chỉ
    public boolean deleteAddress(int addressId, int userId) {
        String sql = "DELETE FROM Addresses WHERE address_id = ? AND user_id = ?";
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, addressId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error deleteAddress: " + e.getMessage());
        }
        return false;
    }
}