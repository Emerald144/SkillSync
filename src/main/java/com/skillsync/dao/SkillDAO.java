package com.skillsync.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.skillsync.model.Skill;
import com.skillsync.model.UserSkill;
import com.skillsync.util.DBConnection;

public class SkillDAO {

    /**
     * Retrieves all skills associated with a specific user.
     * Performs a JOIN on skills to populate skillName and category.
     */
    public List<UserSkill> getSkillsByUserId(int userId) throws SQLException {
        List<UserSkill> userSkills = new ArrayList<>();
        String sql = "SELECT us.user_skill_id, us.user_id, us.skill_id, us.skill_type, us.proficiency_level, " +
                     "s.skill_name, s.category " +
                     "FROM user_skills us " +
                     "JOIN skills s ON us.skill_id = s.skill_id " +
                     "WHERE us.user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserSkill us = new UserSkill();
                    us.setUserSkillId(rs.getInt("user_skill_id"));
                    us.setUserId(rs.getInt("user_id"));
                    us.setSkillId(rs.getInt("skill_id"));
                    us.setSkillType(rs.getString("skill_type"));
                    us.setProficiencyLevel(rs.getString("proficiency_level"));
                    
                    // Populated from joined skills table
                    us.setSkillName(rs.getString("skill_name"));
                    us.setCategory(rs.getString("category"));

                    userSkills.add(us);
                }
            }
        }
        return userSkills;
    }

    /**
     * Finds a skill_id by name, or creates a new entry in 'skills' table if it doesn't exist.
     */
    public int findOrCreateSkill(Connection conn, String skillName, String category) throws SQLException {
        String selectSql = "SELECT skill_id FROM skills WHERE LOWER(skill_name) = LOWER(?)";
        
        try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
            ps.setString(1, skillName.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("skill_id");
                }
            }
        }

        // If not found, insert new skill entry into master skills table
        String insertSql = "INSERT INTO skills (skill_name, category) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, skillName.trim());
            ps.setString(2, (category != null && !category.trim().isEmpty()) ? category.trim() : "General");
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new SQLException("Failed to retrieve generated skill_id for: " + skillName);
    }
    
    
    /**
     * Inserts a single skill for a user into the database.
     * Resolves or creates the master skill entry first if no valid skill_id is provided.
     */
    /**
     * Inserts a single skill for a user into the database.
     * Resolves or creates the master skill entry first if no valid skill_id is provided.
     * Returns true if the insertion was successful.
     */
    public boolean insertUserSkill(UserSkill us) throws SQLException {
        String insertSql = "INSERT INTO user_skills (user_id, skill_id, skill_type, proficiency_level) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            int resolvedSkillId = us.getSkillId();

            // If skillId is 0 or unassigned, resolve or insert into 'skills' table first
            if (resolvedSkillId <= 0 && us.getSkillName() != null) {
                resolvedSkillId = findOrCreateSkill(conn, us.getSkillName(), us.getCategory());
            }

            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, us.getUserId());
                ps.setInt(2, resolvedSkillId);
                ps.setString(3, us.getSkillType());
                ps.setString(4, us.getProficiencyLevel());
                
                // executeUpdate() returns the number of rows affected. 
                // If it's greater than 0, the insert was successful!
                int rowsAffected = ps.executeUpdate();
                return rowsAffected > 0;
            }
        }
    }

    /**
     * Replaces a user's skills list in a single atomic transaction.
     * First deletes old user_skills entries, then inserts updated ones.
     */
    public void replaceUserSkills(int userId, List<UserSkill> updatedSkills) throws SQLException {
        String deleteSql = "DELETE FROM user_skills WHERE user_id = ?";
        String insertSql = "INSERT INTO user_skills (user_id, skill_id, skill_type, proficiency_level) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // Begin Transaction

            try {
                // 1. Delete existing skills for this user
                try (PreparedStatement deletePs = conn.prepareStatement(deleteSql)) {
                    deletePs.setInt(1, userId);
                    deletePs.executeUpdate();
                }

                // 2. Insert new skills
                try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                    for (UserSkill us : updatedSkills) {
                        int resolvedSkillId = us.getSkillId();

                        // If skillId is 0 or unassigned, resolve or insert into 'skills' table first
                        if (resolvedSkillId <= 0 && us.getSkillName() != null) {
                            resolvedSkillId = findOrCreateSkill(conn, us.getSkillName(), us.getCategory());
                        }

                        insertPs.setInt(1, userId);
                        insertPs.setInt(2, resolvedSkillId);
                        insertPs.setString(3, us.getSkillType());
                        insertPs.setString(4, us.getProficiencyLevel());
                        insertPs.addBatch();
                    }
                    insertPs.executeBatch();
                }

                conn.commit(); // Commit Transaction
            } catch (SQLException e) {
                conn.rollback(); // Rollback on failure
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    /**
     * Retrieves all master skills for dropdowns or autocomplete inputs.
     */
    public List<Skill> getAllMasterSkills() throws SQLException {
        List<Skill> list = new ArrayList<>();
        String sql = "SELECT skill_id, skill_name, category FROM skills ORDER BY skill_name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Skill s = new Skill();
                s.setSkillId(rs.getInt("skill_id"));
                s.setSkillName(rs.getString("skill_name"));
                s.setCategory(rs.getString("category"));
                list.add(s);
            }
        }
        return list;
    }
    
    /**
     * Retrieves top popular skills based on user enrollment count.
     * Includes fallback calculation for learner count and popularity percentage.
     */
    public List<Skill> getPopularSkills(int limit) {
        List<Skill> list = new ArrayList<>();
        String sql = "SELECT s.skill_id, s.skill_name, s.category, COUNT(us.user_id) AS learner_count " +
                     "FROM skills s " +
                     "LEFT JOIN user_skills us ON s.skill_id = us.skill_id " +
                     "GROUP BY s.skill_id, s.skill_name, s.category " +
                     "ORDER BY learner_count DESC " +
                     "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Skill s = new Skill();
                    s.setSkillId(rs.getInt("skill_id"));
                    s.setSkillName(rs.getString("skill_name"));
                    s.setCategory(rs.getString("category"));
                    
                    // Optional: If your Skill model has helper fields or setter methods
                    // for learner count and percentage, you can map them here:
                    int learnerCount = rs.getInt("learner_count");
                    s.setLearnerCount(learnerCount);

                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}