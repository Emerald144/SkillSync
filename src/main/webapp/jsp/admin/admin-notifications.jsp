<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillsync.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    if (!"Admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications · Admin SkillSync</title>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/admin-dashboard.css">
</head>
<body>

<div class="app-shell">
    <!-- Sidebar -->
    <aside class="sidebar">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="SkillSync Logo" class="logo-img" />
            <div>
                <div class="logo-text">Skill<span class="text-gradient">Sync</span></div>
                <div class="logo-sub">Admin Portal</div>
            </div>
        </a>

        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">
                <span class="nav-icon"><i data-lucide="layout-dashboard"></i></span>
                <span>Dashboard</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
                <span class="nav-icon"><i data-lucide="users"></i></span>
                <span>User Management</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/moderation-queue" class="nav-item">
                <span class="nav-icon"><i data-lucide="flag"></i></span>
                <span>Moderation Queue</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/notifications" class="nav-item active">
                <span class="nav-icon"><i data-lucide="bell"></i></span>
                <span>Notifications</span>
                <c:if test="${unreadCount > 0}">
                    <span class="nav-badge">${unreadCount}</span>
                </c:if>
            </a>
        </nav>
    </aside>

    <!-- Main Wrapper -->
    <div class="main-wrapper">
        <header class="top-header">
            <div class="header-search">
                <i data-lucide="search" class="search-icon-pos"></i>
                <input type="text" placeholder="Search system notifications…">
            </div>

            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/admin/notifications" class="icon-btn" title="Notifications">
                    <i data-lucide="bell"></i>
                    <c:if test="${unreadCount > 0}">
                        <span class="notification-dot"></span>
                    </c:if>
                </a>

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
                            <img src="${pageContext.request.contextPath}/<%= photoPath %>" alt="Profile" class="user-avatar-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
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
                        <i data-lucide="chevron-down" class="dropdown-arrow"></i>
                    </button>

                    <div class="profile-dropdown-menu" id="profileMenu">
                        <div class="dropdown-header">
                            <span class="username-tag"><%= currentUser.getEmail() %></span>
                        </div>
                        <ul class="dropdown-links">
                            <li>
                                <a href="${pageContext.request.contextPath}/admin/settings">
                                    <i data-lucide="settings"></i>
                                    <span>Account settings</span>
                                </a>
                            </li>
                            <li class="dropdown-divider"></li>
                            <li>
                                <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-link">
                                    <i data-lucide="log-out"></i>
                                    <span>Log out</span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </header>

        <!-- Main Body Content -->
        <main class="dashboard-content">
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h1 class="page-title">Admin Notifications</h1>
                    <p class="page-subtitle">System alerts, user reports, and platform activities requiring attention.</p>
                </div>
                <form action="${pageContext.request.contextPath}/admin/notifications" method="POST">
                    <input type="hidden" name="action" value="MARK_ALL_READ" />
                    <button type="submit" class="btn-outline-sm">
                        <i data-lucide="check-check" style="width:14px; height:14px; margin-right:4px;"></i> Mark all as read
                    </button>
                </form>
            </div>

            <div class="admin-split-grid">
                <section class="card-panel" style="grid-column: 1 / -1;">
                    <div class="notification-list">
                        <c:choose>
                            <c:when test="${not empty notifications}">
                                <c:forEach var="notif" items="${notifications}">
                                    <div class="notification-card ${notif.isRead ? 'read' : 'unread'}" style="padding: 1rem; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 0.75rem; display: flex; justify-content: space-between; align-items: flex-start; background: ${notif.isRead ? '#ffffff' : '#f0f9ff'};">
                                        <div style="display: flex; gap: 12px; align-items: flex-start;">
                                            <div class="stat-icon" style="padding: 8px; border-radius: 8px; background: #e0f2fe; color: #0284c7;">
                                                <i data-lucide="${notif.type == 'REPORT' ? 'flag' : notif.type == 'USER' ? 'user-plus' : 'bell'}"></i>
                                            </div>
                                            <div>
                                                <div style="font-weight: 600; font-size: 0.95rem;">${notif.title}</div>
                                                <div style="color: #475569; font-size: 0.875rem; margin-top: 2px;">${notif.message}</div>
                                                <div style="color: #94a3b8; font-size: 0.75rem; margin-top: 6px;">${notif.formattedDate}</div>
                                            </div>
                                        </div>

                                        <c:if test="${!notif.isRead}">
                                            <form action="${pageContext.request.contextPath}/admin/notifications" method="POST">
                                                <input type="hidden" name="action" value="MARK_READ" />
                                                <input type="hidden" name="notificationId" value="${notif.id}" />
                                                <button type="submit" class="btn-ghost-sm" title="Mark as Read">
                                                    <i data-lucide="check"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p style="padding: 2rem; color: #64748b; text-align: center;">No system notifications found.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>
            </div>
        </main>
    </div>
</div>

<script>
    lucide.createIcons();

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
</script>

</body>
</html>