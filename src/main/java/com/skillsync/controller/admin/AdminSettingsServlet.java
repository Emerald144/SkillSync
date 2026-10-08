package com.skillsync.controller.admin;

import com.skillsync.model.User;
import com.skillsync.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;

@WebServlet("/admin/settings")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminSettingsServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        if (currentUser.getRole() == null || !"ADMIN".equalsIgnoreCase(currentUser.getRole().trim())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // Forward to settings JSP page
        request.getRequestDispatcher("/jsp/admin/settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || currentUser.getRole() == null || !"ADMIN".equalsIgnoreCase(currentUser.getRole().trim())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            handleProfileUpdate(request, response, session, currentUser);
        } else if ("changePassword".equals(action)) {
            handlePasswordChange(request, response, session, currentUser);
        } else {
            session.setAttribute("flashError", "Invalid form submission.");
            response.sendRedirect(request.getContextPath() + "/admin/settings");
        }
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response, 
                                       HttpSession session, User currentUser) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");

        if (fullName == null || fullName.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            session.setAttribute("flashError", "Full name and email are required fields.");
            response.sendRedirect(request.getContextPath() + "/admin/settings");
            return;
        }

        // Handle File Upload for Profile Picture
        Part filePart = request.getPart("profilePhoto");
        String photoPath = currentUser.getProfilePhoto();

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String extension = fileName.substring(fileName.lastIndexOf("."));
            String newFileName = "admin_" + currentUser.getUserId() + "_" + System.currentTimeMillis() + extension;

            String uploadDir = getServletContext().getRealPath("/") + "uploads/profiles";
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) uploadDirFile.mkdirs();

            filePart.write(uploadDir + File.separator + newFileName);
            photoPath = "uploads/profiles/" + newFileName;
        }

        // Update object & database
        currentUser.setFullName(fullName.trim());
        currentUser.setEmail(email.trim());
        currentUser.setProfilePhoto(photoPath);

        boolean updated = false;
        try {
            updated = userDAO.updateUserProfile(currentUser);
        } catch (SQLException e) {
            System.err.println("Database error while updating admin profile: " + e.getMessage());
            e.printStackTrace();
        }

        if (updated) {
            session.setAttribute("currentUser", currentUser);
            session.setAttribute("flashMessage", "Profile updated successfully!");
        } else {
            session.setAttribute("flashError", "Failed to update profile. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/settings");
    }

    private void handlePasswordChange(HttpServletRequest request, HttpServletResponse response, 
                                        HttpSession session, User currentUser) throws IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || newPassword == null || confirmPassword == null ||
            currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            session.setAttribute("flashError", "All password fields are required.");
            response.sendRedirect(request.getContextPath() + "/admin/settings");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("flashError", "New password and confirmation do not match.");
            response.sendRedirect(request.getContextPath() + "/admin/settings");
            return;
        }

        if (newPassword.length() < 6) {
            session.setAttribute("flashError", "New password must be at least 6 characters long.");
            response.sendRedirect(request.getContextPath() + "/admin/settings");
            return;
        }

        // Verify current password against database
        boolean isCurrentPasswordValid = userDAO.verifyPassword(currentUser.getUserId(), currentPassword);
        if (!isCurrentPasswordValid) {
            session.setAttribute("flashError", "Current password is incorrect.");
            response.sendRedirect(request.getContextPath() + "/admin/settings");
            return;
        }

        // Update password
        boolean passwordUpdated = userDAO.updatePassword(currentUser.getUserId(), newPassword);
        if (passwordUpdated) {
            currentUser.setPassword(newPassword);
            session.setAttribute("currentUser", currentUser);
            session.setAttribute("flashMessage", "Password updated successfully!");
        } else {
            session.setAttribute("flashError", "Failed to change password. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/settings");
    }
}