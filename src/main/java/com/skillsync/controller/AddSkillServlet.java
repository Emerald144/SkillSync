package com.skillsync.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.skillsync.dao.SkillDAO;
import com.skillsync.model.User;
import com.skillsync.model.UserSkill;

@WebServlet("/AddSkillServlet")
public class AddSkillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Ensure user is logged in
        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String skillName = request.getParameter("skillName");
        String skillLevel = request.getParameter("skillLevel");
        String skillType = request.getParameter("skillType");

        if (skillName == null || skillName.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            SkillDAO skillDAO = new SkillDAO();
            
            // Create a new UserSkill object
            UserSkill newSkill = new UserSkill();
            newSkill.setUserId(currentUser.getUserId());
            newSkill.setSkillName(skillName.trim());
            newSkill.setSkillType(skillType);
            newSkill.setProficiencyLevel(skillLevel);

            // Add to database
            // Note: Make sure your SkillDAO has a method named 'addUserSkill' or similar 
            // that handles the SQL INSERT statement.
            boolean success = skillDAO.insertUserSkill(newSkill);
            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        
    }
    
}