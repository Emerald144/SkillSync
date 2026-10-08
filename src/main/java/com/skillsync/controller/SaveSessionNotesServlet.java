package com.skillsync.controller;

import com.skillsync.dao.SessionDAO;
import com.skillsync.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/save-session-notes")
public class SaveSessionNotesServlet extends HttpServlet {
    private final SessionDAO sessionDAO = new SessionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            int sessionId = Integer.parseInt(request.getParameter("sessionId"));
            String notes = request.getParameter("notes");
            boolean updated = sessionDAO.updateSessionNotes(sessionId, notes);
            response.setStatus(updated ? HttpServletResponse.SC_OK : HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}