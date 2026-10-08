<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillsync.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    int tokenBalance = (currentUser != null) ? currentUser.getTokenBalance() : 320;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reviews · SkillSync</title>
    <!-- Inter Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reviews.css?v=2">
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

                <a href="${pageContext.request.contextPath}/reviews" class="nav-item active">
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
                                String photoPath = currentUser != null ? currentUser.getProfilePhoto() : null;
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
                            <% } else if (currentUser != null) { %>
                                <div class="user-avatar-badge">
                                    <%= currentUser.getFullName().substring(0, Math.min(2, currentUser.getFullName().length())).toUpperCase() %>
                                </div>
                            <% } %>

                            <div class="user-details">
                                <div class="user-name-label"><%= currentUser != null ? currentUser.getFullName() : "User" %></div>
                                <div class="user-role-label"><%= currentUser != null ? currentUser.getRole() : "Member" %></div>
                            </div>
                            
                            <svg class="dropdown-arrow" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m6 9 6 6 6-6"/></svg>
                        </button>

                        <!-- Dropdown Menu -->
                        <div class="profile-dropdown-menu" id="profileMenu">
                            <div class="dropdown-header">
                                <span class="username-tag">@<%= (currentUser != null && currentUser.getEmail() != null) ? currentUser.getEmail().split("@")[0] : "user" %></span>
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

            <div class="content-container">
                <div class="page-header">
                    <h1>Reviews</h1>
                    <p>Reviews are only unlocked after a completed session, so every rating is earned.</p>
                </div>

                <div class="reviews-grid">
                    <!-- Left Column: Metrics, Breakdown & Post Form -->
                    <div class="left-panel">
                        <!-- Score Banner -->
                        <div class="surface-card aurora review-summary-card">
                            <div class="progress-ring-container">
                                <svg class="progress-ring" width="110" height="110">
                                    <circle class="ring-bg" cx="55" cy="55" r="48" />
                                    <circle class="ring-fill" cx="55" cy="55" r="48" stroke-dasharray="301.59" stroke-dashoffset="60" />
                                </svg>
                                <div class="ring-content">
                                    <span class="ring-val">${not empty rating ? rating : '0.0'} ★</span>
                                    <span class="ring-lbl">avg rating</span>
                                </div>
                            </div>
                            <div class="summary-meta">
                                <div class="star-group">
                                    <i class="fa-solid fa-star star-filled"></i>
                                    <i class="fa-solid fa-star star-filled"></i>
                                    <i class="fa-solid fa-star star-filled"></i>
                                    <i class="fa-solid fa-star star-filled"></i>
                                    <i class="fa-solid fa-star star-filled"></i>
                                </div>
                                <div class="verified-text">${not empty totalReviews ? totalReviews : 0} verified reviews</div>
                                <div class="reputation-text">${not empty reputationScore ? reputationScore : 0} · ${not empty reputationTier ? reputationTier : 'Member'}</div>
                            </div>
                        </div>

                        <!-- Rating Breakdown -->
                        <div class="surface-card section-card">
                            <h3 class="section-title">Rating breakdown</h3>
                            <p class="section-subtitle">Across all completed sessions</p>

                            <div class="distribution-list">
                                <div class="dist-row">
                                    <span class="dist-label">5 <i class="fa-solid fa-star star-icon"></i></span>
                                    <div class="bar-track"><div class="bar-fill" style="width: 82%;"></div></div>
                                    <span class="dist-pct">82%</span>
                                </div>
                                <div class="dist-row">
                                    <span class="dist-label">4 <i class="fa-solid fa-star star-icon"></i></span>
                                    <div class="bar-track"><div class="bar-fill" style="width: 14%;"></div></div>
                                    <span class="dist-pct">14%</span>
                                </div>
                                <div class="dist-row">
                                    <span class="dist-label">3 <i class="fa-solid fa-star star-icon"></i></span>
                                    <div class="bar-track"><div class="bar-fill" style="width: 3%;"></div></div>
                                    <span class="dist-pct">3%</span>
                                </div>
                                <div class="dist-row">
                                    <span class="dist-label">2 <i class="fa-solid fa-star star-icon"></i></span>
                                    <div class="bar-track"><div class="bar-fill" style="width: 1%;"></div></div>
                                    <span class="dist-pct">1%</span>
                                </div>
                                <div class="dist-row">
                                    <span class="dist-label">1 <i class="fa-solid fa-star star-icon"></i></span>
                                    <div class="bar-track"><div class="bar-fill" style="width: 0%;"></div></div>
                                    <span class="dist-pct">0%</span>
                                </div>
                            </div>
                        </div>

                        <!-- Write a Review Form -->
                        <div class="surface-card section-card">
                            <h3 class="section-title">Write a review</h3>
                            <p class="section-subtitle">Select a completed session to leave feedback</p>

                            <c:choose>
                                <c:when test="${not empty pendingReviews}">
                                    <form action="${pageContext.request.contextPath}/ReviewServlet" method="POST" class="review-form">
                                        <div class="form-group" style="margin-bottom: 1rem;">
                                            <label for="sessionId" style="display: block; margin-bottom: 0.5rem; font-size: 0.875rem; font-weight: 500;">Select Completed Session</label>
                                            <select name="sessionId" id="sessionId" required class="form-control" style="width: 100%; padding: 0.75rem; border-radius: 8px; border: 1px solid var(--border-color, #e2e8f0); background-color: var(--bg-surface, #fff); color: inherit;">
                                                <option value="">Choose a completed session...</option>
                                                <c:forEach var="item" items="${pendingReviews}">
                                                    <option value="${item.sessionId}">
                                                        ${item.revieweeName} — ${item.skillName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <input type="hidden" name="rating" id="selectedRating" value="5" />
                                        
                                        <div class="star-picker" id="starPicker">
                                            <i class="fa-solid fa-star picker-star active" data-val="1"></i>
                                            <i class="fa-solid fa-star picker-star active" data-val="2"></i>
                                            <i class="fa-solid fa-star picker-star active" data-val="3"></i>
                                            <i class="fa-solid fa-star picker-star active" data-val="4"></i>
                                            <i class="fa-solid fa-star picker-star active" data-val="5"></i>
                                        </div>

                                        <textarea name="reviewText" rows="4" maxlength="1000" required class="review-textarea" placeholder="What did they explain well? What could be sharper?"></textarea>

                                        <button type="submit" class="btn-gradient btn-publish">
                                            <i class="fa-solid fa-pen"></i> Publish Review
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <p class="empty-state" style="color: #64748b; font-size: 0.9rem; margin-top: 1rem;">No completed sessions available to review right now.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Right Column: Peer Reviews Feed -->
                    <div class="right-panel">
                        <div class="review-list">
                            <c:choose>
                                <c:when test="${not empty reviews}">
                                    <c:forEach var="rev" items="${reviews}">
                                        <article class="surface-card review-card lift">
                                            <div class="card-header flex-header">
                                                <a href="${pageContext.request.contextPath}/ProfileServlet?userId=${rev.reviewerId}" 
   													class="reviewer-profile-link" 
   													style="display: flex; align-items: center; gap: 0.75rem; text-decoration: none; color: inherit;">
                                                    <div class="avatar avatar-teal">
                                                        <c:choose>
                                                            <c:when test="${not empty rev.reviewerPhoto}">
                                                                <img src="${pageContext.request.contextPath}/${rev.reviewerPhoto.startsWith('/') ? rev.reviewerPhoto.substring(1) : rev.reviewerPhoto}" 
                                                                     alt="${rev.reviewerName}" 
                                                                     style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;" 
                                                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                                                <span style="display: none;">
                                                                    <c:out value="${not empty rev.reviewerName ? rev.reviewerName.substring(0,1).toUpperCase() : 'U'}" />
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:out value="${not empty rev.reviewerName ? rev.reviewerName.substring(0,1).toUpperCase() : 'U'}" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="author-info">
                                                        <div class="author-name" style="font-weight: 600; font-size: 0.95rem;">${rev.reviewerName}</div>
                                                        <div class="review-sub">
                                                            <span class="stars-mini">
                                                                <c:forEach begin="1" end="${rev.rating}">
                                                                    <i class="fa-solid fa-star"></i>
                                                                </c:forEach>
                                                            </span>
                                                            ${rev.skillName} · ${rev.reviewDate}
                                                        </div>
                                                    </div>
                                                </a>
                                            </div>
                                            <p class="review-body" style="margin-top: 0.75rem;">${rev.comment}</p>
                                        </article>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="surface-card review-card" style="text-align: center; color: #64748b; padding: 2rem;">
                                        <p>No reviews posted yet.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
    // 1. Toggle Profile Dropdown Menu
    function toggleProfileDropdown(event) {
        event.stopPropagation();
        const profileMenu = document.getElementById('profileMenu');
        profileMenu.classList.toggle('show');
    }

    // 2. Close Dropdown When Clicking Outside
    window.addEventListener('click', function(event) {
        const profileMenu = document.getElementById('profileMenu');
        const profileBtn = document.getElementById('profileDropdownBtn');
        
        if (profileMenu && profileMenu.classList.contains('show')) {
            if (!profileBtn.contains(event.target) && !profileMenu.contains(event.target)) {
                profileMenu.classList.remove('show');
            }
        }
    });

    // 3. Interactive Star Rating Picker
    const stars = document.querySelectorAll('.picker-star');
    const ratingInput = document.getElementById('selectedRating');

    stars.forEach(star => {
        star.addEventListener('click', () => {
            const val = parseInt(star.getAttribute('data-val'));
            if (ratingInput) ratingInput.value = val;
            
            stars.forEach(s => {
                const sVal = parseInt(s.getAttribute('data-val'));
                if (sVal <= val) {
                    s.classList.add('active');
                    s.classList.remove('fa-regular');
                    s.classList.add('fa-solid');
                } else {
                    s.classList.remove('active');
                    s.classList.remove('fa-solid');
                    s.classList.add('fa-regular');
                }
            });
        });
    });
    </script>
</body>
</html>