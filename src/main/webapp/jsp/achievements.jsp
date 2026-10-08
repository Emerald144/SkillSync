<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillsync.model.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
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
    <title>Achievements &amp; Badges · SkillSync</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/achievements.css">
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
                <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/></svg></span>
                <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/matching" class="nav-item">
                <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m12 3-1.9 5.8a2 2 0 0 1-1.28 1.28L3 12l5.8 1.9a2 2 0 0 1 1.28 1.28L12 21l1.9-5.8a2 2 0 0 1 1.28-1.28L21 12l-5.8-1.9a2 2 0 0 1-1.28-1.28z"/></svg></span>
                <span>AI Matching</span>
            </a>
            <a href="${pageContext.request.contextPath}/jsp/skills.jsp" class="nav-item">
                <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg></span>
                <span>Skills</span>
            </a>
            <a href="${pageContext.request.contextPath}/search" class="nav-item">
                <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></span>
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
                <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></span>
                <span>Sessions</span>
            </a>
            <a href="${pageContext.request.contextPath}/achievements" class="nav-item active">
                <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"/></svg></span>
                <span>Achievements</span>
            </a>
            <a href="${pageContext.request.contextPath}/reviews" class="nav-item">
                <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg></span>
                <span>Reviews</span>
            </a>
            <a href="${pageContext.request.contextPath}/wallet" class="nav-item">
                <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3v4a1 1 0 0 1-1 1H5a2 2 0 0 1-2-2V7"/></svg></span>
                <span>Wallet</span>
            </a>
            <a href="${pageContext.request.contextPath}/notifications" class="nav-item">
                <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg></span>
                <span>Notifications</span>
                <span class="nav-badge">3</span>
            </a>
            <a href="${pageContext.request.contextPath}/ProfileServlet" class="nav-item">
                <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></span>
                <span>Profile</span>
            </a>

            <a href="${pageContext.request.contextPath}/report-user" class="nav-item">
                <span class="nav-icon"><i data-lucide="flag"></i></span>
                <span>Report a user</span>
            </a>
        </nav>

        <div class="sidebar-wallet-card">
            <div class="wallet-card-title">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="8" cy="8" r="6"/><path d="M18 0 6 12"/><circle cx="16" cy="16" r="6"/></svg>
                Token balance
            </div>
            <div class="wallet-balance-val">${currentUser.tokenBalance}</div>
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

                <div class="profile-dropdown-wrapper">
                    <button class="user-profile-menu" id="profileDropdownBtn" onclick="toggleProfileDropdown(event)">
                        <c:choose>
                            <c:when test="${not empty currentUser.profilePhoto}">
                                <img src="${pageContext.request.contextPath}/${currentUser.profilePhoto.startsWith('/') ? currentUser.profilePhoto.substring(1) : currentUser.profilePhoto}"
                                     alt="Profile" class="user-avatar-img"
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                <div class="user-avatar-badge" style="display: none;">
                                    ${currentUser.fullName.substring(0, 2).toUpperCase()}
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="user-avatar-badge">
                                    ${currentUser.fullName.substring(0, 2).toUpperCase()}
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="user-details">
                            <div class="user-name-label">${currentUser.fullName}</div>
                            <div class="user-role-label">${currentUser.role}</div>
                        </div>
                        <svg class="dropdown-arrow" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m6 9 6 6 6-6"/></svg>
                    </button>

                    <div class="profile-dropdown-menu" id="profileMenu">
                        <div class="dropdown-header">
                            <span class="username-tag">@${currentUser.email != null ? currentUser.email.split("@")[0] : "user"}</span>
                        </div>
                        <ul class="dropdown-links">
                            <li><a href="${pageContext.request.contextPath}/ProfileServlet">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                <span>My profile</span></a></li>
                            <li><a href="${pageContext.request.contextPath}/UpdateProfileServlet">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
                                <span>Edit profile</span></a></li>
                            <li><a href="${pageContext.request.contextPath}/wallet">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3v4a1 1 0 0 1-1 1H5a2 2 0 0 1-2-2V7"/></svg>
                                <span>Token wallet</span></a></li>
                            <li class="dropdown-divider"></li>
                            <li><a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-link">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                                <span>Log out</span></a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </header>

        <!-- Achievements Body -->
        <main class="achievements-content">
            <div class="page-header">
                <h1>Achievements &amp; badges</h1>
                <p>Every badge is earned through real sessions, reviews and consistency — no shortcuts.</p>
            </div>

            <c:set var="totalBadgesCount" value="${allBadges.size()}" />
            <c:set var="earnedBadgesCount" value="${userBadges.size()}" />
            <c:set var="completionPct" value="${totalBadgesCount > 0 ? (earnedBadgesCount * 100 / totalBadgesCount) : 0}" />

            <!-- Aurora Hero -->
            <section class="hero-badge-card">
                <div class="progress-ring-container">
                    <svg width="120" height="120" viewBox="0 0 120 120">
                        <circle class="ring-bg" cx="60" cy="60" r="52" />
                        <circle class="ring-fill" cx="60" cy="60" r="52" stroke-dasharray="327" stroke-dashoffset="${327 - (327 * completionPct / 100)}" />
                    </svg>
                    <div class="ring-content">
                        <div class="ring-val">${earnedBadgesCount}/${totalBadgesCount}</div>
                        <div class="ring-lbl">badges</div>
                    </div>
                </div>

                <div class="hero-text">
                    <div class="hero-tier">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"/></svg>
                        Gold Mentor
                    </div>
                    <h2>Newest badge: Top Mentor</h2>
                    <p>Ranked in the top 5% of mentors on your campus.</p>
                    <div class="hero-progress-row">
                        <span>Achievement progress</span>
                        <span class="hero-progress-count">${earnedBadgesCount}/${totalBadgesCount} unlocked</span>
                    </div>
                    <div class="progress-bar-bg">
                        <div class="progress-bar-fill" style="width: ${completionPct}%;"></div>
                    </div>
                    <div class="hero-progress-sub">
                        <fmt:formatNumber value="${completionPct}" maxFractionDigits="0"/>% complete · ${totalBadgesCount - earnedBadgesCount} badges to go
                    </div>
                </div>

                <div class="hero-medal tier-gold badge-glow">
                    <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="1.8"><path d="M8 21l4-7 4 7"/><circle cx="12" cy="8" r="6"/></svg>
                </div>
            </section>

            <!-- Stat Cards -->
            <section class="achv-stats-grid">
                <div class="achv-stat-card">
                    <div class="stat-icon-row">
                        <div class="stat-icon-circle tone-primary">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"/></svg>
                        </div>
                        <span class="stat-delta">of ${totalBadgesCount}</span>
                    </div>
                    <div class="stat-value">${earnedBadgesCount}</div>
                    <div class="stat-label">Total badges</div>
                </div>

                <!-- Updated Clickable Reputation Score Card -->
                <div class="achv-stat-card clickable-card" onclick="openReputationModal()" style="cursor: pointer;">
                    <div class="stat-icon-row">
                        <div class="stat-icon-circle tone-success">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 7 13.5 15.5 8.5 10.5 2 17"/><polyline points="16 7 22 7 22 13"/></svg>
                        </div>
                        <span class="stat-delta delta-success">+24</span>
                    </div>
                    <div class="stat-value">${not empty stats ? stats.reputationScore : 862}</div>
                    <div class="stat-label">Reputation score <span style="font-size: 0.8em; opacity: 0.7;">(click for history)</span></div>
                </div>

                <div class="achv-stat-card">
                    <div class="stat-icon-row">
                        <div class="stat-icon-circle tone-primary">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m22 8-6 4 6 4V8Z"/><rect width="14" height="12" x="2" y="6" rx="2"/></svg>
                        </div>
                        <span class="stat-delta delta-success">+5</span>
                    </div>
                    <div class="stat-value">${not empty stats ? stats.sessionsCompleted : 90}</div>
                    <div class="stat-label">Sessions completed</div>
                </div>

                <div class="achv-stat-card">
                    <div class="stat-icon-row">
                        <div class="stat-icon-circle tone-warning">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                        </div>
                        <span class="stat-delta">reviews</span>
                    </div>
                    <div class="stat-value">${not empty stats ? stats.averageRating : "4.9"}★</div>
                    <div class="stat-label">Average rating</div>
                </div>

                <div class="achv-stat-card">
                    <div class="stat-icon-row">
                        <div class="stat-icon-circle tone-destructive">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/></svg>
                        </div>
                        <span class="stat-delta">best streak</span>
                    </div>
                    <div class="stat-value">${not empty stats ? stats.streakDays : 18} days</div>
                    <div class="stat-label">Learning streak</div>
                </div>
            </section>

            <!-- Unlocked Badges Grid -->
            <section class="badge-section-card">
                <div class="section-header">
                    <h3>Unlocked badges</h3>
                    <p>${earnedBadgesCount} earned · newest first</p>
                </div>
                <div class="badge-tile-grid">
                    <c:choose>
                        <c:when test="${not empty userBadges}">
                            <c:forEach var="ub" items="${userBadges}">
                                <div class="badge-tile">
                                    <div class="badge-hex ${not empty ub.tierClass ? ub.tierClass : 'tier-gold'} badge-shine">
                                        <c:choose>
                                            <c:when test="${not empty ub.iconSvg}">
                                                <c:choose>
                                                    <c:when test="${ub.iconSvg.startsWith('<svg')}">
                                                        <c:out value="${ub.iconSvg}" escapeXml="false" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="${ub.iconSvg}"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:when test="${not empty ub.icon}">
                                                <c:choose>
                                                    <c:when test="${ub.icon.startsWith('<svg')}">
                                                        <c:out value="${ub.icon}" escapeXml="false" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="${ub.icon}"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2"><path d="M8 21l4-7 4 7"/><circle cx="12" cy="8" r="6"/></svg>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="badge-tile-name"><c:out value="${ub.badgeName}" /></div>
                                    <div class="badge-tile-desc"><c:out value="${ub.description}" /></div>
                                    <div class="badge-tile-date">
                                        <fmt:formatDate value="${not empty ub.earnedAt ? ub.earnedAt : ub.earnedDate}" pattern="dd MMM yyyy"/>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="color: var(--text-muted); grid-column: 1 / -1; padding: 12px 0;">No badges unlocked yet. Keep participating to earn badges!</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>

            <!-- Locked Badges Grid -->
            <section class="badge-section-card">
                <div class="section-header">
                    <h3>Locked badges</h3>
                    <p>${totalBadgesCount - earnedBadgesCount} still to unlock</p>
                </div>
                <div class="badge-tile-grid">
                    <c:forEach var="badge" items="${allBadges}">
                        <c:if test="${not earnedBadgeIds.contains(badge.badgeId)}">
                            <div class="badge-tile locked">
                                <div class="badge-hex tier-locked">
                                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                                </div>
                                <div class="badge-tile-name"><c:out value="${badge.badgeName}" /></div>
                                <div class="badge-tile-desc"><c:out value="${badge.description}" /></div>
                                
                                <c:if test="${badge.requirementValue > 0}">
                                    <c:set var="percent" value="${(badge.currentProgress / badge.requirementValue) * 100}" />
                                    <c:if test="${percent > 100}">
                                        <c:set var="percent" value="100" />
                                    </c:if>

                                    <div class="progress-bar-bg small">
                                        <div class="progress-bar-fill" style="width: ${percent}%;"></div>
                                    </div>
                                    <div class="badge-tile-progress">
                                        <fmt:formatNumber value="${badge.currentProgress}" maxFractionDigits="0"/> / ${badge.requirementValue}
                                    </div>
                                </c:if>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </section>

            <!-- Token Milestones -->
            <section class="badge-section-card">
                <div class="section-header">
                    <h3>Token milestones</h3>
                    <p>Badges tied to your wallet activity</p>
                </div>
                <div class="token-milestone-row">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="8" cy="8" r="6"/><path d="M18 0 6 12"/><circle cx="16" cy="16" r="6"/></svg>
                    <span class="token-count">${currentUser.tokenBalance} tokens</span>
                    <span class="token-sub">· Earn tokens by completing teaching sessions on SkillSync</span>
                </div>
            </section>
        </main>
    </div>
</div>

<!-- Reputation History Modal -->
<div id="reputationModal" class="modal-overlay" onclick="closeReputationModal(event)">
    <div class="modal-card" onclick="event.stopPropagation()">
        <div class="modal-header">
            <h3>Reputation Point History</h3>
            <button type="button" class="modal-close-btn" onclick="closeReputationModal()">&times;</button>
        </div>
        <div class="modal-body">
            <ul id="reputationList" class="history-list">
                <li class="loading-state">Loading history...</li>
            </ul>
        </div>
    </div>
</div>

<script>
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

    // Reputation Modal Operations
    function openReputationModal() {
        const modal = document.getElementById('reputationModal');
        const list = document.getElementById('reputationList');
        
        modal.classList.add('active');
        list.innerHTML = '<li class="loading-state" style="color: #a1a1aa; padding: 12px 0;">Loading history...</li>';

        fetch('${pageContext.request.contextPath}/api/reputation-history')
            .then(response => {
                if (!response.ok) throw new Error('Failed to fetch history');
                return response.json();
            })
            .then(data => {
                if (!data || data.length === 0) {
                    list.innerHTML = '<li style="color: #a1a1aa; padding: 12px 0;">No reputation activity logged yet.</li>';
                    return;
                }

                let historyHTML = '';
                data.forEach(item => {
                    const pointsClass = item.points >= 0 ? 'history-points' : 'history-points negative';
                    const sign = item.points >= 0 ? '+' : '';
                    historyHTML += `
                        <li class="history-item">
                            <div>
                                <div class="history-reason">\${item.reason}</div>
                                <div class="history-date">\${item.date}</div>
                            </div>
                            <span class="\${pointsClass}">\${sign}\${item.points}</span>
                        </li>
                    `;
                });
                list.innerHTML = historyHTML;
            })
            .catch(error => {
                console.error('Error fetching history:', error);
                list.innerHTML = '<li style="color: #ef4444; padding: 12px 0;">Could not load reputation history.</li>';
            });
    }

    function closeReputationModal(event) {
        if (!event || event.target.id === 'reputationModal' || event.target.classList.contains('modal-close-btn')) {
            document.getElementById('reputationModal').classList.remove('active');
        }
    }
</script>
</body>
</html>