package com.skillsync.controller.admin;

import com.skillsync.dao.ReportDAO;
import com.skillsync.model.Report;
import com.skillsync.util.AdminAuthCheck;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/moderation-queue")
public class AdminModerationQueueServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Authenticate Admin Session
        if (!AdminAuthCheck.verifyAdmin(request, response)) {
            return;
        }

        try {
            // Optional filter parameter: "all", "Pending", "Resolved", "Dismissed"
            String statusFilter = request.getParameter("status");
            List<Report> reportList;

            if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter)) {
                reportList = reportDAO.getReportsByStatus(statusFilter);
            } else {
                reportList = reportDAO.getAllReports();
            }

            request.setAttribute("reports", reportList);
            request.setAttribute("selectedStatus", statusFilter != null ? statusFilter : "all");

            request.getRequestDispatcher("/jsp/admin/moderation-queue.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to load moderation queue: " + e.getMessage());
            request.getRequestDispatcher("/jsp/admin/moderation-queue.jsp").forward(request, response);
        }
    }
}