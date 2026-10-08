package com.skillsync.model;

import java.sql.Timestamp;

public class Message {
    private int messageId;
    private int senderId;
    private int receiverId;
    private String message;
    private Timestamp sentAt;

    public Message() {}

    public Message(int messageId, int senderId, int receiverId, String message, Timestamp sentAt) {
        this.messageId = messageId;
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.message = message;
        this.sentAt = sentAt;
    }

    public int getMessageId() { return messageId; }
    public void setMessageId(int messageId) { this.messageId = messageId; }

    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }

    public int getReceiverId() { return receiverId; }
    public void setReceiverId(int receiverId) { this.receiverId = receiverId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Timestamp getSentAt() { return sentAt; }
    public void setSentAt(Timestamp sentAt) { this.sentAt = sentAt; }
}