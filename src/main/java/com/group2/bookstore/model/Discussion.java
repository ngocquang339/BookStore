package com.group2.bookstore.model;

import java.util.Date;
import java.util.List; // NHỚ IMPORT THÊM CÁI NÀY NỮA NHÉ

public class Discussion {
    private int discussionId;
    private int bookId;
    private int userId;
    private String discussionTitle;
    private String discussionContent;
    private boolean hasSpoiler;
    private String topicTag;
    private Date createdAt;
    
    // Thuộc tính phụ trợ (Không có trong DB bảng Discussions, dùng để join bảng hiển thị UI)
    private String username; 
    private int replyCount;
    
    // THIẾU CÁI NÀY NÈ: Danh sách chứa các câu trả lời
    private List<DiscussionReply> replies;

    public Discussion() {
    }

    public Discussion(int discussionId, int bookId, int userId, String discussionTitle, String discussionContent, boolean hasSpoiler, String topicTag, Date createdAt) {
        this.discussionId = discussionId;
        this.bookId = bookId;
        this.userId = userId;
        this.discussionTitle = discussionTitle;
        this.discussionContent = discussionContent;
        this.hasSpoiler = hasSpoiler;
        this.topicTag = topicTag;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getDiscussionId() { return discussionId; }
    public void setDiscussionId(int discussionId) { this.discussionId = discussionId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getDiscussionTitle() { return discussionTitle; }
    public void setDiscussionTitle(String discussionTitle) { this.discussionTitle = discussionTitle; }

    public String getDiscussionContent() { return discussionContent; }
    public void setDiscussionContent(String discussionContent) { this.discussionContent = discussionContent; }

    public boolean isHasSpoiler() { return hasSpoiler; }
    // HÀM CHỐNG LỖI CHO TOMCAT NÈ:
    public boolean getHasSpoiler() { return hasSpoiler; } 
    public void setHasSpoiler(boolean hasSpoiler) { this.hasSpoiler = hasSpoiler; }

    public String getTopicTag() { return topicTag; }
    public void setTopicTag(String topicTag) { this.topicTag = topicTag; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public int getReplyCount() { return replyCount; }
    public void setReplyCount(int replyCount) { this.replyCount = replyCount; }

    // GETTER VÀ SETTER CHO DANH SÁCH TRẢ LỜI
    public List<DiscussionReply> getReplies() { return replies; }
    public void setReplies(List<DiscussionReply> replies) { this.replies = replies; }
}