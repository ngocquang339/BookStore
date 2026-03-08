package com.group2.bookstore.model;

public class ReturnReportDTO {
    private String bookTitle;
    private String author;
    private int returnCount;
    private double totalRefunded;

    // Getters and Setters
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public int getReturnCount() { return returnCount; }
    public void setReturnCount(int returnCount) { this.returnCount = returnCount; }
    public double getTotalRefunded() { return totalRefunded; }
    public void setTotalRefunded(double totalRefunded) { this.totalRefunded = totalRefunded; }
}