package com.group2.bookstore.model;

import java.sql.Timestamp;

public class UserVoucher {
    private int userId;
    private int voucherId;
    private boolean isUsed;
    private Timestamp savedDate;
    
    // Chứa luôn thông tin của Voucher đó để dễ hiển thị ra JSP
    private Voucher voucher; 

    public UserVoucher() {
    }

    public UserVoucher(int userId, int voucherId, boolean isUsed, Timestamp savedDate, Voucher voucher) {
        this.userId = userId;
        this.voucherId = voucherId;
        this.isUsed = isUsed;
        this.savedDate = savedDate;
        this.voucher = voucher;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getVoucherId() { return voucherId; }
    public void setVoucherId(int voucherId) { this.voucherId = voucherId; }

    public boolean isUsed() { return isUsed; }
    public void setUsed(boolean used) { isUsed = used; }

    public Timestamp getSavedDate() { return savedDate; }
    public void setSavedDate(Timestamp savedDate) { this.savedDate = savedDate; }

    public Voucher getVoucher() { return voucher; }
    public void setVoucher(Voucher voucher) { this.voucher = voucher; }
}