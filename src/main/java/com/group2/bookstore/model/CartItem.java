package com.group2.bookstore.model;

public class CartItem {
    private Book book;      // Chứa thông tin sách (ID, Tên, Giá, Ảnh...)
    private int quantity;   // Số lượng mua

    public CartItem() {
    }

    public CartItem(Book book, int quantity) {
        this.book = book;
        this.quantity = quantity;
    }

    // Hàm tính thành tiền của món này (Giá * Số lượng)
    public double getTotalPrice() {
        return book.getPrice() * quantity;
    }

    public Book getBook() { return book; }
    public void setBook(Book book) { this.book = book; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}