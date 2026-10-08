<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillsync.model.User" %>
<%@ page import="com.skillsync.model.Message" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
    <title>Messages · SkillSync</title>
    
    <!-- Feather Icons for clean SVG icons matching Dashboard style -->
    <script src="https://unpkg.com/feather-icons"></script>

   
    <!-- Messages Page Specific CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/message.css?v=2">
</head>
<body>

<div class="app-shell">
    <!-- Sidebar Navigation (Synchronized with dashboard.jsp) -->
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

            <a href="${pageContext.request.contextPath}/messages" class="nav-item active">
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
                <span class="nav-icon"><i data-feather="flag"></i></span>
                <span>Report a user</span>
            </a>
        </nav>

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

                <!-- Profile Dropdown -->
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
                                 alt="Profile" class="user-avatar-img" 
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

        <!-- Messages Workspace Container -->
        <main class="dashboard-content messages-workspace">
            <div class="msg-card">
                <!-- Sidebar: Dynamic Conversations List -->
                <div class="msg-sidebar">
                    <div class="msg-sidebar-header">
                        <h2>Messages</h2>
                        <div class="msg-search-box">
                            <i data-feather="search" class="search-icon-svg"></i>
                            <input type="text" placeholder="Search conversations" class="msg-search-input">
                        </div>
                    </div>

                    <div class="conversations-list">
                        <c:choose>
                            <c:when test="${not empty conversations}">
                                <c:forEach var="cUser" items="${conversations}">
                                    <a href="${pageContext.request.contextPath}/messages?userId=${cUser.userId}" 
                                       class="conv-item ${not empty activeUser and cUser.userId == activeUser.userId ? 'active' : ''}">
                                        
                                        <!-- Sidebar Avatar Box Wrapper -->
                                        <div style="position: relative; display: inline-flex;">
                                            <div class="avatar-box">
                                                <c:choose>
                                                    <c:when test="${not empty cUser.profilePhoto}">
                                                        <c:set var="photoUrl" value="${cUser.profilePhoto}" />
                                                        <c:if test="${fn:startsWith(photoUrl, '/')}">
                                                            <c:set var="photoUrl" value="${fn:substring(photoUrl, 1, fn:length(photoUrl))}" />
                                                        </c:if>
                                                        <img src="${pageContext.request.contextPath}/${photoUrl}"
                                                             alt="${cUser.fullName}" class="avatar-img"
                                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                                        <div class="avatar-initials" style="display:none;">
                                                            ${fn:substring(cUser.fullName, 0, 2).toUpperCase()}
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="avatar-initials">
                                                            ${fn:substring(cUser.fullName, 0, 2).toUpperCase()}
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <span class="status-dot online"></span>
                                        </div>

                                        <div class="conv-details">
                                            <div class="conv-top-row">
                                                <span class="conv-name"><c:out value="${cUser.fullName}" /></span>
                                            </div>
                                        </div>
                                    </a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div style="padding: 1rem; color: #64748b; font-size: 0.9rem;">
                                    No active conversations.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Main Active Thread Panel -->
                <div class="msg-thread-panel">
                    <c:choose>
                        <c:when test="${not empty activeUser}">
                            <!-- Thread Header -->
                            <header class="thread-header">
                                <a href="${pageContext.request.contextPath}/ProfileServlet?userId=${activeUser.userId}" 
                                   class="thread-user-link" 
                                   style="display: flex; align-items: center; gap: 0.75rem; text-decoration: none; color: inherit;">
                                    
                                    <!-- Thread Avatar Box Wrapper -->
                                    <div style="position: relative; display: inline-flex;">
                                        <div class="avatar-box">
                                            <c:choose>
                                                <c:when test="${not empty activeUser.profilePhoto}">
                                                    <c:set var="photoUrl" value="${activeUser.profilePhoto}" />
                                                    <c:if test="${fn:startsWith(photoUrl, '/')}">
                                                        <c:set var="photoUrl" value="${fn:substring(photoUrl, 1, fn:length(photoUrl))}" />
                                                    </c:if>
                                                    <img src="${pageContext.request.contextPath}/${photoUrl}"
                                                         alt="${activeUser.fullName}" class="avatar-img"
                                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                                    <div class="avatar-initials" style="display:none;">
                                                        ${fn:substring(activeUser.fullName, 0, 2).toUpperCase()}
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="avatar-initials">
                                                        ${fn:substring(activeUser.fullName, 0, 2).toUpperCase()}
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <span class="status-dot online"></span>
                                    </div>

                                    <div class="thread-user-info">
                                        <div class="thread-user-name"><c:out value="${activeUser.fullName}" /></div>
                                        <div class="thread-user-status">Active now</div>
                                    </div>
                                </a>

                                <div class="thread-actions">
                                    <button type="button" class="btn-action-icon" title="Start Call">
                                        <i data-feather="phone"></i>
                                    </button>
                                    <button type="button" class="btn-action-icon" title="Start Video Call">
                                        <i data-feather="video"></i>
                                    </button>
                                </div>
                            </header>

                            <!-- Dynamic Message Bubble Area -->
                            <div class="chat-bubbles-area" id="chatThread">
                                <c:choose>
                                    <c:when test="${not empty messages}">
                                        <c:forEach var="msg" items="${messages}">
                                            <div class="msg-row ${msg.senderId == sessionScope.currentUser.userId ? 'me' : 'other'}">
                                                <div class="msg-bubble">
                                                    <p><c:out value="${msg.message}" /></p>
                                                    <div class="msg-timestamp">
                                                        <fmt:formatDate value="${msg.sentAt}" pattern="HH:mm" />
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div style="display:flex; flex-direction:column; align-items:center; justify-content:center; height:100%; color:#94a3b8; font-size:0.95rem; text-align:center; padding: 20px;">
                                            <i data-feather="message-square" style="width: 48px; height: 48px; margin-bottom: 12px; opacity: 0.5;"></i>
                                            <p>No messages yet with <strong><c:out value="${activeUser.fullName}" /></strong>.</p>
                                            <p style="font-size:0.85rem; color:#cbd5e1; margin-top:4px;">Send a message below to start the conversation!</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Input Footer Bar -->
                            <div class="chat-input-footer">
                                <div class="emoji-picker-bar">
                                    <button type="button" class="emoji-chip" onclick="insertEmoji('👍')">👍</button>
                                    <button type="button" class="emoji-chip" onclick="insertEmoji('🎉')">🎉</button>
                                    <button type="button" class="emoji-chip" onclick="insertEmoji('🙏')">🙏</button>
                                    <button type="button" class="emoji-chip" onclick="insertEmoji('🔥')">🔥</button>
                                    <button type="button" class="emoji-chip" onclick="insertEmoji('😄')">😄</button>
                                    <button type="button" class="emoji-chip" onclick="insertEmoji('🤯')">🤯</button>
                                    <button type="button" class="emoji-chip" onclick="insertEmoji('✅')">✅</button>
                                </div>

                                <form class="msg-form" action="${pageContext.request.contextPath}/messages" method="POST">
                                    <input type="hidden" name="receiverId" value="${activeUser.userId}" />

                                    <button type="button" class="btn-action-icon" title="Attach File">
                                        <i data-feather="paperclip"></i>
                                    </button>
                                    <button type="button" class="btn-action-icon" title="Pick Emoji">
                                        <i data-feather="smile"></i>
                                    </button>

                                    <input type="text" id="chatInput" name="message" 
                                           placeholder="Message ${activeUser.fullName}..." 
                                           class="msg-input" autocomplete="off" required>

                                    <button type="submit" class="btn-send-gradient" title="Send Message">
                                        <i data-feather="send"></i>
                                    </button>
                                </form>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="display:flex; align-items:center; justify-content:center; height:100%; color:#64748b;">
                                Select a conversation to start messaging.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
    // Initialize Feather Icons
    feather.replace();

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

    // Auto scroll chat thread to bottom on page load
    const chatContainer = document.getElementById("chatThread");
    if (chatContainer) {
        chatContainer.scrollTop = chatContainer.scrollHeight;
    }

    // Quick emoji insertion helper
    function insertEmoji(emojiStr) {
        const input = document.getElementById("chatInput");
        if (input) {
            input.value += emojiStr;
            input.focus();
        }
    }
</script>

</body>
</html>