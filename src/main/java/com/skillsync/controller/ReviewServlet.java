package com.skillsync.controller;

import com.skillsync.dao.NotificationDAO;
import com.skillsync.dao.ReviewDAO;
import com.skillsync.dao.SessionDAO;
import com.skillsync.model.User;
import com.skillsync.model.Session;
import com.skillsync.service.BadgeService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final SessionDAO sessionDAO = new SessionDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final BadgeService badgeService = new BadgeService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        try {
            int sessionId = Integer.parseInt(request.getParameter("sessionId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("reviewText");

            // 1. Input Validation
            if (rating < 1 || rating > 5 || comment == null || comment.trim().isEmpty() || comment.length() > 1000) {
                response.sendRedirect(request.getContextPath() + "/reviews?error=invalid");
                return;
            }

            int reviewerId = currentUser.getUserId();

            // 2. Prevent Duplicate Reviews
            if (reviewDAO.hasReviewed(sessionId, reviewerId)) {
                response.sendRedirect(request.getContextPath() + "/reviews?error=duplicate");
                return;
            }

            // 3. Save Review
            boolean success = reviewDAO.addReview(sessionId, reviewerId, rating, comment);

            if (success) {
                // Determine Reviewee (Teacher or Learner)
                Session currentSession = sessionDAO.getSessionById(sessionId);
                int revieweeId = 0;

                if (currentSession != null) {
                    revieweeId = (currentSession.getLearnerId() == reviewerId) 
                            ? currentSession.getTeacherId() 
                            : currentSession.getLearnerId();
                }

                if (revieweeId > 0) {
                    // 1. Notify Reviewee (Passing sessionId as 5th argument relatedId)
                    notificationDAO.createNotification(
                        revieweeId,
                        "NEW_REVIEW",
                        "New Review Received",
                        currentUser.getFullName() + " left you a new review.",
                        sessionId
                    );

                    // 2. Re-evaluate Badges for Reviewee
                    badgeService.checkBadges(revieweeId);
                }

                response.sendRedirect(request.getContextPath() + "/reviews?success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/reviews?error=failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/reviews?error=invalid");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/reviews?error=system");
        }
    }
}