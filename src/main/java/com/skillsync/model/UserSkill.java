package com.skillsync.model;

public class UserSkill {
    private int userSkillId;
    private int userId;
    private int skillId;
    private String skillType;        // "TEACHING" or "LEARNING"
    private String proficiencyLevel; // "Beginner", "Intermediate", "Advanced", "Expert"

    // Optional JOIN fields for easy display in JSP UI
    private String skillName;
    private String category;

    // Default Constructor
    public UserSkill() {}

    // Constructor for insertion/mapping
    public UserSkill(int userId, int skillId, String skillType, String proficiencyLevel) {
        this.userId = userId;
        this.skillId = skillId;
        this.skillType = skillType;
        this.proficiencyLevel = proficiencyLevel;
    }

    // Getters and Setters
    public int getUserSkillId() {
        return userSkillId;
    }

    public void setUserSkillId(int userSkillId) {
        this.userSkillId = userSkillId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getSkillId() {
        return skillId;
    }

    public void setSkillId(int skillId) {
        this.skillId = skillId;
    }

    public String getSkillType() {
        return skillType;
    }

    public void setSkillType(String skillType) {
        this.skillType = skillType;
    }

    public String getProficiencyLevel() {
        return proficiencyLevel;
    }

    public void setProficiencyLevel(String proficiencyLevel) {
        this.proficiencyLevel = proficiencyLevel;
    }

    public String getSkillName() {
        return skillName;
    }

    public void setSkillName(String skillName) {
        this.skillName = skillName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}