package com.skillsync.dao;

import com.skillsync.model.Notification;
import com.skillsync.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    // Overloaded method without relatedId for general notifications
    public boolean createNotification(int userId, String type, String title, String message) {
        return createNotification(userId, type, title, message, null);
    }

    // Main method with relatedId support
    public boolean createNotification(int userId, String type, String title, String message, Integer relatedId) {
        String sql = "INSERT INTO notifications (user_id, type, title, message, related_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, type);
            ps.setString(3, title);
            ps.setString(4, message);
            
            if (relatedId != null) {
                ps.setInt(5, relatedId);
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Notification> getNotificationsForUser(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setNotificationId(rs.getInt("notification_id"));
                    n.setUserId(rs.getInt("user_id"));
                    n.setType(rs.getString("type"));
                    n.setTitle(rs.getString("title"));
                    n.setMessage(rs.getString("message"));
                    
                    int relId = rs.getInt("related_id");
                    n.setRelatedId(rs.wasNull() ? null : relId);
                    
                    n.setRead(rs.getBoolean("is_read"));
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0";
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

    public boolean markAsRead(int notificationId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE notification_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markAllAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}