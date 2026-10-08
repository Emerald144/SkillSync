package com.skillsync.controller;

import com.skillsync.dao.ReviewDAO;
import com.skillsync.model.Review;
import com.skillsync.model.User;
import com.skillsync.model.PendingReview;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/reviews")
public class ReviewsServlet extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        int userId = currentUser.getUserId();

        // 1. Fetch live reputation data
        int liveReputationScore = reviewDAO.getReputationScore(userId);
        
        // 2. Sync reputation score to active session user
        currentUser.setReputationScore(liveReputationScore);

        // 3. Fetch stats and review lists from DB
        double avgRating = reviewDAO.getAverageRating(userId);
        int totalReviews = reviewDAO.getReviewCount(userId);
        List<Review> reviewsList = reviewDAO.getReviewsForUser(userId);
        List<PendingReview> pendingReviews = reviewDAO.getPendingReviews(userId);

        // 4. Set attributes for JSP rendering
        request.setAttribute("rating", String.format("%.1f", avgRating));
        request.setAttribute("totalReviews", totalReviews);
        request.setAttribute("reputationScore", liveReputationScore);
        request.setAttribute("reputationTier", getReputationTier(liveReputationScore));
        request.setAttribute("reviews", reviewsList);
        request.setAttribute("pendingReviews", pendingReviews);

        request.getRequestDispatcher("/jsp/reviews.jsp").forward(request, response);
    }

    private String getReputationTier(int score) {
        if (score >= 1000) return "Platinum Mentor";
        if (score >= 500) return "Gold Mentor";
        if (score >= 250) return "Silver Mentor";
        return "Rising Mentor";
    }
}