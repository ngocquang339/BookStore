package com.group2.bookstore.model;

public class Book {
import java.io.Serializable;

public class Book implements Serializable {
    
    private int id;
    private String title;
    private String author;
    private double price;
    private String description;
    private String image;
    private int stockQuantity;
    private int soldQuantity;
    private String publisher;
    private String isbn;
    private int categoryId;
    
    // NEW FIELDS for Admin Features
    private boolean active;       // Maps to [is_active]
    private double importPrice;   // Maps to [import_price]

    public Book() {
    }

    // Getters and Setters
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

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

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

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public double getImportPrice() { return importPrice; }
    public void setImportPrice(double importPrice) { this.importPrice = importPrice; }
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