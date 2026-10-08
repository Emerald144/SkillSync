package com.skillsync.dao;

import com.skillsync.model.Report;
import com.skillsync.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO {

    public boolean createReport(int reporterId, int reportedUserId, String reason, String description) {
        String sql = "INSERT INTO reports (reporter_id, reported_user_id, reason, description, status) VALUES (?, ?, ?, ?, 'Pending')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reporterId);
            ps.setInt(2, reportedUserId);
            ps.setString(3, reason);
            ps.setString(4, description);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Report> getAllReports() {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT r.*, u1.full_name AS reporter_name, u2.full_name AS reported_name " +
                     "FROM reports r " +
                     "JOIN users u1 ON r.reporter_id = u1.user_id " +
                     "JOIN users u2 ON r.reported_user_id = u2.user_id " +
                     "ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToReport(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Report getReportById(int reportId) {
        String sql = "SELECT r.*, u1.full_name AS reporter_name, u2.full_name AS reported_name " +
                     "FROM reports r " +
                     "JOIN users u1 ON r.reporter_id = u1.user_id " +
                     "JOIN users u2 ON r.reported_user_id = u2.user_id " +
                     "WHERE r.report_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReport(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateReportStatus(int reportId, String status, String adminNote) {
        String sql = "UPDATE reports SET status = ?, admin_note = ?, resolved_at = NOW() WHERE report_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, adminNote);
            ps.setInt(3, reportId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateReportStatus(int reportId, String status) {
        // Calls your existing 3-parameter method, passing null for the adminNote
        return updateReportStatus(reportId, status, null);
    }

    public int getPendingReportCount() {
        String sql = "SELECT COUNT(*) FROM reports WHERE status = 'Pending'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Report mapResultSetToReport(ResultSet rs) throws SQLException {
        Report r = new Report();
        r.setReportId(rs.getInt("report_id"));
        r.setReporterId(rs.getInt("reporter_id"));
        r.setReportedUserId(rs.getInt("reported_user_id"));
        r.setReason(rs.getString("reason"));
        r.setDescription(rs.getString("description"));
        r.setStatus(rs.getString("status"));
        r.setAdminNote(rs.getString("admin_note"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        r.setResolvedAt(rs.getTimestamp("resolved_at"));
        r.setReporterName(rs.getString("reporter_name"));
        r.setReportedUserName(rs.getString("reported_name"));
        return r;
    }
    
    public List<Report> getReportsByStatus(String status) {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT r.*, u1.full_name AS reporter_name, u2.full_name AS reported_name " +
                     "FROM reports r " +
                     "JOIN users u1 ON r.reporter_id = u1.user_id " +
                     "JOIN users u2 ON r.reported_user_id = u2.user_id " +
                     "WHERE r.status = ? " +
                     "ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToReport(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}