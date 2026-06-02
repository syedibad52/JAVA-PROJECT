<%-- frontend/jsp/error.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="An error occurred while processing your request. Please go back or return to login.">
  <title>Course Hub – Error</title>
  <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🎓</text></svg>">
  <!-- Google Fonts Outfit -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-body">
  <main class="auth-container">
    <div class="auth-card error-card">
      <header class="auth-header-block">
        <div class="auth-logo error-logo" aria-hidden="true">💫</div>
        <h1>Something went wrong</h1>
        <p class="subtitle">We couldn't complete your request</p>
      </header>

      <div class="error-details">
        <% 
            Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
            String message = "An unexpected error occurred.";
            if (statusCode != null) {
                if (statusCode == 404) {
                    message = "The page you are looking for does not exist or has been moved.";
                } else if (statusCode == 500) {
                    message = "Our servers encountered an internal error. Please try again later.";
                }
            } else if (exception != null && exception.getMessage() != null) {
                message = exception.getMessage();
            }
        %>
        <p class="error-message-text"><%= message %></p>
        <% if (statusCode != null) { %>
          <span class="error-badge">Error Code: <%= statusCode %></span>
        <% } %>
      </div>

      <div class="error-actions">
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-block" id="btn-error-home">
          Return to Portal
        </a>
      </div>
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
