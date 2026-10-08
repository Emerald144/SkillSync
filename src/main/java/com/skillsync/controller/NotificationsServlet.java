package com.skillsync.controller;

import com.skillsync.dao.NotificationDAO;
import com.skillsync.model.Notification;
import com.skillsync.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/notifications")
public class NotificationsServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        int userId = currentUser.getUserId();
        List<Notification> notifications = notificationDAO.getNotificationsForUser(userId);
        int unreadCount = notificationDAO.getUnreadCount(userId);

        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);

        request.getRequestDispatcher("/jsp/notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("MARK_ALL_READ".equalsIgnoreCase(action)) {
            notificationDAO.markAllAsRead(currentUser.getUserId());
        }

        response.sendRedirect(request.getContextPath() + "/notifications");
    }
}