<%-- frontend/jsp/register.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Registration form for new students to join the Course Registration System portal.">
  <title>Course Hub – Student Registration</title>
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

      <!-- Autofill Demo Data Control -->
      <div style="display: flex; justify-content: flex-end; margin-bottom: 1.25rem;">
        <button type="button" id="btn-autofill" class="btn btn-sm" style="background: rgba(99, 102, 241, 0.12); color: #a5b4fc; border: 1px solid rgba(99, 102, 241, 0.25); border-radius: var(--radius-md); font-family: inherit; font-size: 0.82rem; font-weight: 500; cursor: pointer; display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.5rem 0.85rem; transition: var(--transition-smooth);" onmouseover="this.style.background='rgba(99, 102, 241, 0.22)'; this.style.borderColor='var(--primary)';" onmouseout="this.style.background='rgba(99, 102, 241, 0.12)'; this.style.borderColor='rgba(99, 102, 241, 0.25)';">
          <span>✨</span> Autofill Random Data
        </button>
      </div>

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

  <script>
    document.addEventListener('DOMContentLoaded', function() {
      const btn = document.getElementById('btn-autofill');
      if (btn) {
        btn.addEventListener('click', function() {
          const firstNames = ['Aarav', 'Ananya', 'Arjun', 'Diya', 'Vihaan', 'Isha', 'Krishna', 'Riya', 'Rahul', 'Aditya', 'Sneha', 'Sai', 'Kavya', 'Amit', 'Neha', 'Rajesh', 'Priya', 'Vikram', 'Divya', 'Sanjay', 'Anjali', 'Rohan', 'Pooja', 'Abhishek', 'Swati', 'Dev', 'Meera', 'Kabir', 'Shalini', 'Neil', 'Kiran', 'Yash', 'Tanya', 'Karan', 'Preeti', 'Pranav', 'Aishwarya', 'Rohit', 'Geeta', 'Suresh'];
          const lastNames = ['Sharma', 'Patel', 'Verma', 'Gupta', 'Kumar', 'Mehta', 'Joshi', 'Rao', 'Reddy', 'Nair', 'Iyer', 'Singh', 'Sen', 'Roy', 'Banerjee', 'Mukherjee', 'Das', 'Shah', 'Choudhury', 'Kulkarni', 'Deshmukh', 'Patil', 'Bhat', 'Prasad', 'Mishra', 'Pandey', 'Trivedi', 'Jha', 'Narayanan', 'Menon', 'Gill', 'Dhillon', 'Malhotra', 'Kapoor', 'Khanna', 'Bose', 'Chatterjee', 'Dutta', 'Sinha', 'Chawla'];
          
          const first = firstNames[Math.floor(Math.random() * firstNames.length)];
          const last = lastNames[Math.floor(Math.random() * lastNames.length)];
          const randNum = Math.floor(Math.random() * 900) + 100;
          
          const fullName = first + ' ' + last;
          const email = first.toLowerCase() + '.' + last.toLowerCase() + randNum + '@university.edu';
          const password = 'student' + randNum;
          
          const inputName = document.getElementById('input-name');
          const inputEmail = document.getElementById('input-email');
          const inputPassword = document.getElementById('input-password');
          
          if (inputName && inputEmail && inputPassword) {
            // Fill values
            inputName.value = fullName;
            inputEmail.value = email;
            inputPassword.value = password;
            
            // Highlight fields with a beautiful glow transition
            [inputName, inputEmail, inputPassword].forEach(input => {
              input.style.borderColor = 'var(--primary)';
              input.style.boxShadow = '0 0 12px var(--primary-glow)';
              input.style.transform = 'scale(1.015)';
              setTimeout(() => {
                input.style.borderColor = '';
                input.style.boxShadow = '';
                input.style.transform = '';
              }, 600);
            });
          }
        });
      }
    });
  </script>

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
