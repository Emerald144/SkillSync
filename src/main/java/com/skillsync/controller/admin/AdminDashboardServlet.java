package com.skillsync.controller.admin;

import com.skillsync.dao.ReportDAO;
import com.skillsync.dao.UserDAO;
import com.skillsync.util.AdminAuthCheck;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();
    private final ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Authenticate Admin Session
        if (!AdminAuthCheck.verifyAdmin(request, response)) {
            return;
        }

        try {
            // 2. Fetch Aggregated Metrics & Lists from DAOs
            request.setAttribute("totalUsers", userDAO.getTotalUserCount());
            request.setAttribute("activeUsers", userDAO.getActiveUserCount());
            request.setAttribute("suspendedUsers", userDAO.getSuspendedUserCount());
            request.setAttribute("pendingReports", reportDAO.getPendingReportCount());
            request.setAttribute("recentReports", reportDAO.getAllReports());

            // 3. Forward to View
            request.getRequestDispatcher("/jsp/admin-dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to load dashboard metrics: " + e.getMessage());
            request.getRequestDispatcher("/jsp/admin-dashboard.jsp").forward(request, response);
        }
    }
}