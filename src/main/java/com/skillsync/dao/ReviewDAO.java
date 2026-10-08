package com.skillsync.dao;

import com.skillsync.model.Review;
import com.skillsync.model.PendingReview;
import com.skillsync.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    /**
     * Fetches the live reputation score directly from the Users table.
     */
    public int getReputationScore(int userId) {
        String sql = "SELECT reputation_score FROM users WHERE user_id = ?";
        int score = 0;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    score = rs.getInt("reputation_score");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return score;
    }

    public double getAverageRating(int userId) {
        String sql = "SELECT COALESCE(AVG(rating), 0.0) FROM reviews WHERE reviewee_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public int getReviewCount(int userId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE reviewee_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

   

    /**
     * Retrieves all reviews submitted for a given user, including the reviewer's photo.
     */
    /**
     * Retrieves all reviews submitted for a given user, including the reviewer's photo.
     */
    public List<Review> getReviewsForUser(int userId) {
        List<Review> list = new ArrayList<>();
        
        // Explicitly map r.reviewer_id and ensure user profile info joins strictly on reviewer_id
        String sql = "SELECT r.review_id, r.session_id, r.reviewer_id, r.reviewee_id, r.rating, r.comment, r.review_date, " +
                     "       u.full_name AS reviewer_name, u.profile_photo AS reviewer_photo, sk.skill_name " +
                     "FROM reviews r " +
                     "INNER JOIN users u ON r.reviewer_id = u.user_id " +
                     "INNER JOIN sessions s ON r.session_id = s.session_id " +
                     "INNER JOIN learning_requests lr ON s.request_id = lr.request_id " +
                     "INNER JOIN skills sk ON lr.skill_id = sk.skill_id " +
                     "WHERE r.reviewee_id = ? " +
                     "ORDER BY r.review_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review rev = new Review();
                    rev.setReviewId(rs.getInt("review_id"));
                    rev.setSessionId(rs.getInt("session_id"));
                    rev.setReviewerId(rs.getInt("reviewer_id")); // Strictly reads r.reviewer_id
                    rev.setRevieweeId(rs.getInt("reviewee_id"));
                    rev.setRating(rs.getInt("rating"));
                    rev.setComment(rs.getString("comment"));
                    rev.setReviewDate(rs.getTimestamp("review_date"));
                    rev.setReviewerName(rs.getString("reviewer_name"));
                    rev.setReviewerPhoto(rs.getString("reviewer_photo"));
                    rev.setSkillName(rs.getString("skill_name"));
                    list.add(rev);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PendingReview> getPendingReviews(int userId) {
        List<PendingReview> pendingList = new ArrayList<>();
        
        String sql = "SELECT s.session_id, sk.skill_name, " +
                     "       CASE WHEN s.learner_id = ? THEN u_teacher.full_name ELSE u_learner.full_name END AS reviewee_name, " +
                     "       CASE WHEN s.learner_id = ? THEN s.teacher_id ELSE s.learner_id END AS reviewee_id " +
                     "FROM sessions s " +
                     "JOIN learning_requests lr ON s.request_id = lr.request_id " +
                     "JOIN skills sk ON lr.skill_id = sk.skill_id " +
                     "JOIN users u_learner ON s.learner_id = u_learner.user_id " +
                     "JOIN users u_teacher ON s.teacher_id = u_teacher.user_id " +
                     "WHERE (s.learner_id = ? OR s.teacher_id = ?) " +
                     "  AND LOWER(s.status) = 'completed' " +
                     "  AND s.session_id NOT IN ( " +
                     "      SELECT session_id FROM reviews WHERE reviewer_id = ? " +
                     "  )";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            ps.setInt(4, userId);
            ps.setInt(5, userId);

            // Added ResultSet inside try-with-resources to ensure auto-closure
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PendingReview pr = new PendingReview();
                    pr.setSessionId(rs.getInt("session_id"));
                    pr.setSkillName(rs.getString("skill_name"));
                    pr.setRevieweeName(rs.getString("reviewee_name"));
                    pr.setRevieweeId(rs.getInt("reviewee_id"));
                    pendingList.add(pr);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return pendingList;
    }

    public boolean hasReviewed(int sessionId, int reviewerId) {
        String sql = "SELECT 1 FROM reviews WHERE session_id = ? AND reviewer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            ps.setInt(2, reviewerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Accepts primitive attributes directly from ReviewServlet, determines reviewee_id,
     * verifies completed session status, adds review, and updates reputation atomically.
     */
    public boolean addReview(int sessionId, int reviewerId, int rating, String comment) {
        String findSessionSql = "SELECT teacher_id, learner_id, status FROM sessions WHERE session_id = ?";
        String insertReviewSql = "INSERT INTO reviews (session_id, reviewer_id, reviewee_id, rating, comment) VALUES (?, ?, ?, ?, ?)";
        String updateRepSql = "UPDATE users SET reputation_score = reputation_score + ? WHERE user_id = ?";
        String insertTxSql = "INSERT INTO reputation_transactions (user_id, session_id, points, reason) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Identify reviewee_id securely from session database record
            int revieweeId = -1;
            try (PreparedStatement psSession = conn.prepareStatement(findSessionSql)) {
                psSession.setInt(1, sessionId);
                ResultSet rs = psSession.executeQuery();
                if (rs.next()) {
                    String status = rs.getString("status");
                    if (!"completed".equalsIgnoreCase(status)) {
                        conn.rollback();
                        return false;
                    }

                    int teacherId = rs.getInt("teacher_id");
                    int learnerId = rs.getInt("learner_id");

                    if (reviewerId == teacherId) {
                        revieweeId = learnerId;
                    } else if (reviewerId == learnerId) {
                        revieweeId = teacherId;
                    } else {
                        conn.rollback();
                        return false; // Reviewer was not part of session
                    }
                } else {
                    conn.rollback();
                    return false; // Session does not exist
                }
            }

            // 2. Insert Review
            try (PreparedStatement psReview = conn.prepareStatement(insertReviewSql)) {
                psReview.setInt(1, sessionId);
                psReview.setInt(2, reviewerId);
                psReview.setInt(3, revieweeId);
                psReview.setInt(4, rating);
                psReview.setString(5, comment);
                psReview.executeUpdate();
            }

            // 3. Award reputation points if rating >= 4
            int reputationPoints = (rating >= 4) ? 5 : 0;
            if (reputationPoints > 0) {
                try (PreparedStatement psRep = conn.prepareStatement(updateRepSql)) {
                    psRep.setInt(1, reputationPoints);
                    psRep.setInt(2, revieweeId);
                    psRep.executeUpdate();
                }

                try (PreparedStatement psTx = conn.prepareStatement(insertTxSql)) {
                    psTx.setInt(1, revieweeId);
                    psTx.setInt(2, sessionId);
                    psTx.setInt(3, reputationPoints);
                    psTx.setString(4, "Positive Review Received");
                    psTx.executeUpdate();
                }
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    /**
     * Overloaded method to maintain backwards compatibility with Review object callers.
     */
    public boolean addReviewWithReputation(Review review, int reputationPoints) {
        return addReview(review.getSessionId(), review.getReviewerId(), review.getRating(), review.getComment());
    }
    
 // Fetch a limited number of recent reviews for dashboard display
    public List<Review> getRecentReviewsForUser(int userId, int limit) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.review_id, r.session_id, r.reviewer_id, r.reviewee_id, r.rating, r.comment, r.review_date, " +
                     "       u.full_name AS reviewer_name, u.profile_photo AS reviewer_photo, sk.skill_name " +
                     "FROM reviews r " +
                     "INNER JOIN users u ON r.reviewer_id = u.user_id " +
                     "INNER JOIN sessions s ON r.session_id = s.session_id " +
                     "INNER JOIN learning_requests lr ON s.request_id = lr.request_id " +
                     "INNER JOIN skills sk ON lr.skill_id = sk.skill_id " +
                     "WHERE r.reviewee_id = ? " +
                     "ORDER BY r.review_date DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review rev = new Review();
                    rev.setReviewId(rs.getInt("review_id"));
                    rev.setSessionId(rs.getInt("session_id"));
                    rev.setReviewerId(rs.getInt("reviewer_id"));
                    rev.setRevieweeId(rs.getInt("reviewee_id"));
                    rev.setRating(rs.getInt("rating"));
                    rev.setComment(rs.getString("comment"));
                    rev.setReviewDate(rs.getTimestamp("review_date"));
                    rev.setReviewerName(rs.getString("reviewer_name"));
                    rev.setReviewerPhoto(rs.getString("reviewer_photo"));
                    rev.setSkillName(rs.getString("skill_name"));
                    list.add(rev);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}