package com.skillsync.model;

import java.sql.Timestamp;

public class TokenTransaction {
    private int transactionId;
    private Integer senderId;
    private Integer receiverId;
    private Integer sessionId;
    private int amount;
    private String transactionType;
    private String reason;
    private Timestamp transactionDate;
    private String counterpartyName; // Auxiliary field for displaying who sent/received

    public TokenTransaction() {}

    public int getTransactionId() { return transactionId; }
    public void setTransactionId(int transactionId) { this.transactionId = transactionId; }

    public Integer getSenderId() { return senderId; }
    public void setSenderId(Integer senderId) { this.senderId = senderId; }

    public Integer getReceiverId() { return receiverId; }
    public void setReceiverId(Integer receiverId) { this.receiverId = receiverId; }

    public Integer getSessionId() { return sessionId; }
    public void setSessionId(Integer sessionId) { this.sessionId = sessionId; }

    public int getAmount() { return amount; }
    public void setAmount(int amount) { this.amount = amount; }

    public String getTransactionType() { return transactionType; }
    public void setTransactionType(String transactionType) { this.transactionType = transactionType; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public Timestamp getTransactionDate() { return transactionDate; }
    public void setTransactionDate(Timestamp transactionDate) { this.transactionDate = transactionDate; }

    public String getCounterpartyName() { return counterpartyName; }
    public void setCounterpartyName(String counterpartyName) { this.counterpartyName = counterpartyName; }
}