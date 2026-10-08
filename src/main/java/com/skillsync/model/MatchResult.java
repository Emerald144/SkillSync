package com.skillsync.model;

import java.util.ArrayList;
import java.util.List;

public class MatchResult {
    private int userId;
    private String fullName;
    private String university;
    private String profilePhoto;
    private double rating;
    
    
    // Sub-scores (0 - 100)
    private double skillScore;
    private double availabilityScore;
    private double goalScore;
    private double interestScore;
    private double reputationScore;
    private double matchScore; // Weighted final score

    private List<String> matchedSkills = new ArrayList<>();
    private List<String> explanations = new ArrayList<>();
    
    private int skillId; // NEW
    private boolean requestSent;

    // Constructors
    public MatchResult() {}

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getUniversity() { return university; }
    public void setUniversity(String university) { this.university = university; }

    public String getProfilePhoto() { return profilePhoto; }
    public void setProfilePhoto(String profilePhoto) { this.profilePhoto = profilePhoto; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public double getSkillScore() { return skillScore; }
    public void setSkillScore(double skillScore) { this.skillScore = skillScore; }

    public double getAvailabilityScore() { return availabilityScore; }
    public void setAvailabilityScore(double availabilityScore) { this.availabilityScore = availabilityScore; }

    public double getGoalScore() { return goalScore; }
    public void setGoalScore(double goalScore) { this.goalScore = goalScore; }

    public double getInterestScore() { return interestScore; }
    public void setInterestScore(double interestScore) { this.interestScore = interestScore; }

    public double getReputationScore() { return reputationScore; }
    public void setReputationScore(double reputationScore) { this.reputationScore = reputationScore; }

    public double getMatchScore() { return matchScore; }
    public void setMatchScore(double matchScore) { this.matchScore = matchScore; }

    public List<String> getMatchedSkills() { return matchedSkills; }
    public void setMatchedSkills(List<String> matchedSkills) { this.matchedSkills = matchedSkills; }

    public List<String> getExplanations() { return explanations; }
    public void setExplanations(List<String> explanations) { this.explanations = explanations; }
    
    public int getSkillId() { return skillId; }              // NEW
    public void setSkillId(int skillId) { this.skillId = skillId; } // NEW
    
    public boolean isRequestSent() { return requestSent; }
    public void setRequestSent(boolean requestSent) { this.requestSent = requestSent; }
    
 // Add to MatchResult.java
    public long getMatchScoreRounded() {
        return Math.round(matchScore);
    }

    public long getReputationDisplay() {
        return Math.round(reputationScore * 8);
    }
}