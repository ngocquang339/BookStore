package com.group2.bookstore.model;

import java.sql.Timestamp;

public class Voucher {
    private int id;
    private String code;
    private double discountAmount;
    private int discountPercent;
    private double minOrderValue;
    private Timestamp startDate;
    private Timestamp endDate;
    private int usageLimit;
    private int status;
    private Double maxDiscount;

    // Constructors
    public Voucher() {
    }

    public Voucher(int id, String code, double discountAmount, int discountPercent, double minOrderValue, Timestamp startDate, Timestamp endDate, int usageLimit, int status) {
        this.id = id;
        this.code = code;
        this.discountAmount = discountAmount;
        this.discountPercent = discountPercent;
        this.minOrderValue = minOrderValue;
        this.startDate = startDate;
        this.endDate = endDate;
        this.usageLimit = usageLimit;
        this.status = status;
    }

    // Getters and Setters (Bạn dùng Alt + Insert hoặc Source -> Generate Getters and Setters để tạo nhanh nhé)
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    
    public double getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(double discountAmount) { this.discountAmount = discountAmount; }
    
    public int getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(int discountPercent) { this.discountPercent = discountPercent; }
    
    public double getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(double minOrderValue) { this.minOrderValue = minOrderValue; }
    
    public Timestamp getStartDate() { return startDate; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }
    
    public Timestamp getEndDate() { return endDate; }
    public void setEndDate(Timestamp endDate) { this.endDate = endDate; }
    
    public int getUsageLimit() { return usageLimit; }
    public void setUsageLimit(int usageLimit) { this.usageLimit = usageLimit; }
    
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    public Double getMaxDiscount() { return maxDiscount; }
    public void setMaxDiscount(Double maxDiscount) { this.maxDiscount = maxDiscount; }
}