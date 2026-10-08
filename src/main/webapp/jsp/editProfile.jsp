<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skillsync.model.User"%>
<%@ page import="com.skillsync.model.UserSkill"%>
<%@ page import="com.skillsync.model.Skill"%>
<%@ page import="com.skillsync.dao.SkillDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.skillsync.model.UserAvailability"%>
<%@ page import="com.skillsync.dao.AvailabilityDAO"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    // Always fetch fresh skills directly from DB on page render
    SkillDAO skillDAO = new SkillDAO();
    List<UserSkill> userSkills = null;
    List<Skill> masterSkills = null;

    try {
        userSkills = skillDAO.getSkillsByUserId(currentUser.getUserId());
        masterSkills = skillDAO.getAllMasterSkills();
    } catch (Exception e) {
        e.printStackTrace(); // Prints any DB errors to your Tomcat/IDE console
        userSkills = new ArrayList<>();
        masterSkills = new ArrayList<>();
    }

    request.setAttribute("userSkills", userSkills);
    request.setAttribute("masterSkills", masterSkills);

    // Dynamic Parse Availability String into Array for JSTL
    AvailabilityDAO availabilityDAO = new AvailabilityDAO();
    List<UserAvailability> userAvailabilities = null;
    try {
        userAvailabilities = availabilityDAO.getAvailabilityByUserId(currentUser.getUserId());
    } catch (Exception e) {
        e.printStackTrace();
        userAvailabilities = new ArrayList<>();
    }
    request.setAttribute("userAvailabilities", userAvailabilities);

    // Profile Photo Processing
    String photoPath = currentUser.getProfilePhoto();
    boolean hasPhoto = photoPath != null && !photoPath.trim().isEmpty();
    if (hasPhoto && photoPath.startsWith("/")) {
        photoPath = photoPath.substring(1);
    }

    // User Initials Calculation
    String initials = "U";
    if (currentUser.getFullName() != null && !currentUser.getFullName().trim().isEmpty()) {
        String[] names = currentUser.getFullName().trim().split("\\s+");
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
    <title>Edit Profile · SkillSync</title>
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/editProfile.css?v=2">
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        /* Modal Popup Styles */
        .modal-backdrop {
            display: none;
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.4);
            backdrop-filter: blur(4px);
            z-index: 999;
            align-items: center;
            justify-content: center;
        }
        .modal-box {
            background: #ffffff;
            border-radius: 12px;
            padding: 24px;
            width: 90%;
            max-width: 420px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
        }
        .modal-backdrop.active { display: flex; }
    </style>
</head>
<body class="bg-slate-50 text-slate-800">

    <div class="edit-profile-container">
        
        <form action="${pageContext.request.contextPath}/UpdateProfileServlet" method="POST" enctype="multipart/form-data">
            
            <!-- Page Header -->
            <div class="page-header">
                <div>
                    <h1 class="page-title">Edit profile</h1>
                    <p class="page-subtitle">Changes go live immediately and re-run your AI matching in the background.</p>
                </div>
                <button type="submit" class="btn-primary">
                    <i data-lucide="save" class="icon-sm"></i> Save changes
                </button>
            </div>

            <div class="edit-sections-stack">
                
                <!-- Profile Photo Section -->
                <div class="card">
                    <h3 class="card-title">Profile photo</h3>
                    <p class="card-subtitle">A clear face photo doubles response rates</p>
                    
                    <div class="photo-upload-wrapper mt-4">
                        <div class="avatar-camera-container">
                            <% if (hasPhoto) { %>
                                <img src="${pageContext.request.contextPath}/<%= photoPath %>" 
                                     alt="Profile" 
                                     class="edit-avatar-img" 
                                     id="avatar-preview"
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                <div class="edit-avatar-initials" style="display: none;"><%= initials %></div>
                            <% } else { %>
                                <div class="edit-avatar-initials" id="avatar-initials-fallback"><%= initials %></div>
                                <img src="" alt="Profile" class="edit-avatar-img" id="avatar-preview" style="display: none;" />
                            <% } %>
                            
                            <label for="profilePhotoInput" class="camera-badge-btn" title="Upload Photo">
                                <i data-lucide="camera" class="icon-xs"></i>
                            </label>
                        </div>

                        <div class="photo-actions">
                            <input type="file" id="profilePhotoInput" name="profilePhoto" accept="image/*" class="hidden-file-input" onchange="previewImage(event)" />
                            <label for="profilePhotoInput" class="btn-outline">Upload new</label>
                            <button type="button" class="btn-ghost-danger" onclick="removePhoto()">Remove</button>
                            <input type="hidden" name="removePhotoFlag" id="removePhotoFlag" value="false" />
                        </div>
                    </div>
                </div>

                <!-- Basic Details Section -->
                <div class="card">
                    <h3 class="card-title">Basic details</h3>
                    
                    <div class="form-grid mt-4">
                        <div class="form-group">
                            <label for="fullName">Full name</label>
                            <input type="text" id="fullName" name="fullName" value="<%= currentUser.getFullName() %>" class="form-input" required />
                        </div>

                        <div class="form-group">
                            <label for="university">University</label>
                            <input type="text" id="university" name="university" value="<%= currentUser.getUniversity() != null ? currentUser.getUniversity() : "" %>" class="form-input" required />
                        </div>

                        <div class="form-group full-width">
                            <label for="bio">Bio</label>
                            <textarea id="bio" name="bio" rows="4" class="form-textarea"><%= currentUser.getBio() != null ? currentUser.getBio() : "" %></textarea>
                        </div>
                    </div>
                </div>
                
                <!-- Learning Goals Section -->
                <div class="card">
                    <h3 class="card-title">Learning goals</h3>
                    <p class="card-subtitle">Describe what you hope to achieve or build on SkillSync</p>
                    
                    <div class="form-group full-width mt-4">
                        <textarea id="learningGoals" 
                                  name="learningGoals" 
                                  rows="4" 
                                  class="form-textarea" 
                                  placeholder="e.g., I want to learn Java for my university project and improve my programming skills."><%= currentUser.getLearningGoals() != null ? currentUser.getLearningGoals() : "" %></textarea>
                    </div>
                </div>

                <!-- Skills Section -->
<div class="card">
    <h3 class="card-title">Skills</h3>
    <p class="card-subtitle">Tap a chip to remove, or add a new one</p>

    <div class="skills-stack mt-4">
        <!-- Teaching Skills -->
<div>
    <div class="skill-category-label">TEACHING</div>
    <div class="chip-group" id="teaching-chip-group">
        <c:forEach var="s" items="${userSkills}">
            <c:if test="${s.skillType != null && s.skillType.trim().equalsIgnoreCase('TEACHING')}">
                <span class="skill-chip editable-chip">
                    ${s.skillName} <span class="level-badge">${s.proficiencyLevel}</span>
                    <button type="button" class="chip-remove-btn" onclick="this.parentElement.remove()">&times;</button>
                    <input type="hidden" name="teachingSkills" value="${s.skillName}:${s.proficiencyLevel}" />
                </span>
            </c:if>
        </c:forEach>
        <button type="button" class="btn-add-chip" onclick="openAddModal('TEACHING')">
            <i data-lucide="plus" class="icon-xs"></i> Add
        </button>
    </div>
</div>

<!-- Learning Skills -->
<div>
    <div class="skill-category-label">LEARNING</div>
    <div class="chip-group" id="learning-chip-group">
        <c:forEach var="s" items="${userSkills}">
            <c:if test="${s.skillType != null && s.skillType.trim().equalsIgnoreCase('LEARNING')}">
                <span class="skill-chip skill-chip-accent editable-chip">
                    ${s.skillName} <span class="level-badge">${s.proficiencyLevel}</span>
                    <button type="button" class="chip-remove-btn" onclick="this.parentElement.remove()">&times;</button>
                    <input type="hidden" name="learningSkills" value="${s.skillName}:${s.proficiencyLevel}" />
                </span>
            </c:if>
        </c:forEach>
        <button type="button" class="btn-add-chip" onclick="openAddModal('LEARNING')">
            <i data-lucide="plus" class="icon-xs"></i> Add
        </button>
    </div>
</div>
    </div>
</div>

              <!-- Availability Section -->
<div class="card">
    <h3 class="card-title">Availability</h3>
    <p class="card-subtitle">When you can host or attend sessions</p>

    <div class="availability-stack mt-4" id="availabilityContainer">
        <c:choose>
            <c:when test="${not empty userAvailabilities}">
                <c:forEach var="slot" items="${userAvailabilities}">
                    <div class="availability-item">
                        <select name="dayOfWeek" class="form-input" required>
                            <option value="Monday" ${slot.dayOfWeek == 'Monday' ? 'selected' : ''}>Monday</option>
                            <option value="Tuesday" ${slot.dayOfWeek == 'Tuesday' ? 'selected' : ''}>Tuesday</option>
                            <option value="Wednesday" ${slot.dayOfWeek == 'Wednesday' ? 'selected' : ''}>Wednesday</option>
                            <option value="Thursday" ${slot.dayOfWeek == 'Thursday' ? 'selected' : ''}>Thursday</option>
                            <option value="Friday" ${slot.dayOfWeek == 'Friday' ? 'selected' : ''}>Friday</option>
                            <option value="Saturday" ${slot.dayOfWeek == 'Saturday' ? 'selected' : ''}>Saturday</option>
                            <option value="Sunday" ${slot.dayOfWeek == 'Sunday' ? 'selected' : ''}>Sunday</option>
                        </select>
                        <input type="time" name="startTime" value="${slot.startTime}" class="form-input" required />
                        <span class="availability-separator">to</span>
                        <input type="time" name="endTime" value="${slot.endTime}" class="form-input" required />
                        <button type="button" class="btn-remove-slot" onclick="this.parentElement.remove()" title="Remove slot">&times;</button>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="availability-item">
                    <select name="dayOfWeek" class="form-input" required>
                        <option value="Monday">Monday</option>
                        <option value="Tuesday">Tuesday</option>
                        <option value="Wednesday">Wednesday</option>
                        <option value="Thursday">Thursday</option>
                        <option value="Friday">Friday</option>
                        <option value="Saturday">Saturday</option>
                        <option value="Sunday">Sunday</option>
                    </select>
                    <input type="time" name="startTime" value="18:00" class="form-input" required />
                    <span class="availability-separator">to</span>
                    <input type="time" name="endTime" value="21:00" class="form-input" required />
                    <button type="button" class="btn-remove-slot" onclick="this.parentElement.remove()" title="Remove slot">&times;</button>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <button type="button" class="btn-outline mt-4" onclick="addAvailabilitySlot()">
        <i data-lucide="plus" class="icon-xs"></i> Add time slot
    </button>
</div>

<!-- Interests Section -->
<div class="card">
    <h3 class="card-title">Interests</h3>
    <p class="card-subtitle">Select topics you want to explore or connect over</p>
    
    <div class="interests-grid mt-4">
        <c:forEach var="interest" items="${allInterests}">
            <label class="interest-chip">
                <input type="checkbox" 
                       name="interests" 
                       value="${interest.interestId}"
                       <c:if test="${selectedInterestIds.contains(interest.interestId)}">checked</c:if> />
                <span>${interest.interestName}</span>
            </label>
        </c:forEach>
    </div>
</div>
            </div>
        </form>
    </div>

    <!-- Add Skill Modal Dialog -->
    <div class="modal-backdrop" id="addSkillModal">
        <div class="modal-box">
            <h3 class="text-lg font-semibold mb-4" id="modalTitle">Add Skill</h3>
            
            <div class="form-group mb-3">
                <label for="modalSkillInput">Skill Name</label>
                <input type="text" id="modalSkillInput" list="masterSkillsList" class="form-input" placeholder="e.g. Java, Python, Public Speaking" required />
                <datalist id="masterSkillsList">
                    <c:forEach var="m" items="${masterSkills}">
                        <option value="${m.skillName}">
                    </c:forEach>
                </datalist>
            </div>

            <div class="form-group mb-4">
                <label for="modalLevelSelect">Proficiency Level</label>
                <select id="modalLevelSelect" class="form-input">
                    <option value="Beginner">Beginner</option>
                    <option value="Intermediate" selected>Intermediate</option>
                    <option value="Advanced">Advanced</option>
                    <option value="Expert">Expert</option>
                </select>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 16px;">
                <button type="button" class="btn-outline" onclick="closeAddModal()">Cancel</button>
                <button type="button" class="btn-primary" onclick="saveSkillFromModal()">Add Skill</button>
            </div>
        </div>
    </div>
    
    <script>
        lucide.createIcons();
        
        let currentModalType = 'TEACHING';

        function openAddModal(type) {
            currentModalType = type;
            document.getElementById('modalTitle').innerText = 'Add ' + (type === 'TEACHING' ? 'Teaching' : 'Learning') + ' Skill';
            document.getElementById('modalSkillInput').value = '';
            document.getElementById('addSkillModal').classList.add('active');
        }

        function closeAddModal() {
            document.getElementById('addSkillModal').classList.remove('active');
        }

        function saveSkillFromModal() {
            const skillName = document.getElementById('modalSkillInput').value.trim();
            const level = document.getElementById('modalLevelSelect').value;

            if (!skillName) {
                alert('Please enter a skill name.');
                return;
            }

            const containerId = currentModalType === 'TEACHING' ? 'teaching-chip-group' : 'learning-chip-group';
            const inputName = currentModalType === 'TEACHING' ? 'teachingSkills' : 'learningSkills';
            const chipClass = currentModalType === 'TEACHING' ? 'skill-chip editable-chip' : 'skill-chip skill-chip-accent editable-chip';

            const container = document.getElementById(containerId);
            const addBtn = container.querySelector('.btn-add-chip');

            const newChip = document.createElement('span');
            newChip.className = chipClass;
            
            newChip.innerHTML = 
                skillName + ' <span class="level-badge">' + level + '</span>' +
                '<button type="button" class="chip-remove-btn" onclick="this.parentElement.remove()">&times;</button>' +
                '<input type="hidden" name="' + inputName + '" value="' + skillName + ':' + level + '" />';

            container.insertBefore(newChip, addBtn);
            closeAddModal();
            lucide.createIcons();
        }

        function previewImage(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const img = document.getElementById('avatar-preview');
                    const fallback = document.getElementById('avatar-initials-fallback');
                    img.src = e.target.result;
                    img.style.display = 'block';
                    if (fallback) fallback.style.display = 'none';
                    document.getElementById('removePhotoFlag').value = 'false';
                };
                reader.readAsDataURL(file);
            }
        }

        function removePhoto() {
            const img = document.getElementById('avatar-preview');
            const fallback = document.getElementById('avatar-initials-fallback');
            const fileInput = document.getElementById('profilePhotoInput');
            
            fileInput.value = '';
            if (img) img.style.display = 'none';
            if (fallback) fallback.style.display = 'flex';
            document.getElementById('removePhotoFlag').value = 'true';
        }
        
        function addAvailabilitySlot() {
            const container = document.getElementById('availabilityContainer');
            const div = document.createElement('div');
            div.className = 'availability-item';
            
            div.innerHTML = `
                <select name="dayOfWeek" class="form-input" required>
                    <option value="Monday">Monday</option>
                    <option value="Tuesday">Tuesday</option>
                    <option value="Wednesday">Wednesday</option>
                    <option value="Thursday">Thursday</option>
                    <option value="Friday">Friday</option>
                    <option value="Saturday">Saturday</option>
                    <option value="Sunday">Sunday</option>
                </select>
                <input type="time" name="startTime" value="18:00" class="form-input" required />
                <span class="availability-separator">to</span>
                <input type="time" name="endTime" value="21:00" class="form-input" required />
                <button type="button" class="btn-remove-slot" onclick="this.parentElement.remove()" title="Remove slot">&times;</button>
            `;
            
            container.appendChild(div);
            lucide.createIcons();
        }
    </script>
</body>
</html>