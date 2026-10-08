package com.skillsync.controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.skillsync.dao.UserDAO;
import com.skillsync.dao.SkillDAO;
import com.skillsync.dao.AvailabilityDAO;
import com.skillsync.dao.InterestDAO;
import com.skillsync.dao.ReviewDAO;
import com.skillsync.dao.BadgeDAO;

import com.skillsync.model.User;
import com.skillsync.model.UserSkill;
import com.skillsync.model.UserAvailability;
import com.skillsync.model.UserBadge;
import com.skillsync.model.Interest;
import com.skillsync.model.Review;
import com.skillsync.model.Badge;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private SkillDAO skillDAO;
    private AvailabilityDAO availabilityDAO;
    private InterestDAO interestDAO;
    private ReviewDAO reviewDAO;
    private BadgeDAO badgeDAO;

    @Override
    public void init() {
        this.userDAO = new UserDAO();
        this.skillDAO = new SkillDAO();
        this.availabilityDAO = new AvailabilityDAO();
        this.interestDAO = new InterestDAO();
        this.reviewDAO = new ReviewDAO();
        this.badgeDAO = new BadgeDAO();
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

        String userIdParam = request.getParameter("userId");
        if (userIdParam == null || userIdParam.trim().isEmpty()) {
            userIdParam = request.getParameter("id");
        }

        int targetUserId;
        User profileUser = null;

        if (userIdParam != null && !userIdParam.trim().isEmpty()) {
            try {
                targetUserId = Integer.parseInt(userIdParam.trim());
                profileUser = userDAO.getUserById(targetUserId); 
            } catch (NumberFormatException e) {
                targetUserId = currentUser.getUserId();
                profileUser = currentUser;
            }
        } else {
            targetUserId = currentUser.getUserId();
            profileUser = currentUser;
        }

        if (profileUser == null) {
            targetUserId = currentUser.getUserId();
            profileUser = currentUser;
        }

        try {
            request.setAttribute("profileUser", profileUser);
            boolean isOwnProfile = (profileUser.getUserId() == currentUser.getUserId());
            request.setAttribute("isOwnProfile", isOwnProfile);

            // Fetch Skills, Availability, Interests
            List<UserSkill> userSkills = skillDAO.getSkillsByUserId(targetUserId);
            request.setAttribute("userSkills", userSkills);

            List<UserAvailability> userAvailabilities = availabilityDAO.getAvailabilityByUserId(targetUserId);
            request.setAttribute("userAvailabilities", userAvailabilities);

            List<Interest> userInterests = interestDAO.getInterestsByUserId(targetUserId);
            request.setAttribute("userInterests", userInterests);

            // Fetch Reviews & Ratings
            List<Review> userReviews = reviewDAO.getReviewsForUser(targetUserId);
            double avgRating = reviewDAO.getAverageRating(targetUserId);
            int reviewCount = reviewDAO.getReviewCount(targetUserId);

            request.setAttribute("userReviews", userReviews);
            request.setAttribute("avgRating", String.format("%.1f", avgRating));
            request.setAttribute("reviewCount", reviewCount);

            // Fetch Dynamic Badges and Calculate Progress
            List<UserBadge> userBadges = badgeDAO.getUserBadges(targetUserId);
            int totalAvailableBadges = badgeDAO.getTotalBadgeCount(); 
            if (totalAvailableBadges == 0) totalAvailableBadges = 15; // Fallback default

            int earnedCount = (userBadges != null) ? userBadges.size() : 0;
            int progressPercent = (int) Math.round(((double) earnedCount / totalAvailableBadges) * 100);

            request.setAttribute("userBadges", userBadges);
            request.setAttribute("earnedBadgeCount", earnedCount);
            request.setAttribute("totalBadgeCount", totalAvailableBadges);
            request.setAttribute("badgeProgressPercent", progressPercent);

            // 1. Fetch completed sessions count (teaching + learning)
            int completedSessionsCount = 0;
            try {
                // If SessionDAO is available:
                // completedSessionsCount = sessionDAO.getCompletedSessionCountByUserId(targetUserId);
                completedSessionsCount = reviewCount; // Fallback to review count if no sessionDAO yet
            } catch (Exception e) {
                completedSessionsCount = 0;
            }

            // 2. Fetch learning streak days
            int currentStreak = 0;
            try {
                // If stored in User object or DAO:
                // currentStreak = userDAO.getLearningStreakDays(targetUserId);
                currentStreak = 14; // Default fallback value
            } catch (Exception e) {
                currentStreak = 0;
            }

            // Pass statistics attributes to request
            request.setAttribute("completedSessionsCount", completedSessionsCount);
            request.setAttribute("currentStreak", currentStreak);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/jsp/profile.jsp").forward(request, response);
    }
}