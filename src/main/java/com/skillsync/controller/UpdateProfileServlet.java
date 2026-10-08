package com.skillsync.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.skillsync.dao.SkillDAO;
import com.skillsync.dao.UserDAO;
import com.skillsync.dao.AvailabilityDAO;
import com.skillsync.dao.InterestDAO;
import com.skillsync.model.Skill;
import com.skillsync.model.User;
import com.skillsync.model.UserSkill;
import com.skillsync.model.UserAvailability;
import com.skillsync.model.Interest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/UpdateProfileServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB memory buffer
    maxFileSize = 1024 * 1024 * 10,       // 10MB max per file
    maxRequestSize = 1024 * 1024 * 50     // 50MB max total request
)
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private SkillDAO skillDAO;
    private AvailabilityDAO availabilityDAO;
    private InterestDAO interestDAO;

    @Override
    public void init() throws ServletException {
        this.userDAO = new UserDAO();
        this.skillDAO = new SkillDAO();
        this.availabilityDAO = new AvailabilityDAO();
        this.interestDAO = new InterestDAO();
    }

    /**
     * Handles GET requests: Loads existing skills from the database and forwards to editProfile.jsp.
     */
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
            // Retrieve fresh user skills and master skills catalog from DB
            List<UserSkill> userSkills = skillDAO.getSkillsByUserId(currentUser.getUserId());
            List<Skill> masterSkills = skillDAO.getAllMasterSkills();
            
         // Retrieve interests catalog and user's selected interest IDs
            List<Interest> allInterests = interestDAO.getAllInterests();
            List<Integer> selectedInterestIds = interestDAO.getInterestIdsByUserId(currentUser.getUserId());

            // Pass lists as request attributes to editProfile.jsp
            request.setAttribute("userSkills", userSkills);
            request.setAttribute("masterSkills", masterSkills);
            request.setAttribute("allInterests", allInterests);
            request.setAttribute("selectedInterestIds", selectedInterestIds);

            // Forward to the JSP page
            request.getRequestDispatcher("/jsp/editProfile.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load profile skills from database.");
            request.getRequestDispatcher("/jsp/editProfile.jsp").forward(request, response);
        }
    }

    /**
     * Handles POST requests: Processes form submissions, saves profile fields & updates skills.
     */
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
            int userId = currentUser.getUserId();

            // 1. Extract Form Parameters
            String fullName = request.getParameter("fullName");
            String university = request.getParameter("university");
            String bio = request.getParameter("bio");
            String learningGoals = request.getParameter("learningGoals");
            String removePhotoFlag = request.getParameter("removePhotoFlag");

            // 2. Read Availability Arrays
            String[] days = request.getParameterValues("dayOfWeek");
            String[] startTimes = request.getParameterValues("startTime");
            String[] endTimes = request.getParameterValues("endTime");

            List<UserAvailability> availabilityList = new ArrayList<>();
            StringBuilder availabilitySummary = new StringBuilder();

            if (days != null && startTimes != null && endTimes != null) {
                for (int i = 0; i < days.length; i++) {
                    String day = days[i];
                    String startStr = startTimes[i];
                    String endStr = endTimes[i];

                    if (startStr != null && !startStr.trim().isEmpty() && endStr != null && !endStr.trim().isEmpty()) {
                        // Convert HTML time inputs (HH:mm) into java.sql.Time (HH:mm:ss)
                        if (startStr.length() == 5) startStr += ":00";
                        if (endStr.length() == 5) endStr += ":00";

                        Time startTime = Time.valueOf(startStr);
                        Time endTime = Time.valueOf(endStr);

                        UserAvailability slot = new UserAvailability(userId, day, startTime, endTime);
                        availabilityList.add(slot);

                        // Build string representation for User model
                        if (availabilitySummary.length() > 0) availabilitySummary.append(", ");
                        availabilitySummary.append(day).append(" ").append(startStr.substring(0, 5)).append("–").append(endStr.substring(0, 5));
                    }
                }
            }

            // Save availability entries via AvailabilityDAO
            availabilityDAO.saveUserAvailability(userId, availabilityList);

            // 3. Handle Profile Photo Upload / Removal
            String updatedPhotoPath = currentUser.getProfilePhoto();

            if ("true".equalsIgnoreCase(removePhotoFlag)) {
                updatedPhotoPath = "images/default_avatar.png";
            } else {
                Part filePart = request.getPart("profilePhoto");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String fileExt = "";
                    
                    int dotIndex = fileName.lastIndexOf('.');
                    if (dotIndex > 0) {
                        fileExt = fileName.substring(dotIndex);
                    }

                    // Generate unique filename
                    String newFileName = "user_" + userId + "_" + UUID.randomUUID().toString().substring(0, 8) + fileExt;

                    // Ensure upload directory exists inside deployed webapp
                    String uploadDir = getServletContext().getRealPath("/uploads");
                    File uploadFolder = new File(uploadDir);
                    if (!uploadFolder.exists()) {
                        uploadFolder.mkdirs();
                    }

                    // Save file to server disk
                    String filePath = uploadDir + File.separator + newFileName;
                    filePart.write(filePath);

                    // Store relative web path in DB
                    updatedPhotoPath = "uploads/" + newFileName;
                }
            }

            // 4. Update User Object & Save to Database
            currentUser.setFullName(fullName != null ? fullName.trim() : "");
            currentUser.setUniversity(university != null ? university.trim() : "");
            currentUser.setBio(bio != null ? bio.trim() : "");
            currentUser.setLearningGoals(learningGoals != null ? learningGoals.trim() : "");
            currentUser.setAvailability(availabilitySummary.toString());
            currentUser.setProfilePhoto(updatedPhotoPath);

            userDAO.updateUserProfile(currentUser);

            // 5. Process Skills (Teaching & Learning)
            List<UserSkill> updatedSkillsList = new ArrayList<>();

            // Parse Teaching Skills ("SkillName:ProficiencyLevel")
            String[] teachingSkills = request.getParameterValues("teachingSkills");
            if (teachingSkills != null) {
                for (String raw : teachingSkills) {
                    UserSkill us = parseSkillString(raw, "TEACHING", userId);
                    if (us != null) {
                        updatedSkillsList.add(us);
                    }
                }
            }

            // Parse Learning Skills
            String[] learningSkills = request.getParameterValues("learningSkills");
            if (learningSkills != null) {
                for (String raw : learningSkills) {
                    UserSkill us = parseSkillString(raw, "LEARNING", userId);
                    if (us != null) {
                        updatedSkillsList.add(us);
                    }
                }
            }

            // Save user skills in DB transaction
            skillDAO.replaceUserSkills(userId, updatedSkillsList);
            
         // 6. Process Interests
            String[] selectedInterestValues = request.getParameterValues("interests");
            List<Integer> selectedInterestIds = new ArrayList<>();
            if (selectedInterestValues != null) {
                for (String val : selectedInterestValues) {
                    try {
                        selectedInterestIds.add(Integer.parseInt(val));
                    } catch (NumberFormatException ignored) {}
                }
            }
            interestDAO.replaceUserInterests(userId, selectedInterestIds);

            // 7. Sync Session and Redirect
            session.setAttribute("currentUser", currentUser);
            
            response.sendRedirect(request.getContextPath() + "/jsp/profile.jsp?updated=true");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to update profile. Database error.");
            request.getRequestDispatcher("/jsp/editProfile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred while saving changes.");
            request.getRequestDispatcher("/jsp/editProfile.jsp").forward(request, response);
        }
    }

    /**
     * Helper method to parse input strings formatted like "Java:Expert"
     */
    private UserSkill parseSkillString(String raw, String skillType, int userId) {
        if (raw == null || !raw.contains(":")) {
            return null;
        }

        String[] parts = raw.split(":", 2);
        if (parts.length < 2) {
            return null;
        }

        String name = parts[0].trim();
        String level = parts[1].trim();

        if (name.isEmpty()) {
            return null;
        }

        UserSkill us = new UserSkill();
        us.setUserId(userId);
        us.setSkillName(name);
        us.setSkillType(skillType);
        us.setProficiencyLevel(level.isEmpty() ? "Intermediate" : level);

        return us;
    }
}