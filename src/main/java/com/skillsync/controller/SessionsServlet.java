package com.skillsync.controller;

import com.skillsync.dao.SessionDAO;
import com.skillsync.model.Session;
import com.skillsync.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/sessions")
public class SessionsServlet extends HttpServlet {

    private final SessionDAO sessionDAO = new SessionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        // 1. Session မယူမီ Overdue/Stalled ဖြစ်နေသော Session များကို စစ်ဆေး၍ Status အလိုအလျောက် ပြောင်းပေးမည်
        sessionDAO.flagOverdueSessions();

        // 2. Request Parameter များကို ဖတ်ယူမည်
        String requestIdParam = request.getParameter("requestId");
        String activeTab = request.getParameter("tab");
        List<Session> sessions;

        if (requestIdParam != null && !requestIdParam.trim().isEmpty()) {
            try {
                int requestId = Integer.parseInt(requestIdParam);
                // requestId ပါလာပါက ၎င်း Request နှင့် သက်ဆိုင်သည့် Session ကို ဆွဲယူမည်
                sessions = sessionDAO.getSessionsForUserAndRequest(currentUser.getUserId(), requestId);
                
                if (sessions.isEmpty()) {
                    sessions = sessionDAO.getSessionsForUser(currentUser.getUserId());
                }
            } catch (NumberFormatException e) {
                sessions = sessionDAO.getSessionsForUser(currentUser.getUserId());
            }
        } else {
            // requestId မပါပါက User ၏ Sessions (Scheduled, Completed, Cancelled, Needs Review) အားလုံးကို ဆွဲယူမည်
            sessions = sessionDAO.getSessionsForUser(currentUser.getUserId());
        }

        // 3. JSP သို့ Sessions List နှင့် Active Tab Name ကို ပေးပို့မည် (Default Tab မှာ 'upcoming' ဖြစ်သည်)
        request.setAttribute("sessions", sessions);
        request.setAttribute("activeTab", activeTab != null ? activeTab : "upcoming");

        request.getRequestDispatcher("/jsp/sessions.jsp").forward(request, response);
    }
}