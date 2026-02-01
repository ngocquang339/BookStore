package com.group2.bookstore.model;

import java.io.Serializable;
import java.sql.Timestamp; // Import for the date

public class User implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String username;
    private String password;
    private String email;
    private String fullname;
    private String phone_number;
    private String address;
    private int role;           // 1=Admin, 2=Customer, 3=Warehouse
    
    // NEW FIELDS added to match Database
    private int status;         // 1=Active, 0=Banned (Mapped from [bit])
    private Timestamp createAt; // Mapped from [datetime]

    public User() {
    }

    public User(int id, String username, String password, String email, String fullname, int role, String phone_number, String address, int status, Timestamp createAt) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullname = fullname;
        this.role = role;
        this.phone_number = phone_number;
        this.address = address;
        this.status = status;
        this.createAt = createAt;
    }

    // --- GETTERS AND SETTERS ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public int getRole() { return role; }
    public void setRole(int role) { this.role = role; }

    public String getPhone_number() { return phone_number; }
    public void setPhone_number(String phone_number) { this.phone_number = phone_number; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    // New Getters/Setters
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public Timestamp getCreateAt() { return createAt; }
    public void setCreateAt(Timestamp createAt) { this.createAt = createAt; }
}