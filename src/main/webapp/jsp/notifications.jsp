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
    <title>Notifications · SkillSync</title>
    <meta name="description" content="All your SkillSync activity: learning requests, accepted sessions, messages, tokens and badges.">
    
    <!-- Design System CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notifications.css?v=1">
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

            <a href="${pageContext.request.contextPath}/notifications" class="nav-item active">
                <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg></span>
                <span>Notifications</span>
                <c:if test="${not empty unreadCount and unreadCount > 0}">
                    <span class="nav-badge">${unreadCount}</span>
                </c:if>
            </a>
            
            <a href="${pageContext.request.contextPath}/ProfileServlet" class="nav-item">
                <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></span>
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
            <div class="wallet-balance-val">${currentUser.tokenBalance}</div>
            <div class="wallet-sub">+100 monthly top-up on the 1st</div>
            <a href="${pageContext.request.contextPath}/wallet" class="btn-wallet">Open wallet</a>
        </div>
    </aside>


    <!-- Main Content Area -->
    <div class="main-wrapper">
        
        <!-- Header -->
        <!-- Top Navbar -->
        <header class="top-header">
            <form action="${pageContext.request.contextPath}/search" method="GET" class="header-search">
                <svg class="search-icon-pos" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                <input type="text" name="q" value="${param.q}" placeholder="Search skills, people, universities…">
            </form>

            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/notifications" class="icon-btn" title="Notifications">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg>
                    <c:if test="${not empty unreadCount and unreadCount > 0}">
                        <span class="notification-dot"></span>
                    </c:if>
                </a>

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

        <!-- Main Notifications View -->
        <main class="notifications-container">
            <div class="page-header-row">
                <div>
                    <h1 class="page-title">Notifications</h1>
                    <p class="page-subtitle">Grouped by what actually needs you — requests and sessions first, everything else after.</p>
                </div>
                <form action="${pageContext.request.contextPath}/notifications" method="post">
                    <input type="hidden" name="action" value="MARK_ALL_READ" />
                    <button type="submit" class="btn-mark-all">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6 7 17l-5-5"/><path d="m22 10-7.5 7.5L13 16"/></svg>
                        Mark all read
                    </button>
                </form>
            </div>

            <div class="notifications-list">
                <c:choose>
                    <c:when test="${not empty notifications}">
                        <c:forEach var="n" items="${notifications}" varStatus="status">
                            <c:set var="typeLower" value="${fn:toLowerCase(n.type)}" />
                            
                            <!-- Determine dynamic destination link based on notification type -->
                            <c:choose>
                                <c:when test="${fn:contains(typeLower, 'token')}">
                                    <c:set var="targetUrl" value="${pageContext.request.contextPath}/wallet" />
                                </c:when>
                                <c:when test="${fn:contains(typeLower, 'review')}">
                                    <c:set var="targetUrl" value="${pageContext.request.contextPath}/reviews" />
                                </c:when>
                                <c:when test="${fn:contains(typeLower, 'session')}">
                                    <c:set var="targetUrl" value="${pageContext.request.contextPath}/sessions" />
                                </c:when>
                                <c:when test="${fn:contains(typeLower, 'request')}">
                                    <c:set var="targetUrl" value="${pageContext.request.contextPath}/requests" />
                                </c:when>
                                <c:when test="${fn:contains(typeLower, 'badge')}">
                                    <c:set var="targetUrl" value="${pageContext.request.contextPath}/jsp/achievements.jsp" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="targetUrl" value="#" />
                                </c:otherwise>
                            </c:choose>

                            <a href="${targetUrl}" class="notification-card-link" style="text-decoration:none; color:inherit; display:block;">
                                <div class="notification-card surface-card lift animate-fade-up ${n.unread ? 'is-unread' : ''}" style="animation-delay: ${status.index * 60}ms;">
                                    
                                    <!-- Icon Badge dynamically mapped to type -->
                                    <div class="icon-badge tone-${typeLower}">
                                        <c:choose>
                                            <c:when test="${fn:contains(typeLower, 'request')}">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"/><path d="M5.45 5.11 2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"/></svg>
                                            </c:when>
                                            <c:when test="${fn:contains(typeLower, 'session')}">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/><path d="m9 16 2 2 4-4"/></svg>
                                            </c:when>
                                            <c:when test="${fn:contains(typeLower, 'review')}">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                            </c:when>
                                            <c:when test="${fn:contains(typeLower, 'token')}">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="8" cy="8" r="6"/><path d="M18 0 6 12"/><circle cx="16" cy="16" r="6"/></svg>
                                            </c:when>
                                            <c:when test="${fn:contains(typeLower, 'badge')}">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"/></svg>
                                            </c:when>
                                            <c:otherwise>
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Notification Content -->
                                    <div class="notification-body">
                                        <div class="title-row">
                                            <span class="notification-title">${n.title}</span>
                                            <c:if test="${n.unread}">
                                                <span class="unread-dot"></span>
                                            </c:if>
                                        </div>
                                        <p class="notification-text">${n.body}</p>
                                    </div>

                                    <!-- Relative Timestamp -->
                                    <span class="notification-time">${n.time}</span>
                                </div>
                            </a>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- Dynamic Empty State when user has zero notifications -->
                        <div class="empty-notifications-card surface-card" style="text-align: center; padding: 3rem 1.5rem; border-radius: 12px; background: rgba(255,255,255,0.02); border: 1px dashed rgba(255,255,255,0.1);">
                            <div style="margin-bottom: 1rem; color: var(--text-muted, #8b949e);">
                                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg>
                            </div>
                            <h3 style="font-size: 1.15rem; font-weight: 600; margin-bottom: 0.5rem; color: var(--text-main, #e6edf3);">You're all caught up!</h3>
                            <p style="font-size: 0.9rem; color: var(--text-muted, #8b949e); max-width: 400px; margin: 0 auto;">No new notifications right now. Activity on your sessions, reviews, and tokens will show up here.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>

<script>
function toggleProfileDropdown(event) {
    event.stopPropagation();
    const menu = document.getElementById('profileMenu');
    menu.classList.toggle('show');
}

window.addEventListener('click', function() {
    const menu = document.getElementById('profileMenu');
    if (menu && menu.classList.contains('show')) {
        menu.classList.remove('show');
    }
});
</script>

</body>
</html>