package com.group2.bookstore.model;

import java.sql.Timestamp;

public class WalletHistory {
    private int transactionId;
    private int userId;
    private double amount;
    private String transactionType; // "REFUND" hoặc "PAYMENT"
    private String description;
    private int orderId;
    private Timestamp createdAt;

    // Constructor rỗng
    public WalletHistory() {
    }

    // Constructor đầy đủ
    public WalletHistory(int transactionId, int userId, double amount, String transactionType, String description, int orderId, Timestamp createdAt) {
        this.transactionId = transactionId;
        this.userId = userId;
        this.amount = amount;
        this.transactionType = transactionType;
        this.description = description;
        this.orderId = orderId;
        this.createdAt = createdAt;
    }

    // --- GETTERS & SETTERS ---
    public int getTransactionId() { return transactionId; }
    public void setTransactionId(int transactionId) { this.transactionId = transactionId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getTransactionType() { return transactionType; }
    public void setTransactionType(String transactionType) { this.transactionType = transactionType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}