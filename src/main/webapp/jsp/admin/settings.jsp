<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillsync.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    if (!"Admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
        return;
    }

    String flashMessage = (String) session.getAttribute("flashMessage");
    String flashError = (String) session.getAttribute("flashError");
    session.removeAttribute("flashMessage");
    session.removeAttribute("flashError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Settings · SkillSync</title>
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>
    
    <!-- CSS Stylesheets -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/admin-dashboard.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/settings.css">
</head>
<body>

<div class="app-shell">
    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="SkillSync Logo" class="logo-img" />
            <div>
                <div class="logo-text">Skill<span class="text-gradient">Sync</span></div>
                <div class="logo-sub">Admin Portal</div>
            </div>
        </a>

        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">
                <span class="nav-icon"><i data-lucide="layout-dashboard"></i></span>
                <span>Dashboard</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
                <span class="nav-icon"><i data-lucide="users"></i></span>
                <span>User Management</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/moderation-queue" class="nav-item">
                <span class="nav-icon"><i data-lucide="flag"></i></span>
                <span>Moderation Queue</span>
            </a>
        </nav>
    </aside>

    <!-- Main Wrapper Area -->
    <div class="main-wrapper">
        <!-- Top Header Navigation -->
        <header class="top-header">
            <div class="header-search">
                <i data-lucide="search" class="search-icon-pos"></i>
                <input type="text" placeholder="Search skills, people, universities…">
            </div>

            <div class="header-actions">
                <button class="icon-btn" title="Pending Reports Alert">
                    <i data-lucide="bell"></i>
                    <c:if test="${pendingReports > 0}">
                        <span class="notification-dot"></span>
                    </c:if>
                </button>

                <!-- Profile Dropdown Menu -->
                <div class="profile-dropdown-wrapper">
                    <button class="user-profile-menu" id="profileDropdownBtn" onclick="toggleProfileDropdown(event)">
                        <% 
                            String photoPath = currentUser.getProfilePhoto();
                            boolean hasPhoto = photoPath != null && !photoPath.trim().isEmpty();
                            if (hasPhoto && photoPath.startsWith("/")) {
                                photoPath = photoPath.substring(1);
                            }
                        %>

                        <% if (hasPhoto) { %>
                            <img src="${pageContext.request.contextPath}/<%= photoPath %>" 
                                 alt="Profile" 
                                 class="user-avatar-img" 
                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                            <div class="user-avatar-badge" style="display: none;">
                                <%= currentUser.getFullName().substring(0, Math.min(2, currentUser.getFullName().length())).toUpperCase() %>
                            </div>
                        <% } else { %>
                            <div class="user-avatar-badge">
                                <%= currentUser.getFullName().substring(0, Math.min(2, currentUser.getFullName().length())).toUpperCase() %>
                            </div>
                        <% } %>

                        <div class="user-details">
                            <div class="user-name-label"><%= currentUser.getFullName() %></div>
                            <div class="user-role-label"><%= currentUser.getRole() %></div>
                        </div>
                        
                        <i data-lucide="chevron-down" class="dropdown-arrow"></i>
                    </button>

                    <!-- Dropdown Links -->
                    <div class="profile-dropdown-menu" id="profileMenu">
                        <div class="dropdown-header">
                            <span class="username-tag"><%= currentUser.getEmail() %></span>
                        </div>
                        <ul class="dropdown-links">
                            <li>
                                <a href="${pageContext.request.contextPath}/admin/settings">
                                    <i data-lucide="settings"></i>
                                    <span>Account settings</span>
                                </a>
                            </li>
                            <li class="dropdown-divider"></li>
                            <li>
                                <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-link">
                                    <i data-lucide="log-out"></i>
                                    <span>Log out</span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </header>

        <!-- Main Dashboard Content -->
        <main class="dashboard-content">
            
            <!-- Alert Flash Messages -->
            <% if (flashMessage != null) { %>
                <div class="alert-box alert-success-custom">
                    <i data-lucide="check-circle" style="width: 18px; height: 18px;"></i>
                    <span><%= flashMessage %></span>
                </div>
            <% } %>

            <% if (flashError != null) { %>
                <div class="alert-box alert-danger-custom">
                    <i data-lucide="alert-triangle" style="width: 18px; height: 18px;"></i>
                    <span><%= flashError %></span>
                </div>
            <% } %>

            <div class="page-header" style="margin-bottom: 1.5rem;">
                <h1 class="page-title">Account Settings</h1>
                <p class="page-subtitle">Manage your personal admin account details and password security.</p>
            </div>

            <!-- Settings Forms Section -->
            <div class="settings-grid">
                
                <!-- Profile Information Panel -->
                <div class="form-card">
                    <div class="form-card-title">
                        <i data-lucide="user"></i>
                        <span>Profile Information</span>
                    </div>
                    <p class="form-card-sub">Update your personal account name and profile picture.</p>

                    <form action="${pageContext.request.contextPath}/admin/settings" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="updateProfile" />

                        <div class="avatar-upload-wrapper">
                            <% if (hasPhoto) { %>
                                <img src="${pageContext.request.contextPath}/<%= photoPath %>" id="avatarPreview" class="avatar-preview-lg" alt="Avatar" />
                            <% } else { %>
                                <div class="avatar-initials-lg" id="avatarInitials">
                                    <%= currentUser.getFullName().substring(0, Math.min(2, currentUser.getFullName().length())).toUpperCase() %>
                                </div>
                            <% } %>
                            <div>
                                <label class="form-label">Profile Photo</label>
                                <input type="file" name="profilePhoto" class="form-control" accept="image/*" onchange="previewImage(event)" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Full Name</label>
                            <input type="text" name="fullName" class="form-control" value="<%= currentUser.getFullName() %>" required />
                        </div>

                        <div class="form-group">
                            <label class="form-label">Email Address</label>
                            <input type="email" name="email" class="form-control" value="<%= currentUser.getEmail() %>" required />
                        </div>

                        <div class="form-group">
                            <label class="form-label">Role</label>
                            <input type="text" class="form-control" value="<%= currentUser.getRole() %>" disabled />
                        </div>

                        <button type="submit" class="btn-primary-action">
                            <i data-lucide="save" style="width: 16px; height: 16px;"></i>
                            <span>Save Profile Changes</span>
                        </button>
                    </form>
                </div>

                <!-- Password Change Panel -->
                <div class="form-card">
                    <div class="form-card-title">
                        <i data-lucide="lock"></i>
                        <span>Change Password</span>
                    </div>
                    <p class="form-card-sub">Ensure your account uses a strong password for platform security.</p>

                    <form action="${pageContext.request.contextPath}/admin/settings" method="POST">
                        <input type="hidden" name="action" value="changePassword" />

                        <div class="form-group">
                            <label class="form-label">Current Password</label>
                            <input type="password" name="currentPassword" class="form-control" placeholder="••••••••" required />
                        </div>

                        <div class="form-group">
                            <label class="form-label">New Password</label>
                            <input type="password" name="newPassword" class="form-control" placeholder="••••••••" required minlength="6" />
                        </div>

                        <div class="form-group">
                            <label class="form-label">Confirm New Password</label>
                            <input type="password" name="confirmPassword" class="form-control" placeholder="••••••••" required minlength="6" />
                        </div>

                        <button type="submit" class="btn-primary-action">
                            <i data-lucide="key-round" style="width: 16px; height: 16px;"></i>
                            <span>Update Password</span>
                        </button>
                    </form>
                </div>

            </div>
        </main>
    </div>
</div>

<script>
    // Initialize Lucide Icons
    lucide.createIcons();

    // Profile Dropdown Toggle
    function toggleProfileDropdown(event) {
        event.stopPropagation();
        const wrapper = document.querySelector('.profile-dropdown-wrapper');
        wrapper.classList.toggle('open');
    }

    document.addEventListener('click', function(event) {
        const wrapper = document.querySelector('.profile-dropdown-wrapper');
        if (wrapper && !wrapper.contains(event.target)) {
            wrapper.classList.remove('open');
        }
    });

    // Preview Profile Photo Upload
    function previewImage(event) {
        const reader = new FileReader();
        reader.onload = function() {
            let img = document.getElementById('avatarPreview');
            const initials = document.getElementById('avatarInitials');
            
            if (!img) {
                img = document.createElement('img');
                img.id = 'avatarPreview';
                img.className = 'avatar-preview-lg';
                if (initials) initials.parentNode.replaceChild(img, initials);
            }
            img.src = reader.result;
            img.style.display = 'block';
        };
        if (event.target.files[0]) {
            reader.readAsDataURL(event.target.files[0]);
        }
    }
</script>
</body>
</html>