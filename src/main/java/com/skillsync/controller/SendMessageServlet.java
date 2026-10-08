package com.skillsync.controller;

import com.skillsync.dao.MessageDAO;
import com.skillsync.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/send-message")
public class SendMessageServlet extends HttpServlet {

    private final MessageDAO messageDAO = new MessageDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String receiverIdParam = request.getParameter("receiverId");
        String messageText = request.getParameter("message");

        if (receiverIdParam != null && messageText != null && !messageText.trim().isEmpty()) {
            try {
                int receiverId = Integer.parseInt(receiverIdParam);
                
                // Database ထဲသို့ Message သိမ်းဆည်းခြင်း
                messageDAO.sendMessage(currentUser.getUserId(), receiverId, messageText.trim());
                
                // Message ပို့ပြီးပါက အဆိုပါ Conversation သို့ ပြန်လည် Redirect လုပ်မည်
                response.sendRedirect(request.getContextPath() + "/messages?userId=" + receiverId);
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Parameter မှားယွင်းပါက /messages သို့ ပြန်ညွှန်းမည်
        response.sendRedirect(request.getContextPath() + "/messages");
    }
}