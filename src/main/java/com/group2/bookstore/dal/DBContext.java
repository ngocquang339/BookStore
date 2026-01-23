package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    public Connection getConnection() throws ClassNotFoundException, SQLException {
    // Note the double backslash \\ for the instance name
    String serverName = "DESKTOP-V0CJE41\\SQLEXPRESS01"; 
    String dbName = "BookShop";
    String userID = "sa";
    String password = "1";

    // REMOVE the port number from the URL string
    String url = "jdbc:sqlserver://" + serverName
               + ";databaseName=" + dbName
               + ";encrypt=true;trustServerCertificate=true;";

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