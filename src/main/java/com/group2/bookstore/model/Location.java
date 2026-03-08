package com.group2.bookstore.model;

public class Location {
    private int id;
    private String zone;
    private String rack;
    private String shelf;
    private String locationCode; // Mã tự gen từ DB (A-01-01)
    private int categoryId;
    private String categoryName; // Lấy thêm tên thể loại để hiển thị cho đẹp
    private String description;

    public Location() {}

    public Location(int id, String zone, String rack, String shelf, String locationCode, int categoryId, String categoryName, String description) {
        this.id = id;
        this.zone = zone;
        this.rack = rack;
        this.shelf = shelf;
        this.locationCode = locationCode;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = description;
    }

    // Getters và Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getZone() { return zone; }
    public void setZone(String zone) { this.zone = zone; }

    public String getRack() { return rack; }
    public void setRack(String rack) { this.rack = rack; }

    public String getShelf() { return shelf; }
    public void setShelf(String shelf) { this.shelf = shelf; }

    public String getLocationCode() { return locationCode; }
    public void setLocationCode(String locationCode) { this.locationCode = locationCode; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}