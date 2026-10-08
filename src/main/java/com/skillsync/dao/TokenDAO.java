package com.skillsync.dao;

import com.skillsync.model.TokenTransaction;
import com.skillsync.util.DBConnection; // Adjust import to match your database connection class

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TokenDAO {

    public int getBalance(int userId) {
        String sql = "SELECT token_balance FROM Users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("token_balance");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean processSessionPayment(int sessionId, int learnerId, int teacherId, int amount, String sessionTitle) {
        String deductSql = "UPDATE Users SET token_balance = token_balance - ? WHERE user_id = ? AND token_balance >= ?";
        String addSql = "UPDATE Users SET token_balance = token_balance + ? WHERE user_id = ?";
        String recordTxSql = "INSERT INTO token_transactions (sender_id, receiver_id, session_id, amount, reason, transaction_type) VALUES (?, ?, ?, ?, ?, 'SESSION_PAYMENT')";
        String updateSessionSql = "UPDATE sessions SET status = 'completed' WHERE session_id = ? AND LOWER(status) <> 'completed'";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin atomic transaction

            // 1. Deduct tokens from learner (Atomic check)
            try (PreparedStatement psDeduct = conn.prepareStatement(deductSql)) {
                psDeduct.setInt(1, amount);
                psDeduct.setInt(2, learnerId);
                psDeduct.setInt(3, amount);
                if (psDeduct.executeUpdate() == 0) {
                    conn.rollback(); // Insufficient balance or invalid learner
                    return false;
                }
            }

            // 2. Add tokens to teacher
            try (PreparedStatement psAdd = conn.prepareStatement(addSql)) {
                psAdd.setInt(1, amount);
                psAdd.setInt(2, teacherId);
                if (psAdd.executeUpdate() == 0) {
                    conn.rollback(); // Invalid teacher user ID
                    return false;
                }
            }

            // 3. Insert transaction log
            try (PreparedStatement psTx = conn.prepareStatement(recordTxSql)) {
                psTx.setInt(1, learnerId);
                psTx.setInt(2, teacherId);
                psTx.setInt(3, sessionId);
                psTx.setInt(4, amount);
                psTx.setString(5, sessionTitle);
                psTx.executeUpdate();
            }

            // 4. Update session status to completed
            try (PreparedStatement psSession = conn.prepareStatement(updateSessionSql)) {
                psSession.setInt(1, sessionId);
                if (psSession.executeUpdate() == 0) {
                    conn.rollback(); // Session already completed or invalid ID
                    return false;
                }
            }

            conn.commit(); // Commit all changes together
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

    public List<TokenTransaction> getTransactions(int userId) {
        List<TokenTransaction> list = new ArrayList<>();
        String sql = "SELECT t.*, " +
                     "CASE WHEN t.sender_id = ? THEN u_rec.full_name ELSE u_send.full_name END AS counterparty " +
                     "FROM token_transactions t " +
                     "LEFT JOIN Users u_send ON t.sender_id = u_send.user_id " +
                     "LEFT JOIN Users u_rec ON t.receiver_id = u_rec.user_id " +
                     "WHERE t.sender_id = ? OR t.receiver_id = ? " +
                     "ORDER BY t.transaction_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TokenTransaction tx = new TokenTransaction();
                tx.setTransactionId(rs.getInt("transaction_id"));
                tx.setSenderId((Integer) rs.getObject("sender_id"));
                tx.setReceiverId((Integer) rs.getObject("receiver_id"));
                tx.setSessionId((Integer) rs.getObject("session_id"));
                tx.setAmount(rs.getInt("amount"));
                tx.setReason(rs.getString("reason"));
                tx.setTransactionType(rs.getString("transaction_type"));
                tx.setTransactionDate(rs.getTimestamp("transaction_date"));
                tx.setCounterpartyName(rs.getString("counterparty"));
                list.add(tx);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}