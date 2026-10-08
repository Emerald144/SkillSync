package com.skillsync.controller;

import com.skillsync.dao.TokenDAO;
import com.skillsync.model.TokenTransaction;
import com.skillsync.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/wallet")
public class WalletServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private TokenDAO tokenDAO;

    @Override
    public void init() throws ServletException {
        tokenDAO = new TokenDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Redirect to login if user session does not exist
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        int userId = user.getUserId();

        // Fetch balance and transactions from DB
        int balance = tokenDAO.getBalance(userId);
        List<TokenTransaction> transactions = tokenDAO.getTransactions(userId);

        // Keep session user object in sync with latest DB balance
        user.setTokenBalance(balance);

        // Bind attributes for wallet.jsp
        request.setAttribute("balance", balance);
        request.setAttribute("transactions", transactions);
        
        // Forward request to view
        request.getRequestDispatcher("/jsp/wallet.jsp").forward(request, response);
    }
}