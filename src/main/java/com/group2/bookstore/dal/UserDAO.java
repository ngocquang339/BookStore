package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.group2.bookstore.model.CustomerNote;
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
                        u.setWalletBalance(rs.getDouble("wallet_balance"));
                        u.setF_points(rs.getInt("f_point"));
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
                User u = new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("fullname"),
                        rs.getInt("role"),
                        rs.getString("phone_number"),
                        rs.getInt("status"));
                        u.setF_points(rs.getInt("f_point"));
                        return u;
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
                User u = new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("fullname"),
                        rs.getInt("role"),
                        rs.getString("phone_number"),
                        rs.getInt("status"));
                        u.setF_points(rs.getInt("f_point"));
                        return u;
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
                    u.setF_points(rs.getInt("f_point"));
                    list.add(u);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi SQL khi lấy danh sách user: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // HÀM CẬP NHẬT SỐ DƯ F-POINT CHO USER
    public boolean updateUserPoint(int userId, int newPoint) {
        String sql = "UPDATE Users SET f_point = ? WHERE user_id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newPoint);
            ps.setInt(2, userId);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;

        } catch (Exception e) {
            System.err.println("Lỗi cập nhật điểm F-Point cho User: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // HÀM LỌC CRM NÂNG CAO (Fix lỗi không hiển thị Nhãn dán)
    public List<User> getFilteredCustomers(String keyword, String memberTier, Double minSpend, Double maxSpend) {
        List<User> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM (" +
                        "   SELECT u.user_id, u.fullname, u.username, u.email, u.phone_number, u.status, u.tags, u.f_point," +
                        "          COALESCE((SELECT SUM(total_amount) FROM Orders o WHERE o.user_id = u.user_id AND o.status = 4), 0) AS total_spend "
                        +
                        "   FROM Users u " +
                        "   WHERE u.role = 0 " +
                        ") AS c WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(
                    " AND (c.fullname LIKE ? OR c.email LIKE ? OR c.phone_number LIKE ? OR CAST(c.user_id AS VARCHAR) = ?) ");
            String kw = "%" + keyword + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
            params.add(keyword);
        }
        if (minSpend != null) {
            sql.append(" AND c.total_spend >= ? ");
            params.add(minSpend);
        }
        if (maxSpend != null) {
            sql.append(" AND c.total_spend <= ? ");
            params.add(maxSpend);
        }

        if (memberTier != null && !memberTier.equals("all")) {
            switch (memberTier) {
                case "diamond":
                    sql.append(" AND c.total_spend >= 10000000 ");
                    break;
                case "gold":
                    sql.append(" AND c.total_spend >= 5000000 AND c.total_spend < 10000000 ");
                    break;
                case "silver":
                    sql.append(" AND c.total_spend >= 1000000 AND c.total_spend < 5000000 ");
                    break;
                case "bronze":
                    sql.append(" AND c.total_spend < 1000000 ");
                    break;
            }
        }

        sql.append(" ORDER BY c.user_id DESC");

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("user_id"));
                    u.setFullname(rs.getString("fullname"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone_number(rs.getString("phone_number"));
                    u.setStatus(rs.getInt("status"));
                    u.setTotalSpend(rs.getDouble("total_spend"));

                    u.setTags(rs.getString("tags"));
                    u.setF_points(rs.getInt("f_point"));
                    list.add(u);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // LƯU NHÃN DÁN CHO NHIỀU KHÁCH HÀNG CÙNG LÚC
    public void updateCustomerTags(String userIdsStr, String tags) {
        if (userIdsStr == null || userIdsStr.trim().isEmpty())
            return;

        String[] userIds = userIdsStr.split(",");
        StringBuilder sql = new StringBuilder("UPDATE Users SET tags = ? WHERE user_id IN (");

        for (int i = 0; i < userIds.length; i++) {
            sql.append("?");
            if (i < userIds.length - 1)
                sql.append(",");
        }
        sql.append(")");

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setNString(1, tags); // Lưu chuỗi tags (vd: "khach_si,boom_hang")
            for (int i = 0; i < userIds.length; i++) {
                ps.setInt(i + 2, Integer.parseInt(userIds[i].trim()));
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // HÀM LƯU GHI CHÚ NỘI BỘ CHO KHÁCH HÀNG
    public void addInternalNotes(String userIdsStr, String channel, String noteContent, String followUpDate) {
        if (userIdsStr == null || userIdsStr.trim().isEmpty())
            return;

        String[] userIds = userIdsStr.split(",");
        String sql = "INSERT INTO Customer_Notes (user_id, contact_channel, note_content, follow_up_date) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            for (String idStr : userIds) {
                ps.setInt(1, Integer.parseInt(idStr.trim()));
                ps.setString(2, channel);
                ps.setNString(3, noteContent); // setNString để hỗ trợ gõ Tiếng Việt có dấu

                // Xử lý ngày hẹn gọi lại (nếu người dùng có chọn ngày)
                if (followUpDate != null && !followUpDate.trim().isEmpty()) {
                    ps.setDate(4, java.sql.Date.valueOf(followUpDate));
                } else {
                    ps.setNull(4, java.sql.Types.DATE);
                }

                ps.executeUpdate(); // Chạy lệnh lưu vào DB
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lưu ghi chú: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // HÀM LẤY LỊCH SỬ GHI CHÚ CỦA KHÁCH HÀNG
    public List<CustomerNote> getCustomerNotes(int userId) {
        List<CustomerNote> list = new ArrayList<>();
        // Lấy ghi chú mới nhất lên đầu
        String sql = "SELECT * FROM Customer_Notes WHERE user_id = ? ORDER BY create_at DESC";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CustomerNote n = new CustomerNote();
                    n.setNoteId(rs.getInt("note_id"));
                    n.setUserId(rs.getInt("user_id"));
                    n.setContactChannel(rs.getString("contact_channel"));
                    n.setNoteContent(rs.getString("note_content"));
                    n.setFollowUpDate(rs.getDate("follow_up_date"));
                    n.setCreateAt(rs.getTimestamp("create_at"));
                    list.add(n);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Hàm lấy email Khách hàng theo nhóm Marketing
    public List<String> getMarketingEmails(String targetGroup) {
        List<String> emails = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT DISTINCT email FROM Users WHERE email IS NOT NULL AND email <> '' AND role = 0");

        switch (targetGroup) {
            case "vip":
                sql.append(
                        " AND (SELECT COALESCE(SUM(total_amount),0) FROM Orders o WHERE o.user_id = Users.user_id AND o.status = 4) >= 5000000");
                break;
            case "inactive":
                sql.append(
                        " AND (SELECT COALESCE(SUM(total_amount),0) FROM Orders o WHERE o.user_id = Users.user_id AND o.status = 4) < 1000000");
                break;
            case "cart_abandon":
                // Khách bỏ giỏ hàng chưa có bảng chứa trạng thái; chọn những có order chưa hoàn
                // thành và chưa hoàn tất
                sql.append(
                        " AND EXISTS (SELECT 1 FROM Cart c WHERE c.user_id = Users.user_id AND c.status = 'abandon')");
                break;
            case "all":
            default:
                break;
        }

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString());
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                emails.add(rs.getString("email"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return emails;
    }

    // Hàm lấy thông tin 1 User theo ID (Phiên bản Fix chuẩn)
    public User getUserById(int id) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

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
                    u.setF_points(rs.getInt("f_point"));
                    // Xử lý an toàn: Lấy thẳng chuỗi String từ DB để không bị lỗi Timestamp
                    if (rs.getString("createAt") != null) {
                        u.setCreateAt(rs.getTimestamp("createAt"));
                    }
                    // Lấy số dư ví từ Database và nhét vào Object User
                    u.setWalletBalance(rs.getDouble("wallet_balance"));
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

    // Hàm cập nhật số dư ví cho User
    public void updateWalletBalance(int userId, double newBalance) {
        String sql = "UPDATE Users SET wallet_balance = ? WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, newBalance);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}