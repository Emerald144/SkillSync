package com.skillsync.controller;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

import com.skillsync.dao.UserDAO;
import com.skillsync.model.User;
import com.skillsync.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/RegisterServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 4,      // 4MB
    maxRequestSize = 1024 * 1024 * 10   // 10MB
)
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Read form parameters matching input names in register.jsp
        String fullName = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String university = request.getParameter("university");

        // Preserve input values so register.jsp displays them if validation fails
        request.setAttribute("name", fullName);
        request.setAttribute("email", email);
        request.setAttribute("university", university);

        // 1. Basic Validation
        if (fullName == null || fullName.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || university == null || university.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }

        // 2. Password Match Check
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }

        try {
            // 3. Duplicate Email Check
            if (userDAO.isEmailTaken(email)) {
                request.setAttribute("error", "An account with this email already exists.");
                request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
                return;
            }

            // 4. Handle Profile Photo Upload
            String dbPath = "images/default_avatar.png";
            Part filePart = request.getPart("profilePhoto");

            if (filePart != null && filePart.getSize() > 0 
                    && filePart.getSubmittedFileName() != null 
                    && !filePart.getSubmittedFileName().trim().isEmpty()) {
                
                String originalFileName = filePart.getSubmittedFileName();
                String fileExtension = "";
                int dotIndex = originalFileName.lastIndexOf(".");
                if (dotIndex >= 0) {
                    fileExtension = originalFileName.substring(dotIndex);
                }
                
                String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "uploads";
                
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                filePart.write(uploadPath + File.separator + uniqueFileName);
                dbPath = "images/uploads/" + uniqueFileName;
            }

            // 5. Hash Password
            String hashedPassword = PasswordUtil.hashPassword(password);

            // 6. Save User
            User newUser = new User(fullName, email, hashedPassword, university, dbPath);
            boolean success = userDAO.registerUser(newUser);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/jsp/login.jsp?registered=true");
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/jsp/register.jsp");
    }
}