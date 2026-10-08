<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillsync.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    // Fetch logged-in user from HttpSession
    User currentUser = (User) session.getAttribute("currentUser");
    
    // Redirect if user is not logged in
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    // Role-based security check: restrict access to non-admin users
    if (!"Admin".equalsIgnoreCase(currentUser.getRole())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have admin privileges.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard · SkillSync</title>
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>
    
    <!-- CSS Link -->
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
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item active">
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
        </nav>
    </aside>

    <!-- Main Content Area -->
    <div class="main-wrapper">
        <!-- Top Header Navigation -->
        <header class="top-header">
            <div class="header-search">
                <i data-lucide="search" class="search-icon-pos"></i>
                <input type="text" placeholder="Search skills, people, universities…">
            </div>

            <div class="header-actions">
                <!-- Dynamic Notification Alert for Pending Reports -->
                <a href="${pageContext.request.contextPath}/admin/notifications" class="icon-btn" title="Pending Reports & Alerts">
    <i data-lucide="bell"></i>
    <c:if test="${pendingReports > 0}">
        <span class="notification-dot"></span>
    </c:if>
</a>

                <!-- Profile Dropdown Menu -->
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
                        
                        <i data-lucide="chevron-down" class="dropdown-arrow"></i>
                    </button>

                    <!-- Dropdown Links -->
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

        <!-- Dashboard Main Content -->
        <main class="dashboard-content">
            <!-- Alert Messages -->
            <c:if test="${not empty sessionScope.flashMessage}">
                <div class="alert alert-success" style="padding: 12px; margin-bottom: 16px; background-color: #d4edda; color: #155724; border-radius: 6px;">
                    ${sessionScope.flashMessage}
                </div>
                <% session.removeAttribute("flashMessage"); %>
            </c:if>
            <c:if test="${not empty sessionScope.flashError}">
                <div class="alert alert-danger" style="padding: 12px; margin-bottom: 16px; background-color: #f8d7da; color: #721c24; border-radius: 6px;">
                    ${sessionScope.flashError}
                </div>
                <% session.removeAttribute("flashError"); %>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" style="padding: 12px; margin-bottom: 16px; background-color: #f8d7da; color: #721c24; border-radius: 6px;">
                    ${errorMessage}
                </div>
            </c:if>

            <!-- Page Header -->
            <div class="page-header">
                <h1 class="page-title">Admin dashboard</h1>
                <p class="page-subtitle">Platform health, moderation queue and user management.</p>
            </div>

            <!-- Stats Grid Links -->
            <div class="stats-grid">
                <!-- Total Users Link -->
                <a href="${pageContext.request.contextPath}/admin/users" class="stat-card stat-card-link">
                    <div class="stat-header">
                        <div class="stat-icon icon-brand">
                            <i data-lucide="users"></i>
                        </div>
                    </div>
                    <div class="stat-value">${totalUsers != null ? totalUsers : 0}</div>
                    <div class="stat-title">Total users</div>
                </a>

                <!-- Active Users Link -->
                <a href="${pageContext.request.contextPath}/admin/users?status=Active" class="stat-card stat-card-link">
                    <div class="stat-header">
                        <div class="stat-icon icon-success">
                            <i data-lucide="user-check"></i>
                        </div>
                    </div>
                    <div class="stat-value">${activeUsers != null ? activeUsers : 0}</div>
                    <div class="stat-title">Active users</div>
                </a>

                <!-- Suspended Users Link -->
                <a href="${pageContext.request.contextPath}/admin/users?status=Suspended" class="stat-card stat-card-link">
                    <div class="stat-header">
                        <div class="stat-icon icon-warning">
                            <i data-lucide="user-x"></i>
                        </div>
                    </div>
                    <div class="stat-value">${suspendedUsers != null ? suspendedUsers : 0}</div>
                    <div class="stat-title">Suspended users</div>
                </a>

                <!-- Pending Reports Link -->
                <a href="${pageContext.request.contextPath}/admin/reports?status=Pending" class="stat-card stat-card-link">
                    <div class="stat-header">
                        <div class="stat-icon icon-destructive">
                            <i data-lucide="flag"></i>
                        </div>
                    </div>
                    <div class="stat-value">${pendingReports != null ? pendingReports : 0}</div>
                    <div class="stat-title">Pending reports</div>
                </a>
            </div>

            <!-- Moderation Queue -->
            <div class="admin-split-grid">
                <section class="card-panel" style="grid-column: 1 / -1;">
                    <div class="panel-header">
                        <div>
                            <h2 class="panel-title">Moderation Queue</h2>
                            <p class="panel-sub">Recent reports awaiting review</p>
                        </div>
                    </div>

                    <div class="moderation-queue-list">
                        <c:choose>
                            <c:when test="${not empty recentReports}">
                                <c:forEach var="report" items="${recentReports}">
                                    <div class="report-card" style="margin-bottom: 1rem; padding: 1rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                                        <div class="report-title" style="font-weight: 600;">
                                            Report #${report.reportId} 
                                            <c:if test="${not empty report.reason}">
                                                — ${report.reason}
                                            </c:if>
                                        </div>
                                        <div class="report-meta" style="color: #64748b; font-size: 0.875rem; margin-top: 4px; margin-bottom: 8px;">
                                            Reported User: 
                                            <c:choose>
                                                <c:when test="${not empty report.reportedUserName}">
                                                    <strong>${report.reportedUserName}</strong> (ID: ${report.reportedUserId})
                                                </c:when>
                                                <c:otherwise>
                                                    ID: ${report.reportedUserId}
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${not empty report.reporterName}">
                                                | Reported By: ${report.reporterName}
                                            </c:if>
                                            | Status: <span style="font-weight: 500;">${report.status}</span>
                                        </div>

                                        <c:if test="${not empty report.description}">
                                            <div style="font-size: 0.875rem; color: #334155; margin-bottom: 10px; background-color: #f8fafc; padding: 8px; border-radius: 4px;">
                                                "${report.description}"
                                            </div>
                                        </c:if>

                                        <!-- Submission Form targeting AdminActionServlet -->
                                        <form action="${pageContext.request.contextPath}/admin/action" method="POST" class="report-actions" style="display: flex; gap: 8px; align-items: center; flex-wrap: wrap;">
                                            <input type="hidden" name="reportId" value="${report.reportId}" />
                                            <input type="hidden" name="reportedUserId" value="${report.reportedUserId}" />
                                            
                                            <input type="text" name="adminNote" placeholder="Reason / Administrative Note" style="padding: 6px 10px; border: 1px solid #cbd5e1; border-radius: 6px; flex-grow: 1; font-size: 0.85rem;" required />

                                            <button type="submit" name="action" value="WARN" class="btn-outline-sm">
                                                Warn
                                            </button>
                                            <button type="submit" name="action" value="SUSPEND" class="btn-ghost-danger-sm">
                                                Suspend
                                            </button>
                                            <button type="submit" name="action" value="DEACTIVATE" class="btn-ghost-danger-sm" style="color: #991b1b;">
                                                Deactivate
                                            </button>
                                            <button type="submit" name="action" value="DISMISS" class="btn-ghost-sm">
                                                Dismiss
                                            </button>
                                        </form>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p style="padding: 1.5rem; color: #64748b; text-align: center;">No pending reports requiring attention.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>
            </div>
        </main>
    </div>
</div>

<script>
    // Initialize Lucide Icons
    lucide.createIcons();

    // Toggle Dropdown Menu
    function toggleProfileDropdown(event) {
        event.stopPropagation();
        const wrapper = document.querySelector('.profile-dropdown-wrapper');
        wrapper.classList.toggle('open');
    }

    // Close Dropdown Menu on Outside Click
    document.addEventListener('click', function(event) {
        const wrapper = document.querySelector('.profile-dropdown-wrapper');
        if (wrapper && !wrapper.contains(event.target)) {
            wrapper.classList.remove('open');
        }
    });
</script>

</body>
</html>