<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create your SkillSync account</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap">

    <!-- External CSS -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/register.css">
</head>
<body class="aurora">

    <div class="auth-page">
        <!-- Top Left Brand Logo -->
        <a href="${pageContext.request.contextPath}/index.jsp" class="auth-logo">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="SkillSync Logo" class="auth-logo-img">
            <div>
                <div class="auth-logo-title">Skill<span class="text-gradient">Sync</span></div>
                <div class="auth-logo-sub">Connecting Minds, Sharing Skills.</div>
            </div>
        </a>

        <div class="auth-container">
            <!-- Left Side Hero Section -->
            <div class="auth-hero">
                <div class="hero-content animate-fade-up">
                    <!-- Large Floating Icon -->
                    <div class="brand-icon-lg animate-float">
                        <img src="${pageContext.request.contextPath}/images/logo.png" alt="SkillSync Logo" class="preview-logo-img">
                    </div>

                    <h1 class="hero-headline">
                        A campus-sized network of people who 
                        <span class="text-gradient">teach what they know</span>.
                    </h1>

                    <!-- Quote Box -->
                    <div class="quote-card glass">
                        <svg class="quote-icon" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h3.983v10h-9.983z" />
                        </svg>
                        <p class="quote-text">"I teach debate, I learn Python. SkillSync made that trade feel completely natural."</p>
                        <div class="quote-author">Kenji Watanabe &middot; Aurora Polytechnic</div>
                    </div>

                    <!-- Footer Stats -->
                    <div class="auth-stats">
                        <div class="stat-item">
                            <div class="stat-value">12.4k</div>
                            <div class="stat-label">students</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">4.8&starf;</div>
                            <div class="stat-label">avg rating</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">1.2M</div>
                            <div class="stat-label">tokens shared</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Side Form Card -->
            <div class="auth-form-wrapper animate-pop">
                <div class="form-card glass-strong">
                    <div class="form-header">
                        <h2>Create your account</h2>
                        <p>Two minutes to set up, and 100 tokens land in your wallet on day one.</p>
                    </div>
                    
                    <%-- Show Error Alert if present --%>
                    <c:if test="${not empty error}">
                        <div style="color: #ef4444; background-color: #fef2f2; border: 1px solid #fca5a5; padding: 0.75rem 1rem; border-radius: 0.75rem; font-size: 0.85rem; margin-bottom: 1rem;">
                            <c:out value="${error}" />
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/RegisterServlet" method="POST" class="auth-form" enctype="multipart/form-data">
                        <!-- Profile Photo Picker -->
                        <div class="avatar-upload-group">
                            <div class="avatar-wrapper">
                                <div class="avatar-placeholder" id="avatarPreview">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2" />
                                        <circle cx="12" cy="7" r="4" />
                                    </svg>
                                </div>
                                <label for="profilePhoto" class="camera-btn gradient-brand" title="Upload profile photo">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z" />
                                        <circle cx="12" cy="13" r="3" />
                                    </svg>
                                </label>
                                <input type="file" id="profilePhoto" name="profilePhoto" accept="image/*" class="sr-only">
                            </div>
                            <div class="avatar-text">
                                <div class="avatar-title">Profile photo</div>
                                <div class="avatar-sub">PNG or JPG, up to 4MB. A real face gets 2&times; more matches.</div>
                            </div>
                        </div>

                        <!-- Full Name -->
                        <div class="form-group">
                            <label for="name">Full name</label>
                            <div class="input-relative">
                                <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2" />
                                    <circle cx="12" cy="7" r="4" />
                                </svg>
                                <input type="text" id="name" name="name" value="<c:out value='${not empty name ? name : param.name}'/>" placeholder="Amara Osei" class="form-input" required>
                            </div>
                        </div>

                        <c:set var="savedUni" value="${not empty university ? university : param.university}" />
                        <c:set var="standardUnis" value="University of Yangon,Auston University Myanmar,Dagon University,Myanmar Maritime University (MMU),University of Medicine1 Yangon,University of Computer Studies, Yangon,Technological University, Thanlyin,Strategy First University,Yangon University of Education,Yangon University of Foreign Languages,Yangon Technological University,West Yangon Technological University,Polytechnic University,Yangon University of Economics" />
                        <c:set var="isCustomUni" value="${not empty savedUni && !standardUnis.contains(savedUni)}" />

                        <!-- University Dropdown Selection -->
                        <div class="form-group">
                            <label for="universitySelect">University</label>
                            <div class="input-relative">
                                <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M6 22V4a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v18Z" />
                                    <path d="M6 12H4a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h2" />
                                    <path d="M18 9h2a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2h-2" />
                                    <path d="M10 6h4" /><path d="M10 10h4" /><path d="M10 14h4" /><path d="M10 18h4" />
                                </svg>
                                <select id="universitySelect" name="universitySelect" class="form-input" required onchange="toggleCustomUniversity(this)">
                                    <option value="" disabled ${empty savedUni ? 'selected' : ''}>Select your university</option>
                                    <option value="University of Yangon" ${savedUni == 'University of Yangon' ? 'selected' : ''}>University of Yangon</option>
                                    <option value="Auston University Myanmar" ${savedUni == 'Auston University Myanmar' ? 'selected' : ''}>Auston University Myanmar</option>
                                    <option value="Dagon University" ${savedUni == 'Dagon University' ? 'selected' : ''}>Dagon University</option>
                                    <option value="Myanmar Maritime University (MMU)" ${savedUni == 'Myanmar Maritime University (MMU)' ? 'selected' : ''}>Myanmar Maritime University (MMU)</option>
                                    <option value="University of Medicine1 Yangon" ${savedUni == 'University of Medicine1 Yangon' ? 'selected' : ''}>University of Medicine1 Yangon</option>
                                    <option value="University of Computer Studies, Yangon" ${savedUni == 'University of Computer Studies, Yangon' ? 'selected' : ''}>University of Computer Studies, Yangon</option>
                                    <option value="Technological University, Thanlyin" ${savedUni == 'Technological University, Thanlyin' ? 'selected' : ''}>Technological University, Thanlyin</option>
                                    <option value="Strategy First University" ${savedUni == 'Strategy First University' ? 'selected' : ''}>Strategy First University</option>
                                    <option value="Yangon University of Education" ${savedUni == 'Yangon University of Education' ? 'selected' : ''}>Yangon University of Education</option>
                                    <option value="Yangon University of Foreign Languages" ${savedUni == 'Yangon University of Foreign Languages' ? 'selected' : ''}>Yangon University of Foreign Languages</option>
                                    <option value="Yangon Technological University" ${savedUni == 'Yangon Technological University' ? 'selected' : ''}>Yangon Technological University</option>
                                    <option value="West Yangon Technological University" ${savedUni == 'West Yangon Technological University' ? 'selected' : ''}>West Yangon Technological University</option>
                                    <option value="Polytechnic University" ${savedUni == 'Polytechnic University' ? 'selected' : ''}>Polytechnic University</option>
                                    <option value="Yangon University of Economics" ${savedUni == 'Yangon University of Economics' ? 'selected' : ''}>Yangon University of Economics</option>
                                    <option value="Other" ${isCustomUni ? 'selected' : ''}>Other (Specify below)</option>
                                </select>
                            </div>
                        </div>

                        <!-- Hidden Custom University Input Field (Revealed on 'Other') -->
                        <div class="form-group" id="customUniWrapper" style="display: ${isCustomUni ? 'block' : 'none'}; margin-top: 0.75rem;">
                            <label for="customUniversity">Specify University Name</label>
                            <div class="input-relative">
                                <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M6 22V4a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v18Z" />
                                    <path d="M6 12H4a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h2" />
                                    <path d="M18 9h2a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2h-2" />
                                    <path d="M10 6h4" /><path d="M10 10h4" /><path d="M10 14h4" /><path d="M10 18h4" />
                                </svg>
                                <input type="text" 
                                       id="customUniversity" 
                                       value="<c:out value='${isCustomUni ? savedUni : ""}'/>"
                                       placeholder="Enter your university name" 
                                       class="form-input"
                                       ${isCustomUni ? 'required' : ''} />
                            </div>
                        </div>

                        <!-- Hidden input field sent to RegisterServlet as 'university' -->
                        <input type="hidden" id="finalUniversity" name="university" value="<c:out value='${savedUni}'/>" />

                        <!-- Email -->
                        <div class="form-group">
                            <label for="email">Email</label>
                            <div class="input-relative">
                                <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect width="20" height="16" x="2" y="4" rx="2" />
                                    <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7" />
                                </svg>
                                <input type="email" id="email" name="email" value="<c:out value='${not empty email ? email : param.email}'/>" placeholder="you@university.edu" class="form-input" required>
                            </div>
                        </div>

                        <!-- Password Fields -->
                        <div class="form-row">
                            <div class="form-group">
                                <label for="pw">Password</label>
                                <div class="input-relative">
                                    <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect width="18" height="11" x="3" y="11" rx="2" ry="2" />
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                                    </svg>
                                    <input type="password" id="pw" name="password" placeholder="••••••••" class="form-input" required>
                                    <button type="button" class="toggle-password-btn" onclick="togglePasswordVisibility('pw', this)">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                            <circle cx="12" cy="12" r="3"/>
                                        </svg>
                                    </button>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="pw2">Confirm password</label>
                                <div class="input-relative">
                                    <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect width="18" height="11" x="3" y="11" rx="2" ry="2" />
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                                    </svg>
                                    <input type="password" id="pw2" name="confirmPassword" placeholder="••••••••" class="form-input" required>
                                    <button type="button" class="toggle-password-btn" onclick="togglePasswordVisibility('pw2', this)">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                            <circle cx="12" cy="12" r="3"/>
                                        </svg>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn-submit gradient-brand">
                            Create account
                            <svg class="btn-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M5 12h14M12 5l7 7-7 7" />
                            </svg>
                        </button>

                        <!-- Divider -->
                        <div class="divider">
                            <span>or</span>
                        </div>

                        <p class="auth-footer-text">
                            Already registered? <a href="${pageContext.request.contextPath}/jsp/login.jsp">Log in</a>
                        </p>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script>
    // Avatar Image Preview Handler
    document.getElementById('profilePhoto').addEventListener('change', function(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const previewContainer = document.getElementById('avatarPreview');
                previewContainer.innerHTML = '<img src="' + e.target.result + '" alt="Avatar Preview" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">';
            };
            reader.readAsDataURL(file);
        }
    });

    // Dynamic Custom University Field Toggle
    function toggleCustomUniversity(selectObj) {
        const customWrapper = document.getElementById('customUniWrapper');
        const customInput = document.getElementById('customUniversity');
        
        if (selectObj.value === 'Other') {
            customWrapper.style.display = 'block';
            customInput.required = true;
            customInput.focus();
        } else {
            customWrapper.style.display = 'none';
            customInput.required = false;
            customInput.value = '';
        }
    }

    // Form Submission Interceptor: assigns selection/custom text to hidden parameter 'university'
    document.querySelector('.auth-form').addEventListener('submit', function(e) {
        const selectObj = document.getElementById('universitySelect');
        const customInput = document.getElementById('customUniversity');
        const finalInput = document.getElementById('finalUniversity');
        
        if (selectObj.value === 'Other') {
            finalInput.value = customInput.value.trim();
        } else {
            finalInput.value = selectObj.value;
        }
    });

    // Toggle Password Visibility Handler
    function togglePasswordVisibility(inputId, btn) {
        const passwordInput = document.getElementById(inputId);
        const isPassword = passwordInput.type === 'password';
        
        passwordInput.type = isPassword ? 'text' : 'password';
        
        btn.innerHTML = isPassword 
            ? `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                <line x1="1" y1="1" x2="23" y2="23"></line>
               </svg>`
            : `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                <circle cx="12" cy="12" r="3"/>
               </svg>`;
    }
    </script>

</body>
</html>