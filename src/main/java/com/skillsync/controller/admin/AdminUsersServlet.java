package com.skillsync.controller.admin;

import com.skillsync.dao.UserDAO;
import com.skillsync.model.User;
import com.skillsync.util.AdminAuthCheck;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Admin Authentication စစ်ဆေးခြင်း
        if (!AdminAuthCheck.verifyAdmin(request, response)) {
            return;
        }

        try {
            // 2. URL Parameter မှ status ကို ရယူခြင်း (e.g., /admin/users?status=Active)
            String status = request.getParameter("status");
            List<User> userList;

            // Filter status ပါမပါ စစ်ဆေးပြီး အချက်အလက်များ ဆွဲထုတ်ခြင်း
            if (status != null && !status.trim().isEmpty()) {
                userList = userDAO.getUsersByStatus(status);
            } else {
                userList = userDAO.getAllUsers();
            }

            // 3. Request Attribute များ ထည့်သွင်းပေးခြင်း
            request.setAttribute("userList", userList);
            request.setAttribute("selectedStatus", status != null ? status : "All");

            // 4. JSP သို့ Forward လုပ်ခြင်း
            request.getRequestDispatcher("/jsp/admin/admin-users.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("flashError", "Failed to retrieve user list.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
}