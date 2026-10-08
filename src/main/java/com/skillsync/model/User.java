package com.skillsync.model;

import java.io.Serializable;

/**
 * User Entity Model
 * Maps directly to the `users` database table and stores session data.
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private int userId;
    private String fullName;
    private String email;
    private String password;
    private String profilePhoto;
    private String bio = "";
    private String university;
    private String availability;
    private String role = "User";            // Defaults to 'User'
    private int reputationScore = 0;    // Defaults to 0
    private int tokenBalance = 100;       // Defaults to 100
    private String status = "Active";       // Defaults to 'Active'
    private String learningGoals;
    private int warningCount = 0;         // Defaults to 0 for warning counter

    // 1. Default No-Arg Constructor (Required for JavaBeans/JSON serialization)
    public User() {
    }

    // 2. Registration Constructor (Without Profile Photo)
    public User(String fullName, String email, String password, String university) {
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.university = university;
        this.tokenBalance = 100; // Aligned with SkillSync bonus offer
        this.role = "User";
        this.status = "Active";
        this.warningCount = 0;
    }

    // 3. Full Registration Constructor (With Profile Photo)
    public User(String fullName, String email, String password, String university, String profilePhoto) {
        this(fullName, email, password, university);
        this.profilePhoto = profilePhoto;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getProfilePhoto() { return profilePhoto; }
    public void setProfilePhoto(String profilePhoto) { this.profilePhoto = profilePhoto; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getUniversity() { return university; }
    public void setUniversity(String university) { this.university = university; }
    
    // Availability Getter and Setter
    public String getAvailability() { return availability; }
    public void setAvailability(String availability) { this.availability = availability; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public int getReputationScore() { return reputationScore; }
    public void setReputationScore(int reputationScore) { this.reputationScore = reputationScore; }

    public int getTokenBalance() { return tokenBalance; }
    public void setTokenBalance(int tokenBalance) { this.tokenBalance = tokenBalance; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getLearningGoals() {
        return learningGoals;
    }

    public void setLearningGoals(String learningGoals) {
        this.learningGoals = learningGoals;
    }

    // Warning Count Getter and Setter
    public int getWarningCount() {
        return warningCount;
    }

    public void setWarningCount(int warningCount) {
        this.warningCount = warningCount;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", university='" + university + '\'' +
                ", availability='" + availability + '\'' +
                ", learningGoals='" + learningGoals + '\'' +
                ", role='" + role + '\'' +
                ", tokenBalance=" + tokenBalance +
                ", status='" + status + '\'' +
                ", warningCount=" + warningCount +
                '}';
    }
}