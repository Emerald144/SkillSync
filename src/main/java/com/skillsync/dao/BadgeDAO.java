package com.skillsync.dao;

import com.skillsync.model.Badge;
import com.skillsync.model.UserBadge;
import com.skillsync.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class BadgeDAO {

    public List<Badge> getAllBadges() {
        List<Badge> list = new ArrayList<>();
        String sql = "SELECT * FROM Badges ORDER BY badge_id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Badge(
                    rs.getInt("badge_id"),
                    rs.getString("badge_name"),
                    rs.getString("description"),
                    rs.getString("icon"),
                    rs.getString("requirement_type"),
                    rs.getDouble("requirement_value")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<UserBadge> getUserBadges(int userId) {
        List<UserBadge> list = new ArrayList<>();
        String sql = "SELECT ub.*, b.badge_name, b.description, b.icon " +
                     "FROM User_Badges ub " +
                     "JOIN Badges b ON ub.badge_id = b.badge_id " +
                     "WHERE ub.user_id = ? ORDER BY ub.earned_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserBadge ub = new UserBadge();
                    ub.setUserBadgeId(rs.getInt("user_badge_id"));
                    ub.setUserId(rs.getInt("user_id"));
                    ub.setBadgeId(rs.getInt("badge_id"));
                    ub.setBadgeName(rs.getString("badge_name"));
                    ub.setDescription(rs.getString("description"));
                    ub.setIcon(rs.getString("icon"));
                    ub.setEarnedAt(rs.getTimestamp("earned_at"));
                    list.add(ub);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Set<Integer> getEarnedBadgeIds(int userId) {
        Set<Integer> earnedBadgeIds = new HashSet<>();
        String sql = "SELECT badge_id FROM User_Badges WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    earnedBadgeIds.add(rs.getInt("badge_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return earnedBadgeIds;
    }

    public boolean hasBadge(int userId, int badgeId) {
        String sql = "SELECT 1 FROM User_Badges WHERE user_id = ? AND badge_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, badgeId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean awardBadge(int userId, int badgeId) {
        String sql = "INSERT IGNORE INTO User_Badges (user_id, badge_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, badgeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Badge getBadgeByName(String badgeName) {
        String sql = "SELECT * FROM Badges WHERE badge_name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, badgeName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Badge(
                        rs.getInt("badge_id"),
                        rs.getString("badge_name"),
                        rs.getString("description"),
                        rs.getString("icon"),
                        rs.getString("requirement_type"),
                        rs.getDouble("requirement_value")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
 // Add these methods inside your BadgeDAO class:

    public UserBadge getLatestBadgeForUser(int userId) {
        List<UserBadge> userBadges = getUserBadges(userId);
        if (userBadges != null && !userBadges.isEmpty()) {
            return userBadges.get(0); // getUserBadges is already ordered by earned_at DESC
        }
        return null;
    }

    public int getUnlockedBadgeCount(int userId) {
        String sql = "SELECT COUNT(*) FROM User_Badges WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalBadgeCount() {
        String sql = "SELECT COUNT(*) FROM Badges";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}