package com.skillsync.model;

public class Skill {
    private int skillId;
    private String skillName;
    private String category;
    private int learnerCount; // Added field

    public Skill() {}

    public Skill(int skillId, String skillName, String category) {
        this.skillId = skillId;
        this.skillName = skillName;
        this.category = category;
    }

    public Skill(int skillId, String skillName, String category, int learnerCount) {
        this.skillId = skillId;
        this.skillName = skillName;
        this.category = category;
        this.learnerCount = learnerCount;
    }

    public int getSkillId() {
        return skillId;
    }

    public void setSkillId(int skillId) {
        this.skillId = skillId;
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

    public int getLearnerCount() {
        return learnerCount;
    }

    public void setLearnerCount(int learnerCount) {
        this.learnerCount = learnerCount;
    }
}