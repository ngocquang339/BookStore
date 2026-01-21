package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    public Connection getConnection() throws ClassNotFoundException, SQLException {
        // 1. Thông tin cấu hình
        String serverName = "localhost";
        String dbName = "BookShop"; // Thay tên DB của bạn vào đây
        String portNumber = "1433";
        String instance = ""; // Bản 2022 mặc định để trống
        
        // Tài khoản sa mà bạn đã tạo mật khẩu 123456 lúc cài đặt
        String userID = "sa";
        String password = "123456"; // Điền pass bạn đã cài

        // 2. Cấu trúc Connection String chuẩn cho SQL Server 2022
        // encrypt=true;trustServerCertificate=true; là BẮT BUỘC để tránh lỗi SSL
        String url = "jdbc:sqlserver://" + serverName + ":" + portNumber + "\\" + instance 
                   + ";databaseName=" + dbName 
                   + ";encrypt=true;trustServerCertificate=true;";

        if (instance == null || instance.trim().isEmpty()) {
             url = "jdbc:sqlserver://" + serverName + ":" + portNumber 
                   + ";databaseName=" + dbName 
                   + ";encrypt=true;trustServerCertificate=true;";
        }

        // 3. Load Driver và Kết nối
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, userID, password);
    }

    // Main để test thử xem kết nối được chưa
    public static void main(String[] args) {
        try {
            System.out.println(new DBContext().getConnection());
            System.out.println("Kết nối thành công! 🎉");
        } catch (Exception e) {
            System.out.println("Kết nối thất bại: " + e.getMessage());
            e.printStackTrace();
        }
    }
}