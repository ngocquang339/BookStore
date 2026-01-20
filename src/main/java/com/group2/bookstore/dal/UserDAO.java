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
                    rs.getInt("role"),
                    rs.getString("phone_number")
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
}
