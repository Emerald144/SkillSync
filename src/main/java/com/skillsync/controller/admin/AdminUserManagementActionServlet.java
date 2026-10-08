package com.skillsync.controller.admin;

import com.skillsync.dao.NotificationDAO;
import com.skillsync.dao.UserDAO;
import com.skillsync.model.User;
import com.skillsync.util.AdminAuthCheck;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/user-action")
public class AdminUserManagementActionServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check Admin Session Authentication
        if (!AdminAuthCheck.verifyAdmin(request, response)) {
            return;
        }

        try {
            int targetUserId = Integer.parseInt(request.getParameter("userId"));
            String action = request.getParameter("action"); // "suspend", "activate", "delete"

            // 2. Fetch target user details to guard Admin role protection
            User targetUser = userDAO.getUserById(targetUserId);

            if (targetUser == null) {
                request.getSession().setAttribute("flashError", "Target user not found.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            // 3. Prevent actions against ADMIN accounts
            if ("ADMIN".equalsIgnoreCase(targetUser.getRole())) {
                request.getSession().setAttribute("flashError", "Administrative accounts cannot be modified or deleted.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            // 4. Perform Action
            switch (action.toLowerCase()) {
                case "suspend":
                    userDAO.updateUserStatus(targetUserId, "Suspended");
                    notificationDAO.createNotification(
                        targetUserId,
                        "ACCOUNT_SUSPENDED",
                        "Account Suspended",
                        "Your account has been suspended by an administrator."
                    );
                    request.getSession().setAttribute("flashMessage", "User " + targetUser.getFullName() + " suspended successfully.");
                    break;

                case "activate":
                    userDAO.updateUserStatus(targetUserId, "Active");
                    notificationDAO.createNotification(
                        targetUserId,
                        "ACCOUNT_ACTIVATED",
                        "Account Restored",
                        "Your account has been reactivated by an administrator."
                    );
                    request.getSession().setAttribute("flashMessage", "User " + targetUser.getFullName() + " reactivated successfully.");
                    break;

                case "delete":
                    userDAO.deleteUser(targetUserId);
                    request.getSession().setAttribute("flashMessage", "User " + targetUser.getFullName() + " deleted permanently.");
                    break;

                default:
                    request.getSession().setAttribute("flashError", "Invalid user management action.");
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("flashError", "An error occurred while processing the user action.");
        }

        // Redirect back to User Management page
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}