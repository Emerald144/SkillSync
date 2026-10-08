<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log in to SkillSync</title>
    <!-- Links to your existing stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body class="aurora">
    <div class="auth-page">
        <!-- Top Left Brand Logo -->
        <a href="${pageContext.request.contextPath}/index.jsp" class="auth-logo">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="SkillSync Logo" class="auth-logo-img">
            <div>
                <div class="auth-logo-title">SkillSync</div>
                <div class="auth-logo-sub">Connecting Minds, Sharing Skills.</div>
            </div>
        </a>

        <div class="auth-container">
            <!-- Left Hero Section -->
            <div class="auth-hero animate-fade-up">
                <div class="brand-icon-lg">
                    <img src="${pageContext.request.contextPath}/images/logo.png" alt="SkillSync Logo" class="preview-logo-img">
                </div>

                <h1 class="hero-headline">
                    A campus-sized network of people who <span class="text-gradient">teach what they know</span>.
                </h1>

                <div class="quote-card glass">
                    <svg class="quote-icon" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h3.983v10h-9.83z"/>
                    </svg>
                    <p class="quote-text">"I found three study partners in my first week. My grades and my confidence both moved."</p>
                    <p class="quote-author">Nina Alvarez · Westfield Institute</p>
                </div>

                <div class="auth-stats">
                    <div>
                        <div class="stat-value">12.4k</div>
                        <div class="stat-label">students</div>
                    </div>
                    <div>
                        <div class="stat-value">4.8★</div>
                        <div class="stat-label">avg rating</div>
                    </div>
                    <div>
                        <div class="stat-value">1.2M</div>
                        <div class="stat-label">tokens shared</div>
                    </div>
                </div>
            </div>

            <!-- Right Side Form Card -->
            <div class="auth-form-wrapper animate-pop">
                <div class="form-card glass-strong">
                    <div class="form-header">
                        <h2>Welcome back</h2>
                        <p>Your matches, sessions and tokens are exactly where you left them.</p>
                    </div>

                    <%-- Alert: Registration Success --%>
                    <% if ("true".equals(request.getParameter("registered"))) { %>
                        <div style="color: #166534; background-color: #f0fdf4; border: 1px solid #bbf7d0; padding: 0.75rem 1rem; border-radius: 0.75rem; font-size: 0.85rem; margin-bottom: 1.25rem;">
                            Account created successfully! Please log in below.
                        </div>
                    <% } %>

                    <%-- Alert: Login Error --%>
                    <% if (request.getAttribute("error") != null) { %>
                        <div style="color: #ef4444; background-color: #fef2f2; border: 1px solid #fca5a5; padding: 0.75rem 1rem; border-radius: 0.75rem; font-size: 0.85rem; margin-bottom: 1.25rem;">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>

                    <form action="${pageContext.request.contextPath}/LoginServlet" method="POST" class="auth-form">
                        <!-- Email Field -->
                        <div class="form-group">
                            <label for="email">Email</label>
                            <div class="input-relative">
                                <svg class="input-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                                </svg>
                                <input type="email" id="email" name="email" class="form-input" placeholder="you@university.edu" required>
                            </div>
                        </div>

                        <!-- Password Field -->
                        <div class="form-group">
                            <label for="password">Password</label>
                            <div class="input-relative">
                                <svg class="input-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                                </svg>
                                <input type="password" id="password" name="password" class="form-input" placeholder="••••••••" required>
                                <button type="button" class="toggle-password-btn" onclick="togglePasswordVisibility('password', this)">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                            <circle cx="12" cy="12" r="3"/>
                                        </svg>
                                    </button>
                            </div>
                        </div>

                        <!-- Options Row -->
                        <div style="display: flex; align-items: center; justify-content: space-between; font-size: 0.85rem; margin-top: 0.25rem;">
                            <label style="display: flex; align-items: center; gap: 0.5rem; color: var(--muted-foreground); cursor: pointer;">
                                <input type="checkbox" name="remember" style="accent-color: var(--primary); width: 1rem; height: 1rem; border-radius: 0.25rem;"> Remember me
                            </label>
                            <a href="#" style="color: var(--primary); font-weight: 600; text-decoration: none;">Forgot password?</a>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn-submit gradient-brand">
                            Log in
                            <svg class="btn-arrow" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"/>
                            </svg>
                        </button>

                        <!-- Divider -->
                        <div class="divider">
                            <span>or</span>
                        </div>

                        <!-- Footer -->
                        <p class="auth-footer-text">
                            New to SkillSync? 
                            <a href="${pageContext.request.contextPath}/jsp/register.jsp">Create an account</a>
                        </p>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script>
 // Toggle Password Visibility Handler
    function togglePasswordVisibility(inputId, btn) {
        const passwordInput = document.getElementById(inputId);
        const isPassword = passwordInput.type === 'password';
        
        passwordInput.type = isPassword ? 'text' : 'password';
        
        // Dynamic Eye / Eye-Off SVG swap
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