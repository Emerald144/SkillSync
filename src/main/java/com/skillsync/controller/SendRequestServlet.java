package com.skillsync.controller;

import com.skillsync.dao.LearningRequestDAO;
import com.skillsync.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/send-request")
public class SendRequestServlet extends HttpServlet {

    private final LearningRequestDAO requestDAO = new LearningRequestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = null;
        if (session != null) {
            currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                currentUser = (User) session.getAttribute("user"); // matches your other servlets' fallback
            }
        }

        if (currentUser == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Not logged in");
            return;
        }

        String receiverIdParam = request.getParameter("receiverId");
        String skillIdParam = request.getParameter("skillId");

        if (receiverIdParam == null || skillIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        try {
            int senderId = currentUser.getUserId();
            int receiverId = Integer.parseInt(receiverIdParam);
            int skillId = Integer.parseInt(skillIdParam);

            if (senderId == receiverId) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Cannot send a request to yourself");
                return;
            }

            if (skillId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No valid skill to request");
                return;
            }

            boolean created = requestDAO.createRequest(senderId, receiverId, skillId);

            if (created) {
                response.setStatus(HttpServletResponse.SC_OK); // plain 200, no body — AJAX just checks response.ok
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Insert failed");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
        }
    }
}