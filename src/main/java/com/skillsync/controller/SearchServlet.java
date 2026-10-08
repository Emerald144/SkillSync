package com.skillsync.controller;

import com.skillsync.dao.UserDAO;
import com.skillsync.dao.InterestDAO;
import com.skillsync.model.User;
import com.skillsync.model.UserSearchResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private InterestDAO interestDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        interestDAO = new InterestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get parameters from the search.jsp form
        String rawQuery = request.getParameter("q");
        String rawUniversity = request.getParameter("uni");
        String minRatingStr = request.getParameter("minRating");

        // Normalize query string (convert empty/whitespace string to null)
        String query = rawQuery;
        if (query != null && query.trim().isEmpty()) {
            query = null;
        }

        // Normalize university string (if null, empty, or "all", convert to null)
        String university = rawUniversity;
        if (university != null && (university.trim().isEmpty() || "all".equalsIgnoreCase(university.trim()))) {
            university = null;
        }

        // Parse rating safely (default to 0.0 if not provided)
        double minRating = 0.0;
        if (minRatingStr != null && !minRatingStr.isEmpty()) {
            try {
                minRating = Double.parseDouble(minRatingStr);
            } catch (NumberFormatException e) {
                minRating = 0.0;
            }
        }

        // Get current user session to exclude logged-in user and calculate common interests
        HttpSession session = request.getSession(false);
        User currentUser = null;
        if (session != null) {
            currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                currentUser = (User) session.getAttribute("user");
            }
        }
        int currentUserId = (currentUser != null) ? currentUser.getUserId() : -1;

        // 2. Pass parameters to DAO and execute database search
        List<UserSearchResult> matchedUsers = userDAO.searchUsers(query, university, minRating, currentUserId);

        // 3. Fetch dynamic distinct universities for the dropdown filter
        List<String> dynamicUniversities = userDAO.getAllDistinctUniversities();

        // 4. Calculate dynamic match percentage based on common interests
        if (currentUserId != -1 && matchedUsers != null) {
            for (UserSearchResult result : matchedUsers) {
                try {
                    List<String> common = interestDAO.getCommonInterests(currentUserId, result.getId());
                    result.setCommonInterests(common);

                    int baseMatch = 70;
                    int calculatedMatch = Math.min(99, baseMatch + (common.size() * 10));
                    result.setMatch(calculatedMatch);

                    // Populate requestSent so Connect button shows correct state
                    boolean sent = userDAO.hasPendingRequest(currentUserId, result.getId());
                    result.setRequestSent(sent);

                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        // 5. Set attributes back into the request object
        request.setAttribute("people", matchedUsers);
        request.setAttribute("universities", dynamicUniversities);
        
        // Preserve parameter values for search.jsp form retention
        request.setAttribute("selectedQuery", rawQuery != null ? rawQuery : "");
        request.setAttribute("selectedUni", rawUniversity != null ? rawUniversity : "all");
        request.setAttribute("selectedMinRating", minRatingStr != null ? minRatingStr : "");

        // 6. Forward the request back to search.jsp
        request.getRequestDispatcher("/jsp/search.jsp").forward(request, response);
    }
}