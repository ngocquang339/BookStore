package com.group2.bookstore.dal;

import com.group2.bookstore.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext {
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
                        rs.getInt("status"));
                return u;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE Users SET fullname = ?, email = ?, phone_number = ?, address = ? WHERE user_id = ?";
        try {
            // 2. Chuẩn bị câu lệnh
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setString(1, user.getFullname());
            st.setString(2, user.getEmail());
            st.setString(3, user.getPhone_number());
            st.setString(4, user.getAddress());
            st.setInt(5, user.getId());

            int rowsUpdated = st.executeUpdate();

            // Đóng kết nối để tránh tràn bộ nhớ
            st.close();
            getConnection().close();
            return rowsUpdated > 0;
        } catch (Exception e) {
            System.out.println(e);
            return false;
        }
    }

    public User checkUserExist(String username) {
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
                        rs.getInt("status"));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    public User checkEmailExist(String email) {
        // SỬA LẠI TÊN BẢNG THÀNH "Users"
        String sql = "SELECT * FROM Users WHERE email = ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setString(1, email);
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
                        rs.getInt("status"));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    // Hàm thêm mới người dùng vào Database
    public void createUser(User user) {
        String sql = "INSERT INTO Users (fullname, phone_number, username, password, email, role, status) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            // 2. Mở kết nối
            Connection conn = getConnection();
            PreparedStatement st = conn.prepareStatement(sql);

            st.setString(1, user.getFullname());
            st.setString(2, user.getPhone_number());
            st.setString(3, user.getUsername());
            st.setString(4, user.getPassword());
            st.setString(5, user.getEmail());
            st.setInt(6, user.getStatus());
            st.setInt(7, 2);

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
            ps.setInt(2, newRole);
            ps.setInt(3, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // // Lấy danh sách khách hàng (Role = 2) dành cho Staff
    public List<User> getAllCustomers() {
        List<User> list = new ArrayList<>();
        // Role 2 là khách hàng (dựa trên dữ liệu mẫu của bạn)
        String sql = "SELECT * FROM Users WHERE role = 2";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("user_id"));
                u.setFullname(rs.getString("fullname")); // Cần hiển thị tên thật
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setPhone_number(rs.getString("phone_number")); // Quan trọng để liên hệ
                u.setAddress(rs.getString("address")); // Quan trọng để ship
                u.setRole(rs.getInt("role"));
                u.setStatus(rs.getInt("status")); // Để biết khách có bị khóa không
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- NÂNG CẤP: TÌM KIẾM KHÁCH HÀNG ---
    public List<User> searchCustomers(String keyword) {
        List<User> list = new ArrayList<>();
        // Tìm theo tên hoặc SĐT, chỉ lấy khách hàng (role = 2)
        String sql = "SELECT * FROM Users WHERE role = 2 AND (fullname LIKE ? OR phone_number LIKE ?)";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setFullname(rs.getString("fullname"));
                u.setEmail(rs.getString("email"));
                u.setPhone_number(rs.getString("phone_number"));
                u.setAddress(rs.getString("address"));
                u.setRole(rs.getInt("role"));
                u.setStatus(rs.getInt("status"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Change passWord
    public boolean changePassword(String newPass, User user) {
        String sql = "UPDATE Users SET password = ? where user_id = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newPass);
            ps.setInt(2, user.getId());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
