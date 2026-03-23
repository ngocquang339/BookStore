package com.group2.bookstore.model;

import java.sql.Timestamp;

public class InventoryHistory {
    private int historyId;
    private int bookId;
    private String transactionType;
    private int quantityChanged;
    private Integer relatedId;
    private Timestamp createdAt;
    private Integer createdBy;

    // Các thuộc tính mở rộng (Dùng để JOIN lấy dữ liệu hiển thị lên bảng)
    private String bookTitle;
    private String createdByName;

    public InventoryHistory() {
    }

    // --- GETTERS & SETTERS ---
    public int getHistoryId() { return historyId; }
    public void setHistoryId(int historyId) { this.historyId = historyId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getTransactionType() { return transactionType; }
    public void setTransactionType(String transactionType) { this.transactionType = transactionType; }

    public int getQuantityChanged() { return quantityChanged; }
    public void setQuantityChanged(int quantityChanged) { this.quantityChanged = quantityChanged; }

    public Integer getRelatedId() { return relatedId; }
    public void setRelatedId(Integer relatedId) { this.relatedId = relatedId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }
}