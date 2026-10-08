<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillsync.model.User" %>
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
    <title>AI Matching - SkillSync</title>
    
    <!-- External CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/aimatching.css">
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
            
            <a href="${pageContext.request.contextPath}/MatchingServlet" class="nav-item active">
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

    <!-- Main Content Wrapper -->
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

        <!-- Main Content Area -->
        <main class="dashboard-content">
            <!-- Header Title -->
            <div class="page-header">
                <div>
                    <h1 class="page-title">AI match results</h1>
                    <p class="page-subtitle">We scored candidates on complementary skills, shared interests, availability overlap, and reputation.</p>
                </div>
                <button type="button" class="btn-brand" id="rerunBtn" onclick="rerunMatching()">
    <svg id="rerunIcon" style="margin-right:0.5rem;" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/><path d="M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16"/><path d="M16 16h5v5"/></svg>
    <span id="rerunText">Re-run matching</span>
</button>
            </div>

            <!-- Profile Signal Banner -->
            <div class="aurora-card">
                <div class="progress-ring-container">
                    <svg width="84" height="84">
                        <circle cx="42" cy="42" r="34" stroke="#e2e8f0" stroke-width="6" fill="transparent" />
                        <circle cx="42" cy="42" r="34" stroke="#00bba7" stroke-width="6" fill="transparent"
                                stroke-dasharray="213.6" stroke-dashoffset="12.8" stroke-linecap="round" transform="rotate(-90 42 42)" />
                    </svg>
                    <div class="progress-ring-val">94%<span>signal</span></div>
                </div>
                <div>
                    <div style="display:flex; align-items:center; gap:0.375rem; color:#0d9488; font-size:0.875rem; font-weight:600;">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m12 3-1.9 5.8a2 2 0 0 1-1.28 1.28L3 12l5.8 1.9a2 2 0 0 1 1.28 1.28L12 21l1.9-5.8a2 2 0 0 1 1.28-1.28L21 12l-5.8-1.9a2 2 0 0 1-1.28-1.28z"/></svg>
                        Why these matches
                    </div>
                    <p style="margin: 0.375rem 0 0.75rem 0; font-size: 0.875rem; color: #64748b; max-width: 600px;">
                        Your strongest signal is complementary skill overlap paired with active availability. Adding more learning goals raises your overall candidate compatibility ceiling.
                    </p>
                    <div style="display:flex; gap:0.375rem;">
                        <span class="badge-chip">Complementary skills</span>
                        <span class="badge-chip">Availability overlap</span>
                        <span class="badge-chip">Reputation weighting</span>
                    </div>
                </div>
            </div>

            <!-- Candidate Cards Grid -->
            <section class="match-grid">
                <c:forEach var="match" items="${matches}">
                    <article class="user-card">
                        <div>
                            <div class="card-header">
                                <div class="avatar-circle">
                                    <c:choose>
                                        <c:when test="${not empty match.profilePhoto}">
                                            <img src="${pageContext.request.contextPath}/${match.profilePhoto}" alt="${match.fullName}">
                                        </c:when>
                                        <c:otherwise>
                                            ${not empty match.fullName ? fn:substring(match.fullName, 0, 2) : 'US'}
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="user-info">
                                    <h3 class="user-name">${match.fullName}</h3>
                                    <p class="user-uni">${not empty match.university ? match.university : 'University Student'}</p>
                                    
                                    <div class="meta-stats">
                                        <span>★ ${match.rating > 0 ? match.rating : '4.8'}</span>
                                        <span>•</span>
                                        <span>${match.reputationDisplay} rep</span>
                                    </div>

                                    <div class="badge-list">
                                        <c:forEach var="explanation" items="${match.explanations}">
                                            <span class="badge-chip">✓ ${explanation}</span>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="progress-ring-container">
                                    <svg width="68" height="68">
                                        <circle cx="34" cy="34" r="26" stroke="#e2e8f0" stroke-width="5" fill="transparent" />
                                        <circle cx="34" cy="34" r="26" stroke="#00bba7" stroke-width="5" fill="transparent"
                                                stroke-dasharray="163.3" stroke-dashoffset="${163.3 - (163.3 * match.matchScore / 100)}" 
                                                stroke-linecap="round" transform="rotate(-90 34 34)" />
                                    </svg>
                                    <div class="progress-ring-val" style="font-size:0.75rem;">
                                        ${match.matchScoreRounded}%
                                        <span>match</span>
                                    </div>
                                </div>
                            </div>

                            <div class="skills-container">
                                <div>
                                    <div class="skill-group-title">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>
                                        Matched Teaching Skills
                                    </div>
                                    <div class="skill-chips-row">
                                        <c:forEach var="skill" items="${match.matchedSkills}">
                                            <span class="skill-chip">${skill}</span>
                                        </c:forEach>
                                        <c:if test="${empty match.matchedSkills}">
                                            <span class="skill-chip muted">General Mentorship</span>
                                        </c:if>
                                    </div>
                                </div>

                                <div>
                                    <div class="skill-group-title">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="6"/><circle cx="12" cy="12" r="2"/></svg>
                                        Learning Goals
                                    </div>
                                    <div class="skill-chips-row">
                                        <span class="skill-chip accent">Web Development</span>
                                        <span class="skill-chip accent">Software Engineering</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- AFTER -->
<div class="card-actions">
    <c:choose>
        <c:when test="${match.requestSent}">
            <button type="button" class="btn-brand btn-requested" disabled style="width: 100%;">
                Requested
            </button>
        </c:when>
        <c:otherwise>
            <button type="button"
                    class="btn-brand connect-btn"
                    data-receiver-id="${match.userId}"
                    data-skill-id="${match.skillId}"
                    style="width: 100%;">
                Connect
            </button>
        </c:otherwise>
    </c:choose>
    <a href="${pageContext.request.contextPath}/profile?id=${match.userId}" class="btn-outline">View profile</a>
</div>
                    </article>
                </c:forEach>
            </section>
        </main>
    </div>
</div>

<script>
    const contextPath = "${pageContext.request.contextPath}";

    function toggleProfileDropdown(event) {
        event.stopPropagation();
        const wrapper = document.querySelector('.profile-dropdown-wrapper');
        if (wrapper) {
            wrapper.classList.toggle('open');
        }
    }

    document.addEventListener('click', function(event) {
        const wrapper = document.querySelector('.profile-dropdown-wrapper');
        if (wrapper && !wrapper.contains(event.target)) {
            wrapper.classList.remove('open');
        }
    });

    function rerunMatching() {
        const btn = document.getElementById('rerunBtn');
        const icon = document.getElementById('rerunIcon');
        const text = document.getElementById('rerunText');
        btn.disabled = true;
        btn.style.opacity = '0.75';
        btn.style.cursor = 'not-allowed';
        text.textContent = 'Calculating scores...';
        icon.style.animation = 'spin 2s linear infinite';
        window.location.href = contextPath + '/matching';
    }

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