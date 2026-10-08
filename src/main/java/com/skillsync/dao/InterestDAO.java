package com.skillsync.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.skillsync.model.Interest;
import com.skillsync.util.DBConnection;

public class InterestDAO {

    /**
     * Fetches all interests associated with a specific user.
     */
    public List<Interest> getInterestsByUserId(int userId) throws SQLException {
        List<Interest> interests = new ArrayList<>();
        String sql = "SELECT i.interest_id, i.interest_name FROM interests i " +
                     "JOIN user_interests ui ON i.interest_id = ui.interest_id " +
                     "WHERE ui.user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    interests.add(new Interest(rs.getInt("interest_id"), rs.getString("interest_name")));
                }
            }
        }
        return interests;
    }
    
    
    /**
     * Fetches a list of interest IDs for a user (used by JSTL editProfile.jsp).
     */
    public List<Integer> getInterestIdsByUserId(int userId) throws SQLException {
        List<Integer> interestIds = new ArrayList<>();
        String sql = "SELECT interest_id FROM user_interests WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    interestIds.add(rs.getInt("interest_id"));
                }
            }
        }
        return interestIds;
    }

    /**
     * Finds shared interest names between two users (e.g., logged-in user vs target user).
     */
    public List<String> getCommonInterests(int userId1, int userId2) throws SQLException {
        List<String> common = new ArrayList<>();
        String sql = "SELECT i.interest_name FROM user_interests ui1 " +
                     "JOIN user_interests ui2 ON ui1.interest_id = ui2.interest_id " +
                     "JOIN interests i ON ui1.interest_id = i.interest_id " +
                     "WHERE ui1.user_id = ? AND ui2.user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId1);
            ps.setInt(2, userId2);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    common.add(rs.getString("interest_name"));
                }
            }
        }
        return common;
    }

    /**
     * Fetches all master interests from the database for display in profile forms.
     */
    public List<Interest> getAllInterests() throws SQLException {
        List<Interest> list = new ArrayList<>();
        String sql = "SELECT interest_id, interest_name FROM interests ORDER BY interest_name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Interest(rs.getInt("interest_id"), rs.getString("interest_name")));
            }
        }
        return list;
    }
    
    /**
     * Replaces existing user interests using List<Integer> (called by UpdateProfileServlet).
     */
    public void replaceUserInterests(int userId, List<Integer> interestIds) throws SQLException {
        String deleteSql = "DELETE FROM user_interests WHERE user_id = ?";
        String insertSql = "INSERT INTO user_interests (user_id, interest_id) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement deletePs = conn.prepareStatement(deleteSql)) {
                deletePs.setInt(1, userId);
                deletePs.executeUpdate();
            }

            if (interestIds != null && !interestIds.isEmpty()) {
                try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    for (Integer interestId : interestIds) {
                        insertPs.setInt(1, userId);
                        insertPs.setInt(2, interestId);
                        insertPs.addBatch();
                    }
                    insertPs.executeBatch();
                }
            }

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    /**
     * Replaces existing user interests using String[].
     */
    public void updateUserInterests(int userId, String[] interestIds) throws SQLException {
        List<Integer> list = new ArrayList<>();
        if (interestIds != null) {
            for (String idStr : interestIds) {
                try {
                    list.add(Integer.parseInt(idStr));
                } catch (NumberFormatException ignored) {}
            }
        }
        replaceUserInterests(userId, list);
    }
}