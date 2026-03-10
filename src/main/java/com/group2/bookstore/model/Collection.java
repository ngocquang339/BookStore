package com.group2.bookstore.model;

import java.sql.Timestamp;

public class Collection {
    private int id;
    private int userId;
    private String name;
    private String description;
    private boolean isPublic;
    private String coverColor;
    private Timestamp createdAt;
    
    // Thuộc tính phụ để hiển thị trên giao diện (Không có trong DB)
    private int totalBooks; // Lưu tổng số sách đang có trong bộ sưu tập này

    public Collection() {
    }

    public Collection(int id, int userId, String name, String description, boolean isPublic, String coverColor, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.name = name;
        this.description = description;
        this.isPublic = isPublic;
        this.coverColor = coverColor;
        this.createdAt = createdAt;
    }

    // --- GETTERS & SETTERS ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public boolean isPublic() { return isPublic; }
    public void setPublic(boolean isPublic) { this.isPublic = isPublic; }

    public String getCoverColor() { return coverColor; }
    public void setCoverColor(String coverColor) { this.coverColor = coverColor; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public int getTotalBooks() { return totalBooks; }
    public void setTotalBooks(int totalBooks) { this.totalBooks = totalBooks; }
}