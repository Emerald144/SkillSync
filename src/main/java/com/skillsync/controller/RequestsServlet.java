package com.skillsync.controller;

import com.skillsync.dao.LearningRequestDAO;
import com.skillsync.dao.NotificationDAO;
import com.skillsync.dao.SessionDAO;
import com.skillsync.model.LearningRequest;
import com.skillsync.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/requests")
public class RequestsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final LearningRequestDAO requestDAO = new LearningRequestDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final SessionDAO sessionDAO = new SessionDAO(); // Step 3 Addition: SessionDAO Instance

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null && session != null) {
            currentUser = (User) session.getAttribute("user");
        }

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        int userId = currentUser.getUserId();
        List<LearningRequest> pending = requestDAO.getRequestsByReceiverAndStatus(userId, "Pending");
        List<LearningRequest> accepted = requestDAO.getRequestsByReceiverAndStatus(userId, "Accepted");
        List<LearningRequest> rejected = requestDAO.getRequestsByReceiverAndStatus(userId, "Rejected");
        List<LearningRequest> sent = requestDAO.getAllRequestsBySender(userId);

        // Step 3 Addition: Accepted Requests တိုင်း၏ Session Status ကို စစ်ဆေးပြီး ရလဒ်ထည့်ပေးခြင်း
        for (LearningRequest req : accepted) {
            String status = sessionDAO.getSessionStatusForRequest(req.getRequestId());
            req.setSessionStatus(status);
        }

        request.setAttribute("pendingRequests", pending);
        request.setAttribute("acceptedRequests", accepted);
        request.setAttribute("rejectedRequests", rejected);
        request.setAttribute("sentRequests", sent);

        request.getRequestDispatcher("/jsp/requests.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null && session != null) {
            currentUser = (User) session.getAttribute("user");
        }

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String requestIdParam = request.getParameter("requestId");
        String action = request.getParameter("action");

        if (requestIdParam != null && action != null) {
            try {
                int requestId = Integer.parseInt(requestIdParam);
                if ("SENDER_CANCEL".equalsIgnoreCase(action)) {
                    boolean cancelled = requestDAO.cancelIfOwnedBySender(requestId, currentUser.getUserId());
                    if (!cancelled) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Not authorized to cancel this request");
                        return;
                    }
                } else {
                    String newStatus = switch (action.toUpperCase()) {
                        case "ACCEPT" -> "Accepted";
                        case "REJECT" -> "Rejected";
                        case "CANCEL" -> "Cancelled";
                        case "REOPEN" -> "Pending";
                        default -> null;
                    };

                    if (newStatus != null) {
                        // Fetch request details before status update to get senderId & skillName
                        LearningRequest reqBefore = requestDAO.getRequestById(requestId);

                        if (requestDAO.updateRequestStatus(requestId, newStatus)) {
                            if (reqBefore != null) {
                                if ("Accepted".equals(newStatus)) {
                                    notificationDAO.createNotification(
                                        reqBefore.getSenderId(),
                                        "request",
                                        "Request accepted",
                                        currentUser.getFullName() + " accepted your request for " + reqBefore.getSkillName()
                                    );
                                } else if ("Rejected".equals(newStatus)) {
                                    notificationDAO.createNotification(
                                        reqBefore.getSenderId(),
                                        "request",
                                        "Request declined",
                                        currentUser.getFullName() + " declined your request for " + reqBefore.getSkillName()
                                    );
                                }
                            }
                        }
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/requests");
    }
}