package com.group2.bookstore.dal;

import com.group2.bookstore.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
                    rs.getString("address")
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
                rs.getString("address")
            );
        }
    } catch (Exception e) {
        System.out.println(e);
    }
    return null;
}

// Hàm thêm mới người dùng vào Database
    public void createUser(User user){
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
}
