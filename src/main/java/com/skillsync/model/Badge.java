package com.skillsync.model;

public class Badge {
    private int badgeId;
    private String badgeName;
    private String description;
    private String icon;
    private String requirementType;
    private double requirementValue;
    private double currentProgress;

    public Badge() {}

    public Badge(int badgeId, String badgeName, String description, String icon, String requirementType, double requirementValue) {
        this.badgeId = badgeId;
        this.badgeName = badgeName;
        this.description = description;
        this.icon = icon;
        this.requirementType = requirementType;
        this.requirementValue = requirementValue;
    }

    public int getBadgeId() { return badgeId; }
    public void setBadgeId(int badgeId) { this.badgeId = badgeId; }

    public String getBadgeName() { return badgeName; }
    public void setBadgeName(String badgeName) { this.badgeName = badgeName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public String getRequirementType() { return requirementType; }
    public void setRequirementType(String requirementType) { this.requirementType = requirementType; }

    public double getRequirementValue() { return requirementValue; }
    public void setRequirementValue(double requirementValue) { this.requirementValue = requirementValue; }
    
    public double getCurrentProgress() {
        return currentProgress;
    }

    public void setCurrentProgress(double currentProgress) {
        this.currentProgress = currentProgress;
    }
    
    public int getProgressPercentage() {
        if (requirementValue <= 0) return 0;
        int pct = (int) Math.round((currentProgress / requirementValue) * 100);
        return Math.min(pct, 100);
    }

    public String getProgressText() {
        return formatValue(currentProgress) + " / " + formatValue(requirementValue) + " " + formatRequirementLabel();
    }

    private String formatValue(double val) {
        return (val == Math.floor(val)) ? String.valueOf((long) val) : String.valueOf(val);
    }

    private String formatRequirementLabel() {
        if (requirementType == null) return "";
        switch (requirementType.toUpperCase()) {
            case "SESSIONS_COMPLETED": return "sessions";
            case "REPUTATION_SCORE": return "reputation";
            case "TOKENS_EARNED": return "tokens earned";
            case "STREAK_DAYS": return "day streak";
            default: return "";
        }
    }
}