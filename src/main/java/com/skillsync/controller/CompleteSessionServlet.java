package com.skillsync.controller;

import com.skillsync.dao.NotificationDAO;
import com.skillsync.dao.SessionDAO;
import com.skillsync.dao.TokenDAO;
import com.skillsync.dao.UserDAO;
import com.skillsync.model.Session;
import com.skillsync.model.User;
import com.skillsync.service.BadgeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/complete-session")
public class CompleteSessionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final SessionDAO sessionDAO = new SessionDAO();
    private final TokenDAO tokenDAO = new TokenDAO();
    private final UserDAO userDAO = new UserDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final BadgeService badgeService = new BadgeService();

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
            int sessionId = Integer.parseInt(request.getParameter("sessionId"));
            int currentUserId = currentUser.getUserId();

            // Client ထံမှ ပို့လိုက်သော ID ကို မယုံဘဲ Server-side DB တွင် တိုက်ရိုက် စစ်ဆေးသည်
            Session sess = sessionDAO.getSessionById(sessionId);
            if (sess == null) {
                session.setAttribute("flashError", "Session not found.");
                response.sendRedirect(request.getContextPath() + "/sessions");
                return;
            }

            boolean isLearner = (currentUserId == sess.getLearnerId());
            boolean isTeacher = (currentUserId == sess.getTeacherId());

            if (!isLearner && !isTeacher) {
                session.setAttribute("flashError", "You are not authorized to complete this session.");
                response.sendRedirect(request.getContextPath() + "/sessions");
                return;
            }

            // Confirm နှိပ်သူ၏ Role အလိုက် Confirmation ပေးခြင်း
            if (isLearner) {
                sessionDAO.confirmByLearner(sessionId);
            } else {
                sessionDAO.confirmByTeacher(sessionId);
            }

            // Confirmation စာရင်း အသစ်ကို ပြန်ဆွဲယူသည်
            Session updated = sessionDAO.getSessionById(sessionId);

            // နှစ်ယောက်လုံး Confirm ဖြစ်သွားပါက Token Transaction စတင်မည်
            if (updated.isLearnerConfirmed() && updated.isTeacherConfirmed()) {
                int learnerId = updated.getLearnerId();
                int teacherId = updated.getTeacherId();
                int amount = 20; // Token ပမာဏ

                // သင့် TokenDAO ရဲ့ processSessionPayment ကို တိုက်ရိုက် ခေါ်သုံးသည် (ဆရာရော တပည့်ပါ အဆင်ပြေပြီး status ကိုပါ 'completed' ပြောင်းပေးမည်)
                boolean paid = tokenDAO.processSessionPayment(sessionId, learnerId, teacherId, amount, updated.getSkillName());

                if (paid) {
                    // Reputation Update လုပ်ခြင်း
                    userDAO.updateReputation(learnerId, 10);
                    userDAO.updateReputation(teacherId, 10);
                    
                    // Badges စစ်ဆေးခြင်း
                    try { badgeService.checkBadges(learnerId); } catch (Exception ignored) {}
                    try { badgeService.checkBadges(teacherId); } catch (Exception ignored) {}

                    // Notifications ပို့ခြင်း
                    notificationDAO.createNotification(
                        teacherId, "TOKENS_RECEIVED", "Tokens Received",
                        "You received " + amount + " tokens for completing the session."
                    );
                    notificationDAO.createNotification(
                        learnerId, "SESSION_COMPLETED", "Session Completed",
                        "Your session on " + updated.getSkillName() + " is complete. Leave a review!"
                    );

                    User refreshed = userDAO.getUserById(currentUserId);
                    if (refreshed != null) {
                        session.setAttribute("currentUser", refreshed);
                    }

                    session.setAttribute("flashMessage", "Session completed! Tokens transferred and reputation updated.");
                    response.sendRedirect(request.getContextPath() + "/reviews");
                    return;
                } else {
                    session.setAttribute("flashError", "Failed to transfer tokens. Insufficient balance or session already completed.");
                }
            } else {
                // တစ်ဦးတည်းသာ Confirm လုပ်ထားသေးပါက အခြားတစ်ဦးထံ Notification ပို့ပေးမည်
                int otherUserId = isLearner ? sess.getTeacherId() : sess.getLearnerId();
                notificationDAO.createNotification(
                    otherUserId,
                    "SESSION_CONFIRM_PENDING", "Confirmation Needed",
                    currentUser.getFullName() + " confirmed the session — please confirm your side too."
                );
                session.setAttribute("flashMessage", "Confirmed! Waiting for the other participant to confirm.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Invalid session information.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flashError", "An error occurred while completing the session.");
        }

        response.sendRedirect(request.getContextPath() + "/sessions");
    }
}