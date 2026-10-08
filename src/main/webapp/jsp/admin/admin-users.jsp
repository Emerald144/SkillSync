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
    <title>User Management · SkillSync</title>
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>
    
    <!-- CSS Link -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/admin-dashboard.css">
    
    <style>
        .active-filter {
            background-color: var(--primary) !important;
            color: #ffffff !important;
            border-color: var(--primary) !important;
        }
    </style>
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
            
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-item active">
                <span class="nav-icon"><i data-lucide="users"></i></span>
                <span>User Management</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/moderation-queue" class="nav-item">
                <span class="nav-icon"><i data-lucide="flag"></i></span>
                <span>Moderation Queue</span>
            </a>
        </nav>
    </aside>

    <!-- Main Wrapper Area -->
    <div class="main-wrapper">
        <!-- Top Header Navigation -->
        <header class="top-header">
            <div class="header-search">
                <i data-lucide="search" class="search-icon-pos"></i>
                <input type="text" placeholder="Search skills, people, universities…">
            </div>

            <div class="header-actions">
                <!-- Dynamic Notification Alert for Pending Reports -->
                <button class="icon-btn" title="Pending Reports Alert">
                    <i data-lucide="bell"></i>
                    <c:if test="${pendingReports > 0}">
                        <span class="notification-dot"></span>
                    </c:if>
                </button>

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

        <!-- Main Dashboard Content -->
        <main class="dashboard-content">
            
            <!-- Alert Flash Messages -->
            <c:if test="${not empty sessionScope.flashMessage}">
                <div class="alert alert-success" style="background: rgba(16, 185, 129, 0.12); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.3); border-radius: 0.5rem; padding: 0.75rem 1rem; margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem;">
                    <i data-lucide="check-circle" style="width: 18px; height: 18px;"></i>
                    <span>${sessionScope.flashMessage}</span>
                </div>
                <c:remove var="flashMessage" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.flashError}">
                <div class="alert alert-danger" style="background: rgba(239, 68, 68, 0.12); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.3); border-radius: 0.5rem; padding: 0.75rem 1rem; margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem;">
                    <i data-lucide="alert-triangle" style="width: 18px; height: 18px;"></i>
                    <span>${sessionScope.flashError}</span>
                </div>
                <c:remove var="flashError" scope="session"/>
            </c:if>

            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <div>
                    <h1 class="page-title">User Management</h1>
                    <p class="page-subtitle">Filter: <strong>${empty selectedStatus ? 'All' : selectedStatus}</strong> Users</p>
                </div>
                
                <!-- Status Filter Buttons -->
                <div style="display: flex; gap: 8px;">
                    <a href="${pageContext.request.contextPath}/admin/users" 
                       class="btn-outline-sm ${empty selectedStatus or selectedStatus eq 'All' ? 'active-filter' : ''}">All</a>
                    <a href="${pageContext.request.contextPath}/admin/users?status=Active" 
                       class="btn-outline-sm ${selectedStatus eq 'Active' ? 'active-filter' : ''}">Active</a>
                    <a href="${pageContext.request.contextPath}/admin/users?status=Suspended" 
                       class="btn-outline-sm ${selectedStatus eq 'Suspended' ? 'active-filter' : ''}">Suspended</a>
                </div>
            </div>

            <!-- Users Table / List -->
            <section class="card-panel">
                <div class="user-list">
                    <c:choose>
                        <c:when test="${not empty userList}">
                            <c:forEach var="user" items="${userList}">
                                <div class="user-row-card" style="display: flex; justify-content: space-between; align-items: center; padding: 1rem; border: 1px solid #e2e8f0; border-radius: 0.75rem; margin-bottom: 0.75rem; background: #ffffff;">
                                    
                                    <!-- User Basic Info -->
                                    <div class="user-row-left" style="display: flex; align-items: center; gap: 1rem;">
                                        <div class="avatar-initials" style="width: 42px; height: 42px; border-radius: 50%; background: #0284c7; color: #fff; font-weight: 700; display: flex; align-items: center; justify-content: center; font-size: 0.875rem;">
                                            ${fn:toUpperCase(fn:substring(user.fullName, 0, 2))}
                                        </div>
                                        <div class="user-row-info">
                                            <div class="user-row-name" style="font-weight: 600; color: #0f172a; font-size: 1rem;">${user.fullName}</div>
                                            <div class="user-row-meta" style="font-size: 0.8125rem; color: #64748b;">${user.email} • Role: <strong>${user.role}</strong></div>
                                        </div>
                                    </div>

                                    <!-- User Actions & Status Badges -->
                                    <div class="user-row-actions" style="display: flex; align-items: center; gap: 0.75rem;">
                                        
                                        <!-- Status Badge -->
                                        <c:choose>
                                            <c:when test="${user.status eq 'Active'}">
                                                <span class="badge" style="padding: 4px 10px; border-radius: 9999px; font-weight: 600; font-size: 0.75rem; background-color: #dcfce7; color: #166534;">
                                                    Active
                                                </span>
                                            </c:when>
                                            <c:when test="${user.status eq 'Suspended'}">
                                                <span class="badge" style="padding: 4px 10px; border-radius: 9999px; font-weight: 600; font-size: 0.75rem; background-color: #fee2e2; color: #991b1b;">
                                                    Suspended
                                                </span>
                                            </c:when>
                                            <c:when test="${user.status eq 'Deactivated'}">
                                                <span class="badge" style="padding: 4px 10px; border-radius: 9999px; font-weight: 600; font-size: 0.75rem; background-color: #f1f5f9; color: #64748b;">
                                                    Deactivated
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge" style="padding: 4px 10px; border-radius: 9999px; font-weight: 600; font-size: 0.75rem; background-color: #f1f5f9; color: #475569;">
                                                    ${user.status}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Admin Actions Control Block -->
                                        <c:choose>
                                            <c:when test="${user.role eq 'ADMIN'}">
                                                <!-- Protect Admin Accounts from Modification -->
                                                <span style="font-size: 0.75rem; color: #94a3b8; font-style: italic; border: 1px dashed #cbd5e1; padding: 4px 8px; border-radius: 6px;">
                                                    Protected Admin
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Action Buttons for Standard Users -->
                                                <div style="display: flex; gap: 0.5rem; align-items: center;">
                                                    
                                                    <!-- Option B Logic: Conditional Action Buttons -->
                                                    <c:choose>
                                                        <%-- Show Suspend button if status is Active --%>
                                                        <c:when test="${user.status eq 'Active'}">
                                                            <form action="${pageContext.request.contextPath}/admin/user-action" method="POST" style="margin: 0;">
                                                                <input type="hidden" name="userId" value="${user.userId}" />
                                                                <input type="hidden" name="action" value="suspend" />
                                                                <button type="submit" onclick="return confirm('Are you sure you want to suspend ${user.fullName}?');" 
                                                                        style="background: #fff; border: 1px solid #fca5a5; color: #dc2626; padding: 5px 10px; border-radius: 6px; font-size: 0.75rem; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 4px;">
                                                                    <i data-lucide="user-x" style="width: 14px; height: 14px;"></i> Suspend
                                                                </button>
                                                            </form>
                                                        </c:when>

                                                        <%-- Show Activate button ONLY if status is Suspended --%>
                                                        <c:when test="${user.status eq 'Suspended'}">
                                                            <form action="${pageContext.request.contextPath}/admin/user-action" method="POST" style="margin: 0;">
                                                                <input type="hidden" name="userId" value="${user.userId}" />
                                                                <input type="hidden" name="action" value="activate" />
                                                                <button type="submit" 
                                                                        style="background: #fff; border: 1px solid #86efac; color: #16a34a; padding: 5px 10px; border-radius: 6px; font-size: 0.75rem; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 4px;">
                                                                    <i data-lucide="user-check" style="width: 14px; height: 14px;"></i> Activate
                                                                </button>
                                                            </form>
                                                        </c:when>

                                                        <%-- Deactivated or other statuses will NOT display an Activate/Suspend toggle button --%>
                                                    </c:choose>

                                                    <!-- Delete User Form (Permanent Action) -->
                                                    <form action="${pageContext.request.contextPath}/admin/user-action" method="POST" style="margin: 0;">
                                                        <input type="hidden" name="userId" value="${user.userId}" />
                                                        <input type="hidden" name="action" value="delete" />
                                                        <button type="submit" onclick="return confirm('WARNING: Permanently delete account for ${user.fullName}? This cannot be undone.');" 
                                                                style="background: #fee2e2; border: none; color: #dc2626; padding: 6px 8px; border-radius: 6px; font-size: 0.75rem; font-weight: 600; cursor: pointer;" title="Delete User">
                                                            <i data-lucide="trash-2" style="width: 14px; height: 14px;"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>

                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="text-align: center; color: #64748b; padding: 2rem;">No users found for status: ${empty selectedStatus ? 'All' : selectedStatus}</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
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