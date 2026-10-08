package com.skillsync.model;

public class PendingReview {
    private int sessionId;
    private String skillName;
    private String revieweeName;
    private int revieweeId;

    public PendingReview() {}

    public PendingReview(int sessionId, String skillName, String revieweeName, int revieweeId) {
        this.sessionId = sessionId;
        this.skillName = skillName;
        this.revieweeName = revieweeName;
        this.revieweeId = revieweeId;
    }

    public int getSessionId() {
        return sessionId;
    }

    public void setSessionId(int sessionId) {
        this.sessionId = sessionId;
    }

    public String getSkillName() {
        return skillName;
    }

    public void setSkillName(String skillName) {
        this.skillName = skillName;
    }

    public String getRevieweeName() {
        return revieweeName;
    }

    public void setRevieweeName(String revieweeName) {
        this.revieweeName = revieweeName;
    }

    public int getRevieweeId() {
        return revieweeId;
    }

    public void setRevieweeId(int revieweeId) {
        this.revieweeId = revieweeId;
    }
}