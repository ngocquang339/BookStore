package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.User;

public class UserDAO extends DBContext{
    public User checkLogin(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username = ? AND password = ?";
        
        try {
            // 2. Chuẩn bị câu lệnh
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setString(1, username); 
            st.setString(2, password); 
            
            // 3. Chạy câu lệnh và lấy kết quả
            ResultSet rs = st.executeQuery();
            
            // 4. Nếu có kết quả (tức là đăng nhập đúng)
            if (rs.next()) {
                User u = new User(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("email"),
                    rs.getString("fullname"),
                    rs.getInt("role"),
                    rs.getString("phone_number"),
                    rs.getString("address"),
                    rs.getInt("status"), // 1 or 0
                    rs.getTimestamp("createAt")
                );
                return u; 
            }
        } catch (Exception e){
            System.out.println(e);
        }
        return null; 
    }

    public boolean updateUser(User user){
        String sql = "UPDATE Users SET username = ?, email = ?, phone_number = ? WHERE id = ?";
        try {
            // 2. Chuẩn bị câu lệnh
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setString(1, user.getUsername()); 
            st.setString(2, user.getEmail()); 
            st.setString(3, user.getPhone_number());
            st.setInt(4, user.getId());
            
            int rowsUpdated = st.executeUpdate();

            // Đóng kết nối để tránh tràn bộ nhớ
            st.close();
            getConnection().close();
            return rowsUpdated > 0;
        } catch (Exception e){  
            System.out.println(e);
            return false;
        }
    }
    public User checkUserExist(String username){
    // SỬA LẠI TÊN BẢNG THÀNH "Users"
    String sql = "SELECT * FROM Users WHERE username = ?"; 
    try {
        PreparedStatement st = getConnection().prepareStatement(sql);
        st.setString(1, username);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return new User(
                rs.getInt("user_id"),
                rs.getString("username"),
                rs.getString("password"),
                rs.getString("email"),
                rs.getString("fullname"),
                rs.getInt("role"),
                rs.getString("phone_number"),
                rs.getString("address"),
                rs.getInt("status"), // 1 or 0
                rs.getTimestamp("createAt")
            );
        }
    } catch (Exception e) {
        System.out.println(e);
    }
    return null;
}

// Hàm thêm mới người dùng vào Database
    public void createUser(User user) {
        String sql = "INSERT INTO Users (username, password, email, role) VALUES (?, ?, ?, ?)";

        try {
            // 2. Mở kết nối
            Connection conn = getConnection();
            PreparedStatement st = conn.prepareStatement(sql);

            // 3. Truyền tham số (Thứ tự dấu ? phải khớp với danh sách cột ở trên)
            st.setString(1, user.getUsername()); 
            st.setString(2, user.getPassword()); 
            st.setString(3, user.getEmail());    
            
            // 4. Set Role mặc định (Ví dụ: 2 là Customer. Bạn sửa số này theo quy ước DB của bạn)
            st.setInt(4, 2); 

            // 5. Thực thi câu lệnh (QUAN TRỌNG)
            int rowsAffected = st.executeUpdate();

            // 6. Kiểm tra xem có chèn được không (In ra Console để biết)
            if (rowsAffected > 0) {
                System.out.println("DEBUG: Đã đăng ký thành công user: " + user.getUsername());
            } else {
                System.out.println("DEBUG: Không chèn được dòng nào vào DB.");
            }

            // 7. Đóng kết nối
            st.close();
            conn.close();

        } catch (Exception e) {
            // In lỗi màu đỏ ra Console để dễ nhìn thấy
            System.err.println("LỖI SQL KHI CREATE USER:");
            e.printStackTrace();
        }
    }

    // 1. GET ALL USERS (For Admin List)
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        // Order by newest accounts first
        String sql = "SELECT * FROM Users ORDER BY createAt DESC"; 
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setFullname(rs.getString("fullname"));
                u.setEmail(rs.getString("email"));
                u.setPhone_number(rs.getString("phone_number"));
                u.setAddress(rs.getString("address"));
                u.setRole(rs.getInt("role"));
                u.setStatus(rs.getInt("status")); // 1 or 0
                u.setCreateAt(rs.getTimestamp("createAt"));
                
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. UPDATE USER STATUS/ROLE
    public void updateUser(int userId, int newStatus, int newRole) {
        String sql = "UPDATE Users SET status = ?, role = ? WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newStatus);
            ps.setInt(2, newRole);
            ps.setInt(3, userId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 3. CHECK IF USERNAME EXISTS (Prevent duplicates)
    public boolean checkUsernameExists(String username) {
        String sql = "SELECT user_id FROM Users WHERE username = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // Returns true if found
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 4. ADD NEW USER
    public void addUser(User u) {
        String sql = "INSERT INTO Users (username, password, fullname, email, phone_number, address, role, status, createAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, 1, GETDATE())"; // Default Status=1 (Active)
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword()); // In real app, hash this!
            ps.setString(3, u.getFullname());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getPhone_number());
            ps.setString(6, u.getAddress());
            ps.setInt(7, u.getRole());
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 5. QUICK BAN/UNBAN
    public void updateUserStatus(int userId, int newStatus) {
        String sql = "UPDATE Users SET status = ? WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newStatus);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
