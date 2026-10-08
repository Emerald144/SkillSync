<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillsync.model.User" %>
<%@ page import="com.skillsync.model.MatchResult" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    // Fetch logged-in user from HTTPSession
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
    <title>Dashboard - SkillSync</title>
    
    <!-- External CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/dashboard.css">
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
            <a href="${pageContext.request.contextPath}/dashboard" class="nav-item active">
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

            <a href="${pageContext.request.contextPath}/jsp/skills.jsp" class="nav-item">
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
            
            <!-- Profile Nav Item -->
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
            <div class="wallet-balance-val"><%= currentUser.getTokenBalance() %></div>
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
    String photoPath = currentUser.getProfilePhoto();
    boolean hasPhoto = photoPath != null && !photoPath.trim().isEmpty();
    if (hasPhoto) {
        // Remove leading slash if photoPath already starts with one
        if (photoPath.startsWith("/")) {
            photoPath = photoPath.substring(1);
        }
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
        
        <svg class="dropdown-arrow" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m6 9 6 6 6-6"/></svg>
    </button>

    <!-- Dropdown Menu -->
    <div class="profile-dropdown-menu" id="profileMenu">
        <div class="dropdown-header">
            <span class="username-tag">@<%= currentUser.getEmail() != null ? currentUser.getEmail().split("@")[0] : currentUser.getFullName().toLowerCase().replaceAll("\\s+", "") %></span>
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

        <!-- Dashboard Body Container -->
        <main class="dashboard-content">
            <!-- Hero Banner Section -->
           <section class="hero-banner">
    <div class="banner-main-text">
        <div style="font-size: 0.75rem; font-weight: 700; color: #0284c7; text-transform: uppercase;">
            <span id="current-day-time"></span>
        </div>
        <h1>Welcome back, <%= currentUser.getFullName().split(" ")[0] %> 👋</h1>
        <p class="banner-sub">
            You have ${pendingCount} pending learning requests. Your token balance is <%= currentUser.getTokenBalance() %>.
        </p>
        
        <!-- Live Search Form -->
        <form action="${pageContext.request.contextPath}/search" method="GET" class="hero-search-bar">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: #94a3b8;"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
            <input type="text" name="q" placeholder="Search a skill, e.g. &ldquo;gradient descent&rdquo;">
        </form>

        <!-- Working Quick Action Chips -->
        <div class="action-chip-group">
            <a href="${pageContext.request.contextPath}/matching" class="chip-btn">👁 Find partner</a>
            <a href="${pageContext.request.contextPath}/jsp/skills.jsp" class="chip-btn">+ Add skill</a>
            <a href="${pageContext.request.contextPath}/requests" class="chip-btn">📅 Request session</a>
            <a href="${pageContext.request.contextPath}/messages" class="chip-btn">💬 Messages</a>
        </div>
    </div>

    <!-- Clickable Reputation Widget -->
    <div class="banner-right-widget" style="cursor: pointer;" onclick="openReputationModal()">
        <div class="donut-chart-container">
            <svg width="90" height="90" viewBox="0 0 36 36">
                <path d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" fill="none" stroke="#e2e8f0" stroke-width="3"/>
                <path d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" fill="none" stroke="#0d9488" stroke-width="3" stroke-dasharray="80, 100"/>
            </svg>
            <div class="donut-inner">
                <div class="donut-num"><%= currentUser.getReputationScore() %></div>
                <div class="donut-lbl">reputation</div>
            </div>
        </div>
    </div>
</section>

            <!-- Key Metrics Grid -->
            <section class="stats-grid">
    <!-- Clickable Reputation Card -->
    <div class="stat-card clickable" onclick="openReputationModal()">
        <div class="stat-header">
            <div class="stat-icon" style="background: #eff6ff; color: #3b82f6;">📈</div>
            <span class="badge-green">+24</span>
        </div>
        <div class="stat-value"><%= currentUser.getReputationScore() %></div>
        <div class="stat-title">Reputation score</div>
    </div>

    <!-- Clickable Token Balance Card -->
    <div class="stat-card clickable" onclick="location.href='${pageContext.request.contextPath}/wallet'">
        <div class="stat-header">
            <div class="stat-icon" style="background: #ecfdf5; color: #10b981;">🪙</div>
            <span class="badge-green">+45</span>
        </div>
        <div class="stat-value"><%= currentUser.getTokenBalance() %></div>
        <div class="stat-title">Token balance</div>
    </div>

    <!-- Sessions Taught -->
    <div class="stat-card clickable" onclick="location.href='${pageContext.request.contextPath}/sessions'">
        <div class="stat-header">
            <div class="stat-icon" style="background: #fff7ed; color: #f97316;">📹</div>
            <span class="badge-green">+3</span>
        </div>
        <div class="stat-value">${completedSessionsCount != null ? completedSessionsCount : 0}</div>
        <div class="stat-title">Sessions taught</div>
    </div>

    <!-- Average Rating -->
    <div class="stat-card clickable" onclick="location.href='${pageContext.request.contextPath}/reviews'">
        <div class="stat-header">
            <div class="stat-icon" style="background: #f0fdf4; color: #22c55e;">⭐</div>
            <span style="font-size: 0.75rem; color: #64748b;">${totalReviews} reviews</span>
        </div>
        <div class="stat-value">${avgRating}★</div>
        <div class="stat-title">Average rating</div>
    </div>
</section>

            <!-- AI Recommendations & Achievements Grid -->
            <section class="split-grid">
                <!-- Left Panel: AI Recommendations -->
                <div class="card-panel">
    <div class="panel-header">
        <div>
            <div class="panel-title">Today's AI recommendations</div>
            <div class="panel-sub">Ranked on shared interests, complementary skills and availability overlap.</div>
        </div>
        <a href="${pageContext.request.contextPath}/matching" class="link-btn">See all &nearr;</a>
    </div>

    <c:choose>
        <c:when test="${not empty topMatches}">
            <c:forEach var="match" items="${topMatches}">
                <div class="user-rec-item">
                    <div class="rec-user-info">
                        <div class="rec-avatar">
                            ${not empty match.fullName ? fn:substring(match.fullName, 0, 2) : 'US'}
                        </div>
                        <div>
                            <div style="font-weight: 700; font-size: 0.875rem;">
                                ${match.fullName} 
                                <span style="font-size: 0.6875rem; color: #059669; background: #ecfdf5; padding: 0.15rem 0.4rem; border-radius: 0.35rem;">
                                    ${match.matchScore}% match
                                </span>
                            </div>
                            <div style="font-size: 0.75rem; color: #64748b;">
                                ${not empty match.university ? match.university : 'University Student'}
                            </div>
                            <div>
                                <c:forEach var="skill" items="${match.matchedSkills}">
                                    <span class="tag-pill">${skill}</span>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/ProfileServlet?id=${match.userId}" class="btn-primary-sm">Connect</a>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <p style="font-size: 0.875rem; color: #64748b; padding: 1rem 0;">No active recommendations found right now.</p>
        </c:otherwise>
    </c:choose>
</div>

                <!-- Right Panel: Achievements & Notifications -->
<div class="card-panel">
    <div class="panel-title" style="margin-bottom: 0.25rem;">Recent achievement</div>
    <div class="panel-sub" style="margin-bottom: 1rem;">
        <c:choose>
            <c:when test="${not empty latestBadge}">Just unlocked</c:when>
            <c:otherwise>No achievements unlocked yet</c:otherwise>
        </c:choose>
    </div>

    <c:choose>
        <c:when test="${not empty latestBadge}">
            <div class="badge-display-box">
                <div class="badge-hex-icon">&#127942;</div>
                <div>
                    <div style="font-weight: 700; font-size: 0.875rem;">${latestBadge.badgeName}</div>
                    <div style="font-size: 0.75rem; color: #64748b;">${latestBadge.description}</div>
                    <div style="font-size: 0.6875rem; color: #2563eb; margin-top: 0.25rem;">
                        Earned ${latestBadge.formattedEarnedDate}
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="badge-display-box">
                <div class="badge-hex-icon" style="opacity: 0.5;">&#127941;</div>
                <div>
                    <div style="font-weight: 700; font-size: 0.875rem;">Start your journey</div>
                    <div style="font-size: 0.75rem; color: #64748b;">Complete sessions and gain ratings to earn badges!</div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

    <div style="display: flex; justify-content: space-between; font-size: 0.75rem; font-weight: 600;">
        <span>Achievement progress</span>
        <span style="color: #2563eb;">${unlockedBadgesCount}/${totalBadgesCount} unlocked</span>
    </div>

    <div class="progress-bar-bg">
        <div class="progress-bar-fill" style="width: ${badgeProgressPercentage}%;"></div>
    </div>

    <div style="font-size: 0.6875rem; color: #64748b; margin-bottom: 1rem;">
        ${badgeProgressPercentage}% complete &middot; ${totalBadgesCount - unlockedBadgesCount} badges to go
    </div>

    <a href="${pageContext.request.contextPath}/achievements" class="btn-wallet" style="text-align: center;">View all achievements</a>
</div>
            </section>

            <!-- Bottom Grid: Popular Skills & Recent Reviews -->
            <section class="split-grid">
                <!-- Popular Skills -->
<div class="card-panel">
    <div class="panel-title">Popular skills</div>
    <div class="panel-sub" style="margin-bottom: 1rem;">Trending across all campuses this month</div>

    <div class="skills-grid">
        <c:choose>
            <c:when test="${not empty popularSkills}">
                <c:forEach var="skill" items="${popularSkills}">
                    <div class="skill-card-item">
                        <div class="skill-card-top">
                            <span>${skill.skillName}</span>
                            <span style="color: #059669;">+${skill.growthRate != null ? skill.growthRate : 10}%</span>
                        </div>
                        <div style="font-size: 0.6875rem; color: #64748b; margin: 0.25rem 0 0.5rem;">
                            ${skill.learnerCount} learners
                        </div>
                        <div class="progress-bar-bg">
                            <div class="progress-bar-fill" style="width: ${skill.popularityPercentage != null ? skill.popularityPercentage : 75}%;"></div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p style="font-size: 0.875rem; color: #64748b; padding: 1rem 0;">No popular skills data available.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>

                <!-- Recent Reviews -->
                <div class="card-panel">
    <div class="panel-header">
        <div>
            <div class="panel-title">Recent reviews</div>
            <div class="panel-sub">${avgRating}★ average from ${totalReviews} reviews</div>
        </div>
        <a href="${pageContext.request.contextPath}/reviews" class="link-btn">All reviews</a>
    </div>

    <c:choose>
        <c:when test="${not empty recentReviews}">
            <c:forEach var="review" items="${recentReviews}">
                <div class="review-card-item">
                    <div style="display: flex; align-items: center; gap: 0.5rem;">
                        <div class="user-avatar-badge-sm">${fn:substring(review.reviewerName, 0, 2)}</div>
                        <div>
                            <div style="font-size: 0.75rem; font-weight: 700;">${review.reviewerName}</div>
                            <div style="font-size: 0.625rem; color: #f59e0b;">
                                ★★★★☆ <span style="color: #64748b;">${review.skillName} &middot; ${review.formattedDate}</span>
                            </div>
                        </div>
                    </div>
                    <div class="review-text">&ldquo;${review.comment}&rdquo;</div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <p style="font-size: 0.875rem; color: #64748b; padding: 1rem 0;">No reviews received yet.</p>
        </c:otherwise>
    </c:choose>
</div>

<!-- Reputation Score Modal -->
<div id="reputationModal" class="modal-overlay" style="display: none;">
    <div class="modal-card">
        <h3>Reputation Score Breakdown</h3>
        <p>Your score is based on ratings, session completions, and community contributions.</p>
        <ul>
            <li><strong>Current Score:</strong> <%= currentUser.getReputationScore() %> points</li>
            <li><strong>Completed Sessions:</strong> +10 pts each</li>
            <li><strong>5-Star Reviews:</strong> +15 pts each</li>
        </ul>
        <button class="btn-primary-sm" onclick="closeReputationModal()">Close</button>
    </div>
</div>
            </section>
        </main>
    </div>
</div>

<script>
    function toggleProfileDropdown(event) {
        event.stopPropagation();
        const wrapper = document.querySelector('.profile-dropdown-wrapper');
        wrapper.classList.toggle('open');
    }

    // Close dropdown when clicking anywhere outside
    document.addEventListener('click', function(event) {
        const wrapper = document.querySelector('.profile-dropdown-wrapper');
        if (wrapper && !wrapper.contains(event.target)) {
            wrapper.classList.remove('open');
        }
    });
    
 // Display Live Day and Time in Hero Banner
    function updateBannerTime() {
        const now = new Date();
        const options = { weekday: 'long', hour: '2-digit', minute: '2-digit', hour12: false };
        const formatted = now.toLocaleDateString('en-US', options).toUpperCase();
        const timeElem = document.getElementById('current-day-time');
        if (timeElem) timeElem.textContent = formatted;
    }
    updateBannerTime();

    // Reputation Modal Toggle
    function openReputationModal() {
        document.getElementById('reputationModal').style.display = 'flex';
    }

    function closeReputationModal() {
        document.getElementById('reputationModal').style.display = 'none';
    }

    // Close Modal when clicking outside content
    window.onclick = function(event) {
        const modal = document.getElementById('reputationModal');
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    }
</script>

</body>
</html>