package com.skillsync.util;

import java.sql.Connection;
import java.sql.SQLException;

public class TestConnection {
    public static void main(String[] args) throws SQLException {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            System.out.println("✅ Success: Connected to MySQL database 'skillsync'!");
        } else {
            System.out.println("❌ Failed: Could not connect to MySQL.");
        }
    }
}