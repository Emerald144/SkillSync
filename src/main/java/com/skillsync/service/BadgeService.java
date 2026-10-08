package com.skillsync.service;

import com.skillsync.dao.BadgeDAO;
import com.skillsync.dao.NotificationDAO;
import com.skillsync.model.Badge;
import com.skillsync.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class BadgeService {

    private final BadgeDAO badgeDAO = new BadgeDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    public void checkBadges(int userId) {
        checkFirstStep(userId);
        checkConsistentLearner(userId);
        checkKnowledgeSharer(userId);
        checkRisingMentor(userId);
        checkTopMentor(userId);
        checkSkillConnector(userId);
    }

    private void tryAwardBadge(int userId, String badgeName, boolean conditionMet) {
        if (!conditionMet) return;
        Badge badge = badgeDAO.getBadgeByName(badgeName);
        if (badge != null && !badgeDAO.hasBadge(userId, badge.getBadgeId())) {
            boolean awarded = badgeDAO.awardBadge(userId, badge.getBadgeId());
            if (awarded) {
                String iconStr = (badge.getIcon() != null) ? " " + badge.getIcon() : "";
                
                // ✅ NotificationDAO ရဲ့ 4-parameter method နဲ့ ကိုက်ညီအောင် ပြင်ဆင်ထားပါသည်
                notificationDAO.createNotification(
                    userId,
                    "BADGE",
                    "New Badge Unlocked!",
                    "You earned the " + badge.getBadgeName() + " badge" + iconStr
                );
            }
        }
    }

    private void checkFirstStep(int userId) {
        String sql = "SELECT COUNT(*) FROM sessions WHERE LOWER(status) = 'completed' AND (learner_id = ? OR teacher_id = ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) >= 1) {
                    tryAwardBadge(userId, "First Step", true);
                }
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    private void checkConsistentLearner(int userId) {
        String sql = "SELECT COUNT(*) FROM sessions WHERE LOWER(status) = 'completed' AND learner_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) >= 5) {
                    tryAwardBadge(userId, "Consistent Learner", true);
                }
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    private void checkKnowledgeSharer(int userId) {
        String sql = "SELECT COUNT(*) FROM sessions WHERE LOWER(status) = 'completed' AND teacher_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) >= 5) {
                    tryAwardBadge(userId, "Knowledge Sharer", true);
                }
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    private void checkRisingMentor(int userId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE reviewee_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) >= 5) {
                    tryAwardBadge(userId, "Rising Mentor", true);
                }
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    private void checkTopMentor(int userId) {
        String sql = "SELECT COUNT(*), AVG(rating) FROM reviews WHERE reviewee_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    double avg = rs.getDouble(2);
                    if (count >= 5 && avg >= 4.5) {
                        tryAwardBadge(userId, "Top Mentor", true);
                    }
                }
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    private void checkSkillConnector(int userId) {
        // ✅ Double counting မဖြစ်စေရန် learner_id = ? တစ်ခုတည်းဖြင့် စစ်ဆေးထားပါသည်
        String sql = "SELECT COUNT(*) FROM sessions s1 " +
                     "JOIN sessions s2 ON s1.learner_id = s2.teacher_id AND s1.teacher_id = s2.learner_id " +
                     "WHERE LOWER(s1.status) = 'completed' AND LOWER(s2.status) = 'completed' " +
                     "AND s1.learner_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) >= 1) {
                    tryAwardBadge(userId, "Skill Connector", true);
                }
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }
}