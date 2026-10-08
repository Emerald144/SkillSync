package com.skillsync.model;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class UserBadge {
    private int userBadgeId;
    private int userId;
    private int badgeId;
    private String badgeName;
    private String description;
    private String icon;
    private Timestamp earnedAt;

    public int getUserBadgeId() { return userBadgeId; }
    public void setUserBadgeId(int userBadgeId) { this.userBadgeId = userBadgeId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getBadgeId() { return badgeId; }
    public void setBadgeId(int badgeId) { this.badgeId = badgeId; }

    public String getBadgeName() { return badgeName; }
    public void setBadgeName(String badgeName) { this.badgeName = badgeName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public Timestamp getEarnedAt() { return earnedAt; }
    public void setEarnedAt(Timestamp earnedAt) { this.earnedAt = earnedAt; }

    // =========================================================================
    // JSP Alias & Formatter Getters (PropertyNotFoundException Solutions)
    // =========================================================================

    /**
     * Formats earnedAt timestamp into a readable date string for JSP ${latestBadge.formattedEarnedDate}
     */
    public String getFormattedEarnedDate() {
        if (this.earnedAt != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
            return sdf.format(this.earnedAt);
        }
        return "";
    }

    /**
     * Alias for earnedAt to support ${ub.earnedDate} in JSP
     */
    public Timestamp getEarnedDate() { 
        return this.earnedAt; 
    }

    /**
     * Alias for JSP expecting ${ub.iconSvg}.
     * Returns null so <c:when test="${not empty ub.iconSvg}"> safely falls back 
     * to the default icon in JSP.
     */
    public String getIconSvg() { 
        return null; 
    }

    /**
     * Alias for JSP expecting ${ub.tierClass}.
     * Returns null so ternary expression falls back to 'tier-gold'.
     */
    public String getTierClass() { 
        return null; 
    }
}