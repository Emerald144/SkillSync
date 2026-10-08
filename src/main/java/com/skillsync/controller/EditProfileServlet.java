package com.skillsync.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.skillsync.dao.InterestDAO;
import com.skillsync.dao.SkillDAO;
import com.skillsync.model.Interest;
import com.skillsync.model.Skill;
import com.skillsync.model.User;
import com.skillsync.model.UserSkill;

@WebServlet("/EditProfileServlet")
public class EditProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private SkillDAO skillDAO;
    private InterestDAO interestDAO;

    @Override
    public void init() throws ServletException {
        this.skillDAO = new SkillDAO();
        this.interestDAO = new InterestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        try {
            // Fetch skills
            List<UserSkill> userSkills = skillDAO.getSkillsByUserId(currentUser.getUserId());
            List<Skill> masterSkills = skillDAO.getAllMasterSkills();

            // Fetch interests
            List<Interest> userInterests = interestDAO.getInterestsByUserId(currentUser.getUserId());
            List<Interest> masterInterests = interestDAO.getAllInterests();

            // Set request attributes
            request.setAttribute("userSkills", userSkills);
            request.setAttribute("masterSkills", masterSkills);
            request.setAttribute("userInterests", userInterests);
            request.setAttribute("masterInterests", masterInterests);

            request.getRequestDispatcher("/jsp/editProfile.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load profile details. Please try again.");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
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

        try {
            // Retrieve interest IDs array directly from form checkboxes/selects
            String[] selectedInterests = request.getParameterValues("interests");

            // Save user interests (passes String[] directly to DAO)
            interestDAO.updateUserInterests(currentUser.getUserId(), selectedInterests);

            response.sendRedirect(request.getContextPath() + "/EditProfileServlet?status=success");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to update profile interests. Please try again.");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }
}