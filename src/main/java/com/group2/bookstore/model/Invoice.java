package com.group2.bookstore.model;

import java.sql.Timestamp;

public class Invoice {
    private int invoiceId;
    private String invoiceType; // "SALE" hoặc "PURCHASE"
    private Integer orderId; // Dùng Integer thay vì int để có thể chứa null
    private Integer purchaseOrderId;
    private Timestamp createdDate;
    private double totalAmount;
    private String status;

    public Invoice() {
    }

    public Invoice(int invoiceId, String invoiceType, Integer orderId, Integer purchaseOrderId, 
                   Timestamp createdDate, double totalAmount, String status) {
        this.invoiceId = invoiceId;
        this.invoiceType = invoiceType;
        this.orderId = orderId;
        this.purchaseOrderId = purchaseOrderId;
        this.createdDate = createdDate;
        this.totalAmount = totalAmount;
        this.status = status;
    }

    // --- GETTERS & SETTERS ---
    public int getInvoiceId() { return invoiceId; }
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }

    public String getInvoiceType() { return invoiceType; }
    public void setInvoiceType(String invoiceType) { this.invoiceType = invoiceType; }

    public Integer getOrderId() { return orderId; }
    public void setOrderId(Integer orderId) { this.orderId = orderId; }

    public Integer getPurchaseOrderId() { return purchaseOrderId; }
    public void setPurchaseOrderId(Integer purchaseOrderId) { this.purchaseOrderId = purchaseOrderId; }

    public Timestamp getCreatedDate() { return createdDate; }
    public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    // Helper method để lấy ra ID của order liên quan (phục vụ hiển thị trên bảng)
    public int getRelatedOrderId() {
        if ("SALE".equals(invoiceType) && orderId != null) return orderId;
        if ("PURCHASE".equals(invoiceType) && purchaseOrderId != null) return purchaseOrderId;
        return -1;
    }
}