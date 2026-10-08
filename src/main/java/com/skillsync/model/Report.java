package com.skillsync.model;

import java.sql.Timestamp;

public class Report {
    private int reportId;
    private int reporterId;
    private int reportedUserId;
    private String reason;
    private String description;
    private String status;
    private String adminNote;
    private Timestamp createdAt;
    private Timestamp resolvedAt;

    // Joins မှ ရယူမည့် Extra Display Fields
    private String reporterName;
    private String reportedUserName;

    public Report() {}

    // Getters and Setters
    public int getReportId() { return reportId; }
    public void setReportId(int reportId) { this.reportId = reportId; }

    public int getReporterId() { return reporterId; }
    public void setReporterId(int reporterId) { this.reporterId = reporterId; }

    public int getReportedUserId() { return reportedUserId; }
    public void setReportedUserId(int reportedUserId) { this.reportedUserId = reportedUserId; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAdminNote() { return adminNote; }
    public void setAdminNote(String adminNote) { this.adminNote = adminNote; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(Timestamp resolvedAt) { this.resolvedAt = resolvedAt; }

    public String getReporterName() { return reporterName; }
    public void setReporterName(String reporterName) { this.reporterName = reporterName; }

    public String getReportedUserName() { return reportedUserName; }
    public void setReportedUserName(String reportedUserName) { this.reportedUserName = reportedUserName; }
}