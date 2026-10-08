<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillsync.model.User"%>
<%@ page import="com.skillsync.model.UserSkill"%>
<%@ page import="com.skillsync.model.UserAvailability"%>
<%@ page import="com.skillsync.model.UserBadge"%>
<%@ page import="com.skillsync.model.Review"%>
<%@ page import="com.skillsync.dao.SkillDAO"%>
<%@ page import="com.skillsync.dao.AvailabilityDAO"%>
<%@ page import="com.skillsync.dao.ReviewDAO"%>
<%@ page import="com.skillsync.dao.BadgeDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.skillsync.model.Interest"%>
<%@ page import="com.skillsync.dao.InterestDAO"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    User profileUser = (User) request.getAttribute("profileUser");
    User displayUser = (profileUser != null) ? profileUser : currentUser;
    boolean isOwnProfile = (displayUser.getUserId() == currentUser.getUserId());
    
    // 1. Retrieve skills
    @SuppressWarnings("unchecked")
    List<UserSkill> userSkills = (List<UserSkill>) request.getAttribute("userSkills");
    if (userSkills == null) {
        try {
            SkillDAO skillDAO = new SkillDAO();
            userSkills = skillDAO.getSkillsByUserId(displayUser.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
            userSkills = new ArrayList<>();
        }
    }
    request.setAttribute("userSkills", userSkills);

    // Resolve active skill ID for the Connect request button
    int activeSkillId = 1;
    if (userSkills != null && !userSkills.isEmpty()) {
        activeSkillId = userSkills.get(0).getSkillId();
    }

    // 2. Retrieve availability list
    @SuppressWarnings("unchecked")
    List<UserAvailability> userAvailabilities = (List<UserAvailability>) request.getAttribute("userAvailabilities");
    if (userAvailabilities == null) {
        try {
            AvailabilityDAO availabilityDAO = new AvailabilityDAO();
            userAvailabilities = availabilityDAO.getAvailabilityByUserId(displayUser.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
            userAvailabilities = new ArrayList<>();
        }
    }
    request.setAttribute("userAvailabilities", userAvailabilities);
    
    // 3. Retrieve interests
    @SuppressWarnings("unchecked")
    List<Interest> userInterests = (List<Interest>) request.getAttribute("userInterests");
    if (userInterests == null) {
        try {
            InterestDAO interestDAO = new InterestDAO();
            userInterests = interestDAO.getInterestsByUserId(displayUser.getUserId());
        } catch (Exception e) {
            e.printStackTrace();
            userInterests = new ArrayList<>();
        }
    }
    request.setAttribute("userInterests", userInterests);

    // 4. Retrieve Reviews & Ratings Data
    @SuppressWarnings("unchecked")
    List<Review> userReviews = (List<Review>) request.getAttribute("userReviews");
    String avgRatingStr = (String) request.getAttribute("avgRating");
    Integer reviewCountObj = (Integer) request.getAttribute("reviewCount");

    if (userReviews == null || avgRatingStr == null || reviewCountObj == null) {
        try {
            ReviewDAO reviewDAO = new ReviewDAO();
            if (userReviews == null) {
                userReviews = reviewDAO.getReviewsForUser(displayUser.getUserId());
            }
            if (avgRatingStr == null) {
                double avg = reviewDAO.getAverageRating(displayUser.getUserId());
                avgRatingStr = String.format("%.1f", avg);
            }
            if (reviewCountObj == null) {
                reviewCountObj = reviewDAO.getReviewCount(displayUser.getUserId());
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (userReviews == null) userReviews = new ArrayList<>();
            if (avgRatingStr == null) avgRatingStr = "0.0";
            if (reviewCountObj == null) reviewCountObj = 0;
        }
    }

    request.setAttribute("userReviews", userReviews);
    request.setAttribute("avgRating", avgRatingStr);
    request.setAttribute("reviewCount", reviewCountObj);

    // 5. Retrieve Badges Data Fallbacks
    @SuppressWarnings("unchecked")
    List<UserBadge> userBadges = (List<UserBadge>) request.getAttribute("userBadges");
    Integer earnedBadgeCount = (Integer) request.getAttribute("earnedBadgeCount");
    Integer totalBadgeCount = (Integer) request.getAttribute("totalBadgeCount");
    Integer badgeProgressPercent = (Integer) request.getAttribute("badgeProgressPercent");

    if (userBadges == null || earnedBadgeCount == null || totalBadgeCount == null || badgeProgressPercent == null) {
        try {
            BadgeDAO badgeDAO = new BadgeDAO();
            userBadges = badgeDAO.getUserBadges(displayUser.getUserId());
            totalBadgeCount = badgeDAO.getTotalBadgeCount();
            if (totalBadgeCount == 0) totalBadgeCount = 15;
            earnedBadgeCount = (userBadges != null) ? userBadges.size() : 0;
            badgeProgressPercent = (int) Math.round(((double) earnedBadgeCount / totalBadgeCount) * 100);
        } catch (Exception e) {
            e.printStackTrace();
            if (userBadges == null) userBadges = new ArrayList<>();
            earnedBadgeCount = 0;
            totalBadgeCount = 15;
            badgeProgressPercent = 0;
        }
    }

    request.setAttribute("userBadges", userBadges);
    request.setAttribute("earnedBadgeCount", earnedBadgeCount);
    request.setAttribute("totalBadgeCount", totalBadgeCount);
    request.setAttribute("badgeProgressPercent", badgeProgressPercent);

    // 6. Retrieve Additional Stats Fallbacks
    Integer completedSessionsObj = (Integer) request.getAttribute("completedSessionsCount");
    if (completedSessionsObj == null) {
        completedSessionsObj = reviewCountObj; 
    }
    request.setAttribute("completedSessionsCount", completedSessionsObj);

    Integer currentStreakObj = (Integer) request.getAttribute("currentStreak");
    if (currentStreakObj == null) {
        currentStreakObj = 0;
    }
    request.setAttribute("currentStreak", currentStreakObj);

    String photoPath = displayUser.getProfilePhoto();
    boolean hasPhoto = photoPath != null && !photoPath.trim().isEmpty();
    if (hasPhoto && photoPath.startsWith("/")) {
        photoPath = photoPath.substring(1);
    }
    
    String initials = "U";
    if (displayUser.getFullName() != null && !displayUser.getFullName().trim().isEmpty()) {
        String[] names = displayUser.getFullName().trim().split("\\s+");
        if (names.length >= 2) {
            initials = ("" + names[0].charAt(0) + names[1].charAt(0)).toUpperCase();
        } else {
            initials = ("" + names[0].charAt(0)).toUpperCase();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isOwnProfile ? "My Profile" : displayUser.getFullName() %> · SkillSync</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
    <script src="https://unpkg.com/lucide@0.400.0/dist/umd/lucide.js"></script>
</head>
<body>

    <div class="profile-container">
        
        <!-- Header -->
        <div class="page-header">
            <div>
                <h1 class="page-title"><%= isOwnProfile ? "My profile" : displayUser.getFullName() %></h1>
                <p class="page-subtitle">This is what peers see before requesting a session.</p>
            </div>
            <% if (isOwnProfile) { %>
                <a href="${pageContext.request.contextPath}/UpdateProfileServlet" class="btn-primary">
                    <i data-lucide="pencil" class="icon-sm"></i> Edit profile
                </a>
            <% } else { %>
                <div class="flex items-center gap-2">
                    <a href="${pageContext.request.contextPath}/messages?userId=<%= displayUser.getUserId() %>" class="btn-primary btn-message">
                        <i data-lucide="message-square" class="icon-sm"></i> Message
                    </a>
                    <c:choose>
                        <c:when test="${displayUser.requestSent}">
                            <button type="button" class="btn-primary btn-requested" disabled style="flex: 1;">
                                <i data-lucide="check" class="icon-sm"></i> Requested
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="button"
                                    class="btn-primary connect-btn"
                                    data-receiver-id="<%= displayUser.getUserId() %>"
                                    data-skill-id="<%= activeSkillId %>"
                                    style="flex: 1;">
                                <i data-lucide="user-plus" class="icon-sm"></i> Connect / Request Session
                            </button>
                        </c:otherwise>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/report-user?userId=<%= displayUser.getUserId() %>" 
                       class="btn-primary btn-red-gradient" 
                       title="Report this user">
                        <i data-lucide="flag" class="icon-sm"></i> Report
                    </a>
                </div>
            <% } %>
        </div>

        <!-- Top Stats Cards Grid (DYNAMIC) -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon-wrapper text-blue">
                        <i data-lucide="award" class="icon-sm"></i>
                    </div>
                    <span class="stat-delta text-muted">of ${totalBadgeCount}</span>
                </div>
                <div class="stat-value">${earnedBadgeCount}</div>
                <div class="stat-label">Total badges earned</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon-wrapper text-emerald">
                        <i data-lucide="trending-up" class="icon-sm"></i>
                    </div>
                    <span class="stat-delta text-emerald">Points</span>
                </div>
                <div class="stat-value"><%= displayUser.getReputationScore() %></div>
                <div class="stat-label">Reputation score</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon-wrapper text-blue">
                        <i data-lucide="video" class="icon-sm"></i>
                    </div>
                    <span class="stat-delta text-muted">Total</span>
                </div>
                <div class="stat-value">${completedSessionsCount}</div>
                <div class="stat-label">Sessions completed</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon-wrapper text-amber">
                        <i data-lucide="star" class="icon-sm"></i>
                    </div>
                    <span class="stat-delta text-amber">${reviewCount} reviews</span>
                </div>
                <div class="stat-value">${avgRating}★</div>
                <div class="stat-label">Average rating</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon-wrapper text-rose">
                        <i data-lucide="flame" class="icon-sm"></i>
                    </div>
                    <span class="stat-delta text-rose">Active</span>
                </div>
                <div class="stat-value">${currentStreak} days</div>
                <div class="stat-label">Learning streak</div>
            </div>
        </div>

        <!-- Main Content Area -->
        <div class="profile-layout">
            
            <!-- Left Column -->
            <div class="layout-column">
                
                <!-- Main Profile Hero Card -->
                <div class="card profile-hero-card">
                    <div class="avatar-wrapper">
                        <% if (hasPhoto) { %>
                            <img src="${pageContext.request.contextPath}/<%= photoPath %>" 
                                 alt="Profile" 
                                 class="profile-avatar-img" 
                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                            <div class="avatar-initials" style="display: none;"><%= initials %></div>
                        <% } else { %>
                            <div class="avatar-initials"><%= initials %></div>
                        <% } %>
                    </div>

                    <h2 class="user-name"><%= displayUser.getFullName() %></h2>
                    <p class="user-handle">@<%= displayUser.getEmail() != null ? displayUser.getEmail().split("@")[0] : "user" %></p>
                    <p class="user-university">
                        <i data-lucide="map-pin" class="icon-xs"></i> <%= displayUser.getUniversity() %>
                    </p>

                    <span class="badge-pill">
                        <i data-lucide="award" class="icon-xs"></i> Gold Mentor
                    </span>

                    <p class="user-bio">
                        <%= (displayUser.getBio() != null && !displayUser.getBio().isEmpty()) ? displayUser.getBio() : "No bio provided yet." %>
                    </p>

                    <div class="reputation-summary">
                        <div class="ring-container">
                            <svg class="ring-svg" viewBox="0 0 36 36">
                                <path class="ring-bg" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
                                <path class="ring-stroke" stroke-dasharray="86, 100" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
                            </svg>
                            <div class="ring-text">
                                <span class="ring-score"><%= displayUser.getReputationScore() %></span>
                                <span class="ring-sub">reputation</span>
                            </div>
                        </div>

                        <div class="rating-details">
                            <div class="stars-row">
                                <i data-lucide="star" class="star-filled"></i>
                                <i data-lucide="star" class="star-filled"></i>
                                <i data-lucide="star" class="star-filled"></i>
                                <i data-lucide="star" class="star-filled"></i>
                                <i data-lucide="star" class="star-filled"></i>
                            </div>
                            <div class="rating-avg">${avgRating} average</div>
                            <div class="rating-count">${reviewCount} reviews</div>
                            <div class="session-counts">${completedSessionsCount} sessions</div>
                        </div>
                    </div>
                </div>

                <!-- Dynamic Availability Card -->
                <div class="card">
                    <h3 class="card-title">Availability</h3>
                    <p class="card-subtitle">Local time, updated weekly</p>
                    <div class="availability-list mt-3">
                        <c:choose>
                            <c:when test="${not empty userAvailabilities}">
                                <c:forEach var="slot" items="${userAvailabilities}">
                                    <div class="availability-item flex items-center gap-2 mb-2">
                                        <i data-lucide="clock" class="icon-sm text-primary"></i> 
                                        <strong>${slot.dayOfWeek}:</strong> ${slot.startTime} – ${slot.endTime}
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted text-sm mt-2">No availability schedule set yet.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>

            <!-- Right Column -->
            <div class="layout-column">
                
                <!-- Skills I Teach -->
                <div class="card">
                    <h3 class="card-title">Skills I teach</h3>
                    <p class="card-subtitle">Levels help peers pitch the right depth</p>
                    <div class="chip-group">
                        <% 
                            boolean hasTeachingSkills = false;
                            if (userSkills != null && !userSkills.isEmpty()) {
                                for (UserSkill skill : userSkills) { 
                                    if ("TEACHING".equalsIgnoreCase(skill.getSkillType())) {
                                        hasTeachingSkills = true;
                        %>
                            <span class="skill-chip">
                                <%= skill.getSkillName() %> 
                                <span class="level-badge"><%= skill.getProficiencyLevel() %></span>
                            </span>
                        <% 
                                    }
                                }
                            }
                            if (!hasTeachingSkills) { 
                        %>
                            <p class="text-muted text-sm mt-2">No skills added to teach yet.</p>
                        <% } %>
                    </div>
                </div>

                <!-- Skills I Want to Learn -->
                <div class="card">
                    <h3 class="card-title">Skills I want to learn</h3>
                    <div class="chip-group mt-3">
                        <% 
                            boolean hasLearningSkills = false;
                            if (userSkills != null && !userSkills.isEmpty()) {
                                for (UserSkill skill : userSkills) { 
                                    if ("LEARNING".equalsIgnoreCase(skill.getSkillType())) {
                                        hasLearningSkills = true;
                        %>
                            <span class="skill-chip skill-chip-accent">
                                <%= skill.getSkillName() %> 
                                <span class="level-badge"><%= skill.getProficiencyLevel() %></span>
                            </span>
                        <% 
                                    }
                                }
                            }
                            if (!hasLearningSkills) { 
                        %>
                            <p class="text-muted text-sm mt-2">No learning goals added yet.</p>
                        <% } %>
                    </div>
                </div>
                
                <!-- Learning Goals Card -->
                <div class="card">
                    <h3 class="card-title">Learning goals</h3>
                    <p class="card-subtitle">What <%= displayUser.getFullName() %> is working towards</p>
                    <p class="text-muted text-sm mt-3" style="line-height: 1.6; color: #334155;">
                        <%= (displayUser.getLearningGoals() != null && !displayUser.getLearningGoals().trim().isEmpty()) 
                            ? displayUser.getLearningGoals() 
                            : "No learning goals provided yet." %>
                    </p>
                </div>
                
                <!-- Interests & Hobbies Card -->
                <div class="card">
                    <h3 class="card-title">Interests & Hobbies</h3>
                    <div class="chip-group mt-3">
                        <c:choose>
                            <c:when test="${not empty userInterests}">
                                <c:forEach var="interest" items="${userInterests}">
                                    <span class="skill-chip">${interest.interestName}</span>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted text-sm mt-2">No interests added yet.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Achievements & Badges (DYNAMIC) -->
                <div class="card">
                    <div class="card-header-flex">
                        <div>
                            <h3 class="card-title">Achievements & badges</h3>
                            <p class="card-subtitle">${earnedBadgeCount} of ${totalBadgeCount} unlocked · tap a badge for details</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/jsp/achievements.jsp" class="link-btn">View all</a>
                    </div>

                    <div class="progress-section">
                        <div class="progress-info">
                            <span>Achievement progress</span>
                            <span class="text-primary font-semibold">${earnedBadgeCount}/${totalBadgeCount} unlocked</span>
                        </div>
                        <div class="progress-bar-bg">
                            <div class="progress-bar-fill" style="width: ${badgeProgressPercent}%;"></div>
                        </div>
                        <p class="progress-sub">${badgeProgressPercent}% complete · ${totalBadgeCount - earnedBadgeCount} badges to go</p>
                    </div>

                    <div class="badges-grid">
                        <c:choose>
                            <c:when test="${not empty userBadges}">
                                <c:forEach var="badge" items="${userBadges}">
                                    <div class="badge-tile unlocked">
                                        <div class="badge-icon-wrap bg-amber-light">
                                            <i data-lucide="${not empty badge.icon ? badge.icon : 'award'}" class="icon-sm"></i>
                                        </div>
                                        <div class="badge-name"><c:out value="${badge.badgeName}" /></div>
                                        <div class="badge-desc"><c:out value="${badge.description}" /></div>
                                        <c:if test="${not empty badge.earnedAt}">
                                            <div class="badge-date">
                                                <i data-lucide="calendar" class="icon-xs"></i> 
                                                <fmt:formatDate value="${badge.earnedAt}" pattern="dd MMM yyyy" />
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted text-sm mt-3">No badges unlocked yet. Keep teaching and learning to earn badges!</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Dynamic Ratings & Reviews Card -->
                <div class="card">
                    <div class="card-header-flex">
                        <h3 class="card-title">Ratings & reviews</h3>
                        <span class="text-xs text-muted">${reviewCount} reviews</span>
                    </div>

                    <div class="reviews-list mt-3">
                        <c:choose>
                            <c:when test="${not empty userReviews}">
                                <c:forEach var="rev" items="${userReviews}">
                                    <div class="review-card">
                                        <div class="review-header">
                                            <div class="flex items-center gap-2">
                                                <div class="review-avatar">
                                                    <c:choose>
                                                        <c:when test="${not empty rev.reviewerName}">
                                                            ${rev.reviewerName.substring(0, 1).toUpperCase()}
                                                        </c:when>
                                                        <c:otherwise>U</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div>
                                                    <div class="review-author">
                                                        <c:out value="${not empty rev.reviewerName ? rev.reviewerName : 'Anonymous'}" />
                                                    </div>
                                                    <div class="review-meta text-amber-500">
                                                        ★ ${rev.rating} / 5.0
                                                    </div>
                                                </div>
                                            </div>
                                            <c:if test="${not empty rev.reviewDate}">
                                                <span class="text-xs text-muted" style="margin-left: auto;">
                                                    <fmt:formatDate value="${rev.reviewDate}" pattern="dd MMM yyyy" />
                                                </span>
                                            </c:if>
                                        </div>
                                        <p class="review-body">
                                            <c:out value="${rev.comment}" />
                                        </p>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted text-sm">No reviews received yet.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://unpkg.com/lucide@0.400.0/dist/umd/lucide.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
            
            const connectBtn = document.querySelector('.connect-btn');
            if (connectBtn) {
                connectBtn.addEventListener('click', function() {
                    const receiverId = this.getAttribute('data-receiver-id');
                    const skillId = this.getAttribute('data-skill-id');

                    if (!receiverId || receiverId === "0") {
                        alert("Unable to process request: Target user ID is missing.");
                        return;
                    }

                    if (!skillId || parseInt(skillId) <= 0) {
                        alert("Unable to process request: Please select a valid skill to request.");
                        return;
                    }

                    this.disabled = true;
                    this.innerHTML = '<i data-lucide="loader" class="icon-sm animate-spin"></i> Sending...';
                    if (typeof lucide !== 'undefined') lucide.createIcons();

                    fetch("${pageContext.request.contextPath}/send-request", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/x-www-form-urlencoded",
                        },
                        body: new URLSearchParams({
                            "receiverId": receiverId,
                            "skillId": skillId
                        })
                    })
                    .then(response => {
                        if (response.ok) {
                            this.className = "btn-primary btn-requested";
                            this.innerHTML = '<i data-lucide="check" class="icon-sm"></i> Requested';
                            if (typeof lucide !== 'undefined') lucide.createIcons();
                        } else {
                            response.text().then(text => {
                                alert("Failed to send request: " + (text || "Server error"));
                            });
                            this.disabled = false;
                            this.innerHTML = '<i data-lucide="user-plus" class="icon-sm"></i> Connect / Request Session';
                            if (typeof lucide !== 'undefined') lucide.createIcons();
                        }
                    })
                    .catch(error => {
                        console.error("Error sending connection request:", error);
                        alert("An error occurred while sending the request.");
                        this.disabled = false;
                        this.innerHTML = '<i data-lucide="user-plus" class="icon-sm"></i> Connect / Request Session';
                        if (typeof lucide !== 'undefined') lucide.createIcons();
                    });
                });
            }
        });
    </script>
</body>
</html>