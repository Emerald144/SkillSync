package com.skillsync.controller;

import com.skillsync.dao.BadgeDAO;
import com.skillsync.dao.UserStatsDAO; // 1. UserStatsDAO ကို import လုပ်ပါ
import com.skillsync.model.Badge;
import com.skillsync.model.UserBadge;
import com.skillsync.model.User;
import com.skillsync.model.UserStats; // 2. UserStats Model ကို import လုပ်ပါ

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/achievements")
public class AchievementsServlet extends HttpServlet {

    private final BadgeDAO badgeDAO = new BadgeDAO();
    private final UserStatsDAO statsDAO = new UserStatsDAO(); // 3. UserStatsDAO instance ဆောက်ပါ

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
        
        // Data များ DAO ထံမှ ရယူခြင်း
        List<Badge> allBadges = badgeDAO.getAllBadges();
        List<UserBadge> userBadges = badgeDAO.getUserBadges(userId);
        UserStats stats = statsDAO.getUserStats(userId); // 4. User ရဲ့ Stats များကို ရယူပါ

        Set<Integer> earnedBadgeIds = new HashSet<>();
        for (UserBadge ub : userBadges) {
            earnedBadgeIds.add(ub.getBadgeId());
        }

        // 5. Badge တစ်ခုချင်းစီအတွက် User ရဲ့ လက်ရှိ Progress ကို calculate လုပ်ပြီး သတ်မှတ်ပေးခြင်း
        if (allBadges != null) {
            for (Badge b : allBadges) {
                double current = 0.0;
                String reqType = b.getRequirementType();

                if (reqType != null) {
                    switch (reqType.toUpperCase()) {
                        case "SESSIONS_COMPLETED":
                            current = stats.getSessionsCompleted();
                            break;
                        case "REPUTATION_SCORE":
                            current = stats.getReputationScore();
                            break;
                        case "TOKENS_EARNED":
                            current = currentUser.getTokenBalance();
                            break;
                        case "STREAK_DAYS":
                            current = stats.getStreakDays();
                            break;
                        default:
                            current = 0.0;
                            break;
                    }
                }
                b.setCurrentProgress(current);
            }
        }

        // 6. JSP စာမျက်နှာအတွက် Request Attributes များ ပေးပို့ခြင်း
        request.setAttribute("allBadges", allBadges);
        request.setAttribute("userBadges", userBadges);
        request.setAttribute("earnedBadgeIds", earnedBadgeIds);
        request.setAttribute("stats", stats); // JSP ရှိ Stat Cards များ (sessions, rating, reputation) အတွက်

        request.getRequestDispatcher("/jsp/achievements.jsp").forward(request, response);
    } 
}