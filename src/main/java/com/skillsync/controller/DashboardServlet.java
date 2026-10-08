package com.skillsync.controller;

import com.skillsync.model.User;
import com.skillsync.model.MatchResult;
import com.skillsync.model.Review;
import com.skillsync.model.UserBadge; // Assuming your badge model
import com.skillsync.model.Skill;     // Assuming your skill model
import com.skillsync.service.MatchingService;
import com.skillsync.dao.UserDAO;
import com.skillsync.dao.LearningRequestDAO;
import com.skillsync.dao.MessageDAO;
import com.skillsync.dao.ReviewDAO;
import com.skillsync.dao.SessionDAO;
import com.skillsync.dao.BadgeDAO;
import com.skillsync.dao.SkillDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private MatchingService matchingService;
    private UserDAO userDAO;
    private LearningRequestDAO requestDAO;
    private MessageDAO messageDAO;
    private ReviewDAO reviewDAO;
    private SessionDAO sessionDAO;
    private BadgeDAO badgeDAO;
    private SkillDAO skillDAO;

    @Override
    public void init() {
        matchingService = new MatchingService();
        userDAO = new UserDAO();
        requestDAO = new LearningRequestDAO();
        messageDAO = new MessageDAO();
        reviewDAO = new ReviewDAO();
        sessionDAO = new SessionDAO();
        badgeDAO = new BadgeDAO();
        skillDAO = new SkillDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Redirect to login if user session does not exist
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        int userId = currentUser.getUserId();

        // 1. Refresh currentUser from DB
        User freshUser = userDAO.getUserById(userId);
        if (freshUser != null) {
            session.setAttribute("currentUser", freshUser);
            currentUser = freshUser;
        }

        // 2. Fetch AI Recommendations
        List<MatchResult> topMatches = matchingService.getRankedMatches(userId);
        if (topMatches != null && topMatches.size() > 2) {
            topMatches = topMatches.subList(0, 2);
        }

        // 3. Fetch Navbar & Badge Data
        int pendingCount = requestDAO.getPendingCount(userId);
        int unreadMessageCount = messageDAO.getUnreadMessageCount(userId);

        // 4. Fetch Metric Cards & Review Data
        int completedSessionsCount = sessionDAO.getCompletedSessionCount(userId);
        double averageRating = reviewDAO.getAverageRating(userId);       
        int reviewCount = reviewDAO.getReviewCount(userId);
        List<Review> recentReviews = reviewDAO.getRecentReviewsForUser(userId, 2);

        // 5. Fetch Dynamic Achievements/Badges
        UserBadge latestBadge = badgeDAO.getLatestBadgeForUser(userId);
        int unlockedBadgesCount = badgeDAO.getUnlockedBadgeCount(userId);
        int totalBadgesCount = badgeDAO.getTotalBadgeCount();
        int badgeProgressPercentage = (totalBadgesCount > 0) ? (unlockedBadgesCount * 100 / totalBadgesCount) : 0;

        // 6. Fetch Popular Skills
        List<Skill> popularSkills = skillDAO.getPopularSkills(2); // Fetch top 2 trending skills

        // 7. Attach all retrieved metrics to request scope
        request.setAttribute("topMatches", topMatches);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("unreadMessageCount", unreadMessageCount);
        request.setAttribute("completedSessionsCount", completedSessionsCount);
        request.setAttribute("avgRating", averageRating);
        request.setAttribute("totalReviews", reviewCount);
        request.setAttribute("recentReviews", recentReviews);

        // Achievements request attributes
        request.setAttribute("latestBadge", latestBadge);
        request.setAttribute("unlockedBadgesCount", unlockedBadgesCount);
        request.setAttribute("totalBadgesCount", totalBadgesCount);
        request.setAttribute("badgeProgressPercentage", badgeProgressPercentage);

        // Popular Skills request attribute
        request.setAttribute("popularSkills", popularSkills);

        // Forward request and response to JSP
        request.getRequestDispatcher("/jsp/dashboard.jsp").forward(request, response);
    }
}