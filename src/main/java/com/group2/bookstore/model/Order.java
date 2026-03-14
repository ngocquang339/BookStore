package com.group2.bookstore.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order {

    private int id;
    private int voucher_id; 
    private BigDecimal discount_amount = BigDecimal.ZERO;
    private int userId;
    private Timestamp orderDate; // Use Timestamp for exact date & time
    private double totalAmount;
    private int status;          // 1=Pending, 2=Shipping, etc.
    private String shippingAddress;
    private String phoneNumber;
    private String paymentMethod;
    private String statusNote;
    private String staffNote;

    // Optional: Helper field to show User's name in Admin Panel
    private String userName;
    private List<OrderDetail> details = new ArrayList<>();

    public Order() {
    }

    public Order(int id, int userId, Timestamp orderDate, double totalAmount, int status, String shippingAddress, String phoneNumber) {
        this.id = id;
        this.userId = userId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.shippingAddress = shippingAddress;
        this.phoneNumber = phoneNumber;
    }

    // --- GETTERS AND SETTERS ---
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getVoucher_id() { 
        return voucher_id; 
    }

    public void setVoucher_id(int voucher_id) { 
        this.voucher_id = voucher_id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public List<OrderDetail> getDetails() {
        return details;
    }

    public void setDetails(List<OrderDetail> details) {
        this.details = details;
    }

    public BigDecimal getDiscountAmount() {
        return discount_amount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discount_amount = discountAmount;
    }

    public String getStatusNote() {
        return statusNote;
    }

    public void setStatusNote(String statusNote) {
        this.statusNote = statusNote;
    }
    public String getStaffNote() {
    return staffNote;
}
public void setStaffNote(String staffNote) {
    this.staffNote = staffNote;
}
}