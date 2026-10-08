<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page import="com.skillsync.model.User" %> 

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Learning Requests · SkillSync</title>
    <meta name="description" content="Review pending, accepted and rejected peer learning requests and respond in one tap.">
    
    <!-- SkillSync Design System -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/requests.css?v=2">
</head>
<body>

<div class="app-shell">
    
    <!-- Navigation Sidebar -->
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

            <a href="${pageContext.request.contextPath}/requests" class="nav-item active">
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

            <a href="${pageContext.request.contextPath}/achievements" class="nav-item">
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
            <div class="wallet-balance-val">${not empty currentUser ? currentUser.tokenBalance : 320}</div>
            <div class="wallet-sub">+100 monthly top-up on the 1st</div>
            <a href="${pageContext.request.contextPath}/wallet" class="btn-wallet">Open wallet</a>
        </div>
    </aside>

    <!-- Main Content Layout -->
    <div class="main-wrapper">
        <!-- Top Navbar -->
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
                    <% 
                    User currentUser = (User) session.getAttribute("currentUser");

                    String photoPath = (currentUser != null) ? currentUser.getProfilePhoto() : null;
                    boolean hasPhoto = photoPath != null && !photoPath.trim().isEmpty();
                    if (hasPhoto && photoPath.startsWith("/")) {
                        photoPath = photoPath.substring(1);
                    }
                    String fullName = (currentUser != null && currentUser.getFullName() != null) ? currentUser.getFullName() : "User";
                    String userRole = (currentUser != null && currentUser.getRole() != null) ? currentUser.getRole() : "Member";
                    String initials = fullName.substring(0, Math.min(2, fullName.length())).toUpperCase();
                    %>

                    <a href="${pageContext.request.contextPath}/ProfileServlet" class="user-profile-menu" style="text-decoration:none;">
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
                    </a>

                    <button type="button" class="dropdown-arrow-btn" id="profileDropdownBtn" onclick="toggleProfileDropdown(event)">
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
                                <a href="${pageContext.request.contextPath}/wallet">
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

        <!-- Main Requests Area -->
        <main class="requests-container">
            <div class="page-header">
                <h1 class="page-title">Learning requests</h1>
                <p class="page-subtitle">Every request states the skill, the proposed time and the tokens on offer, so you can decide fast.</p>
            </div>

            <!-- Tab Triggers -->
            <div class="tabs-navigation" role="tablist">
                <button type="button" class="tab-btn active" data-tab="Pending" onclick="switchTab('Pending')">
                    <span>Pending</span>
                    <span class="tab-count-badge">${fn:length(pendingRequests)}</span>
                </button>
                <button type="button" class="tab-btn" data-tab="Accepted" onclick="switchTab('Accepted')">
                    <span>Accepted</span>
                    <span class="tab-count-badge">${fn:length(acceptedRequests)}</span>
                </button>
                <button type="button" class="tab-btn" data-tab="Rejected" onclick="switchTab('Rejected')">
                    <span>Rejected</span>
                    <span class="tab-count-badge">${fn:length(rejectedRequests)}</span>
                </button>
                <button type="button" class="tab-btn" data-tab="Sent" onclick="switchTab('Sent')">
                    <span>Sent</span>
                    <span class="tab-count-badge">${fn:length(sentRequests)}</span>
                </button>
            </div>

            <!-- Pending Requests Tab -->
            <div id="tab-Pending" class="tab-content active">
                <div class="requests-list">
                    <c:choose>
                        <c:when test="${not empty pendingRequests}">
                            <c:forEach var="req" items="${pendingRequests}">
                                <article class="request-card">
                                    <div class="card-inner">
                                        <!-- UPDATED: Avatar with profile link and photo support -->
                                        <a href="${pageContext.request.contextPath}/profile?id=${req.otherUserId}" class="avatar-link">
                                            <c:choose>
                                                <c:when test="${not empty req.otherUserPhoto}">
                                                    <img src="${pageContext.request.contextPath}/${req.otherUserPhoto}" 
                                                         alt="${req.requesterName}" 
                                                         class="avatar-photo"
                                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                                    <div class="initials-avatar" style="display:none;">${req.initials}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="initials-avatar">${req.initials}</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                        <div class="card-main-content">
                                            <div class="user-name-row">
                                                <!-- UPDATED: Clickable user name -->
                                                <h3 class="person-name">
                                                    <a href="${pageContext.request.contextPath}/profile?id=${req.otherUserId}" style="color:inherit; text-decoration:none;">
                                                        ${req.requesterName}
                                                    </a>
                                                </h3>
                                                <span class="status-pill pending">Pending</span>
                                            </div>
                                            <p class="request-subject">wants to learn <strong>${req.skillName}</strong></p>
                                            <c:if test="${not empty req.note}">
                                                <div class="note-bubble">${req.note}</div>
                                            </c:if>
                                            <div class="meta-row">
                                                <span class="meta-item time">
                                                    <fmt:formatDate value="${req.requestedTime}" pattern="EEE dd MMM · HH:mm" />
                                                </span>
                                                <span class="meta-item tokens">${req.tokenAmount} tokens</span>
                                            </div>
                                        </div>
                                        <div class="card-actions">
                                            <form action="${pageContext.request.contextPath}/requests" method="post" style="display:inline;">
                                                <input type="hidden" name="requestId" value="${req.requestId}" />
                                                <input type="hidden" name="action" value="ACCEPT" />
                                                <button type="submit" class="btn-accept">Accept</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/requests" method="post" style="display:inline;">
                                                <input type="hidden" name="requestId" value="${req.requestId}" />
                                                <input type="hidden" name="action" value="REJECT" />
                                                <button type="submit" class="btn-reject">Reject</button>
                                            </form>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="color: #64748b; padding: 1rem 0;">No pending requests right now.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Accepted Requests Tab -->
            <div id="tab-Accepted" class="tab-content">
                <div class="requests-list">
                    <c:choose>
                        <c:when test="${not empty acceptedRequests}">
                            <c:forEach var="req" items="${acceptedRequests}">
                                <article class="request-card">
                                    <div class="card-inner">
                                        <!-- UPDATED: Avatar with profile link and photo support -->
                                        <a href="${pageContext.request.contextPath}/profile?id=${req.otherUserId}" class="avatar-link">
                                            <c:choose>
                                                <c:when test="${not empty req.otherUserPhoto}">
                                                    <img src="${pageContext.request.contextPath}/${req.otherUserPhoto}" 
                                                         alt="${req.requesterName}" 
                                                         class="avatar-photo"
                                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                                    <div class="initials-avatar" style="display:none;">${req.initials}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="initials-avatar">${req.initials}</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                        <div class="card-main-content">
                                            <div class="user-name-row">
                                                <!-- UPDATED: Clickable user name -->
                                                <h3 class="person-name">
                                                    <a href="${pageContext.request.contextPath}/profile?id=${req.otherUserId}" style="color:inherit; text-decoration:none;">
                                                        ${req.requesterName}
                                                    </a>
                                                </h3>
                                                <span class="status-pill accepted">Accepted</span>
                                            </div>
                                            <p class="request-subject">learning <strong>${req.skillName}</strong></p>
                                        </div>
                                        <!-- Step 4 Updated: Conditional Card Actions & Schedule Form -->
                                        <div class="card-actions">
                                            <c:choose>
                                                <c:when test="${req.hasSession}">
                                                    <span class="status-pill ${req.sessionCompleted ? 'completed' : 'scheduled'}" style="padding: 0.4rem 0.8rem; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">
                                                        Session: ${req.sessionStatus}
                                                    </span>
                                                    <a href="${pageContext.request.contextPath}/sessions?requestId=${req.requestId}" class="btn-accept" style="text-decoration: none; text-align: center; display: inline-block;">View session</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn-accept toggle-schedule-form" data-target="schedule-form-${req.requestId}">
                                                        Create session
                                                    </button>
                                                    <form action="${pageContext.request.contextPath}/requests" method="post" style="display:inline;">
                                                        <input type="hidden" name="requestId" value="${req.requestId}" />
                                                        <input type="hidden" name="action" value="CANCEL" />
                                                        <button type="submit" class="btn-cancel">Cancel session</button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <c:if test="${not req.hasSession}">
                                            <div id="schedule-form-${req.requestId}" class="schedule-form" style="display:none; margin-top:1rem; padding-top:1rem; border-top:1px solid var(--border); width:100%;">
                                                <form action="${pageContext.request.contextPath}/schedule-session" method="post">
                                                    <input type="hidden" name="requestId" value="${req.requestId}" />
                                                    <input type="hidden" name="teacherId" value="${req.receiverId}" />
                                                    <input type="hidden" name="learnerId" value="${req.senderId}" />

                                                    <div style="display:flex; gap:0.75rem; flex-wrap:wrap; align-items:flex-end;">
                                                        <div>
                                                            <label style="font-size:0.75rem; font-weight:600; display:block; margin-bottom:0.3rem;">Date & time</label>
                                                            <input type="datetime-local" name="sessionDate" required style="padding:0.5rem; border-radius:0.5rem; border:1px solid var(--border);" />
                                                        </div>
                                                        <div>
                                                            <label style="font-size:0.75rem; font-weight:600; display:block; margin-bottom:0.3rem;">Type</label>
                                                            <select name="sessionType" style="padding:0.5rem; border-radius:0.5rem; border:1px solid var(--border);">
                                                                <option value="Online">Online</option>
                                                                <option value="In-Person">In-Person</option>
                                                            </select>
                                                        </div>
                                                        <div style="flex:1; min-width:200px;">
                                                            <label style="font-size:0.75rem; font-weight:600; display:block; margin-bottom:0.3rem;">Meeting link or location</label>
                                                            <input type="text" name="meetingLink" placeholder="https://meet... or address" style="width:100%; padding:0.5rem; border-radius:0.5rem; border:1px solid var(--border);" />
                                                        </div>
                                                        <button type="submit" class="btn-accept">Confirm</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </c:if>
                                    </div>
                                </article>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="color: #64748b; padding: 1rem 0;">No accepted requests.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Rejected Requests Tab -->
            <div id="tab-Rejected" class="tab-content">
                <div class="requests-list">
                    <c:choose>
                        <c:when test="${not empty rejectedRequests}">
                            <c:forEach var="req" items="${rejectedRequests}">
                                <article class="request-card">
                                    <div class="card-inner">
                                        <!-- UPDATED: Avatar with profile link and photo support -->
                                        <a href="${pageContext.request.contextPath}/profile?id=${req.otherUserId}" class="avatar-link">
                                            <c:choose>
                                                <c:when test="${not empty req.otherUserPhoto}">
                                                    <img src="${pageContext.request.contextPath}/${req.otherUserPhoto}" 
                                                         alt="${req.requesterName}" 
                                                         class="avatar-photo"
                                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                                    <div class="initials-avatar" style="display:none;">${req.initials}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="initials-avatar">${req.initials}</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                        <div class="card-main-content">
                                            <div class="user-name-row">
                                                <!-- UPDATED: Clickable user name -->
                                                <h3 class="person-name">
                                                    <a href="${pageContext.request.contextPath}/profile?id=${req.otherUserId}" style="color:inherit; text-decoration:none;">
                                                        ${req.requesterName}
                                                    </a>
                                                </h3>
                                                <span class="status-pill rejected">Rejected</span>
                                            </div>
                                            <p class="request-subject">requested <strong>${req.skillName}</strong></p>
                                        </div>
                                        <div class="card-actions">
                                            <form action="${pageContext.request.contextPath}/requests" method="post">
                                                <input type="hidden" name="requestId" value="${req.requestId}" />
                                                <input type="hidden" name="action" value="REOPEN" />
                                                <button type="submit" class="btn-reopen">Re-open</button>
                                            </form>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="color: #64748b; padding: 1rem 0;">No rejected requests.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
           <!-- Sent Requests Tab Panel -->
<div id="tab-Sent" class="tab-content">
    <div class="requests-list">
        <c:choose>
            <c:when test="${not empty sentRequests}">
                <c:forEach var="req" items="${sentRequests}">
                    <article class="request-card">
                        <div class="card-inner">
                            <a href="${pageContext.request.contextPath}/profile?id=${req.otherUserId}" class="avatar-link">
                                <c:choose>
                                    <c:when test="${not empty req.otherUserPhoto}">
                                        <img src="${pageContext.request.contextPath}/${req.otherUserPhoto}" 
                                             alt="${req.requesterName}" 
                                             class="avatar-photo"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                        <div class="initials-avatar" style="display:none;">${req.initials}</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="initials-avatar">${req.initials}</div>
                                    </c:otherwise>
                                </c:choose>
                            </a>
                            <div class="card-main-content">
                                <div class="user-name-row">
                                    <h3 class="person-name">
                                        <a href="${pageContext.request.contextPath}/profile?id=${req.otherUserId}" style="color:inherit; text-decoration:none;">
                                            ${req.requesterName}
                                        </a>
                                    </h3>
                                    <c:choose>
                                        <c:when test="${req.status == 'Pending'}">
                                            <span class="status-pill pending">Pending</span>
                                        </c:when>
                                        <c:when test="${req.status == 'Accepted'}">
                                            <span class="status-pill accepted">Accepted</span>
                                        </c:when>
                                        <c:when test="${req.status == 'Rejected'}">
                                            <span class="status-pill rejected">Rejected</span>
                                        </c:when>
                                        <c:when test="${req.status == 'Cancelled'}">
                                            <span class="status-pill rejected">Cancelled by tutor</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                                <p class="request-subject">you requested <strong>${req.skillName}</strong></p>
                            </div>
                            <div class="card-actions">
                                <c:if test="${req.status == 'Pending'}">
                                    <form action="${pageContext.request.contextPath}/requests" method="post">
                                        <input type="hidden" name="requestId" value="${req.requestId}" />
                                        <input type="hidden" name="action" value="SENDER_CANCEL" />
                                        <button type="submit" class="btn-cancel">Cancel request</button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </article>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p style="color: #64748b; padding: 1rem 0;">You haven't sent any learning requests yet.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>
        </main>
    </div>
</div>

<script>
function switchTab(status) {
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.classList.toggle('active', btn.getAttribute('data-tab') === status);
    });
    document.querySelectorAll('.tab-content').forEach(panel => {
        panel.classList.toggle('active', panel.id === 'tab-' + status);
    });
}

function toggleProfileDropdown(event) {
    event.stopPropagation();
    const menu = document.getElementById('profileMenu');
    if (menu) {
        menu.classList.toggle('show');
    }
}

//Event Listeners after DOM loads
document.addEventListener('DOMContentLoaded', function() {
    // Toggle schedule form visibility
    document.querySelectorAll('.toggle-schedule-form').forEach(btn => {
        btn.addEventListener('click', function() {
            const targetId = this.getAttribute('data-target');
            const form = document.getElementById(targetId);
            if (form) {
                form.style.display = (form.style.display === 'none' || form.style.display === '') ? 'block' : 'none';
            }
        });
    });
});

document.addEventListener('click', function(event) {
    const menu = document.getElementById('profileMenu');
    const btn = document.getElementById('profileDropdownBtn');
    if (menu && btn && !btn.contains(event.target) && !menu.contains(event.target)) {
        menu.classList.remove('show');
    }
});
</script>
</body>
</html>