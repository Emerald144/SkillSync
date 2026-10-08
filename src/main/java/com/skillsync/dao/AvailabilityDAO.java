package com.skillsync.dao;

import com.skillsync.model.UserAvailability;
import com.skillsync.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AvailabilityDAO {

    // 1. Fetch all availability time slots for a user
    public List<UserAvailability> getAvailabilityByUserId(int userId) {
        List<UserAvailability> list = new ArrayList<>();
        String sql = "SELECT * FROM User_Availability WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                UserAvailability ua = new UserAvailability();
                ua.setAvailabilityId(rs.getInt("availability_id"));
                ua.setUserId(rs.getInt("user_id"));
                ua.setDayOfWeek(rs.getString("day_of_week"));
                ua.setStartTime(rs.getTime("start_time"));
                ua.setEndTime(rs.getTime("end_time"));
                list.add(ua);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Insert a single availability time slot
    public boolean addAvailability(UserAvailability availability) {
        String sql = "INSERT INTO User_Availability (user_id, day_of_week, start_time, end_time) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, availability.getUserId());
            stmt.setString(2, availability.getDayOfWeek());
            stmt.setTime(3, availability.getStartTime());
            stmt.setTime(4, availability.getEndTime());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Delete all availability time slots for a user
    public boolean deleteAvailabilityByUserId(int userId) {
        String sql = "DELETE FROM User_Availability WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Bulk update: Clears old slots and batch inserts new slots in a single transaction
    public void saveUserAvailability(int userId, List<UserAvailability> availabilities) {
        String deleteSql = "DELETE FROM User_Availability WHERE user_id = ?";
        String insertSql = "INSERT INTO User_Availability (user_id, day_of_week, start_time, end_time) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // Begin transaction

            // Clear old availability settings
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setInt(1, userId);
                deleteStmt.executeUpdate();
            }

            // Batch insert new slots
            if (availabilities != null && !availabilities.isEmpty()) {
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    for (UserAvailability slot : availabilities) {
                        insertStmt.setInt(1, userId);
                        insertStmt.setString(2, slot.getDayOfWeek());
                        insertStmt.setTime(3, slot.getStartTime());
                        insertStmt.setTime(4, slot.getEndTime());
                        insertStmt.addBatch();
                    }
                    insertStmt.executeBatch();
                }
            }

            conn.commit(); // Commit transaction
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}