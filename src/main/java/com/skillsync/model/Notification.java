package com.skillsync.model;

import java.sql.Timestamp;
import java.time.Duration;
import java.time.LocalDateTime;

public class Notification {
    private int notificationId;
    private int userId;
    private String type;
    private String title;
    private String message;
    private Integer relatedId; // Added field
    private boolean isRead;
    private Timestamp createdAt;

    public Notification() {}

    public int getNotificationId() { return notificationId; }
    public void setNotificationId(int notificationId) { this.notificationId = notificationId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Integer getRelatedId() { return relatedId; }
    public void setRelatedId(Integer relatedId) { this.relatedId = relatedId; } // Added setter

    public boolean isRead() { return isRead; }
    public void setRead(boolean isRead) { this.isRead = isRead; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    // JSP EL Mappings & Helper Methods
    public String getBody() { return message; }

    public boolean isUnread() { return !isRead; }

    public String getTime() {
        if (createdAt == null) return "";
        Duration diff = Duration.between(createdAt.toLocalDateTime(), LocalDateTime.now());
        long seconds = diff.getSeconds();
        if (seconds < 60) return "just now";
        long minutes = seconds / 60;
        if (minutes < 60) return minutes + "m ago";
        long hours = minutes / 60;
        if (hours < 24) return hours + "h ago";
        long days = hours / 24;
        return days + "d ago";
    }
}