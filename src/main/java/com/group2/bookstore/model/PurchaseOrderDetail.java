package com.group2.bookstore.model;

public class PurchaseOrderDetail {
    private int poDetailId;
    private int purchaseOrderId;
    private int bookId;
    private int expectedQuantity;
    private int receivedQuantity;
    private double price; // Giá nhập

    // --- CÁC THUỘC TÍNH MỞ RỘNG ĐỂ HIỂN THỊ (JOIN) ---
    // Thay vì lưu rời rạc từng biến title, author... ta lưu nguyên object Book
    private Book book; 

    // 1. Constructor không tham số
    public PurchaseOrderDetail() {
    }

    // 2. Constructor đầy đủ tham số
    public PurchaseOrderDetail(int poDetailId, int purchaseOrderId, int bookId, 
                               int expectedQuantity, int receivedQuantity, double price) {
        this.poDetailId = poDetailId;
        this.purchaseOrderId = purchaseOrderId;
        this.bookId = bookId;
        this.expectedQuantity = expectedQuantity;
        this.receivedQuantity = receivedQuantity;
        this.price = price;
    }

    // 3. Getters và Setters
    public int getPoDetailId() { return poDetailId; }
    public void setPoDetailId(int poDetailId) { this.poDetailId = poDetailId; }

    public int getPurchaseOrderId() { return purchaseOrderId; }
    public void setPurchaseOrderId(int purchaseOrderId) { this.purchaseOrderId = purchaseOrderId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public int getExpectedQuantity() { return expectedQuantity; }
    public void setExpectedQuantity(int expectedQuantity) { this.expectedQuantity = expectedQuantity; }

    public int getReceivedQuantity() { return receivedQuantity; }
    public void setReceivedQuantity(int receivedQuantity) { this.receivedQuantity = receivedQuantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    // Getters/Setters cho thuộc tính mở rộng
    public Book getBook() { return book; }
    public void setBook(Book book) { this.book = book; }
}