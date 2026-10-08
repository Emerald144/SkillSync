package com.skillsync.util;

import com.skillsync.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class AdminAuthCheck {

    public static boolean verifyAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // 1. Not logged in at all -> Redirect to Login JSP
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return false;
        }

        // 2. Logged in, but NOT an admin -> Redirect to Regular User Dashboard
        if (!"Admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return false;
        }

        // 3. Authenticated Admin -> Allow access
        return true;
    }
}