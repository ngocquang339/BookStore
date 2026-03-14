package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.User;

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
                        rs.getInt("status"));
                return u;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE Users SET fullname = ?, email = ?, phone_number = ? WHERE user_id = ?";
        try {
            // 2. Chuẩn bị câu lệnh
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setString(1, user.getFullname());
            st.setString(2, user.getEmail());
            st.setString(3, user.getPhone_number());
            st.setInt(4, user.getId());

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
            st.setInt(6, 0);
            st.setInt(7, 1);

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
                u.setRole(rs.getInt("role"));

                // --- YOU MUST ADD THESE TWO LINES ---
                u.setStatus(rs.getInt("status"));
                u.setCreateAt(rs.getTimestamp("createAt")); // Use getTimestamp for datetime
                // ------------------------------------

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
            ps.setInt(2, newRole);
            ps.setInt(3, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- HÀM TÍCH HỢP: TÌM KIẾM & SẮP XẾP TÀI KHOẢN ---
    public List<User> getCustomers(String keyword, String sort) {
        List<User> list = new ArrayList<>();

        // 1. Dùng trick "WHERE 1=1" để dễ dàng cộng chuỗi điều kiện
        StringBuilder sql = new StringBuilder("SELECT * FROM Users WHERE role = 0 "); // Chỉ lấy khách hàng (role=0)

        // 2. Nếu có từ khóa -> Nối thêm điều kiện LIKE
        boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());
        if (hasKeyword) {
            sql.append(
                    " AND (fullname LIKE ? OR phone_number LIKE ? OR email LIKE ? OR CAST(user_id AS VARCHAR) LIKE ?) ");
        }
        // 3. Xử lý Sắp xếp (Sorting)
        if ("az".equals(sort)) {
            sql.append(" ORDER BY fullname ASC "); // Tên A-Z
        } else if ("za".equals(sort)) {
            sql.append(" ORDER BY fullname DESC "); // Tên Z-A
        } else if ("id_asc".equals(sort)) {
            sql.append(" ORDER BY user_id ASC "); // ID Tăng dần (1, 2, 3...)
        } else {
            sql.append(" ORDER BY user_id DESC "); // Mặc định: ID Giảm dần (Mới nhất lên đầu)
        }

        // 4. Chạy câu lệnh an toàn (Try-with-resources)
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Nếu có tìm kiếm thì mới set tham số ?
            if (hasKeyword) {
                ps.setString(1, "%" + keyword + "%"); // Dấu ? số 1 (fullname)
                ps.setString(2, "%" + keyword + "%"); // Dấu ? số 2 (phone_number)
                ps.setString(3, "%" + keyword + "%"); // Dấu ? số 3 (email) - Vừa thêm
                ps.setString(4, "%" + keyword + "%"); // Dấu ? số 4 (user_id)
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("user_id"));
                    u.setUsername(rs.getString("username"));
                    u.setFullname(rs.getString("fullname"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone_number(rs.getString("phone_number"));
                    u.setRole(rs.getInt("role"));
                    u.setStatus(rs.getInt("status"));
                    list.add(u);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi SQL khi lấy danh sách user: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Hàm lấy thông tin 1 User theo ID
    public User getUserById(int id) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, id);
            
            // Sử dụng thêm try-with-resources cho ResultSet để chống rò rỉ bộ nhớ
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("user_id"));
                    u.setUsername(rs.getString("username"));
                    u.setFullname(rs.getString("fullname"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone_number(rs.getString("phone_number"));
                    u.setRole(rs.getInt("role"));
                    u.setStatus(rs.getInt("status"));
                    u.setCreateAt(rs.getTimestamp("create_at"));
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
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

    // Hàm kiểm tra trùng số điện thoại (Bản siêu nhẹ & chống lỗi)
    public boolean isPhoneExist(String phone) {
        String sql = "SELECT 1 FROM Users WHERE phone_number = ?";
        try {
            PreparedStatement st = getConnection().prepareStatement(sql);
            st.setString(1, phone);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return true; // Báo hiệu: SỐ ĐÃ TỒN TẠI
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi đỏ ra console nếu có
        }
        return false; // KHÔNG TỒN TẠI
    }

    // 3. CHECK IF USERNAME EXISTS (Prevent duplicates)
    public boolean checkUsernameExists(String username) {
        String sql = "SELECT user_id FROM Users WHERE username = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // Returns true if found
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. ADD NEW USER
    public void addUser(User u) {
        String sql = "INSERT INTO Users (username, password, fullname, email, phone_number, role, status, createAt) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, 1, GETDATE())"; // Default Status=1 (Active)

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword()); // In real app, hash this!
            ps.setString(3, u.getFullname());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getPhone_number());
            ps.setInt(6, u.getRole());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- V.I.P 1: CẬP NHẬT TRẠNG THÁI TÀI KHOẢN (KHÓA/MỞ) ---
    public void updateUserStatus(int userId, int newStatus) {
        String sql = "UPDATE Users SET status = ? WHERE user_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newStatus); // Truyền trạng thái mới (0 hoặc 1)
            ps.setInt(2, userId); // Truyền ID của khách hàng cần khóa

            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("Lỗi khi cập nhật trạng thái user: " + e.getMessage());
            e.printStackTrace();
        }
    }
}