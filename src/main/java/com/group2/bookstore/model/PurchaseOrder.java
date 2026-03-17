package com.group2.bookstore.model;

import java.util.Date;
import java.util.List;

public class PurchaseOrder {
    private int purchaseOrderId;
    private int supplierId;
    private int userId; // Người tạo đơn (Warehouse)
    private Integer approvedBy; // Người duyệt (Admin) - Dùng Integer để có thể nhận giá trị null
    private Date orderDate;
    private int totalQuantity;
    private double totalAmount;
    private int status; // 0: Pending, 1: Approved, 2: Received, 3: Cancelled
    private String statusNote;

    // --- CÁC THUỘC TÍNH MỞ RỘNG ĐỂ HIỂN THỊ (JOIN) ---
    private String supplierName; 
    private String createdByName;
    private String approvedByName;
    private List<PurchaseOrderDetail> details; // Danh sách các sách trong đơn này

    // 1. Constructor không tham số
    public PurchaseOrder() {
    }

    // 2. Constructor đầy đủ tham số (Tùy chọn, VSCode có thể tự gen)
    public PurchaseOrder(int purchaseOrderId, int supplierId, int userId, Integer approvedBy, Date orderDate,
                         int totalQuantity, double totalAmount, int status, String statusNote) {
        this.purchaseOrderId = purchaseOrderId;
        this.supplierId = supplierId;
        this.userId = userId;
        this.approvedBy = approvedBy;
        this.orderDate = orderDate;
        this.totalQuantity = totalQuantity;
        this.totalAmount = totalAmount;
        this.status = status;
        this.statusNote = statusNote;
    }

    // 3. Getters và Setters
    public int getPurchaseOrderId() { return purchaseOrderId; }
    public void setPurchaseOrderId(int purchaseOrderId) { this.purchaseOrderId = purchaseOrderId; }

    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Integer getApprovedBy() { return approvedBy; }
    public void setApprovedBy(Integer approvedBy) { this.approvedBy = approvedBy; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }

    public int getTotalQuantity() { return totalQuantity; }
    public void setTotalQuantity(int totalQuantity) { this.totalQuantity = totalQuantity; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public String getStatusNote() { return statusNote; }
    public void setStatusNote(String statusNote) { this.statusNote = statusNote; }

    // Getters/Setters cho thuộc tính mở rộng
    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }

    public String getApprovedByName() { return approvedByName; }
    public void setApprovedByName(String approvedByName) { this.approvedByName = approvedByName; }

    public List<PurchaseOrderDetail> getDetails() { return details; }
    public void setDetails(List<PurchaseOrderDetail> details) { this.details = details; }
}