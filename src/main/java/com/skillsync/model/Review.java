package com.skillsync.model;

import java.sql.Timestamp;

public class Review {
    private int reviewId;
    private int sessionId;
    private int reviewerId;
    private int revieweeId;
    private int rating;
    private String comment;
    private Timestamp reviewDate;

    // Display fields for UI rendering
    private String reviewerName;
    private String revieweeName;
    private String reviewerPhoto; // NEW: Added missing photo property
    private String skillName;

    public Review() {}

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public int getSessionId() { return sessionId; }
    public void setSessionId(int sessionId) { this.sessionId = sessionId; }

    public int getReviewerId() { return reviewerId; }
    public void setReviewerId(int reviewerId) { this.reviewerId = reviewerId; }

    public int getRevieweeId() { return revieweeId; }
    public void setRevieweeId(int revieweeId) { this.revieweeId = revieweeId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Timestamp getReviewDate() { return reviewDate; }
    public void setReviewDate(Timestamp reviewDate) { this.reviewDate = reviewDate; }

    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }

    public String getRevieweeName() { return revieweeName; }
    public void setRevieweeName(String revieweeName) { this.revieweeName = revieweeName; }

    // NEW: Getter and Setter for reviewerPhoto
    public String getReviewerPhoto() { return reviewerPhoto; }
    public void setReviewerPhoto(String reviewerPhoto) { this.reviewerPhoto = reviewerPhoto; }

    public String getSkillName() { return skillName; }
    public void setSkillName(String skillName) { this.skillName = skillName; }
}