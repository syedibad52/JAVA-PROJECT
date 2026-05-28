<%-- frontend/jsp/error.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="An error occurred while processing your request. Please go back or return to login.">
  <title>Course Hub – Error</title>
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
</body>
</html>
