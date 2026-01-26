package com.group2.bookstore.model;

import java.io.Serializable;

public class Book implements Serializable {
    
    // Core Fields (Matches Database Columns)
    private int id;
    private String title;
    private String author;
    private double price;
    private String description;
    private String image;       // Standardized to 'image' (was conflicting with imageUrl)
    private int stockQuantity;
    private int soldQuantity;
    private String publisher;
    private String isbn;
    private int categoryId;
    
    // NEW FIELDS for Admin Features
    private boolean active;       // Maps to [is_active]
    private double importPrice;   // Maps to [import_price]

    // 1. Empty Constructor (Required for JSP/Frameworks)
    public Book() {
    }

    // 2. Full Constructor (Updated to match fields)
    public Book(int id, String title, String author, double price, int stockQuantity, String image, int categoryId, String description) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.image = image;
        this.categoryId = categoryId;
        this.description = description;
    }

    // --- GETTERS & SETTERS ---

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    // Unified Image Getter/Setter
    // public String getImage() { return image; }
    // public void setImage(String image) { this.image = image; }
    
    // Compatibility: If teammate's code calls getImageUrl, redirect it to getImage
    public String getImageUrl() { return image; }
    public void setImageUrl(String image) { this.image = image; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public int getSoldQuantity() { return soldQuantity; }
    public void setSoldQuantity(int soldQuantity) { this.soldQuantity = soldQuantity; }

    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    // Admin Feature Getters/Setters
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public double getImportPrice() { return importPrice; }
    public void setImportPrice(double importPrice) { this.importPrice = importPrice; }
}