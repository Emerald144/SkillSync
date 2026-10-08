package com.skillsync.filter;

import com.skillsync.dao.LearningRequestDAO;
import com.skillsync.dao.MessageDAO;
import com.skillsync.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class NavDataFilter implements Filter {

    private LearningRequestDAO requestDAO;
    private MessageDAO messageDAO;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        requestDAO = new LearningRequestDAO();
        messageDAO = new MessageDAO();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession(false);

        if (session != null) {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                currentUser = (User) session.getAttribute("user");
            }

            // Automatically attach navigation badge counts for logged-in users
            if (currentUser != null) {
                // Learning Requests badge count
                int pendingCount = requestDAO.getPendingCount(currentUser.getUserId());
                httpRequest.setAttribute("pendingCount", pendingCount);

                // Unread Messages badge count
                int unreadMessageCount = messageDAO.getUnreadMessageCount(currentUser.getUserId());
                httpRequest.setAttribute("unreadMessageCount", unreadMessageCount);
            }
        }

        chain.doFilter(request, response);
    }
}