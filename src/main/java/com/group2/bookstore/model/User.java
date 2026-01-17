package com.group2.bookstore.model;

public class User {
    private int id;
    private String username;
    private String password;
    private String email;
    private String fullname;
    private int role; // 1: Admin, 2: User

    public User() {
    }

    public User(int id, String username, String password, String email, String fullname, int role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullname = fullname;
        this.role = role;
    }

    // --- Getter và Setter (Bắt buộc phải có để JSP đọc được) ---
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
}
