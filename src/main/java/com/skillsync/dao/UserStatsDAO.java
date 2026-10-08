package com.skillsync.dao;

import com.skillsync.model.UserStats;
import com.skillsync.util.DBConnection; 

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserStatsDAO {

    public UserStats getUserStats(int userId) {
        UserStats stats = new UserStats();
        
        // 1. Reputation score မှတ်တမ်းယူခြင်း
        String userSql = "SELECT reputation_score FROM users WHERE user_id = ?";
        // 2. ပြီးစီးသွားသော Session အရေအတွက် ယူခြင်း
        String sessionSql = "SELECT COUNT(*) FROM sessions WHERE (mentor_id = ? OR mentee_id = ?) AND status = 'COMPLETED'";
        // 3. Average Rating ယူခြင်း
        String reviewSql = "SELECT AVG(rating) FROM reviews WHERE reviewee_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            // User Reputation
            try (PreparedStatement ps = conn.prepareStatement(userSql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) stats.setReputationScore(rs.getInt("reputation_score"));
            }

            // Completed Sessions
            try (PreparedStatement ps = conn.prepareStatement(sessionSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) stats.setSessionsCompleted(rs.getInt(1));
            }

            // Average Rating
            try (PreparedStatement ps = conn.prepareStatement(reviewSql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    double avg = rs.getDouble(1);
                    stats.setAverageRating(Math.round(avg * 10.0) / 10.0); // 1 decimal place
                }
            }
            
            // Streak Days (သီးသန့် logic မရှိပါက Default သို့မဟုတ် DB အတိုင်းထားနိုင်သည်)
            stats.setStreakDays(0); 

        } catch (Exception e) {
            e.printStackTrace();
        }

        return stats;
    }
}