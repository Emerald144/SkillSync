package com.skillsync.model;
import java.util.ArrayList;
import java.util.List;

public class UserSearchResult {
    private int id;
    private String name;
    private String avatar;
    private String university;
    private int match; // Percentage match
    private double rating;
    private int reputation;
    private String reputationLevel;
    private List<String> teaching; // List of skills they teach
    private List<String> commonInterests;
    private List<String> badges = new ArrayList<>(); // NEW — defaults to empty, never null
    private int skillId;              // NEW
    private boolean requestSent;      // NEW


    // Add standard Getters and Setters for all the fields above
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
 // Alias methods for compatibility
    public int getUserId() { return id; }
    public void setUserId(int userId) { this.id = userId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }
    
    public String getUniversity() { return university; }
    public void setUniversity(String university) { this.university = university; }
    
    public int getMatch() { return match; }
    public void setMatch(int match) { this.match = match; }
    
    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
    
    public int getReputation() { return reputation; }
    public void setReputation(int reputation) { this.reputation = reputation; }
    
    public String getReputationLevel() { return reputationLevel; }
    public void setReputationLevel(String reputationLevel) { this.reputationLevel = reputationLevel; }
    
    public List<String> getTeaching() { return teaching; }
    public void setTeaching(List<String> teaching) { this.teaching = teaching; }
    
    public List<String> getCommonInterests() { return commonInterests; }
    public void setCommonInterests(List<String> commonInterests) { this.commonInterests = commonInterests; }
    
    public List<String> getBadges() { return badges; }         // NEW
    public void setBadges(List<String> badges) { this.badges = badges; } // NEW
    
    public int getSkillId() { return skillId; }                       // NEW
    public void setSkillId(int skillId) { this.skillId = skillId; }   // NEW

    public boolean isRequestSent() { return requestSent; }                    // NEW
    public void setRequestSent(boolean requestSent) { this.requestSent = requestSent; } // NEW
}