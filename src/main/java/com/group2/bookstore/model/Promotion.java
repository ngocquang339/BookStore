package com.group2.bookstore.model;

import java.sql.Timestamp;

public class Promotion {
    private int promoId;
    private String promoName;
    private int discountPercent;
    private Timestamp startDate;
    private Timestamp endDate;
    private boolean isActive;

    // Constructor rỗng
    public Promotion() {
    }

    // Constructor đầy đủ
    public Promotion(int promoId, String promoName, int discountPercent, Timestamp startDate, Timestamp endDate, boolean isActive) {
        this.promoId = promoId;
        this.promoName = promoName;
        this.discountPercent = discountPercent;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = isActive;
    }

    // --- GETTER & SETTER ---
    public int getPromoId() { return promoId; }
    public void setPromoId(int promoId) { this.promoId = promoId; }

    public String getPromoName() { return promoName; }
    public void setPromoName(String promoName) { this.promoName = promoName; }

    public int getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(int discountPercent) { this.discountPercent = discountPercent; }

    public Timestamp getStartDate() { return startDate; }
    public void setStartDate(Timestamp startDate) { this.startDate = startDate; }

    public Timestamp getEndDate() { return endDate; }
    public void setEndDate(Timestamp endDate) { this.endDate = endDate; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}