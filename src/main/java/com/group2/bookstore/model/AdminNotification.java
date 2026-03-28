package com.group2.bookstore.model;

public class AdminNotification {
    private int id;
    private String link; // ✨ CHANGED from int orderId
    private String message;

    public AdminNotification(int id, String link, String message) {
        this.id = id;
        this.link = link;
        this.message = message;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getLink() { return link; } // ✨ CHANGED
    public void setLink(String link) { this.link = link; } // ✨ CHANGED

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
}