package com.skillsync.controller;

import com.skillsync.dao.ReportDAO;
import com.skillsync.dao.UserDAO;
import com.skillsync.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/report-user")
public class ReportUserServlet extends HttpServlet {

    private final ReportDAO reportDAO = new ReportDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        try {
            int targetUserId = Integer.parseInt(request.getParameter("userId"));
            User targetUser = userDAO.getUserById(targetUserId);
            
            if (targetUser == null) {
                session.setAttribute("flashError", "Target user not found.");
                response.sendRedirect(request.getContextPath() + "/search");
                return;
            }

            request.setAttribute("targetUser", targetUser);
            request.getRequestDispatcher("/jsp/report-user.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/search");
        }
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

        try {
            int reportedUserId = Integer.parseInt(request.getParameter("reportedUserId"));
            String reason = request.getParameter("reason");
            String description = request.getParameter("description");

            boolean success = reportDAO.createReport(currentUser.getUserId(), reportedUserId, reason, description);

            if (success) {
                session.setAttribute("flashMessage", "Report submitted successfully. Our admin team will review it.");
            } else {
                session.setAttribute("flashError", "Failed to submit report. Please try again.");
            }
        } catch (Exception e) {
            session.setAttribute("flashError", "Invalid report request.");
        }

        response.sendRedirect(request.getContextPath() + "/search");
    }
}