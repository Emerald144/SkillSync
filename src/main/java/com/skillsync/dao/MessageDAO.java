package com.skillsync.dao;

import com.skillsync.model.Message;
import com.skillsync.model.User;
import com.skillsync.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    public boolean sendMessage(int senderId, int receiverId, String message) {
        String sql = "INSERT INTO messages (sender_id, receiver_id, message) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, senderId);
            ps.setInt(2, receiverId);
            ps.setString(3, message);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Message> getConversation(int user1, int user2) {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT message_id, sender_id, receiver_id, message, sent_at FROM messages " +
                     "WHERE (sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?) " +
                     "ORDER BY sent_at ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, user1);
            ps.setInt(2, user2);
            ps.setInt(3, user2);
            ps.setInt(4, user1);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Message msg = new Message();
                    msg.setMessageId(rs.getInt("message_id"));
                    msg.setSenderId(rs.getInt("sender_id"));
                    msg.setReceiverId(rs.getInt("receiver_id"));
                    msg.setMessage(rs.getString("message"));
                    msg.setSentAt(rs.getTimestamp("sent_at"));
                    messages.add(msg);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }

    // NEW: Get users connected via an 'Accepted' learning request (whether messaged or not)
    public List<User> getConnectedUsers(int currentUserId) {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT DISTINCT u.user_id, u.full_name, u.profile_photo " +
                     "FROM users u " +
                     "JOIN learning_requests lr ON " +
                     "  ((lr.sender_id = ? AND lr.receiver_id = u.user_id) " +
                     "   OR (lr.receiver_id = ? AND lr.sender_id = u.user_id)) " +
                     "WHERE lr.status = 'Accepted'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, currentUserId);
            ps.setInt(2, currentUserId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setProfilePhoto(rs.getString("profile_photo"));
                    userList.add(u);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    // Get list of unique users the current user has chatted with
    public List<User> getRecentConversations(int currentUserId) {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT DISTINCT u.user_id, u.full_name, u.profile_photo " +
                     "FROM users u " +
                     "JOIN messages m ON (u.user_id = m.sender_id OR u.user_id = m.receiver_id) " +
                     "WHERE (m.sender_id = ? OR m.receiver_id = ?) AND u.user_id != ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, currentUserId);
            ps.setInt(2, currentUserId);
            ps.setInt(3, currentUserId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setProfilePhoto(rs.getString("profile_photo"));
                    userList.add(u);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    // Get user details for active thread header
    public User getUserById(int userId) {
        String sql = "SELECT user_id, full_name, profile_photo FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setProfilePhoto(rs.getString("profile_photo"));
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Count unread messages for global badge notification
    public int getUnreadMessageCount(int userId) {
        String sql = "SELECT COUNT(*) FROM messages WHERE receiver_id = ? AND is_read = FALSE";
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

    // Clear unread status when opening a thread
    public void markMessagesAsRead(int receiverId, int senderId) {
        String sql = "UPDATE messages SET is_read = TRUE WHERE receiver_id = ? AND sender_id = ? AND is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, receiverId);
            ps.setInt(2, senderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}