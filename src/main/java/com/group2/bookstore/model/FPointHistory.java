package com.group2.bookstore.model;

import java.sql.Timestamp;

public class FPointHistory {
    private int historyId;
    private int userId;
    private String customerInfo; // Dùng để hiển thị chuỗi "@quang (#1011)" trên UI
    private String actionType;   // Lưu "add" hoặc "sub"
    private int amount;
    private String reason;
    private Timestamp createdAt;

    public FPointHistory() {
    }

    public FPointHistory(int userId, String customerInfo, String actionType, int amount, String reason) {
        this.userId = userId;
        this.customerInfo = customerInfo;
        this.actionType = actionType;
        this.amount = amount;
        this.reason = reason;
    }

    // --- GETTERS AND SETTERS ---
    public int getHistoryId() { return historyId; }
    public void setHistoryId(int historyId) { this.historyId = historyId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getCustomerInfo() { return customerInfo; }
    public void setCustomerInfo(String customerInfo) { this.customerInfo = customerInfo; }

    public String getActionType() { return actionType; }
    public void setActionType(String actionType) { this.actionType = actionType; }

    public int getAmount() { return amount; }
    public void setAmount(int amount) { this.amount = amount; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}