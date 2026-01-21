package com.group2.bookstore.model;

import java.io.Serializable;

public class Book implements Serializable {
    
    private int id;
    private String title;
    private String author;
    private double price;
    private int stockQuantity; // Map với cột 'stock_quantity' trong DB
    private String imageUrl;   // Map với cột 'image' trong DB
    private int categoryId;    // Map với cột 'category_id' trong DB
    private String description;

    // Constructor rỗng (Bắt buộc phải có để JSP không lỗi khi khởi tạo mặc định)
    public Book() {
    }

    // Constructor đầy đủ (Dùng cho DAO khi load dữ liệu từ DB lên)
    public Book(int id, String title, String author, double price, int stockQuantity, String imageUrl, int categoryId, String description) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl;
        this.categoryId = categoryId;
        this.description = description;
    }

    // --- GETTER & SETTER ---
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}