package com.skillsync.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    // Hash raw password before saving to DB
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            return null;
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    // Verify raw input against stored hash
    public static boolean checkPassword(String plainPassword, String storedPassword) {
        if (plainPassword == null || storedPassword == null || storedPassword.isEmpty()) {
            return false;
        }
        
        // Fallback for old plain-text entries in database (e.g. User12345)
        if (!storedPassword.startsWith("$2a$") && !storedPassword.startsWith("$2b$")) {
            return plainPassword.equals(storedPassword);
        }

        return BCrypt.checkpw(plainPassword, storedPassword);
    }
}