package com.group2.bookstore.model;

public class AdminNotification {
    private int id;
    private int orderId;
    private String message;

    public AdminNotification(int id, int orderId, String message) {
        this.id = id;
        this.orderId = orderId;
        this.message = message;
    }

    public int getId() { return id; }
    public int getOrderId() { return orderId; }
    public String getMessage() { return message; }
}