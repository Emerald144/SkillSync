package com.skillsync.controller;

import com.skillsync.dao.UserDAO;
import com.skillsync.model.MatchResult;
import com.skillsync.model.User;
import com.skillsync.service.MatchingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/matching")
public class MatchingServlet extends HttpServlet {
    private MatchingService matchingService;
    private UserDAO userDAO;

    @Override
    public void init() {
        matchingService = new MatchingService();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = null;
        if (session != null) {
            currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                currentUser = (User) session.getAttribute("user");
            }
        }

        int userId = (currentUser != null) ? currentUser.getUserId() : -1;
        List<MatchResult> matchedCandidates = matchingService.getRankedMatches(userId);

        if (userId != -1 && matchedCandidates != null) {
            for (MatchResult match : matchedCandidates) {
                try {
                    boolean sent = userDAO.hasPendingRequest(userId, match.getUserId()); // သို့မဟုတ် မိမိ UserDAO တွင် သုံးထားသည့် method name
                    match.setRequestSent(sent);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        request.setAttribute("matches", matchedCandidates);
        request.getRequestDispatcher("/jsp/aimatching.jsp").forward(request, response);
    }
}