package com.group2.bookstore.model;
import java.util.Date;

public class DiscussionReply {
    private int replyId;
    private int discussionId;
    private int userId;
    private String replyContent;
    private Date createdAt;
    
    // Thuộc tính phụ trợ lấy từ bảng Users
    private String username;

    public DiscussionReply() {}

    public int getReplyId() { return replyId; }
    public void setReplyId(int replyId) { this.replyId = replyId; }

    public int getDiscussionId() { return discussionId; }
    public void setDiscussionId(int discussionId) { this.discussionId = discussionId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getReplyContent() { return replyContent; }
    public void setReplyContent(String replyContent) { this.replyContent = replyContent; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
}