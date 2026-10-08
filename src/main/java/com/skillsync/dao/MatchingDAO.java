package com.skillsync.dao;

import com.skillsync.model.MatchResult;
import com.skillsync.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

public class MatchingDAO {

    // Helper map to convert proficiency strings to numbers
    private int getProficiencyNumeric(String level) {
        if (level == null) return 1;
        switch (level.trim().toLowerCase()) {
            case "expert": return 4;
            case "advanced": return 3;
            case "intermediate": return 2;
            case "beginner": default: return 1;
        }
    }

    // Get skills current user wants to learn: Map<SkillName, ProficiencyNumeric>
    public Map<String, Integer> getUserLearningSkills(int userId) {
        Map<String, Integer> skills = new HashMap<>();
        String sql = "SELECT s.skill_name, us.proficiency_level " +
                     "FROM user_skills us " +
                     "JOIN skills s ON us.skill_id = s.skill_id " +
                     "WHERE us.user_id = ? AND us.skill_type = 'Learning'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    skills.put(rs.getString("skill_name"), getProficiencyNumeric(rs.getString("proficiency_level")));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return skills;
    }

    // Get candidate's teaching skills: Map<SkillName, ProficiencyNumeric>
    public Map<String, Integer> getCandidateTeachingSkills(int candidateId) {
        Map<String, Integer> skills = new HashMap<>();
        String sql = "SELECT s.skill_name, us.proficiency_level " +
                     "FROM user_skills us " +
                     "JOIN skills s ON us.skill_id = s.skill_id " +
                     "WHERE us.user_id = ? AND us.skill_type = 'Teaching'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, candidateId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    skills.put(rs.getString("skill_name"), getProficiencyNumeric(rs.getString("proficiency_level")));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return skills;
    }

 // Get all candidate users except logged-in user and System Admin
    public List<MatchResult> getCandidateUsers(int currentUserId) {
        List<MatchResult> candidates = new ArrayList<>();
        
        // SQL Query တွင် Admin Filter ပေါင်းထည့်ထားပါသည်
        String sql = "SELECT user_id, full_name, university, profile_photo, reputation_score " +
                     "FROM users WHERE user_id <> ? AND status = 'Active' " +
                     "AND (role IS NULL OR role != 'ADMIN') " +
                     "AND email != 'admin@skillsync.com'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, currentUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MatchResult candidate = new MatchResult();
                    candidate.setUserId(rs.getInt("user_id"));
                    candidate.setFullName(rs.getString("full_name"));
                    candidate.setUniversity(rs.getString("university"));
                    candidate.setProfilePhoto(rs.getString("profile_photo"));
                    candidate.setRating(rs.getDouble("reputation_score"));
                    candidates.add(candidate);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return candidates;
    }
    
 // Candidate ၏ Teaching Skills များကို name -> id map အဖြစ် ထုတ်ယူခြင်း
    public Map<String, Integer> getCandidateTeachingSkillIds(int candidateId) {
        Map<String, Integer> skillIds = new HashMap<>();
        String sql = "SELECT s.skill_name, s.skill_id " +
                     "FROM user_skills us " +
                     "JOIN skills s ON us.skill_id = s.skill_id " +
                     "WHERE us.user_id = ? AND us.skill_type = 'Teaching'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, candidateId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    skillIds.put(rs.getString("skill_name"), rs.getInt("skill_id"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return skillIds;
    }

    // Matched skill မရှိပါက Candidate ၏ ပထမဆုံး Skill ID ကို Fallback အဖြစ် ယူခြင်း
    public int getFirstSkillId(int candidateId) {
        String sql = "SELECT MIN(skill_id) AS skill_id FROM user_skills WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, candidateId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("skill_id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}