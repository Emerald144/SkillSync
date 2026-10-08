package com.skillsync.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.skillsync.model.User;
import com.skillsync.model.UserSearchResult;
import com.skillsync.util.DBConnection;

public class UserDAO {

    /**
     * Registers a new user into the database.
     * Expects user.getPassword() to already be hashed by RegisterServlet.
     */
    public boolean registerUser(User user) throws SQLException {
        String sql = "INSERT INTO users (full_name, email, password, profile_photo, bio, university, role, reputation_score, token_balance, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            // Store password directly as it was already hashed prior to calling registerUser
            ps.setString(3, user.getPassword());
            ps.setString(4, (user.getProfilePhoto() != null && !user.getProfilePhoto().trim().isEmpty()) 
                    ? user.getProfilePhoto() 
                    : "images/default_avatar.png");
            ps.setString(5, user.getBio() != null ? user.getBio() : "");
            ps.setString(6, user.getUniversity());
            ps.setString(7, "User");      // Default role
            ps.setInt(8, 0);              // Default reputation score
            ps.setInt(9, user.getTokenBalance() > 0 ? user.getTokenBalance() : 100); // Token balance
            ps.setString(10, "Active");  // Default status

            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    /**
     * Checks if an email is already registered.
     */
    public boolean isEmailTaken(String email) throws SQLException {
        String sql = "SELECT user_id FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Retrieves full User object by email for Authentication and Session creation.
     */
    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT user_id, full_name, email, password, profile_photo, bio, university, role, reputation_score, token_balance, status, learning_goals, warning_count FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    
                    String photo = rs.getString("profile_photo");
                    user.setProfilePhoto((photo != null && !photo.trim().isEmpty()) ? photo : "images/default_avatar.png");
                    
                    user.setBio(rs.getString("bio") != null ? rs.getString("bio") : "");
                    user.setUniversity(rs.getString("university"));
                    user.setRole(rs.getString("role"));
                    user.setReputationScore(rs.getInt("reputation_score"));
                    user.setTokenBalance(rs.getInt("token_balance"));
                    user.setStatus(rs.getString("status"));
                    user.setLearningGoals(rs.getString("learning_goals") != null ? rs.getString("learning_goals") : "");
                    user.setWarningCount(rs.getInt("warning_count"));
                    return user;
                }
            }
        }
        return null;
    }

    /**
     * Updates profile details (full_name, university, bio, profile_photo) for an existing user.
     */
    public boolean updateUserProfile(User user) throws SQLException {
        String sql = "UPDATE users SET full_name = ?, university = ?, bio = ?, profile_photo = ?, learning_goals = ? WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getUniversity());
            ps.setString(3, user.getBio() != null ? user.getBio() : "");
            ps.setString(4, (user.getProfilePhoto() != null && !user.getProfilePhoto().trim().isEmpty()) 
                    ? user.getProfilePhoto() 
                    : "images/default_avatar.png");
            ps.setString(5, user.getLearningGoals() != null ? user.getLearningGoals() : "");
            ps.setInt(6, user.getUserId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    /**
     * Retrieves full User object by user_id for profile viewing.
     */
    /**
     * Retrieves full User object by user_id for profile viewing.
     */
    public User getUserById(int userId) {
        String sql = "SELECT user_id, full_name, email, password, profile_photo, bio, university, role, reputation_score, token_balance, status, learning_goals, warning_count FROM users WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    
                    String photo = rs.getString("profile_photo");
                    user.setProfilePhoto((photo != null && !photo.trim().isEmpty()) ? photo : "images/default_avatar.png");
                    
                    user.setBio(rs.getString("bio") != null ? rs.getString("bio") : "");
                    user.setUniversity(rs.getString("university"));
                    user.setRole(rs.getString("role"));
                    user.setReputationScore(rs.getInt("reputation_score"));
                    user.setTokenBalance(rs.getInt("token_balance"));
                    user.setStatus(rs.getString("status"));
                    user.setLearningGoals(rs.getString("learning_goals") != null ? rs.getString("learning_goals") : "");
                    user.setWarningCount(rs.getInt("warning_count"));
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    /**
     * Searches for users based on query, university, and minimum rating.
     * Excludes System Admin accounts and current logged-in user.
     */
    public List<UserSearchResult> searchUsers(String query, String university, double minRating, int currentUserId) {
        List<UserSearchResult> results = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder(
            "SELECT u.user_id, u.full_name, u.profile_photo, u.university, u.reputation_score, " +
            "u.reputation_score as rating, " + 
            "(SELECT MIN(skill_id) FROM user_skills WHERE user_id = u.user_id) as first_skill_id, " +
            "(SELECT GROUP_CONCAT(s.skill_name) FROM skills s JOIN user_skills us ON s.skill_id = us.skill_id WHERE us.user_id = u.user_id) as teaching_skills " +
            "FROM users u WHERE 1=1 " +
            "AND (u.role IS NULL OR u.role != 'ADMIN') " +
            "AND u.email != 'admin@skillsync.com' "
        );

        if (currentUserId > 0) {
            sql.append("AND u.user_id != ? ");
        }

        boolean hasQuery = query != null && !query.trim().isEmpty();
        if (hasQuery) {
            sql.append("AND (u.full_name LIKE ? OR EXISTS (SELECT 1 FROM skills s JOIN user_skills us ON s.skill_id = us.skill_id WHERE us.user_id = u.user_id AND s.skill_name LIKE ?)) ");
        }
        
        boolean filterUni = university != null && !university.equals("all") && !university.trim().isEmpty();
        if (filterUni) {
            sql.append("AND u.university LIKE ? ");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;

            if (currentUserId > 0) {
                stmt.setInt(paramIndex++, currentUserId);
            }
            
            if (hasQuery) {
                String searchPattern = "%" + query + "%";
                stmt.setString(paramIndex++, searchPattern);
                stmt.setString(paramIndex++, searchPattern);
            }
            
            if (filterUni) {
                stmt.setString(paramIndex++, "%" + university + "%");
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    UserSearchResult user = new UserSearchResult();
                    user.setId(rs.getInt("user_id"));
                    user.setSkillId(rs.getInt("first_skill_id"));
                    user.setName(rs.getString("full_name"));

                    String photo = rs.getString("profile_photo");
                    if (photo != null && !photo.trim().isEmpty()) {
                        user.setAvatar(photo);
                    } else {
                        user.setAvatar("images/default_avatar.png");
                    }

                    user.setUniversity(rs.getString("university"));
                    user.setMatch((int)(Math.random() * 20) + 80);
                    user.setReputation(rs.getInt("reputation_score"));
                    user.setReputationLevel(user.getReputation() > 100 ? "Pro" : "Beginner");

                    double rating = 4.0 + (user.getReputation() / 100.0);
                    user.setRating(rating > 5.0 ? 5.0 : Math.round(rating * 10.0) / 10.0);

                    String skillsStr = rs.getString("teaching_skills");
                    if (skillsStr != null && !skillsStr.isEmpty()) {
                        user.setTeaching(Arrays.asList(skillsStr.split(",")));
                    } else {
                        user.setTeaching(new ArrayList<>());
                    }

                    if (minRating <= 0.0 || user.getRating() >= minRating) {
                        results.add(user);
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("Database error during searchUsers: " + e.getMessage());
            e.printStackTrace();
        }
        
        return results;
    }

    /**
     * Updates a user's reputation score by adding pointsToAdd.
     */
    public boolean updateReputation(int userId, int pointsToAdd) {
        String sql = "UPDATE users SET reputation_score = reputation_score + ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pointsToAdd);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Returns the first/primary skill_id for a given user, or 0 if they have none.
     */
    public int getPrimarySkillId(int userId) throws SQLException {
        String sql = "SELECT MIN(skill_id) AS skill_id FROM user_skills WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("skill_id");
                }
            }
        }
        return 0;
    }

    /**
     * Checks whether senderId already has a Pending request sent to receiverId.
     */
    public boolean hasPendingRequest(int senderId, int receiverId) throws SQLException {
        String sql = "SELECT 1 FROM learning_requests WHERE sender_id = ? AND receiver_id = ? AND status = 'Pending'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, senderId);
            ps.setInt(2, receiverId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
    
    /**
     * Updates User Account Status (Active / Suspended / Deactivated)
     */
    public boolean updateUserStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Increments User Warning Count and automatically suspends user if warnings >= 3
     */
    public boolean incrementWarningCount(int userId) {
        String sqlUpdate = "UPDATE users SET warning_count = warning_count + 1 WHERE user_id = ?";
        String sqlCheckAndSuspend = "UPDATE users SET status = 'Suspended' WHERE user_id = ? AND warning_count >= 3";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps1 = conn.prepareStatement(sqlUpdate);
             PreparedStatement ps2 = conn.prepareStatement(sqlCheckAndSuspend)) {
            
            ps1.setInt(1, userId);
            int rows = ps1.executeUpdate();
            
            if (rows > 0) {
                ps2.setInt(1, userId);
                ps2.executeUpdate();
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Admin Dashboard Statistics Methods
     */
    public int getTotalUserCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE email != 'admin@skillsync.com' AND (role IS NULL OR role != 'ADMIN')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getActiveUserCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 'Active' AND email != 'admin@skillsync.com' AND (role IS NULL OR role != 'ADMIN')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getSuspendedUserCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 'Suspended' OR status = 'Deactivated'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));

        String photo = rs.getString("profile_photo");
        user.setProfilePhoto((photo != null && !photo.trim().isEmpty()) ? photo : "images/default_avatar.png");

        user.setBio(rs.getString("bio") != null ? rs.getString("bio") : "");
        user.setUniversity(rs.getString("university"));
        user.setRole(rs.getString("role"));
        user.setReputationScore(rs.getInt("reputation_score"));
        user.setTokenBalance(rs.getInt("token_balance"));
        user.setStatus(rs.getString("status"));
        user.setLearningGoals(rs.getString("learning_goals") != null ? rs.getString("learning_goals") : "");
        user.setWarningCount(rs.getInt("warning_count"));
        return user;
    }

    /**
     * Retrieves all users from database.
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, full_name, email, password, profile_photo, bio, university, role, reputation_score, token_balance, status, learning_goals, warning_count FROM users ORDER BY user_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Retrieves users filtered by status (e.g., Active, Suspended, Deactivated).
     */
    public List<User> getUsersByStatus(String status) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, full_name, email, password, profile_photo, bio, university, role, reputation_score, token_balance, status, learning_goals, warning_count FROM users WHERE status = ? ORDER BY user_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Permanently deletes a user account by user_id.
     */
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Verifies if the provided current password matches the BCrypt hash stored in the database.
     */
    public boolean verifyPassword(int userId, String currentPassword) {
        String sql = "SELECT password FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password");
                    if (storedHash != null && !storedHash.trim().isEmpty()) {
                        return BCrypt.checkpw(currentPassword, storedHash);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates the password for a user with a BCrypt hash.
     */
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String newHashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Fetches all distinct university names currently registered in the database.
     * Useful for dynamically populating search filter dropdowns.
     */
    public List<String> getAllDistinctUniversities() {
        List<String> universities = new ArrayList<>();
        String sql = "SELECT DISTINCT university FROM users WHERE university IS NOT NULL AND university != '' ORDER BY university ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                universities.add(rs.getString("university"));
            }
        } catch (SQLException e) {
            System.err.println("Database error during getAllDistinctUniversities: " + e.getMessage());
            e.printStackTrace();
        }
        return universities;
    }
}