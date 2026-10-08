package com.skillsync.model;

import java.sql.Timestamp;

public class LearningRequest {
    private int requestId;
    private int senderId;
    private int receiverId;
    private int skillId;
    private String status; // 'Pending', 'Accepted', 'Rejected', 'Cancelled'
    private Timestamp requestDate;

    // Additional fields populated via SQL JOINs for UI rendering
    private String senderName;
    private String skillName;
    
    private String otherUserPhoto;
    private int otherUserId;

    // Step 2 Addition: Session state tracking field
    // null = no session yet; otherwise 'Scheduled', 'In Progress', 'Completed', etc.
    private String sessionStatus;

    public LearningRequest() {}

    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }

    public int getReceiverId() { return receiverId; }
    public void setReceiverId(int receiverId) { this.receiverId = receiverId; }

    public int getSkillId() { return skillId; }
    public void setSkillId(int skillId) { this.skillId = skillId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getRequestDate() { return requestDate; }
    public void setRequestDate(Timestamp requestDate) { this.requestDate = requestDate; }

    public String getSenderName() { return senderName; }
    public void setSenderName(String senderName) { this.senderName = senderName; }

    public String getSkillName() { return skillName; }
    public void setSkillName(String skillName) { this.skillName = skillName; }
    
    // Getters and Setters for other user info
    public String getOtherUserPhoto() { 
        return otherUserPhoto; 
    }

    public void setOtherUserPhoto(String otherUserPhoto) { 
        this.otherUserPhoto = otherUserPhoto; 
    }

    public int getOtherUserId() { 
        return otherUserId; 
    }

    public void setOtherUserId(int otherUserId) { 
        this.otherUserId = otherUserId; 
    }

    // Step 2 Getters and Setters for sessionStatus
    public String getSessionStatus() { 
        return sessionStatus; 
    }

    public void setSessionStatus(String sessionStatus) { 
        this.sessionStatus = sessionStatus; 
    }

    // Convenience getters for JSP Expression Language (${req.hasSession}, ${req.sessionCompleted})
    public boolean isHasSession() { 
        return sessionStatus != null; 
    }

    public boolean isSessionCompleted() { 
        return "Completed".equalsIgnoreCase(sessionStatus); 
    }

    // Helper for avatar initials in JSP
    public String getInitials() {
        if (senderName == null || senderName.trim().isEmpty()) return "U";
        String[] parts = senderName.trim().split("\\s+");
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < Math.min(2, parts.length); i++) {
            if (!parts[i].isEmpty()) sb.append(Character.toUpperCase(parts[i].charAt(0)));
        }
        return sb.length() > 0 ? sb.toString() : "U";
    }

    public String getRequesterName() {
        return senderName;
    }

    public java.sql.Timestamp getRequestedTime() {
        return requestDate;
    }

    public String getNote() {
        return null;
    }

    public int getTokenAmount() {
        return 0;
    }
}