<%-- frontend/jsp/login.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Secure login portal for students and administrators to access the Course Registration System.">
  <title>Course Hub – Portal Sign In</title>
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
</body>
</html>
