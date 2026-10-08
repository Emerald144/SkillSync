<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillsync.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    int tokenBalance = (currentUser != null) ? currentUser.getTokenBalance() : 0;
%>

<c:set var="earnedTotal" value="0" />
<c:set var="spentTotal" value="0" />
<c:forEach var="tx" items="${transactions}">
    <c:choose>
        <c:when test="${tx.receiverId == sessionScope.currentUser.userId}">
            <c:set var="earnedTotal" value="${earnedTotal + tx.amount}" />
        </c:when>
        <c:otherwise>
            <c:set var="spentTotal" value="${spentTotal + tx.amount}" />
        </c:otherwise>
    </c:choose>
</c:forEach>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Token Wallet · SkillSync</title>
    
    <!-- 1. Global / Layout Styles (App Shell, Sidebar, Header, CSS Variables) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/wallet.css?v=2">
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

            <a href="${pageContext.request.contextPath}/reviews" class="nav-item">
                <span class="nav-icon">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                </span>
                <span>Reviews</span>
            </a>

            <a href="${pageContext.request.contextPath}/wallet" class="nav-item active">
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
                                <%= (currentUser != null && currentUser.getFullName() != null) ? currentUser.getFullName().substring(0, Math.min(2, currentUser.getFullName().length())).toUpperCase() : "US" %>
                            </div>
                        <% } else if (currentUser != null && currentUser.getFullName() != null) { %>
                            <div class="user-avatar-badge">
                                <%= currentUser.getFullName().substring(0, Math.min(2, currentUser.getFullName().length())).toUpperCase() %>
                            </div>
                        <% } else { %>
                            <div class="user-avatar-badge">US</div>
                        <% } %>

                        <div class="user-details">
                            <div class="user-name-label"><%= currentUser != null ? currentUser.getFullName() : "User" %></div>
                            <div class="user-role-label"><%= currentUser != null ? currentUser.getRole() : "" %></div>
                        </div>
                        
                        <svg class="dropdown-arrow" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m6 9 6 6 6-6"/></svg>
                    </button>

                    <div class="profile-dropdown-menu" id="profileMenu">
                        <div class="dropdown-header">
                            <span class="username-tag">@<%= (currentUser != null && currentUser.getEmail() != null) ? currentUser.getEmail().split("@")[0] : (currentUser != null ? currentUser.getFullName().toLowerCase().replaceAll("\\s+", "") : "user") %></span>
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

    <div class="wallet-container">
        <div class="page-header">
            <h1>Token wallet</h1>
            <p>Tokens are the currency of reciprocity: teach to earn, learn to spend.</p>
        </div>

        <div class="wallet-grid">
            <div class="left-column">
                <div class="surface-card aurora-card">
                    <div class="aurora-content">
                        <div class="balance-label">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="8" cy="8" r="6"/><path d="M18 0.99a6 6 0 1 1 0 12"/><path d="M6 18h12"/></svg>
                            Current balance
                        </div>
                        <div class="balance-value">${balance != null ? balance : tokenBalance}</div>
                        <p class="balance-subtext">+100 monthly top-up arrives on the 1st</p>
                        
                        <div class="balance-actions">
                            <a href="${pageContext.request.contextPath}/requests" class="btn-brand">Teach to earn</a>
                            <a href="${pageContext.request.contextPath}/search" class="btn-outline">Request a session</a>
                        </div>
                    </div>

                    <div class="progress-ring-container">
                        <svg class="progress-ring-svg" width="124" height="124" viewBox="0 0 120 120">
                            <circle class="progress-ring-circle-bg" stroke-width="8" fill="transparent" r="52" cx="60" cy="60"/>
                            <circle class="progress-ring-circle" stroke-width="8" stroke-linecap="round" fill="transparent" r="52" cx="60" cy="60"/>
                        </svg>
                        <div class="progress-ring-text">
                            <div class="progress-ring-val">72%</div>
                            <div class="progress-ring-lbl">of monthly cap</div>
                        </div>
                    </div>
                </div>

                <div class="stats-grid">
                    <div class="surface-card stat-card">
                        <div class="stat-card-header">
                            <div class="stat-icon-wrap success">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="17" y1="7" x2="7" y2="17"/><polyline points="17 17 7 17 7 7"/></svg>
                            </div>
                            <span class="stat-delta">90 days</span>
                        </div>
                        <div class="stat-label">Tokens earned</div>
                        <div class="stat-value">${earnedTotal}</div>
                    </div>

                    <div class="surface-card stat-card filter-card" id="card-spent" onclick="filterTransactions('spent', this)" title="Click to filter spent transactions">
                        <div class="stat-card-header">
                            <div class="stat-icon-wrap warning">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="7" y1="17" x2="17" y2="7"/><polyline points="7 7 17 7 17 17"/></svg>
                            </div>
                            <span class="stat-delta">90 days</span>
                        </div>
                        <div class="stat-label">Tokens spent</div>
                        <div class="stat-value">${spentTotal}</div>
                    </div>
                    
                    
				<a href="${pageContext.request.contextPath}/jsp/achievements.jsp" class="surface-card stat-card filter-card-link" title="Click to view Achievements">
                    <div class="stat-card-header">
                            <div class="stat-icon-wrap info">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 12 20 22 4 22 4 12"/><rect x="2" y="7" width="20" height="5"/><line x1="12" y1="22" x2="12" y2="7"/><path d="M12 7H7.5a2.5 2.5 0 0 1 0-5C11 2 12 7 12 7z"/><path d="M12 7h4.5a2.5 2.5 0 0 0 0-5C13 2 12 7 12 7z"/></svg>
                            </div>
                            <span class="stat-delta">1 badge</span>
                        </div>
                        <div class="stat-label">Bonus rewards</div>
                        <div class="stat-value">30</div>
                    </a>
                </div>
                </div>

                <div class="surface-card">
                    <div class="section-header" style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <h2 class="section-title">Transaction history</h2>
                            <p class="section-subtitle" id="tx-subtitle">Showing all transactions</p>
                        </div>
                        <button type="button" class="btn-reset-filter" onclick="filterTransactions('all', null)">View all</button>
                    </div>

                    <!-- 3. Transaction Items with data-type attributes -->
                    <div class="transaction-list" id="transaction-list">
                        <c:choose>
                            <c:when test="${not empty transactions}">
                                <c:forEach var="t" items="${transactions}">
                                    <c:set var="isEarned" value="${t.receiverId == sessionScope.currentUser.userId || t.transactionType == 'EARNED'}" />
                                    <div class="transaction-item" data-type="${isEarned ? 'earned' : 'spent'}">
                                        <div class="tx-icon ${isEarned ? 'earned' : 'spent'}">
                                            <c:choose>
                                                <c:when test="${isEarned}">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="17" y1="7" x2="7" y2="17"/><polyline points="17 17 7 17 7 7"/></svg>
                                                </c:when>
                                                <c:otherwise>
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="7" y1="17" x2="17" y2="7"/><polyline points="7 7 17 7 17 17"/></svg>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="tx-details">
                                            <div class="tx-label">
                                                ${t.reason}
                                                <c:if test="${not empty t.counterpartyName}"> — ${t.counterpartyName}</c:if>
                                            </div>
                                            <div class="tx-date">
                                                <fmt:formatDate value="${t.transactionDate}" pattern="dd MMM" />
                                            </div>
                                        </div>
                                        <div class="tx-amount ${isEarned ? 'earned' : 'spent'}">
                                            ${isEarned ? '+' : '−'}${t.amount}
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p style="color: #6b7280; font-size: 0.9rem;">No transactions recorded yet.</p>
                            </c:otherwise>
                        </c:choose>
                        <p id="no-tx-message" style="display: none; color: #6b7280; font-size: 0.9rem; margin-top: 10px;">No matching transactions found for this filter.</p>
                    </div>
                </div>
            </div>

            <!-- 4. Interactive Reward Summary Links -->
            <div class="right-column">
                <div class="surface-card">
                    <div class="section-header">
                        <h2 class="section-title">Reward summary</h2>
                        <p class="section-subtitle">How you earn faster</p>
                    </div>

                    <div class="reward-list">
                        <a href="${pageContext.request.contextPath}/requests" class="reward-item reward-link" title="Go to Learning Requests">
                            <span class="reward-label">Teach a 60-min session</span>
                            <span class="reward-val">+15 to +25</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/jsp/reviews.jsp" class="reward-item reward-link" title="Go to Reviews">
                            <span class="reward-label">Receive a 5★ review</span>
                            <span class="reward-val">+5</span>
                        </a>
                        <div class="reward-item">
                            <span class="reward-label">Monthly top-up</span>
                            <span class="reward-val">+100</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/jsp/achievements.jsp" class="reward-item reward-link" title="Go to Achievements">
                            <span class="reward-label">Unlock a badge</span>
                            <span class="reward-val">+30</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/requests" class="reward-item reward-link" title="Respond quickly to requests">
                            <span class="reward-label">Reply within 1 hour</span>
                            <span class="reward-val">+2</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/jsp/achievements.jsp" style="text-decoration: none; color: inherit;">
                            <div class="reward-banner" style="cursor: pointer; transition: opacity 0.2s;" onmouseover="this.style.opacity='0.9'" onmouseout="this.style.opacity='1'">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>
                                <span>You are in the top 8% of earners this month. Two more taught sessions unlocks the Deep Diver badge.</span>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Header dropdown handler
    function toggleProfileDropdown(event) {
        event.stopPropagation();
        const menu = document.getElementById("profileMenu");
        menu.classList.toggle("show");
    }

    window.onclick = function(event) {
        const menu = document.getElementById("profileMenu");
        if (menu && menu.classList.contains("show")) {
            menu.classList.remove("show");
        }
    };

    // Client-side Transaction Filtering Logic
    function filterTransactions(type, cardElement) {
        const items = document.querySelectorAll('.transaction-item');
        const cards = document.querySelectorAll('.filter-card');
        const subtitle = document.getElementById('tx-subtitle');
        const noTxMsg = document.getElementById('no-tx-message');
        
        let visibleCount = 0;

        // Reset active state highlights on stat cards
        cards.forEach(card => card.classList.remove('active-filter'));

        // Highlight clicked card
        if (cardElement && type !== 'all') {
            cardElement.classList.add('active-filter');
        }

        // Filter list items
        items.forEach(item => {
            const itemType = item.getAttribute('data-type');
            if (type === 'all' || itemType === type) {
                item.style.display = 'flex';
                visibleCount++;
            } else {
                item.style.display = 'none';
            }
        });

        // Update section subtitle & empty message display
        if (type === 'earned') {
            subtitle.textContent = 'Showing incoming (+ earned) transactions';
        } else if (type === 'spent') {
            subtitle.textContent = 'Showing outgoing (− spent) transactions';
        } else {
            subtitle.textContent = 'Showing all transactions';
        }

        if (noTxMsg) {
            noTxMsg.style.display = visibleCount === 0 ? 'block' : 'none';
        }
    }
</script>
</body>
</html>