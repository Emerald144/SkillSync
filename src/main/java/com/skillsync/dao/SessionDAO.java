package com.skillsync.dao;

import com.skillsync.model.Session;
import com.skillsync.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SessionDAO {

    public boolean createSession(int requestId, int teacherId, int learnerId,
                                  String sessionType, String location, String meetingLink,
                                  Timestamp sessionDate) {
        String sql = "INSERT INTO sessions (request_id, teacher_id, learner_id, session_type, " +
                     "location, meeting_link, session_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, 'Scheduled')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.setInt(2, teacherId);
            ps.setInt(3, learnerId);
            ps.setString(4, sessionType);
            ps.setString(5, location);
            ps.setString(6, meetingLink);
            ps.setTimestamp(7, sessionDate);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Returns the session's status for a given request, or null if no session exists yet.
     */
    public String getSessionStatusForRequest(int requestId) {
        String sql = "SELECT status FROM sessions WHERE request_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("status");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Checks if a session exists for the given request ID.
     */
    public boolean sessionExistsForRequest(int requestId) {
        return getSessionStatusForRequest(requestId) != null;
    }

    /**
     * Returns ALL sessions for a user (including Scheduled, Completed, Cancelled, Needs Review).
     */
    public List<Session> getSessionsForUser(int userId) {
        List<Session> list = new ArrayList<>();
        String sql = "SELECT s.*, " +
                     "lr.skill_id, sk.skill_name, " +
                     "ut.full_name AS teacher_name, ut.profile_photo AS teacher_photo, " +
                     "ul.full_name AS learner_name, ul.profile_photo AS learner_photo " +
                     "FROM sessions s " +
                     "JOIN learning_requests lr ON s.request_id = lr.request_id " +
                     "JOIN skills sk ON lr.skill_id = sk.skill_id " +
                     "JOIN users ut ON s.teacher_id = ut.user_id " +
                     "JOIN users ul ON s.learner_id = ul.user_id " +
                     "WHERE (s.teacher_id = ? OR s.learner_id = ?) " +
                     "ORDER BY s.session_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToSession(rs, userId));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves sessions specifically linked to a request_id for a given user.
     */
    public List<Session> getSessionsForUserAndRequest(int userId, int requestId) {
        List<Session> list = new ArrayList<>();
        String sql = "SELECT s.*, " +
                     "lr.skill_id, sk.skill_name, " +
                     "ut.full_name AS teacher_name, ut.profile_photo AS teacher_photo, " +
                     "ul.full_name AS learner_name, ul.profile_photo AS learner_photo " +
                     "FROM sessions s " +
                     "JOIN learning_requests lr ON s.request_id = lr.request_id " +
                     "JOIN skills sk ON lr.skill_id = sk.skill_id " +
                     "JOIN users ut ON s.teacher_id = ut.user_id " +
                     "JOIN users ul ON s.learner_id = ul.user_id " +
                     "WHERE (s.teacher_id = ? OR s.learner_id = ?) AND s.request_id = ? " +
                     "ORDER BY s.session_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToSession(rs, userId));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Helper method to map ResultSet to Session Object cleanly.
     */
    private Session mapResultSetToSession(ResultSet rs, int userId) throws SQLException {
        Session s = new Session();
        s.setSessionId(rs.getInt("session_id"));
        s.setRequestId(rs.getInt("request_id"));
        s.setTeacherId(rs.getInt("teacher_id"));
        s.setLearnerId(rs.getInt("learner_id"));
        s.setSessionType(rs.getString("session_type"));
        s.setLocation(rs.getString("location"));
        s.setMeetingLink(rs.getString("meeting_link"));
        s.setSessionDate(rs.getTimestamp("session_date"));
        s.setStatus(rs.getString("status"));
        s.setNotes(rs.getString("notes"));
        s.setSkillName(rs.getString("skill_name"));

        // Confirmation States
        s.setLearnerConfirmed(rs.getBoolean("learner_confirmed"));
        s.setTeacherConfirmed(rs.getBoolean("teacher_confirmed"));
        s.setLearnerConfirmedAt(rs.getTimestamp("learner_confirmed_at"));
        s.setTeacherConfirmedAt(rs.getTimestamp("teacher_confirmed_at"));

        boolean userIsTeacher = (rs.getInt("teacher_id") == userId);
        s.setTeacher(userIsTeacher);

        if (userIsTeacher) {
            s.setOtherUserName(rs.getString("learner_name"));
            s.setOtherUserPhoto(rs.getString("learner_photo"));
        } else {
            s.setOtherUserName(rs.getString("teacher_name"));
            s.setOtherUserPhoto(rs.getString("teacher_photo"));
        }
        return s;
    }

    public boolean updateSessionStatus(int sessionId, String newStatus) {
        String sql = "UPDATE sessions SET status = ? WHERE session_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, sessionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cancels a session by updating status to 'Cancelled'.
     */
    public boolean cancelSession(int sessionId) {
        return updateSessionStatus(sessionId, "Cancelled");
    }

    public Session getSessionById(int sessionId) {
        String sql = "SELECT s.*, lr.skill_id, sk.skill_name, " +
                     "ut.full_name AS teacher_name, ut.profile_photo AS teacher_photo, " +
                     "ul.full_name AS learner_name, ul.profile_photo AS learner_photo " +
                     "FROM sessions s " +
                     "JOIN learning_requests lr ON s.request_id = lr.request_id " +
                     "JOIN skills sk ON lr.skill_id = sk.skill_id " +
                     "JOIN users ut ON s.teacher_id = ut.user_id " +
                     "JOIN users ul ON s.learner_id = ul.user_id " +
                     "WHERE s.session_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Session s = new Session();
                    s.setSessionId(rs.getInt("session_id"));
                    s.setRequestId(rs.getInt("request_id"));
                    s.setTeacherId(rs.getInt("teacher_id"));
                    s.setLearnerId(rs.getInt("learner_id"));
                    s.setSessionType(rs.getString("session_type"));
                    s.setLocation(rs.getString("location"));
                    s.setMeetingLink(rs.getString("meeting_link"));
                    s.setSessionDate(rs.getTimestamp("session_date"));
                    s.setStatus(rs.getString("status"));
                    s.setNotes(rs.getString("notes"));
                    s.setSkillName(rs.getString("skill_name"));
                    s.setLearnerConfirmed(rs.getBoolean("learner_confirmed"));
                    s.setTeacherConfirmed(rs.getBoolean("teacher_confirmed"));
                    s.setLearnerConfirmedAt(rs.getTimestamp("learner_confirmed_at"));
                    s.setTeacherConfirmedAt(rs.getTimestamp("teacher_confirmed_at"));
                    return s;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean confirmByLearner(int sessionId) {
        String sql = "UPDATE sessions SET learner_confirmed = 1, learner_confirmed_at = NOW() WHERE session_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean confirmByTeacher(int sessionId) {
        String sql = "UPDATE sessions SET teacher_confirmed = 1, teacher_confirmed_at = NOW() WHERE session_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sessionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Flags overdue/stalled sessions to 'Needs Review' if:
     * 1. The session_date passed > 24 hours ago with ZERO confirmations.
     * 2. ONE user confirmed, but > 48 hours passed without the other user confirming.
     */
    public void flagOverdueSessions() {
        String sql = "UPDATE sessions SET status = 'Needs Review' " +
                     "WHERE status = 'Scheduled' AND ( " +
                     "   (learner_confirmed = 0 AND teacher_confirmed = 0 AND session_date < DATE_SUB(NOW(), INTERVAL 24 HOUR)) " +
                     "   OR " +
                     "   (learner_confirmed = 1 AND teacher_confirmed = 0 AND learner_confirmed_at < DATE_SUB(NOW(), INTERVAL 48 HOUR)) " +
                     "   OR " +
                     "   (teacher_confirmed = 1 AND learner_confirmed = 0 AND teacher_confirmed_at < DATE_SUB(NOW(), INTERVAL 48 HOUR)) " +
                     ")";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean updateSessionNotes(int sessionId, String notes) {
        String sql = "UPDATE sessions SET notes = ? WHERE session_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, notes);
            ps.setInt(2, sessionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
 // Count completed sessions for a specific user
    public int getCompletedSessionCount(int userId) {
        String sql = "SELECT COUNT(*) FROM sessions WHERE (teacher_id = ? OR learner_id = ?) AND status = 'Completed'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, userId);

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
}