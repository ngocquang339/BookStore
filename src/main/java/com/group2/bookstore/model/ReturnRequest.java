package com.group2.bookstore.model;

import java.util.Date;

public class ReturnRequest {

    // Core Database Fields
    private int returnId;
    private int orderId;
    private int bookId;
    private int quantity;
    private String customerReason;
    private String returnMethod;
    private String refundPreference;
    private int status;
    private String adminNote;
    private Date createdAt;
    private String bankName;

    private String accountNumber;

    private String accountOwner;

    private double maxRefundableAmount;

    // Extra fields for the Admin UI (populated via SQL JOIN)
    private String bookTitle;
    private String customerName;

    // Default Constructor
    public ReturnRequest() {
    }

    // --- Getters and Setters ---
    public int getReturnId() {
        return returnId;
    }

    public void setReturnId(int returnId) {
        this.returnId = returnId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getCustomerReason() {
        return customerReason;
    }

    public void setCustomerReason(String customerReason) {
        this.customerReason = customerReason;
    }

    public String getReturnMethod() {
        return returnMethod;
    }

    public void setReturnMethod(String returnMethod) {
        this.returnMethod = returnMethod;
    }

    public String getRefundPreference() {
        return refundPreference;
    }

    public void setRefundPreference(String refundPreference) {
        this.refundPreference = refundPreference;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getAdminNote() {
        return adminNote;
    }

    public void setAdminNote(String adminNote) {
        this.adminNote = adminNote;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getAccountOwner() {
        return accountOwner;
    }

    public void setAccountOwner(String accountOwner) {
        this.accountOwner = accountOwner;
    }

    public double getMaxRefundableAmount() {
        return maxRefundableAmount;
    }

    public void setMaxRefundableAmount(double maxRefundableAmount) {
        this.maxRefundableAmount = maxRefundableAmount;
    }
    
}
