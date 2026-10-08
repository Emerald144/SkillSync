package com.skillsync.dao;

import com.skillsync.model.LearningRequest;
import com.skillsync.util.DBConnection; // Update with your DB utility

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LearningRequestDAO {

	public List<LearningRequest> getRequestsByReceiverAndStatus(int receiverId, String status) {
	    List<LearningRequest> list = new ArrayList<>();
	    String sql = "SELECT lr.request_id, lr.sender_id, lr.receiver_id, lr.skill_id, lr.status, lr.request_date, " +
	                 "u.full_name AS sender_name, u.profile_photo AS sender_photo, s.skill_name " + // u.profile_photo ထည့်သွင်းထားသည်
	                 "FROM learning_requests lr " +
	                 "JOIN users u ON lr.sender_id = u.user_id " +
	                 "JOIN skills s ON lr.skill_id = s.skill_id " +
	                 "WHERE lr.receiver_id = ? AND lr.status = ? " +
	                 "ORDER BY lr.request_date DESC";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setInt(1, receiverId);
	        stmt.setString(2, status);
	        try (ResultSet rs = stmt.executeQuery()) {
	            while (rs.next()) {
	                LearningRequest req = new LearningRequest();
	                req.setRequestId(rs.getInt("request_id"));
	                req.setSenderId(rs.getInt("sender_id"));
	                req.setReceiverId(rs.getInt("receiver_id"));
	                req.setSkillId(rs.getInt("skill_id"));
	                req.setStatus(rs.getString("status"));
	                req.setRequestDate(rs.getTimestamp("request_date"));
	                req.setSenderName(rs.getString("sender_name"));
	                req.setSkillName(rs.getString("skill_name"));

	                // တစ်ဖက်လူ (Sender) ရဲ့ ID နဲ့ Photo ကို set လုပ်ပေးခြင်း
	                req.setOtherUserId(rs.getInt("sender_id"));
	                req.setOtherUserPhoto(rs.getString("sender_photo"));

	                list.add(req);
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return list;
	}

    public boolean updateRequestStatus(int requestId, String newStatus) {
        String sql = "UPDATE learning_requests SET status = ? WHERE request_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newStatus);
            stmt.setInt(2, requestId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean createRequest(int senderId, int receiverId, int skillId) {
        String sql = "INSERT INTO learning_requests (sender_id, receiver_id, skill_id, status) VALUES (?, ?, ?, 'Pending')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, senderId);
            stmt.setInt(2, receiverId);
            stmt.setInt(3, skillId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int getPendingCount(int receiverId) {
        String sql = "SELECT COUNT(*) FROM learning_requests WHERE receiver_id = ? AND status = 'Pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, receiverId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<LearningRequest> getRequestsBySenderAndStatus(int senderId, String status) {
        List<LearningRequest> list = new ArrayList<>();
        String sql = "SELECT lr.request_id, lr.sender_id, lr.receiver_id, lr.skill_id, lr.status, lr.request_date, " +
                     "u.full_name AS receiver_name, u.profile_photo AS receiver_photo, s.skill_name " + // u.profile_photo ထည့်သွင်းထားသည်
                     "FROM learning_requests lr " +
                     "JOIN users u ON lr.receiver_id = u.user_id " +
                     "JOIN skills s ON lr.skill_id = s.skill_id " +
                     "WHERE lr.sender_id = ? AND lr.status = ? " +
                     "ORDER BY lr.request_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, senderId);
            stmt.setString(2, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    LearningRequest req = new LearningRequest();
                    req.setRequestId(rs.getInt("request_id"));
                    req.setSenderId(rs.getInt("sender_id"));
                    req.setReceiverId(rs.getInt("receiver_id"));
                    req.setSkillId(rs.getInt("skill_id"));
                    req.setStatus(rs.getString("status"));
                    req.setRequestDate(rs.getTimestamp("request_date"));
                    req.setSenderName(rs.getString("receiver_name"));
                    req.setSkillName(rs.getString("skill_name"));

                    // တစ်ဖက်လူ (Receiver) ရဲ့ ID နဲ့ Photo ကို set လုပ်ပေးခြင်း
                    req.setOtherUserId(rs.getInt("receiver_id"));
                    req.setOtherUserPhoto(rs.getString("receiver_photo"));

                    list.add(req);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean cancelIfOwnedBySender(int requestId, int senderId) {
        String sql = "UPDATE learning_requests SET status = 'Withdrawn' " +
                     "WHERE request_id = ? AND sender_id = ? AND status = 'Pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, requestId);
            stmt.setInt(2, senderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<LearningRequest> getAllRequestsBySender(int senderId) {
        List<LearningRequest> list = new ArrayList<>();
        String sql = "SELECT lr.request_id, lr.sender_id, lr.receiver_id, lr.skill_id, lr.status, lr.request_date, " +
                     "u.full_name AS receiver_name, u.profile_photo AS receiver_photo, s.skill_name " +
                     "FROM learning_requests lr " +
                     "JOIN users u ON lr.receiver_id = u.user_id " +
                     "JOIN skills s ON lr.skill_id = s.skill_id " +
                     "WHERE lr.sender_id = ? AND lr.status <> 'Withdrawn' " +
                     "ORDER BY lr.request_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, senderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    LearningRequest req = new LearningRequest();
                    req.setRequestId(rs.getInt("request_id"));
                    req.setSenderId(rs.getInt("sender_id"));
                    req.setReceiverId(rs.getInt("receiver_id"));
                    req.setSkillId(rs.getInt("skill_id"));
                    req.setStatus(rs.getString("status"));
                    req.setRequestDate(rs.getTimestamp("request_date"));
                    req.setSenderName(rs.getString("receiver_name"));
                    req.setSkillName(rs.getString("skill_name"));
                    req.setOtherUserId(rs.getInt("receiver_id"));
                    req.setOtherUserPhoto(rs.getString("receiver_photo"));
                    list.add(req);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public LearningRequest getRequestById(int requestId) {
        String sql = "SELECT lr.request_id, lr.sender_id, lr.receiver_id, lr.skill_id, lr.status, lr.request_date, " +
                     "s.skill_name FROM learning_requests lr JOIN skills s ON lr.skill_id = s.skill_id " +
                     "WHERE lr.request_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LearningRequest req = new LearningRequest();
                    req.setRequestId(rs.getInt("request_id"));
                    req.setSenderId(rs.getInt("sender_id"));
                    req.setReceiverId(rs.getInt("receiver_id"));
                    req.setSkillId(rs.getInt("skill_id"));
                    req.setStatus(rs.getString("status"));
                    req.setRequestDate(rs.getTimestamp("request_date"));
                    req.setSkillName(rs.getString("skill_name"));
                    return req;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}