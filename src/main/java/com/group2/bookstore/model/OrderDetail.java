package com.group2.bookstore.model;

public class OrderDetail {
    private int id;        // detail_id
    private int orderId;   // order_id
    private int bookId;    // book_id
    private int quantity;  
    private double price;  // The price at the moment of purchase
    
    // Helper Object: Stores the full book info (Title, Image) for display
    private Book book; 

    public OrderDetail() {}

    public OrderDetail(int id, int orderId, int bookId, int quantity, double price) {
        this.id = id;
        this.orderId = orderId;
        this.bookId = bookId;
        this.quantity = quantity;
        this.price = price;
    }

    // --- GETTERS & SETTERS ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public Book getBook() { return book; }
    public void setBook(Book book) { this.book = book; }
}