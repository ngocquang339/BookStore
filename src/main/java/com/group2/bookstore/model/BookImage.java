package com.group2.bookstore.model;

public class BookImage {
    private int id;
    private int bookId;
    private String imageUrl;

    public BookImage() {}
    
    public BookImage(int id, int bookId, String imageUrl) {
        this.id = id;
        this.bookId = bookId;
        this.imageUrl = imageUrl;
    }
    public int getId(){return id;}
    public void setId(int id) { this.id= id; }

    public int getBookId(){return bookId;}
    public void setBookId(int bookId) { this.bookId= bookId; }
    
    public void setImageUrl(String bookImageUrl) { this.imageUrl = bookImageUrl; }
    public String getImageUrrl() { return imageUrl; }
}