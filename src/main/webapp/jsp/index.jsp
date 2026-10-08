<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillSync — Connecting Minds, Sharing Skills</title>
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&amp;display=swap">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/index.css">
</head>
<body class="aurora">

    <div class="ambient-orb-1 animate-float"></div>
    <div class="ambient-orb-2 animate-float"></div>

    <!-- Top Navigation Header -->
    <header>
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo-group">

    <img src="${pageContext.request.contextPath}/images/logo.png"
         alt="SkillSync Logo">

    <div>
        <div class="logo-title">
            Skill<span class="text-gradient">Sync</span>
        </div>

        <div class="logo-sub">
            Connecting Minds, Sharing Skills
        </div>
    </div>

</a>
<div class="nav-buttons">
    <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="btn btn-ghost">Login</a>
    <a href="${pageContext.request.contextPath}/jsp/register.jsp" class="btn btn-brand gradient-brand">Register</a>
</div>
    </header>

    <!-- Main Hero Container -->
    <main>
        <!-- Left Side Information -->
        <div class="animate-fade-up">
            <div class="badge-pill">
                <!-- Sparkle Icon -->
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275L12 3Z"/></svg>
                Now matching 12,486 students
            </div>

            <h1 class="hero-heading">
                Learn from peers.<br>
                <span class="text-gradient">Teach what you love.</span>
            </h1>

            <p class="hero-desc">
                SkillSync pairs university learners with knowledge providers using intelligent skill matching — then handles sessions, messaging, reviews and tokens in one calm workspace.
            </p>

            <div class="cta-group">
                <a href="${pageContext.request.contextPath}/jsp/register.jsp" class="btn btn-lg btn-brand gradient-brand">
                    Create your account 
                    <svg width="16" height="16" style="margin-left: 0.5rem;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                </a>
                <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="btn btn-lg btn-outline">
                    I already have one
                </a>
            </div>

            <!-- Features Highlights Grid -->
            <div class="features-grid">
                <div class="glass feature-item lift">
                    <svg class="feature-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275L12 3Z"/></svg>
                    <div class="feature-title">AI skill matching</div>
                    <p class="feature-body">Compatibility scoring across teaching strengths and learning goals.</p>
                </div>

                <div class="glass feature-item lift">
                    <svg class="feature-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    <div class="feature-title">Peer sessions</div>
                    <p class="feature-body">Book, run and review 1:1 sessions with students who complement you.</p>
                </div>

                <div class="glass feature-item lift">
                    <svg class="feature-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="8" cy="8" r="6"/><path d="M18 0.99a9 9 0 1 1-6 16.21"/></svg>
                    <div class="feature-title">Token economy</div>
                    <p class="feature-body">Earn tokens for teaching, spend them learning. Topped up monthly.</p>
                </div>

                <div class="glass feature-item lift">
                    <svg class="feature-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10"/><path d="m9 12 2 2 4-4"/></svg>
                    <div class="feature-title">Trust by design</div>
                    <p class="feature-body">Reputation scores, verified reviews and fast moderation.</p>
                </div>
            </div>
        </div>

        <!-- Right Side Preview Widget -->
        <div class="preview-wrapper animate-pop">
    <div class="glass-strong card-preview">
        <!-- Brand Logo Icon Box -->
        <div class="brand-icon-lg animate-float">
            <img src="${pageContext.request.contextPath}/images/logo.png" 
                 alt="SkillSync Logo" 
                 class="preview-logo-img">
        </div>
        
        <div class="preview-info">
            <h2>Skill<span class="text-gradient">Sync</span></h2>
            <p class="logo-sub">Connecting Minds, Sharing Skills.</p>
        </div>

        <div class="match-list">
            <div class="match-item animate-fade-up" style="animation-delay: 0ms;">
                <span class="match-name">Leo &middot; Motion Design</span>
                <span class="match-badge">96% match</span>
            </div>
            <div class="match-item animate-fade-up" style="animation-delay: 120ms;">
                <span class="match-name">Nina &middot; Machine Learning</span>
                <span class="match-badge">91% match</span>
            </div>
            <div class="match-item animate-fade-up" style="animation-delay: 240ms;">
                <span class="match-name">Kenji &middot; Public Speaking</span>
                <span class="match-badge">88% match</span>
            </div>
        </div>
    </div>
</div>
    </main>

</body>
</html>