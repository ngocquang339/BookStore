package com.group2.bookstore.model;

import java.util.Date;

public class Notification {
    private int id;
    private int userId;
    private String message;
    private String link;
    private boolean isRead;
    private Date createdAt;

    // --- Tạo Constructor không tham số ---
    public Notification() {}

    // --- Tạo các Getter và Setter ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getLink() { return link; }
    public void setLink(String link) { this.link = link; }

    public boolean isIsRead() { return isRead; }
    public void setIsRead(boolean isRead) { this.isRead = isRead; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}