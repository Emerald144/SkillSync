<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.skillsync.model.Report" %>
<%@ page import="com.skillsync.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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

    List<Report> reports = (List<Report>) request.getAttribute("reports");
    String selectedStatus = (String) request.getAttribute("selectedStatus");
    if (selectedStatus == null) selectedStatus = "all";

    String flashMessage = (String) session.getAttribute("flashMessage");
    String flashError = (String) session.getAttribute("flashError");
    session.removeAttribute("flashMessage");
    session.removeAttribute("flashError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Moderation Queue · SkillSync</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>
    
    <!-- Admin Dashboard Design CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/admin-dashboard.css">
    
    <style>
        .badge-pending { background-color: #fef3c7; color: #b45309; }
        .badge-resolved { background-color: #dcfce7; color: #15803d; }
        .badge-dismissed { background-color: #f1f5f9; color: #475569; }
        .table-card {
            background: #ffffff;
            border-radius: 1.25rem;
            border: 1px solid var(--border);
            box-shadow: var(--shadow-soft);
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
            
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
                <span class="nav-icon"><i data-lucide="users"></i></span>
                <span>User Management</span>
            </a>

            <a href="${pageContext.request.contextPath}/admin/moderation-queue" class="nav-item active">
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

        <!-- Main Content Area -->
        <main class="dashboard-content">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <div>
                    <h1 class="page-title">Moderation Queue</h1>
                    <p class="page-subtitle">Review reports, take moderation action, and enforce community guidelines.</p>
                </div>
                
                <!-- Filter Dropdown -->
                <form action="${pageContext.request.contextPath}/admin/moderation-queue" method="GET" class="d-flex gap-2">
                    <select name="status" class="form-select" onchange="this.form.submit()">
                        <option value="all" <%= "all".equals(selectedStatus) ? "selected" : "" %>>All Reports</option>
                        <option value="Pending" <%= "Pending".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Pending Only</option>
                        <option value="Resolved" <%= "Resolved".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Resolved Only</option>
                        <option value="Dismissed" <%= "Dismissed".equalsIgnoreCase(selectedStatus) ? "selected" : "" %>>Dismissed Only</option>
                    </select>
                </form>
            </div>

            <!-- Flash Alerts -->
            <% if (flashMessage != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i><%= flashMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            <% if (flashError != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i><%= flashError %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <!-- Reports Table Panel -->
            <div class="table-card p-4">
                <% if (reports == null || reports.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="bi bi-shield-check display-4 text-muted"></i>
                        <p class="text-muted mt-3 mb-0">No reports found in this view.</p>
                    </div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>#ID</th>
                                    <th>Reporter</th>
                                    <th>Reported User</th>
                                    <th>Reason</th>
                                    <th>Description</th>
                                    <th>Status</th>
                                    <th>Date Submitted</th>
                                    <th class="text-end">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Report r : reports) { 
                                    String targetName = r.getReportedUserName() != null ? r.getReportedUserName() : "User #" + r.getReportedUserId();
                                    String safeTargetName = targetName.replace("'", "\\'");
                                %>
                                    <tr>
                                        <td class="fw-bold">#<%= r.getReportId() %></td>
                                        <td><%= r.getReporterName() != null ? r.getReporterName() : "User #" + r.getReporterId() %></td>
                                        <td>
                                            <span class="fw-semibold text-danger">
                                                <%= targetName %>
                                            </span>
                                        </td>
                                        <td><span class="badge bg-light text-dark border"><%= r.getReason() %></span></td>
                                        <td style="max-width: 250px;" class="text-truncate" title="<%= r.getDescription() != null ? r.getDescription() : "" %>">
                                            <%= r.getDescription() != null ? r.getDescription() : "-" %>
                                        </td>
                                        <td>
                                            <% 
                                                String statusClass = "badge-pending";
                                                if ("Resolved".equalsIgnoreCase(r.getStatus())) statusClass = "badge-resolved";
                                                else if ("Dismissed".equalsIgnoreCase(r.getStatus())) statusClass = "badge-dismissed";
                                            %>
                                            <span class="badge <%= statusClass %> px-2 py-1"><%= r.getStatus() %></span>
                                        </td>
                                        <td class="text-muted small"><%= r.getCreatedAt() %></td>
                                        <td class="text-end">
                                            <% if ("Pending".equalsIgnoreCase(r.getStatus())) { %>
                                                <button type="button" 
                                                        class="btn btn-sm btn-outline-primary"
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#actionModal"
                                                        onclick="populateModal('<%= r.getReportId() %>', '<%= r.getReportedUserId() %>', '<%= safeTargetName %>')">
                                                    Review Action
                                                </button>
                                            <% } else { %>
                                                <button class="btn btn-sm btn-light" disabled>Closed</button>
                                            <% } %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
</div>

<!-- Action Modal -->
<div class="modal fade" id="actionModal" tabindex="-1" aria-labelledby="actionModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content" style="border-radius: 1.25rem;">
            <form action="${pageContext.request.contextPath}/admin/action" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="actionModalLabel">Take Moderation Action</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="reportId" id="modalReportId">
                    <input type="hidden" name="reportedUserId" id="modalReportedUserId">

                    <div class="mb-3">
                        <label class="form-label text-muted small uppercase fw-bold">Target User</label>
                        <input type="text" id="modalReportedUserName" class="form-control" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Select Moderation Action</label>
                        <select name="action" class="form-select" required>
                            <option value="WARN">Issue Official Warning (WARN)</option>
                            <option value="SUSPEND">Suspend User Account (SUSPEND)</option>
                            <option value="DEACTIVATE">Deactivate Account (DEACTIVATE)</option>
                            <option value="DISMISS">Dismiss Report (DISMISS)</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Admin Note / Reason</label>
                        <textarea name="adminNote" class="form-control" rows="3" placeholder="Provide context or instructions for this action..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Execute Action</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    lucide.createIcons();

    function populateModal(reportId, reportedUserId, reportedUserName) {
        document.getElementById('modalReportId').value = reportId;
        document.getElementById('modalReportedUserId').value = reportedUserId;
        document.getElementById('modalReportedUserName').value = reportedUserName;
    }

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