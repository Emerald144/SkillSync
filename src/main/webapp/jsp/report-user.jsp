<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillsync.model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // Fetch logged-in user from HttpSession
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report a User - SkillSync</title>
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>
    
    <!-- CSS Link -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/report-user.css">
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
                <span class="nav-icon"><i data-lucide="layout-dashboard"></i></span>
                <span>Dashboard</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/matching" class="nav-item">
                <span class="nav-icon"><i data-lucide="sparkles"></i></span>
                <span>AI Matching</span>
            </a>

            <a href="${pageContext.request.contextPath}/jsp/skills.jsp" class="nav-item">
                <span class="nav-icon"><i data-lucide="graduation-cap"></i></span>
                <span>Skills</span>
            </a>

            <a href="${pageContext.request.contextPath}/search" class="nav-item">
                <span class="nav-icon"><i data-lucide="search"></i></span>
                <span>Search Users</span>
            </a>

            <a href="${pageContext.request.contextPath}/requests" class="nav-item">
                <span class="nav-icon"><i data-lucide="inbox"></i></span>
                <span>Learning Requests</span>
                <c:if test="${not empty pendingCount and pendingCount > 0}">
                    <span class="nav-badge">${pendingCount}</span>
                </c:if>
            </a>

            <a href="${pageContext.request.contextPath}/messages" class="nav-item">
                <span class="nav-icon"><i data-lucide="message-square"></i></span>
                <span>Messages</span>
                <c:if test="${not empty unreadMessageCount and unreadMessageCount > 0}">
                    <span class="nav-badge">${unreadMessageCount}</span>
                </c:if>
            </a>

            <a href="${pageContext.request.contextPath}/sessions" class="nav-item">
                <span class="nav-icon"><i data-lucide="clock"></i></span>
                <span>Sessions</span>
            </a>

            <a href="${pageContext.request.contextPath}/achievements" class="nav-item">
                <span class="nav-icon"><i data-lucide="award"></i></span>
                <span>Achievements</span>
            </a>

            <a href="${pageContext.request.contextPath}/reviews" class="nav-item">
                <span class="nav-icon"><i data-lucide="star"></i></span>
                <span>Reviews</span>
            </a>

            <a href="${pageContext.request.contextPath}/wallet" class="nav-item">
                <span class="nav-icon"><i data-lucide="wallet"></i></span>
                <span>Wallet</span>
            </a>

            <a href="${pageContext.request.contextPath}/notifications" class="nav-item">
                <span class="nav-icon"><i data-lucide="bell"></i></span>
                <span>Notifications</span>
                <span class="nav-badge">3</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/ProfileServlet" class="nav-item">
                <span class="nav-icon"><i data-lucide="user"></i></span>
                <span>Profile</span>
            </a>

            <div class="nav-section-title">Moderation</div>

            <a href="${pageContext.request.contextPath}/report-user" class="nav-item active">
                <span class="nav-icon"><i data-lucide="flag"></i></span>
                <span>Report a user</span>
            </a>
        </nav>

        <!-- Sidebar Wallet Widget -->
        <div class="sidebar-wallet-card">
            <div class="wallet-card-title">
                <i data-lucide="coins"></i>
                Token balance
            </div>
            <div class="wallet-balance-val"><%= currentUser.getTokenBalance() %></div>
            <div class="wallet-sub">+100 monthly top-up on the 1st</div>
            <a href="${pageContext.request.contextPath}/wallet" class="btn-wallet">Open wallet</a>
        </div>
    </aside>

    <!-- Main Content Layout -->
    <div class="main-wrapper">
        <!-- Top Header Navigation -->
        <header class="top-header">
            <form action="${pageContext.request.contextPath}/search" method="GET" class="header-search">
                <svg class="search-icon-pos" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                <input type="text" name="q" value="${param.q}" placeholder="Search skills, people, universities…">
            </form>

            <div class="header-actions">
                <button class="icon-btn" title="Notifications">
                    <i data-lucide="bell"></i>
                    <span class="notification-dot"></span>
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

                    <div class="profile-dropdown-menu" id="profileMenu">
                        <div class="dropdown-header">
                            <span class="username-tag">@<%= currentUser.getEmail() != null ? currentUser.getEmail().split("@")[0] : currentUser.getFullName().toLowerCase().replaceAll("\\s+", "") %></span>
                        </div>
                        <ul class="dropdown-links">
                            <li>
                                <a href="${pageContext.request.contextPath}/ProfileServlet">
                                    <i data-lucide="user"></i>
                                    <span>My profile</span>
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/UpdateProfileServlet">
                                    <i data-lucide="settings"></i>
                                    <span>Edit profile</span>
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/jsp/wallet.jsp">
                                    <i data-lucide="wallet"></i>
                                    <span>Token wallet</span>
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

        <!-- Form Body Content -->
        <main class="dashboard-content">
            <div class="container-narrow">
                
                <div class="page-header">
                    <h1 class="page-title">Report a user</h1>
                    <p class="page-subtitle">Reports are confidential. We never reveal who filed them.</p>
                </div>

                <!-- Warning Banner -->
                <div class="alert-banner alert-destructive">
                    <i data-lucide="shield-alert" class="alert-icon"></i>
                    <div>
                        Misuse of reporting can affect your own reputation score. Please only report genuine issues.
                    </div>
                </div>

                <!-- Report Form -->
                <form action="${pageContext.request.contextPath}/report-user" method="POST" id="reportForm">
                    <input type="hidden" name="reason" id="selectedReason" value="">

                    <c:choose>
                        <c:when test="${not empty targetUser}">
                            <!-- Automatically passes reportedUserId from doGet servlet attribute -->
                            <input type="hidden" name="reportedUserId" value="${targetUser.userId}">
                            
                            <div class="section-card" style="margin-bottom: 1.5rem;">
                                <div class="section-body">
                                    <p style="margin: 0; font-size: 0.95rem; color: var(--text-secondary, #475569);">
                                        <strong>Reporting user:</strong> ${targetUser.fullName} (@${targetUser.email})
                                    </p>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Direct manual user ID input if accessed straight from side nav without URL query param -->
                            <div class="section-card" style="margin-bottom: 1.5rem;">
                                <div class="section-body">
                                    <div class="form-group">
                                        <label for="reportedUserId" class="form-label">User ID to Report</label>
                                        <input type="number" id="reportedUserId" name="reportedUserId" class="form-input" placeholder="Enter target user ID" required style="width: 100%; padding: 0.6rem; border: 1px solid #cbd5e1; border-radius: 6px;">
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="section-card">
                        <div class="section-header">
                            <h2 class="section-title">What happened?</h2>
                            <p class="section-subtitle">Pick the closest reason</p>
                        </div>

                        <div class="section-body">
                            <!-- Options Grid -->
                            <div class="reason-grid">
                                <button type="button" class="reason-btn" data-value="No-show for a session">
                                    No-show for a session
                                </button>
                                <button type="button" class="reason-btn" data-value="Harassment or abuse">
                                    Harassment or abuse
                                </button>
                                <button type="button" class="reason-btn" data-value="Misrepresented skills">
                                    Misrepresented skills
                                </button>
                                <button type="button" class="reason-btn" data-value="Token or review manipulation">
                                    Token or review manipulation
                                </button>
                                <button type="button" class="reason-btn" data-value="Spam or off-platform selling">
                                    Spam or off-platform selling
                                </button>
                                <button type="button" class="reason-btn" data-value="Something else">
                                    Something else
                                </button>
                            </div>

                            <!-- Additional Detail Field (Renamed name attribute to match ReportUserServlet) -->
                            <div class="form-group">
                                <label for="description" class="form-label">Details</label>
                                <textarea id="description" name="description" rows="5" class="form-textarea" placeholder="Share what happened, with dates and session names if you can."></textarea>
                            </div>

                            <!-- Form Actions -->
                            <div class="form-actions">
                                <button type="submit" class="btn btn-gradient">
                                    <i data-lucide="send"></i>
                                    Submit report
                                </button>
                                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-ghost">
                                    Cancel
                                </a>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
        </main>
    </div>
</div>

<script>
    // Initialize Lucide Icons
    lucide.createIcons();

    // Toggle Dropdown Menu
    function toggleProfileDropdown(event) {
        event.stopPropagation();
        const wrapper = document.querySelector('.profile-dropdown-wrapper');
        wrapper.classList.toggle('open');
    }

    // Close Dropdown Menu on Outside Click
    document.addEventListener('click', function(event) {
        const wrapper = document.querySelector('.profile-dropdown-wrapper');
        if (wrapper && !wrapper.contains(event.target)) {
            wrapper.classList.remove('open');
        }
    });

    // Reason Selection Logic
    const reasonButtons = document.querySelectorAll('.reason-btn');
    const hiddenReasonInput = document.getElementById('selectedReason');

    reasonButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            reasonButtons.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            hiddenReasonInput.value = btn.getAttribute('data-value');
        });
    });

    // Form Guard
    document.getElementById('reportForm').addEventListener('submit', (e) => {
        if (!hiddenReasonInput.value) {
            e.preventDefault();
            alert('Please pick a reason for your report.');
        }
    });
</script>

</body>
</html>