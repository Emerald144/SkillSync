package com.skillsync.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.skillsync.dao.UserDAO;
import com.skillsync.model.User;
import com.skillsync.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember"); // "on" if checked

        // 1. Validate inputs
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
            return;
        }

        // Clean input
        String cleanEmail = email.trim().toLowerCase();
        String cleanPassword = password.trim();

        try {
            // 2. Lookup user by email
            User user = userDAO.getUserByEmail(cleanEmail);

            // --- CONSOLE DEBUGGING LOGS ---
            System.out.println("\n========== [LOGIN DEBUG LOG] ==========");
            System.out.println("Attempting login for Email: [" + cleanEmail + "]");
            System.out.println("User record found in DB: " + (user != null));

            if (user != null) {
                System.out.println("User ID: " + user.getUserId());
                System.out.println("DB Password Value: [" + user.getPassword() + "]");
                System.out.println("DB Password Length: " + (user.getPassword() != null ? user.getPassword().length() : 0));
                System.out.println("User Status: " + user.getStatus());
                System.out.println("User Role: " + user.getRole());
            }

            // 3. Password Verification
            boolean isValidPassword = false;

            if (user != null && user.getPassword() != null) {
                String dbPassword = user.getPassword().trim();

                // Check 1: BCrypt / Hashing verification via PasswordUtil
                try {
                    isValidPassword = PasswordUtil.checkPassword(cleanPassword, dbPassword);
                    System.out.println("PasswordUtil.checkPassword Result: " + isValidPassword);
                } catch (Exception e) {
                    System.out.println("PasswordUtil failed or threw exception: " + e.getMessage());
                }

                // Check 2: Fallback for unhashed / plain text passwords stored in DB
                if (!isValidPassword && cleanPassword.equals(dbPassword)) {
                    isValidPassword = true;
                    System.out.println("Plain text password match detected.");
                }
            }

            System.out.println("Final Verification Status: " + (isValidPassword ? "SUCCESS" : "FAILED"));
            System.out.println("========================================\n");

            if (user == null || !isValidPassword) {
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
                return;
            }

            // 4. Check account status (Blocks Suspended, Banned, and Deactivated)
            if (user.getStatus() != null) {
                String status = user.getStatus().trim();
                if ("Suspended".equalsIgnoreCase(status) || 
                    "Banned".equalsIgnoreCase(status) || 
                    "Deactivated".equalsIgnoreCase(status)) {
                    
                    request.setAttribute("error", "Your account has been " + status.toLowerCase() + ". Please contact support.");
                    request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
                    return;
                }
            }

            // 5. Success — Create Session
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user); // Store full object for easy JSP access
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("role", user.getRole());
            session.setAttribute("tokenBalance", user.getTokenBalance());

            // Set session duration
            if ("on".equals(remember)) {
                session.setMaxInactiveInterval(60 * 60 * 24 * 14); // 14 days
            } else {
                session.setMaxInactiveInterval(60 * 30); // 30 minutes
            }

            // Redirect based on role
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred. Please try again.");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect direct GET access back to the login JSP
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    }
}