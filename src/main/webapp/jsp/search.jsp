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
    <title>Search Users · SkillSync</title>
    <meta name="description" content="Search SkillSync students by skill, university, rating and availability.">
    
    <!-- Pure CSS Design System -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/search.css">
    
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

            <a href="${pageContext.request.contextPath}/search" class="nav-item active">
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
                <div class="profile-dropdown-wrapper" style="position: relative; z-index: 1000;">
                    <button type="button" class="user-profile-menu" id="profileDropdownBtn" onclick="toggleProfileDropdown(event)">
                        <% 
                            User currentUser = (User) session.getAttribute("currentUser");
                            if (currentUser == null) {
                                currentUser = (User) session.getAttribute("user");
                            }
                            if (currentUser == null) {
                                currentUser = (User) request.getAttribute("currentUser");
                            }

                            String photoPath = (currentUser != null) ? currentUser.getProfilePhoto() : null;
                            boolean hasPhoto = photoPath != null && !photoPath.trim().isEmpty();
                            if (hasPhoto && photoPath.startsWith("/")) {
                                photoPath = photoPath.substring(1);
                            }
                            String fullName = (currentUser != null && currentUser.getFullName() != null) ? currentUser.getFullName() : "User";
                            String userRole = (currentUser != null && currentUser.getRole() != null) ? currentUser.getRole() : "Member";
                            String initials = fullName.length() > 0 ? fullName.substring(0, Math.min(2, fullName.length())).toUpperCase() : "U";
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

        <!-- Search View Container -->
        <main class="search-container">
            <div class="page-header">
                <h1 class="page-title">Search users</h1>
                <p class="page-subtitle">Find someone who teaches exactly what you're stuck on — or who needs exactly what you know.</p>
            </div>

            <div class="search-layout">
                
                <!-- Filter Sidebar -->
                <aside class="filter-card">
                    <div class="filter-header">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 4H3"/><path d="M10 12H3"/><path d="M18 20H3"/><path d="M14 2v4"/><path d="M12 10v4"/><path d="M16 18v4"/></svg>
                        <span>Filters</span>
                    </div>

                    <form id="searchFilterForm" method="GET" action="${pageContext.request.contextPath}/search" class="filter-form">
                        
                        <div class="form-group">
                            <label for="queryInput">Skill or name</label>
                            <div class="form-input-wrapper">
                                <span class="input-icon">🔍</span>
                                <input type="text" id="queryInput" name="q" value="${param.q}" placeholder="e.g. Machine Learning" class="form-input">
                            </div>
                        </div>

                        <div class="form-group">
    <label for="universitySelect">University</label>
    <select id="universitySelect" name="uni" class="form-select">
        <!-- Default Option -->
        <option value="all" ${empty selectedUni || selectedUni == 'all' ? 'selected' : ''}>
            All universities
        </option>

        <!-- Dynamically populated options from SearchServlet -->
        <c:forEach var="u" items="${universities}">
            <option value="${u}" ${selectedUni == u ? 'selected' : ''}>
                ${u}
            </option>
        </c:forEach>
    </select>
</div>

                        <div class="form-group">
                            <div class="slider-label-row">
                                <label for="ratingSlider">Minimum rating</label>
                                <span id="ratingValDisplay" class="rating-display">${empty param.minRating ? '3.0' : param.minRating}★</span>
                            </div>
                            <input type="range" id="ratingSlider" name="minRating" min="3.0" max="5.0" step="0.1" value="${empty param.minRating ? '3.0' : param.minRating}" class="range-slider">
                        </div>

                        <div class="form-group">
                            <label>Availability</label>
                            <label class="checkbox-label">
                                <input type="checkbox" id="onlineCheckbox" name="online" value="true" ${param.online == 'true' ? 'checked' : ''}>
                                <span>Available now</span>
                            </label>
                        </div>

                        <div class="form-group">
                            <label for="sortSelect">Sort by</label>
                            <select id="sortSelect" name="sort" class="form-select">
                                <option value="match" ${param.sort == null || param.sort == 'match' ? 'selected' : ''}>Best match</option>
                                <option value="rating" ${param.sort == 'rating' ? 'selected' : ''}>Highest rating</option>
                                <option value="reputation" ${param.sort == 'reputation' ? 'selected' : ''}>Reputation score</option>
                            </select>
                        </div>

                        <button type="submit" class="btn-apply">Apply Filters</button>
                    </form>
                </aside>

                <!-- Search Results Area -->
                <div class="results-column">
                    <div class="results-count-bar">
                        <strong>${not empty people ? fn:length(people) : 0}</strong> students match your filters
                    </div>

                    <c:choose>
                        <c:when test="${empty people}">
                            <div class="empty-state-card">
                                <div class="empty-icon">🔍</div>
                                <h3 class="empty-title">No students found</h3>
                                <p class="empty-subtitle">Try loosening the rating filter or searching a broader skill area.</p>
                                <a href="${pageContext.request.contextPath}/search" class="btn-reset">Reset filters</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="user-cards-grid">
                                <c:forEach var="person" items="${people}">
                                    <article class="user-card" style="height: auto; min-height: fit-content;">
    
                                        <!-- Profile Header -->
                                        <div class="card-top-row">
                                            <div class="user-profile-info">
                                                <a href="${pageContext.request.contextPath}/profile?id=${not empty person.id ? person.id : person.userId}" style="text-decoration: none;">
                                                    <div class="card-avatar" style="overflow: hidden; display: flex; align-items: center; justify-content: center;">
                                                        <c:choose>
                                                            <%-- Safely check avatar string length --%>
                                                            <c:when test="${not empty person.avatar and fn:length(person.avatar) <= 2}">
                                                                <span style="font-weight: bold; color: white;">${person.avatar}</span>
                                                            </c:when>
                                                            <c:when test="${not empty person.avatar}">
                                                                <img src="${pageContext.request.contextPath}/${person.avatar}" 
                                                                     alt="${person.name}'s avatar" 
                                                                     style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="font-weight: bold; color: white;">
                                                                    ${not empty person.name ? fn:substring(person.name, 0, 2) : 'U'}
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </a>

                                                <div class="card-user-details">
                                                    <h3>
                                                        <a href="${pageContext.request.contextPath}/profile?id=${not empty person.id ? person.id : person.userId}" style="text-decoration: none; color: inherit;">
                                                            ${not empty person.name ? person.name : 'Unknown Student'}
                                                        </a>
                                                    </h3>
                                                    <p class="card-location">
                                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
                                                        ${not empty person.university ? person.university : 'SkillSync Member'}
                                                    </p>
                                                </div>
                                            </div>
                                            <span class="match-pill">${not empty person.match ? person.match : 0}%</span>
                                        </div>

                                        <!-- Ratings Row -->
                                        <div class="card-ratings-row">
                                            <div class="stars-group">
                                                ★ ★ ★ ★ ★ <strong style="color: var(--foreground); margin-left: 0.2rem;">${not empty person.rating ? person.rating : '0.0'}</strong>
                                            </div>
                                            <div class="reviews-count">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                                ${not empty person.reputation ? person.reputation : 0}
                                            </div>
                                        </div>

                                        <!-- Badges Row -->
                                        <c:if test="${not empty person.badges or not empty person.reputationLevel}">
                                            <div class="card-tags-row">
                                                <c:if test="${not empty person.badges}">
                                                    <c:forEach var="badge" items="${person.badges}" varStatus="loopStatus">
                                                        <c:if test="${loopStatus.first}">
                                                            <span class="badge-tag">
                                                                🏆 ${badge}
                                                            </span>
                                                        </c:if>
                                                    </c:forEach>
                                                </c:if>
                                                <c:if test="${not empty person.reputationLevel}">
                                                    <span class="level-tag">${person.reputationLevel} level</span>
                                                </c:if>
                                            </div>
                                        </c:if>

                                       <!-- Skill Pills -->
                                        <c:if test="${not empty person.teaching}">
                                            <div class="card-tags-row">
                                                <c:forEach var="skill" items="${person.teaching}">
                                                    <span class="skill-pill">${skill}</span>
                                                </c:forEach>
                                            </div>
                                        </c:if>

                                        <!-- Shared Interests Row -->
                                        <c:if test="${not empty person.commonInterests}">
                                            <div class="shared-interests-row" style="margin-top: 0.5rem; display: flex; flex-wrap: wrap; align-items: center; gap: 0.25rem;">
                                                <small style="font-size: 0.75rem; color: #64748b; font-weight: 600; width: 100%;">Shared Interests:</small>
                                                <c:forEach var="interest" items="${person.commonInterests}">
                                                    <span class="skill-pill" style="background-color: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; font-size: 0.75rem; padding: 0.15rem 0.5rem; border-radius: 9999px;">
                                                        ${interest}
                                                    </span>
                                                </c:forEach>
                                            </div>
                                        </c:if>

                                        <!-- Action Buttons -->
<div class="card-actions-row" style="margin-top: 1rem; display: flex; gap: 0.5rem;">
    <a href="${pageContext.request.contextPath}/profile?id=${not empty person.id ? person.id : person.userId}" class="btn-profile" style="flex: 1; text-align: center; display: inline-block;">View profile</a>

    <c:choose>
        <c:when test="${person.requestSent}">
            <button type="button" class="btn-connect btn-requested" disabled style="flex: 1;">
                Requested
            </button>
        </c:when>
        <c:otherwise>
            <button type="button"
                    class="btn-connect connect-btn"
                    data-receiver-id="${not empty person.id ? person.id : person.userId}"
                    data-skill-id="${person.skillId}"
                    style="flex: 1;">
                Connect
            </button>
        </c:otherwise>
    </c:choose>
</div>

                                    </article>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </main>
    </div>
</div>

<script>
    // Rating slider display updater
    
    const contextPath = "${pageContext.request.contextPath}";
    const slider = document.getElementById('ratingSlider');
    const display = document.getElementById('ratingValDisplay');
    if (slider && display) {
        slider.addEventListener('input', (e) => {
            display.textContent = parseFloat(e.target.value).toFixed(1) + '★';
        });
    }

    function toggleProfileDropdown(event) {
        event.preventDefault();
        event.stopPropagation();
        console.log('toggle fired'); 
        
        // Target the specific parent wrapper relative to the clicked button
        const wrapper = event.currentTarget.closest('.profile-dropdown-wrapper');
        if (wrapper) {
            wrapper.classList.toggle('open');
        }
    }

    // Close dropdown when clicking anywhere outside
    document.addEventListener('click', function(event) {
        const activeDropdown = document.querySelector('.profile-dropdown-wrapper.open');
        if (activeDropdown && !activeDropdown.contains(event.target)) {
            activeDropdown.classList.remove('open');
        }
    });

    // Close dropdown on Escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            const activeDropdown = document.querySelector('.profile-dropdown-wrapper.open');
            if (activeDropdown) {
                activeDropdown.classList.remove('open');
            }
        }
    });
    
 // --- Connect button AJAX handler ---
    document.querySelectorAll(".connect-btn").forEach(button => {
        button.addEventListener("click", function () {
            const receiverId = this.getAttribute("data-receiver-id");
            const skillId = this.getAttribute("data-skill-id");
            const btn = this;

            if (!skillId || parseInt(skillId) <= 0) {
                alert("This user hasn't listed a skill yet, so a request can't be sent.");
                return;
            }

            btn.disabled = true;
            const originalText = btn.textContent;
            btn.textContent = "Sending...";

            fetch(contextPath + "/send-request", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "receiverId=" + encodeURIComponent(receiverId) + "&skillId=" + encodeURIComponent(skillId)
            })
            .then(response => {
                if (response.ok) {
                    btn.classList.remove("connect-btn");
                    btn.classList.add("btn-requested");
                    btn.textContent = "Requested";
                    btn.disabled = true;
                } else {
                    alert("Failed to send request. Please try again.");
                    btn.disabled = false;
                    btn.textContent = originalText;
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert("An error occurred while sending the request.");
                btn.disabled = false;
                btn.textContent = originalText;
            });
        });
    });
</script>
</body>
</html>