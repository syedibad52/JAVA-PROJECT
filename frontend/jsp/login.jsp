<%-- frontend/jsp/login.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Secure login portal for students and administrators to access the Course Registration System.">
  <title>Course Hub – Portal Sign In</title>
  <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🎓</text></svg>">
  <!-- Google Fonts Outfit -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-body">
  <main class="auth-container">
    <div class="auth-card">
      <header class="auth-header-block">
        <div class="auth-logo" aria-hidden="true">🎓</div>
        <h1>Course Hub Portal</h1>
        <p class="subtitle">Sign in to manage your academic journey</p>
      </header>

      <% if(request.getAttribute("error") != null) { %>
        <div class="alert alert-error" id="error-message" role="alert">
          <span class="alert-icon">⚠️</span>
          <%= request.getAttribute("error") %>
        </div>
      <% } %>
      <% if("registered".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success" id="success-message" role="alert">
          <span class="alert-icon">✨</span>
          Registration successful! Please log in below.
        </div>
      <% } %>

      <form action="${pageContext.request.contextPath}/login" method="post" id="login-form">
        <div class="form-group">
          <label for="select-role">Access Role</label>
          <select name="role" id="select-role" class="form-control" required>
            <option value="student">Student Portal</option>
            <option value="admin">Administrator</option>
          </select>
        </div>
        
        <div class="form-group">
          <label for="input-email">Email or Username</label>
          <input type="text" name="email" id="input-email" class="form-control" required placeholder="name@university.edu or admin" />
        </div>
        
        <div class="form-group">
          <label for="input-password">Password</label>
          <input type="password" name="password" id="input-password" class="form-control" required placeholder="••••••••" />
        </div>
        
        <button type="submit" class="btn btn-primary btn-block" id="btn-login-submit">
          Sign In
          <span class="arrow" aria-hidden="true">→</span>
        </button>
      </form>
      
      <footer class="auth-footer">
        <p>New student? <a href="${pageContext.request.contextPath}/register" id="link-register">Create an account</a></p>
      </footer>
    </div>
  </main>

  <!-- Cold-start loading overlay -->
  <div id="splash-overlay" style="position:fixed;inset:0;z-index:9999;background:linear-gradient(135deg,#090d16 0%,#111827 50%,#1e1b4b 100%);display:flex;flex-direction:column;align-items:center;justify-content:center;gap:1.5rem;transition:opacity 0.5s ease;">
    <div style="font-size:3.5rem;animation:pulse 1.5s infinite ease-in-out;">🎓</div>
    <div style="font-family:'Outfit',sans-serif;font-size:1.5rem;font-weight:800;background:linear-gradient(to right,#a5b4fc,#6366f1,#c084fc);-webkit-background-clip:text;-webkit-text-fill-color:transparent;">Course Hub</div>
    <div style="display:flex;gap:6px;">
      <span style="width:8px;height:8px;border-radius:50%;background:#6366f1;animation:bounce 1.2s infinite ease-in-out 0s;"></span>
      <span style="width:8px;height:8px;border-radius:50%;background:#818cf8;animation:bounce 1.2s infinite ease-in-out 0.2s;"></span>
      <span style="width:8px;height:8px;border-radius:50%;background:#c084fc;animation:bounce 1.2s infinite ease-in-out 0.4s;"></span>
    </div>
    <p style="font-family:'Outfit',sans-serif;font-size:0.85rem;color:#6b7280;">Starting up server, please wait...</p>
  </div>
  <style>
    @keyframes pulse{0%,100%{transform:scale(1)}50%{transform:scale(1.1)}}
    @keyframes bounce{0%,100%{transform:translateY(0);opacity:.5}50%{transform:translateY(-8px);opacity:1}}
  </style>
  <script>
    window.addEventListener('load', function() {
      var overlay = document.getElementById('splash-overlay');
      if (overlay) { overlay.style.opacity = '0'; setTimeout(function(){ overlay.style.display='none'; }, 500); }
    });
  </script>
</body>
</html>
