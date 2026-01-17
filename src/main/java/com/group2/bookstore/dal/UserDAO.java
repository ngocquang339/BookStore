package com.group2.bookstore.dal;

import com.group2.bookstore.model.User;
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
                    rs.getInt("role")
                );
                return u; 
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null; // Không tìm thấy hoặc lỗi thì trả về null
    }
}
