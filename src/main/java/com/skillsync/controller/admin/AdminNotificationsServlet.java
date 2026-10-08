package com.skillsync.controller.admin;

import com.skillsync.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/notifications")
public class AdminNotificationsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Security check: restrict access to logged-in Admin users only
        if (currentUser == null || !"Admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have admin privileges.");
            return;
        }

        // TODO: Replace with DAO calls to fetch admin notifications and unread counts
        // Example:
        // List<Notification> notifications = notificationDAO.getAdminNotifications();
        // int unreadCount = notificationDAO.getUnreadCountForAdmin();

        request.setAttribute("unreadCount", 3);
        
        // Forward request to the admin notifications JSP page
        request.getRequestDispatcher("/jsp/admin-notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || !"Admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        
        if ("MARK_READ".equals(action)) {
            String notificationId = request.getParameter("notificationId");
            // TODO: Execute DB update to mark specific notification as read
        } else if ("MARK_ALL_READ".equals(action)) {
            // TODO: Execute DB update to mark all notifications as read
        }

        response.sendRedirect(request.getContextPath() + "/admin/notifications");
    }
}