package com.skillsync.controller;

import com.skillsync.dao.NotificationDAO;
import com.skillsync.dao.SessionDAO;
import com.skillsync.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/schedule-session")
public class ScheduleSessionServlet extends HttpServlet {

    private final SessionDAO sessionDAO = new SessionDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            int teacherId = Integer.parseInt(request.getParameter("teacherId"));
            int learnerId = Integer.parseInt(request.getParameter("learnerId"));
            String sessionType = request.getParameter("sessionType"); // "Online" or "In-Person"
            String location = request.getParameter("location");
            String meetingLink = request.getParameter("meetingLink");
            String sessionDateStr = request.getParameter("sessionDate"); // from <input type="datetime-local">

            // Only the teacher or learner on this request may schedule it
            if (currentUser.getUserId() != teacherId && currentUser.getUserId() != learnerId) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            if (sessionDAO.sessionExistsForRequest(requestId)) {
                response.sendRedirect(request.getContextPath() + "/requests");
                return;
            }

            Timestamp sessionDate = Timestamp.valueOf(sessionDateStr.replace("T", " ") + ":00");

            boolean created = sessionDAO.createSession(
                requestId, teacherId, learnerId, sessionType, location, meetingLink, sessionDate
            );

            if (created) {
                int otherUserId = (currentUser.getUserId() == teacherId) ? learnerId : teacherId;
                notificationDAO.createNotification(
                    otherUserId,
                    "session",
                    "Session scheduled",
                    currentUser.getFullName() + " scheduled your session"
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/sessions");
    }
}