package com.group2.bookstore.model;

import java.sql.Date;

public class Review {
    private int id;
    private int rating;
    private String comment;
    private Date createAt;
    private int userId;
    private int bookId;
    
    // Thuộc tính phụ (để hiển thị tên thay vì số ID)
    private String userName;
    private String bookTitle;

    public Review() {
    }

    public Review(int id, int rating, String comment, Date createAt, int userId, int bookId, String userName, String bookTitle) {
        this.id = id;
        this.rating = rating;
        this.comment = comment;
        this.createAt = createAt;
        this.userId = userId;
        this.bookId = bookId;
        this.userName = userName;
        this.bookTitle = bookTitle;
    }

    // Getter & Setter (Bạn tự generate đủ nhé, tôi viết mẫu vài cái chính)
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    public Date getCreateAt() { return createAt; }
    public void setCreateAt(Date createAt) { this.createAt = createAt; }
    public String getUserName() { return userName; } // Quan trọng để hiện tên khách
    public void setUserName(String userName) { this.userName = userName; }
    public String getBookTitle() { return bookTitle; } // Quan trọng để hiện tên sách
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
}