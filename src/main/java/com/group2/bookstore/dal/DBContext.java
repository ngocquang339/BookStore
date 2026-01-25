package com.group2.bookstore.dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {

    public Connection getConnection() throws ClassNotFoundException, SQLException {
        
        // =============================================================
        // OPTION 1: Connection using Named Instance (YOUR ACTIVE SERVER)
        // Use this if your server name is like "DESKTOP-XXX\SQLEXPRESS"
        // =============================================================
        // String serverName = "DESKTOP-V0CJE41\\SQLEXPRESS01"; 
        // String dbName = "BookShop";
        // String userID = "sa";
        // String password = "1";
        
        // // Connection String for Named Instance (Note: No port number needed here)
        // String url = "jdbc:sqlserver://" + serverName + ";databaseName=" + dbName 
        //            + ";encrypt=true;trustServerCertificate=true;";

        
        // =============================================================
        // OPTION 2: Connection using TCP/IP Port (COMMENTED OUT)
        // Use this for standard "localhost" setup on port 1433
        // =============================================================
        
        String serverName = "localhost";
        String dbName = "BookShop";
        String portNumber = "1433";
        String instance = ""; // 2022 default instance is empty
        String userID = "sa";
        String password = "123";

        String url;
        if (instance == null || instance.trim().isEmpty()) {
             url = "jdbc:sqlserver://" + serverName + ":" + portNumber
                   + ";databaseName=" + dbName
                   + ";encrypt=true;trustServerCertificate=true;";
        } else {
             // If using instance name with port (rare)
             url = "jdbc:sqlserver://" + serverName + "\\" + instance + ":" + portNumber
                   + ";databaseName=" + dbName
                   + ";encrypt=true;trustServerCertificate=true;";
        }
        

        // 3. Load Driver and Return Connection
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, userID, password);
    }

    // Main method to test connection
    public static void main(String[] args) {
        try {
            System.out.println(new DBContext().getConnection());
            System.out.println("Kết nối thành công! 🎉 (Connected successfully)");
        } catch (Exception e) {
            System.out.println("Kết nối thất bại: " + e.getMessage());
            e.printStackTrace();
        }
    }
}