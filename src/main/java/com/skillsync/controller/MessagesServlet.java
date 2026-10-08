package com.skillsync.controller;

import com.skillsync.dao.MessageDAO;
import com.skillsync.model.Message;
import com.skillsync.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/messages")
public class MessagesServlet extends HttpServlet {

    private final MessageDAO messageDAO = new MessageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        int currentUserId = currentUser.getUserId();

        // 1. Fetch connected users via Accepted learning requests for the sidebar
        List<User> conversations = messageDAO.getConnectedUsers(currentUserId);
        request.setAttribute("conversations", conversations);

        // 2. Determine target active user
        String receiverIdParam = request.getParameter("userId");
        User activeUser = null;

        if (receiverIdParam != null && !receiverIdParam.trim().isEmpty()) {
            try {
                int receiverId = Integer.parseInt(receiverIdParam);
                activeUser = messageDAO.getUserById(receiverId);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        } else if (!conversations.isEmpty()) {
            // Default to first user in list if no parameter provided
            activeUser = conversations.get(0);
        }

        // 3. Mark unread messages as read and fetch conversation thread
        if (activeUser != null) {
            // Clear unread flag for incoming messages from this active user
            messageDAO.markMessagesAsRead(currentUserId, activeUser.getUserId());

            List<Message> messages = messageDAO.getConversation(currentUserId, activeUser.getUserId());
            request.setAttribute("messages", messages);
            request.setAttribute("activeUser", activeUser);
        }

        request.getRequestDispatcher("/jsp/message.jsp").forward(request, response);
    }

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
                messageDAO.sendMessage(currentUser.getUserId(), receiverId, messageText.trim());
                response.sendRedirect(request.getContextPath() + "/messages?userId=" + receiverId);
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/messages");
    }
}