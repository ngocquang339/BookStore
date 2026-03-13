package com.group2.bookstore.model;

import java.util.Date;

public class SupportTicket {
    private int ticketId;
    private int userId;
    private String issueType;
    private String ticketSubject;
    private String ticketMessage;
    private String status;
    private String adminReply;
    private Date createdAt;

    // Constructors
    public SupportTicket() {
    }

    public SupportTicket(int ticketId, int userId, String issueType, String ticketSubject, 
                         String ticketMessage, String status, String adminReply, Date createdAt) {
        this.ticketId = ticketId;
        this.userId = userId;
        this.issueType = issueType;
        this.ticketSubject = ticketSubject;
        this.ticketMessage = ticketMessage;
        this.status = status;
        this.adminReply = adminReply;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getTicketId() { return ticketId; }
    public void setTicketId(int ticketId) { this.ticketId = ticketId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getIssueType() { return issueType; }
    public void setIssueType(String issueType) { this.issueType = issueType; }

    public String getTicketSubject() { return ticketSubject; }
    public void setTicketSubject(String ticketSubject) { this.ticketSubject = ticketSubject; }

    public String getTicketMessage() { return ticketMessage; }
    public void setTicketMessage(String ticketMessage) { this.ticketMessage = ticketMessage; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAdminReply() { return adminReply; }
    public void setAdminReply(String adminReply) { this.adminReply = adminReply; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}