package com.group2.bookstore.model;

import java.sql.Date;

public class Review {
    private int reviewId;
    private int userId;
    private int bookId;
    private int rating;
    private String comment;
    private Date createAt;

    // Thuộc tính phụ (để hiển thị tên thay vì số ID)
    private String username;
    private String bookTitle;
    private String email;

    public Review() {
    }

    // Constructor đầy đủ
    public Review(int reviewId, int userId, int bookId, int rating, String comment, Date createAt, String username,
            String bookTitle) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.bookId = bookId;
        this.rating = rating;
        this.comment = comment;
        this.createAt = createAt;
        this.username = username;
        this.bookTitle = bookTitle;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }
}