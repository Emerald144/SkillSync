package com.skillsync.controller.admin;

import com.skillsync.dao.NotificationDAO;
import com.skillsync.dao.ReportDAO;
import com.skillsync.dao.UserDAO;
import com.skillsync.util.AdminAuthCheck;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/action")
public class AdminActionServlet extends HttpServlet {

    private final ReportDAO reportDAO = new ReportDAO();
    private final UserDAO userDAO = new UserDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AdminAuthCheck.verifyAdmin(request, response)) return;

        try {
            int reportId = Integer.parseInt(request.getParameter("reportId"));
            int reportedUserId = Integer.parseInt(request.getParameter("reportedUserId"));
            String action = request.getParameter("action"); // "DISMISS", "WARN", "SUSPEND", "DEACTIVATE"
            String adminNote = request.getParameter("adminNote");

            switch (action) {
                case "WARN":
                    userDAO.incrementWarningCount(reportedUserId);
                    reportDAO.updateReportStatus(reportId, "Resolved", adminNote);
                    notificationDAO.createNotification(
                        reportedUserId, "SYSTEM_WARNING", "Community Guidelines Warning",
                        "Your account has received an official warning regarding inappropriate behavior: " + adminNote
                    );
                    break;

                case "SUSPEND":
                    userDAO.updateUserStatus(reportedUserId, "Suspended");
                    reportDAO.updateReportStatus(reportId, "Resolved", adminNote);
                    notificationDAO.createNotification(
                        reportedUserId, "ACCOUNT_SUSPENDED", "Account Suspended",
                        "Your account has been suspended due to policy violations. Reason: " + adminNote
                    );
                    break;

                case "DEACTIVATE":
                    userDAO.updateUserStatus(reportedUserId, "Deactivated");
                    reportDAO.updateReportStatus(reportId, "Resolved", adminNote);
                    break;

                case "DISMISS":
                default:
                    reportDAO.updateReportStatus(reportId, "Dismissed", adminNote);
                    break;
            }

            request.getSession().setAttribute("flashMessage", "Admin action executed successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("flashError", "Failed to perform admin action.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}