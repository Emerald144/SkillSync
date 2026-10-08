<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillsync.model.User" %>
<%@ page import="com.skillsync.model.UserSkill"%>
<%@ page import="com.skillsync.model.Skill"%>
<%@ page import="com.skillsync.dao.SkillDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    // Check both potential session attribute keys ('currentUser' or 'user')
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        currentUser = (User) session.getAttribute("user");
    }
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    int tokenBalance = currentUser.getTokenBalance();

    // Fetch user skills dynamically if not pre-populated by a Controller Servlet
    List<UserSkill> userSkills = (List<UserSkill>) request.getAttribute("userSkills");
    List<Skill> masterSkills = (List<Skill>) request.getAttribute("masterSkills");
    
    SkillDAO skillDAO = new SkillDAO();
    if (userSkills == null) {
        try {
            userSkills = skillDAO.getSkillsByUserId(currentUser.getUserId());
        } catch (Exception e) {
        	e.printStackTrace();
            userSkills = new ArrayList<>();
        }
    }
    if (masterSkills == null) {
        try {
            masterSkills = skillDAO.getAllMasterSkills();
        } catch (Exception e) {
            masterSkills = new ArrayList<>();
        }
    }

    request.setAttribute("userSkills", userSkills);
    request.setAttribute("masterSkills", masterSkills);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Management · SkillSync</title>
    <meta name="description" content="Manage the skills you teach and the skills you want to learn, with levels and categories.">
    
    <!-- Base Layout & Sidebar CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/dashboard.css">
    <!-- Skills Page Specific CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/skills.css">
    <!-- FontAwesome for UI icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <div class="app-shell">
        
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-logo">
                <img src="${pageContext.request.contextPath}/images/logo.png" alt="SkillSync Logo" class="logo-img" />
                <div>
                    <div class="logo-text">Skill<span class="text-gradient">Sync</span></div>
                    <div class="logo-sub">Connecting Minds, Sharing Skills</div>
                </div>
            </a>

            <nav class="sidebar-nav">
                <a href="${pageContext.request.contextPath}/dashboard" class="nav-item">
                    <span class="nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/></svg>
                    </span>
                    <span>Dashboard</span>
                </a>
                
                <a href="${pageContext.request.contextPath}/matching" class="nav-item">
                    <span class="nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m12 3-1.9 5.8a2 2 0 0 1-1.28 1.28L3 12l5.8 1.9a2 2 0 0 1 1.28 1.28L12 21l1.9-5.8a2 2 0 0 1 1.28-1.28L21 12l-5.8-1.9a2 2 0 0 1-1.28-1.28z"/></svg>
                    </span>
                    <span>AI Matching</span>
                </a>

                <a href="${pageContext.request.contextPath}/jsp/skills.jsp" class="nav-item active">
                    <span class="nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>
                    </span>
                    <span>Skills</span>
                </a>

                <a href="${pageContext.request.contextPath}/search" class="nav-item">
                    <span class="nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                    </span>
                    <span>Search Users</span>
                </a>

                <a href="${pageContext.request.contextPath}/requests" class="nav-item">
    <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"/><path d="M5.45 5.11 2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"/></svg></span>
    <span>Learning Requests</span>
    <c:if test="${not empty pendingCount and pendingCount > 0}">
        <span class="nav-badge">${pendingCount}</span>
    </c:if>
</a>

                <a href="${pageContext.request.contextPath}/messages" class="nav-item">
    <span class="nav-icon">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
    </span>
    <span>Messages</span>
    <c:if test="${not empty unreadMessageCount and unreadMessageCount > 0}">
        <span class="nav-badge">${unreadMessageCount}</span>
    </c:if>
</a>

                <a href="${pageContext.request.contextPath}/sessions" class="nav-item">
                    <span class="nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    </span>
                    <span>Sessions</span>
                </a>

                <a href="${pageContext.request.contextPath}/achievements" class="nav-item">
                    <span class="nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"/></svg>
                    </span>
                    <span>Achievements</span>
                </a>

                <a href="${pageContext.request.contextPath}/reviews" class="nav-item">
                    <span class="nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                    </span>
                    <span>Reviews</span>
                </a>

                <a href="${pageContext.request.contextPath}/wallet" class="nav-item">
                    <span class="nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3v4a1 1 0 0 1-1 1H5a2 2 0 0 1-2-2V7"/></svg>
                    </span>
                    <span>Wallet</span>
                </a>

                <a href="${pageContext.request.contextPath}/notifications" class="nav-item">
                    <span class="nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg>
                    </span>
                    <span>Notifications</span>
                    <span class="nav-badge">3</span>
                </a>
                
                <a href="${pageContext.request.contextPath}/ProfileServlet" class="nav-item">
                    <span class="nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    </span>
                    <span>Profile</span>
                </a>

                <div class="nav-section-title">Moderation</div>
                
                
                 <a href="${pageContext.request.contextPath}/report-user" class="nav-item">
                <span class="nav-icon"><i data-lucide="flag"></i></span>
                <span>Report a user</span>
            </a>
        </nav>

            <!-- Sidebar Wallet Widget -->
            <div class="sidebar-wallet-card">
                <div class="wallet-card-title">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="8" cy="8" r="6"/><path d="M18 0 6 12"/><circle cx="16" cy="16" r="6"/></svg>
                    Token balance
                </div>
                <div class="wallet-balance-val"><%= tokenBalance %></div>
                <div class="wallet-sub">+100 monthly top-up on the 1st</div>
                <a href="${pageContext.request.contextPath}/wallet" class="btn-wallet">Open wallet</a>
            </div>
        </aside>

        <!-- Main Content Layout -->
        <div class="main-wrapper">
            <!-- Top Navbar -->
        <header class="top-header">
            <form action="${pageContext.request.contextPath}/search" method="GET" class="header-search">
                <svg class="search-icon-pos" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                <input type="text" name="q" value="${param.q}" placeholder="Search skills, people, universities…">
            </form>

                <div class="header-actions">
                    <button class="icon-btn" title="Notifications">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg>
                        <span class="notification-dot"></span>
                    </button>

                    <!-- Profile Dropdown Container -->
                    <div class="profile-dropdown-wrapper">
                        <button class="user-profile-menu" id="profileDropdownBtn" onclick="toggleProfileDropdown(event)">
                            <% 
                                String photoPath = (currentUser != null) ? currentUser.getProfilePhoto() : null;
                                boolean hasPhoto = photoPath != null && !photoPath.trim().isEmpty();
                                if (hasPhoto && photoPath.startsWith("/")) {
                                    photoPath = photoPath.substring(1);
                                }
                                String fullName = (currentUser != null && currentUser.getFullName() != null) ? currentUser.getFullName() : "User";
                                String userRole = (currentUser != null && currentUser.getRole() != null) ? currentUser.getRole() : "Member";
                                String initials = fullName.substring(0, Math.min(2, fullName.length())).toUpperCase();
                            %>

                            <% if (hasPhoto) { %>
                                <img src="${pageContext.request.contextPath}/<%= photoPath %>" 
                                     alt="Profile" 
                                     class="user-avatar-img" 
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                <div class="user-avatar-badge" style="display: none;">
                                    <%= initials %>
                                </div>
                            <% } else { %>
                                <div class="user-avatar-badge">
                                    <%= initials %>
                                </div>
                            <% } %>

                            <div class="user-details">
                                <div class="user-name-label"><%= fullName %></div>
                                <div class="user-role-label"><%= userRole %></div>
                            </div>
                            
                            <svg class="dropdown-arrow" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m6 9 6 6 6-6"/></svg>
                        </button>

                        <!-- Dropdown Menu -->
                        <div class="profile-dropdown-menu" id="profileMenu">
                            <div class="dropdown-header">
                                <span class="username-tag">@<%= (currentUser != null && currentUser.getEmail() != null) ? currentUser.getEmail().split("@")[0] : fullName.toLowerCase().replaceAll("\\s+", "") %></span>
                            </div>
                            <ul class="dropdown-links">
                                <li>
                                    <a href="${pageContext.request.contextPath}/ProfileServlet">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                        <span>My profile</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/UpdateProfileServlet">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
                                        <span>Edit profile</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/jsp/wallet.jsp">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3v4a1 1 0 0 1-1 1H5a2 2 0 0 1-2-2V7"/></svg>
                                        <span>Token wallet</span>
                                    </a>
                                </li>
                                <li class="dropdown-divider"></li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-link">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                                        <span>Log out</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Main Content Container -->
            <main class="skills-container">
                <div class="skills-grid">
                    
                    <!-- Left Column: Tab Controls, Search & Skill Lists -->
                    <div class="skills-main-column">
                        <div class="controls-bar">
                            <!-- Tabs -->
                            <div class="tabs-list">
                                <button type="button" class="tab-btn active" id="tab-teaching-btn" onclick="switchTab('teaching')">
                                    Teaching skills
                                </button>
                                <button type="button" class="tab-btn" id="tab-learning-btn" onclick="switchTab('learning')">
                                    Learning skills
                                </button>
                            </div>

                            <!-- Search Box -->
                            <div class="search-input-wrapper">
                                <i class="fa-solid fa-magnifying-glass search-icon"></i>
                                <input type="text" id="skill-search" class="form-input search-input" placeholder="Search your skills" oninput="filterSkills()">
                            </div>
                        </div>

                        <!-- Teaching Skills List Panel -->
                        <div id="teaching-panel" class="tab-panel active">
                            <div class="skills-list" id="teaching-list">
                                <c:forEach var="s" items="${userSkills}">
<c:if test="${fn:toUpperCase(fn:trim(s.skillType)) == 'TEACHING'}">                                        <div class="skill-card lift animate-fade-up" data-name="${s.skillName}">
                                            <div class="skill-icon-box">
                                                <i class="fa-solid fa-graduation-cap"></i>
                                            </div>
                                            <div class="skill-info">
                                                <div class="skill-name">${s.skillName}</div>
<div class="skill-category">${not empty s.category ? s.category : 'General'}</div>                                            </div>
                                            <span class="level-badge level-${s.proficiencyLevel.toLowerCase()}">${s.proficiencyLevel}</span>
                                            <button type="button" class="btn-delete-skill" onclick="removeSkill(this, 'teaching')" aria-label="Remove ${s.skillName}">
                                                <i class="fa-regular fa-trash-can"></i>
                                            </button>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                            <div id="teaching-empty" class="empty-state-card hidden">
                                <i class="fa-solid fa-book-open empty-icon"></i>
                                <p class="empty-title">No skills here yet</p>
                                <p class="empty-subtitle">Add one above and matching updates instantly.</p>
                            </div>
                        </div>

                        <!-- Learning Skills List Panel -->
                        <div id="learning-panel" class="tab-panel">
                            <div class="skills-list" id="learning-list">
                                <c:forEach var="s" items="${userSkills}">
<c:if test="${fn:toUpperCase(fn:trim(s.skillType)) == 'LEARNING'}">                                        <div class="skill-card lift animate-fade-up" data-name="${s.skillName}">
                                            <div class="skill-icon-box">
                                                <i class="fa-solid fa-bullseye"></i>
                                            </div>
                                            <div class="skill-info">
                                                <div class="skill-name">${s.skillName}</div>
<div class="skill-category">${not empty s.category ? s.category : 'General'}</div>                                            </div>
                                            <span class="level-badge level-${s.proficiencyLevel.toLowerCase()}">${s.proficiencyLevel}</span>
                                            <button type="button" class="btn-delete-skill" onclick="removeSkill(this, 'learning')" aria-label="Remove ${s.skillName}">
                                                <i class="fa-regular fa-trash-can"></i>
                                            </button>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                            <div id="learning-empty" class="empty-state-card hidden">
                                <i class="fa-solid fa-book-open empty-icon"></i>
                                <p class="empty-title">No skills here yet</p>
                                <p class="empty-subtitle">Add one above and matching updates instantly.</p>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Form & Statistics Side Cards -->
                    <div class="skills-sidebar-column">
                        
                        <!-- Add Skill Form Card -->
                        <div class="card surface-card">
                            <div class="card-header">
                                <h2 class="card-title">Add a skill</h2>
                                <p class="card-subtitle" id="add-skill-target-label">Added to Teaching</p>
                            </div>

                            <form id="add-skill-form" onsubmit="handleAddSkill(event)" class="form-stack">
                                <div class="form-group">
                                    <label for="skill-name-input">Skill name</label>
                                    <input type="text" id="skill-name-input" list="masterSkillsList" class="form-input" placeholder="e.g. Linear Algebra" required>
                                    <datalist id="masterSkillsList">
                                        <c:forEach var="m" items="${masterSkills}">
                                            <option value="${m.skillName}">
                                        </c:forEach>
                                    </datalist>
                                </div>

                                <div class="form-group">
                                    <label for="skill-level-select">Level</label>
                                    <select id="skill-level-select" class="form-select">
                                        <option value="Beginner">Beginner</option>
                                        <option value="Intermediate" selected>Intermediate</option>
                                        <option value="Advanced">Advanced</option>
                                        <option value="Expert">Expert</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="skill-category-select">Category</label>
                                    <select id="skill-category-select" class="form-select">
                                        <option value="Computer Science" selected>Computer Science</option>
                                        <option value="Programming">Programming</option>
                                        <option value="AI">AI</option>
                                        <option value="Design">Design</option>
                                        <option value="Communication">Communication</option>
                                        <option value="Mathematics">Mathematics</option>
                                        <option value="Business">Business</option>
                                    </select>
                                </div>

                                <button type="submit" class="btn-primary gradient-brand">
                                    <i class="fa-solid fa-plus"></i> Add skill
                                </button>
                            </form>
                        </div>

                        <!-- Skill Balance Stat Card -->
                        <div class="card surface-card">
                            <div class="card-header">
                                <h2 class="card-title">Skill balance</h2>
                                <p class="card-subtitle">A healthy profile teaches and learns</p>
                            </div>

                            <div class="balance-metrics-stack">
                                <!-- Teaching Progress -->
                                <div class="metric-row">
                                    <div class="metric-label-row">
                                        <span class="metric-label">
                                            <i class="fa-solid fa-graduation-cap icon-primary"></i> Teaching
                                        </span>
                                        <span class="metric-count" id="teaching-count">0</span>
                                    </div>
                                    <div class="progress-bar-track">
                                        <div class="progress-bar-fill gradient-brand" id="teaching-progress" style="width: 0%;"></div>
                                    </div>
                                </div>

                                <!-- Learning Progress -->
                                <div class="metric-row">
                                    <div class="metric-label-row">
                                        <span class="metric-label">
                                            <i class="fa-solid fa-bullseye icon-primary"></i> Learning
                                        </span>
                                        <span class="metric-count" id="learning-count">0</span>
                                    </div>
                                    <div class="progress-bar-track">
                                        <div class="progress-bar-fill bg-success" id="learning-progress" style="width: 0%;"></div>
                                    </div>
                                </div>

                                <p class="balance-footnote">
                                    Profiles with 3+ skills on each side receive 2.4× more session requests.
                                </p>
                            </div>
                        </div>

                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Client Interactive Logic -->
    <!-- Script Block -->
    <script>
        let currentTab = 'teaching';

        document.addEventListener('DOMContentLoaded', () => {
            updateMetrics();
            checkEmptyStates();
        });

        function toggleProfileDropdown(e) {
            e.stopPropagation();
            // Find the outer wrapper element
            const wrapper = document.querySelector('.profile-dropdown-wrapper');
            if (wrapper) {
                wrapper.classList.toggle('open');
            }
        }

        // Close the dropdown when clicking anywhere outside
        window.addEventListener('click', (event) => {
            const wrapper = document.querySelector('.profile-dropdown-wrapper');
            if (wrapper && wrapper.classList.contains('open')) {
                if (!wrapper.contains(event.target)) {
                    wrapper.classList.remove('open');
                }
            }
        });
        
        function switchTab(tab) {
            currentTab = tab;
            const teachingBtn = document.getElementById('tab-teaching-btn');
            const learningBtn = document.getElementById('tab-learning-btn');
            const teachingPanel = document.getElementById('teaching-panel');
            const learningPanel = document.getElementById('learning-panel');
            const targetLabel = document.getElementById('add-skill-target-label');

            if (tab === 'teaching') {
                teachingBtn.classList.add('active');
                learningBtn.classList.remove('active');
                teachingPanel.classList.add('active');
                learningPanel.classList.remove('active');
                targetLabel.textContent = 'Added to Teaching';
            } else {
                learningBtn.classList.add('active');
                teachingBtn.classList.remove('active');
                learningPanel.classList.add('active');
                teachingPanel.classList.remove('active');
                targetLabel.textContent = 'Added to Learning';
            }

            filterSkills();
        }

        function handleAddSkill(event) {
            event.preventDefault();
            
            // 1. Get values from your form
            const nameInput = document.getElementById('skill-name-input');
            const levelSelect = document.getElementById('skill-level-select');
            const categorySelect = document.getElementById('skill-category-select');

            const name = nameInput.value.trim();
            const level = levelSelect.value;
            const category = categorySelect.value;

            if (!name) return;

            // Determine if it's Teaching or Learning based on your currentTab variable
            const skillType = (currentTab === 'teaching') ? 'TEACHING' : 'LEARNING';

            // 2. Send the data to the server to save in the database
            fetch('../AddSkillServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    skillName: name,
                    skillLevel: level,
                    skillType: skillType,
                    category: category // Sent in case your backend needs to save the category text
                })
            })
            .then(response => {
                if (response.ok) {
                    // 3. If the database save was successful, reload the page!
                    // This forces your JSP to pull the fresh data from the database,
                    // which prevents blank cards and ensures it shows up on your Profile.
                    window.location.reload();
                } else {
                    alert("Database error: Could not save the skill.");
                }
            })
            .catch(error => {
                console.error("Error saving skill:", error);
                alert("Server connection failed.");
            });
        }

        function removeSkill(button, tab) {
            const card = button.closest('.skill-card');
            if (card) {
                card.remove();
                updateMetrics();
                checkEmptyStates();
            }
        }

        function filterSkills() {
            const query = document.getElementById('skill-search').value.toLowerCase().trim();
            const currentList = document.getElementById(currentTab + '-list');
            const cards = currentList.querySelectorAll('.skill-card');

            cards.forEach(card => {
                const name = card.getAttribute('data-name').toLowerCase();
                if (name.includes(query)) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });

            checkEmptyStates();
        }

        function updateMetrics() {
            const teachingCount = document.getElementById('teaching-list').querySelectorAll('.skill-card').length;
            const learningCount = document.getElementById('learning-list').querySelectorAll('.skill-card').length;

            document.getElementById('teaching-count').textContent = teachingCount;
            document.getElementById('learning-count').textContent = learningCount;

            const maxCapacity = 5;
            const teachingPct = Math.min((teachingCount / maxCapacity) * 100, 100);
            const learningPct = Math.min((learningCount / maxCapacity) * 100, 100);

            document.getElementById('teaching-progress').style.width = teachingPct + '%';
            document.getElementById('learning-progress').style.width = learningPct + '%';
        }

        function checkEmptyStates() {
            const teachingCards = document.getElementById('teaching-list').querySelectorAll('.skill-card');
            const learningCards = document.getElementById('learning-list').querySelectorAll('.skill-card');

            const teachingEmpty = document.getElementById('teaching-empty');
            const learningEmpty = document.getElementById('learning-empty');

            let visibleTeaching = 0;
            teachingCards.forEach(c => { if (c.style.display !== 'none') visibleTeaching++; });

            let visibleLearning = 0;
            learningCards.forEach(c => { if (c.style.display !== 'none') visibleLearning++; });

            if (visibleTeaching === 0) {
                teachingEmpty.classList.remove('hidden');
            } else {
                teachingEmpty.classList.add('hidden');
            }

            if (visibleLearning === 0) {
                learningEmpty.classList.remove('hidden');
            } else {
                learningEmpty.classList.add('hidden');
            }
        }
    </script>
</body>
</html>