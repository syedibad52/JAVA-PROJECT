<%-- WebContent/jsp/register.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Registration form for new students to join the Course Registration System portal.">
  <title>Course Hub – Student Registration</title>
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
        <div class="auth-logo" aria-hidden="true">📝</div>
        <h1>Student Registration</h1>
        <p class="subtitle">Join our academic community today</p>
      </header>

      <% if(request.getAttribute("error") != null) { %>
        <div class="alert alert-error" id="error-message" role="alert">
          <span class="alert-icon">⚠️</span>
          <%= request.getAttribute("error") %>
        </div>
      <% } %>

      <form action="${pageContext.request.contextPath}/register" method="post" id="register-form">
        <div class="form-group">
          <label for="input-name">Full Name</label>
          <input type="text" name="name" id="input-name" class="form-control" required placeholder="John Doe" />
        </div>

        <div class="form-group">
          <label for="input-email">University Email</label>
          <input type="email" name="email" id="input-email" class="form-control" required placeholder="john.doe@university.edu" />
        </div>

        <div class="form-group">
          <label for="input-password">Create Password</label>
          <input type="password" name="password" id="input-password" class="form-control" required placeholder="••••••••" />
        </div>

        <button type="submit" class="btn btn-primary btn-block" id="btn-register-submit">
          Create Account
          <span class="arrow" aria-hidden="true">→</span>
        </button>
      </form>

      <footer class="auth-footer">
        <p>Already have an account? <a href="${pageContext.request.contextPath}/login" id="link-login">Sign in instead</a></p>
      </footer>
    </div>
  </main>
</body>
</html>
