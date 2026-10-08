<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillsync.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    int tokenBalance = (currentUser != null) ? currentUser.getTokenBalance() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Learning Sessions · SkillSync</title>
    <!-- Inter Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome for UI Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sessions.css?v=3">
</head>
<body>

    <div class="app-layout">
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

                <a href="${pageContext.request.contextPath}/sessions" class="nav-item active">
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
                </a>
                
                <a href="${pageContext.request.contextPath}/ProfileServlet" class="nav-item">
                    <span class="nav-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    </span>
                    <span>Profile</span>
                </a>
            </nav>

           <div class="nav-section-title">Moderation</div>
                
                
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

           <!-- Content Area -->
            <main class="content-container">
                <div class="page-header">
                    <h1>Learning Sessions</h1>
                    <p>Manage your upcoming learning schedules and review session history.</p>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty sessionScope.flashMessage}">
                    <div class="completion-banner" style="margin-bottom: 1.5rem; background: rgba(16, 185, 129, 0.12); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.3); border-radius: 0.75rem; padding: 1rem;">
                        <i class="fa-solid fa-circle-check"></i> ${sessionScope.flashMessage}
                    </div>
                    <c:remove var="flashMessage" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.flashError}">
                    <div class="completion-banner" style="margin-bottom: 1.5rem; background: rgba(239, 68, 68, 0.12); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); border-radius: 0.75rem; padding: 1rem;">
                        <i class="fa-solid fa-triangle-exclamation"></i> ${sessionScope.flashError}
                    </div>
                    <c:remove var="flashError" scope="session"/>
                </c:if>

                <!-- Count Counters Initialization -->
                <c:set var="upcomingCount" value="0" />
                <c:set var="completedCount" value="0" />
                <c:set var="reviewCount" value="0" />
                <c:set var="cancelledCount" value="0" />

                <c:forEach var="s" items="${sessions}">
                    <c:set var="st" value="${fn:toLowerCase(s.status)}" />
                    <c:choose>
                        <c:when test="${st eq 'scheduled' or st eq 'in progress'}">
                            <c:set var="upcomingCount" value="${upcomingCount + 1}" />
                        </c:when>
                        <c:when test="${st eq 'completed'}">
                            <c:set var="completedCount" value="${completedCount + 1}" />
                        </c:when>
                        <c:when test="${st eq 'needs review'}">
                            <c:set var="reviewCount" value="${reviewCount + 1}" />
                        </c:when>
                        <c:when test="${st eq 'cancelled'}">
                            <c:set var="cancelledCount" value="${cancelledCount + 1}" />
                        </c:when>
                    </c:choose>
                </c:forEach>

                <!-- Filter Tabs Header -->
<div class="session-tabs-nav">
    <button class="tab-btn ${empty activeTab or activeTab eq 'upcoming' ? 'active' : ''}" onclick="switchTab(event, 'upcoming')">
        Upcoming <span class="tab-badge">${upcomingCount}</span>
    </button>
    <button class="tab-btn ${activeTab eq 'completed' ? 'active' : ''}" onclick="switchTab(event, 'completed')">
        Completed <span class="tab-badge">${completedCount}</span>
    </button>
    <button class="tab-btn ${activeTab eq 'review' ? 'active' : ''}" onclick="switchTab(event, 'review')">
        Needs Review <span class="tab-badge">${reviewCount}</span>
    </button>
    <button class="tab-btn ${activeTab eq 'cancelled' ? 'active' : ''}" onclick="switchTab(event, 'cancelled')">
        Cancelled <span class="tab-badge">${cancelledCount}</span>
    </button>
    <button class="tab-btn ${activeTab eq 'all' ? 'active' : ''}" onclick="switchTab(event, 'all')">
        All <span class="tab-badge">${fn:length(sessions)}</span>
    </button>
</div>

                <!-- Dynamic Grid Layout -->
                <div class="grid-layout">
                    <div class="main-column">
                        <c:choose>
                            <c:when test="${not empty sessions}">
                                <c:forEach var="sess" items="${sessions}">
                                    <c:set var="statusLower" value="${fn:toLowerCase(sess.status)}" />
                                    
                                    <!-- Map Status to Filter Category -->
                                    <c:set var="category" value="all" />
                                    <c:choose>
                                        <c:when test="${statusLower eq 'scheduled' or statusLower eq 'in progress'}">
                                            <c:set var="category" value="upcoming" />
                                        </c:when>
                                        <c:when test="${statusLower eq 'completed'}">
                                            <c:set var="category" value="completed" />
                                        </c:when>
                                        <c:when test="${statusLower eq 'needs review'}">
                                            <c:set var="category" value="review" />
                                        </c:when>
                                        <c:when test="${statusLower eq 'cancelled'}">
                                            <c:set var="category" value="cancelled" />
                                        </c:when>
                                    </c:choose>

                                    <!-- Session Item Card -->
                                    <div class="session-card-item" data-category="${category}" style="margin-bottom: 1.5rem;">
                                        <div class="surface-card aurora active-session-card">
                                            <div class="card-header-flex">
                                                <div>
                                                    <!-- Status Badges -->
                                                    <c:choose>
                                                        <c:when test="${statusLower eq 'needs review'}">
                                                            <span class="status-tag" style="background: rgba(239, 68, 68, 0.2); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.4);">
                                                                <i class="fa-solid fa-clock-rotate-left"></i> Overdue - Needs Review
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${statusLower eq 'completed'}">
                                                            <span class="status-tag" style="background: rgba(16, 185, 129, 0.2); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.4);">
                                                                <i class="fa-solid fa-check"></i> Completed
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${statusLower eq 'cancelled'}">
                                                            <span class="status-tag" style="background: rgba(156, 163, 175, 0.2); color: #9ca3af; border: 1px solid rgba(156, 163, 175, 0.4);">
                                                                <i class="fa-solid fa-ban"></i> Cancelled
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-tag">${sess.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <h2 class="session-title" style="margin-top:0.5rem;">${sess.skillName}</h2>
                                                    <div class="instructor-info">
                                                        <c:choose>
                                                            <c:when test="${not empty sess.otherUserPhoto}">
                                                                <img src="${pageContext.request.contextPath}/${sess.otherUserPhoto}" 
                                                                     class="avatar avatar-md" style="object-fit:cover;" 
                                                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                                                <div class="avatar avatar-md" style="display:none;">${sess.initials}</div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="avatar avatar-md">${sess.initials}</div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <div>
                                                            <div class="instructor-name">${sess.otherUserName}</div>
                                                            <div class="instructor-role">${sess.teacher ? 'You are teaching' : 'Teaching this session'}</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Metadata Grid -->
                                            <div class="meta-grid">
                                                <div class="meta-card">
                                                    <i class="fa-regular fa-clock icon-primary"></i>
                                                    <div class="meta-label">WHEN</div>
                                                    <div class="meta-val"><fmt:formatDate value="${sess.sessionDate}" pattern="EEE dd MMM · HH:mm" /></div>
                                                </div>
                                                <div class="meta-card">
                                                    <i class="fa-solid fa-video icon-primary"></i>
                                                    <div class="meta-label">FORMAT</div>
                                                    <div class="meta-val">${sess.sessionType}</div>
                                                </div>
                                            </div>

                                            <!-- Meeting Link Bar (If Active/Upcoming) -->
                                            <c:if test="${not empty sess.meetingLink and statusLower ne 'cancelled'}">
                                                <div class="link-bar">
                                                    <i class="fa-solid fa-link icon-primary"></i>
                                                    <span class="link-url">${sess.meetingLink}</span>
                                                    <button class="btn-secondary" onclick="navigator.clipboard.writeText('${sess.meetingLink}'); alert('Link copied!');"><i class="fa-regular fa-copy"></i> Copy</button>
                                                    <a href="${sess.meetingLink}" target="_blank" class="btn-gradient"><i class="fa-solid fa-video"></i> Join now</a>
                                                </div>
                                            </c:if>

                                            <!-- Action Row -->
                                            <div class="action-row" style="margin-top: 1.5rem; display: flex; gap: 0.75rem; align-items: center;">
                                                <c:choose>
                                                    <c:when test="${statusLower eq 'completed'}">
                                                        <div class="completion-banner" style="flex: 1; background: rgba(16, 185, 129, 0.12); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.3); border-radius: 0.75rem; padding: 0.75rem 1rem; font-weight: 600;">
                                                            <i class="fa-solid fa-circle-check"></i> Completed · Tokens transferred
                                                        </div>
                                                        <a href="${pageContext.request.contextPath}/reviews" class="btn-secondary" style="text-decoration: none;">
                                                            <i class="fa-regular fa-star"></i> Leave Review
                                                        </a>
                                                    </c:when>

                                                    <c:when test="${statusLower eq 'needs review'}">
                                                        <div class="completion-banner" style="width: 100%; background: rgba(239, 68, 68, 0.12); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); border-radius: 0.75rem; padding: 0.75rem 1rem; text-align: center;">
                                                            <i class="fa-solid fa-triangle-exclamation"></i> Overdue. Under Review by system.
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${statusLower eq 'cancelled'}">
                                                        <div class="completion-banner" style="width: 100%; background: rgba(156, 163, 175, 0.12); color: #9ca3af; border: 1px solid rgba(156, 163, 175, 0.3); border-radius: 0.75rem; padding: 0.75rem 1rem; text-align: center;">
                                                            <i class="fa-solid fa-ban"></i> Session Cancelled
                                                        </div>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <!-- Confirmation Logic -->
                                                        <c:choose>
                                                            <c:when test="${(sess.teacher and sess.teacherConfirmed) or (!sess.teacher and sess.learnerConfirmed)}">
                                                                <div class="completion-banner" style="flex: 1; background: rgba(245, 158, 11, 0.12); color: #f59e0b; border: 1px solid rgba(245, 158, 11, 0.3); border-radius: 0.75rem; padding: 0.75rem 1rem; font-weight: 600;">
                                                                    <i class="fa-solid fa-hourglass-half"></i> Waiting for partner confirmation.
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <form action="${pageContext.request.contextPath}/complete-session" method="POST" onsubmit="return confirm('Confirm session complete?');" style="margin:0; flex:1;">
                                                                    <input type="hidden" name="sessionId" value="${sess.sessionId}" />
                                                                    <button type="submit" class="btn-complete" style="width: 100%;">
                                                                        <i class="fa-regular fa-circle-check"></i> Confirm Complete
                                                                    </button>
                                                                </form>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <!-- Cancel Session Form -->
                                                        <form action="${pageContext.request.contextPath}/cancel-session" method="POST" onsubmit="return confirm('Are you sure you want to cancel this session?');" style="margin: 0;">
                                                            <input type="hidden" name="sessionId" value="${sess.sessionId}" />
                                                            <button type="submit" class="btn-secondary" style="color: #ef4444; border-color: rgba(239, 68, 68, 0.3);">
                                                                <i class="fa-solid fa-xmark"></i> Cancel
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <!-- Editable Session Notes -->
                                        <c:if test="${statusLower ne 'cancelled'}">
                                            <div class="surface-card section-card" style="margin-top: 1rem;">
                                                <h3 class="section-title">Session notes</h3>
                                                <p class="section-subtitle">Shared with both participants</p>
                                                <div class="notes-container">
                                                    <i class="fa-solid fa-pen-to-square icon-primary notes-icon"></i>
                                                    <textarea class="notes-textarea" data-session-id="${sess.sessionId}" rows="4" placeholder="Type your session notes here...">${sess.notes}</textarea>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="surface-card section-card">
                                    <p>No sessions found.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div id="noTabResults" class="surface-card section-card" style="display: none;">
                            <p>No sessions found in this section.</p>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- JavaScript Functions -->
    <script>
        function toggleProfileDropdown(event) {
            event.stopPropagation();
            const menu = document.getElementById("profileMenu");
            if (menu) {
                menu.classList.toggle("show");
            }
        }

        window.onclick = function(event) {
            const menu = document.getElementById("profileMenu");
            if (menu && menu.classList.contains("show")) {
                menu.classList.remove("show");
            }
        };

        function copyLink() {
            const meetingElem = document.getElementById("meetingUrl");
            if (meetingElem) {
                const url = meetingElem.innerText;
                navigator.clipboard.writeText(url);
                alert("Link copied to clipboard!");
            }
        }
        
        function confirmComplete() {
            return confirm("Confirm this session is complete? Tokens will only transfer once both participants confirm.");
        }

        // --- Session Notes Auto-Save Logic ---
        document.addEventListener("DOMContentLoaded", function() {
            const notesArea = document.getElementById('notesArea');
            if (notesArea) {
                let saveTimeout;
                notesArea.addEventListener('input', function() {
                    clearTimeout(saveTimeout);
                    saveTimeout = setTimeout(saveNotes, 800); 
                });

                function saveNotes() {
                    const sessionId = notesArea.getAttribute('data-session-id');
                    if (!sessionId) return;

                    fetch('${pageContext.request.contextPath}/save-session-notes', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'sessionId=' + encodeURIComponent(sessionId) + '&notes=' + encodeURIComponent(notesArea.value)
                    })
                    .then(response => {
                        if (response.ok) {
                            console.log('Notes saved successfully');
                        } else {
                            console.error('Failed to save notes');
                        }
                    })
                    .catch(error => console.error('Error saving notes:', error));
                }
            }
        });
        
        function switchTab(evt, targetCategory) {

            // Remove active state from all tabs
            document.querySelectorAll('.tab-btn').forEach(function (btn) {
                btn.classList.remove('active');
            });

            // Add active state
            if (evt) {
                if (evt.currentTarget) {
                    evt.currentTarget.classList.add('active');
                } else if (
                    evt.classList &&
                    evt.classList.contains('tab-btn')
                ) {
                    evt.classList.add('active');
                }
            }

            // Filter session cards
            const cards = document.querySelectorAll('.session-card-item');

            let visibleCount = 0;

            cards.forEach(function (card) {

                const category = card.getAttribute('data-category');

                if (
                    targetCategory === 'all' ||
                    category === targetCategory
                ) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            // Empty state
            const noResults = document.getElementById('noTabResults');

            if (noResults) {
                noResults.style.display =
                    visibleCount === 0 ? 'block' : 'none';
            }
        }


        /* Initialize tabs */
        document.addEventListener('DOMContentLoaded', function () {

            const initialTab =
                "${empty activeTab ? 'upcoming' : activeTab}";

            const buttons =
                document.querySelectorAll('.tab-btn');

            let activeButton = null;

            buttons.forEach(function (button) {

                const onclickValue =
                    button.getAttribute('onclick');

                if (
                    onclickValue &&
                    onclickValue.includes("'" + initialTab + "'")
                ) {
                    activeButton = button;
                }
            });

            if (activeButton) {

                switchTab(
                    activeButton,
                    initialTab
                );

            } else {

                // Fallback to Upcoming
                const upcomingButton =
                    document.querySelector(
                        '.tab-btn:first-child'
                    );

                if (upcomingButton) {
                    switchTab(
                        upcomingButton,
                        'upcoming'
                    );
                }
            }
        });
    </script>
</body>
</html>