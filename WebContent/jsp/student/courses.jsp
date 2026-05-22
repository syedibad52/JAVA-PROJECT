<%-- WebContent/jsp/student/courses.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.*, dao.*" %>
<%
    Student student = (Student) session.getAttribute("student");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    Set<Integer> enrolledIds = (Set<Integer>) request.getAttribute("enrolledIds");
    List<Enrollment> myEnrollments = (List<Enrollment>) request.getAttribute("myEnrollments");
    CourseDAO courseDAO = new CourseDAO();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="View available courses and manage your registrations in the student course registration portal.">
  <title>Course Hub – Student Portal</title>
  <!-- Google Fonts Outfit -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <!-- Semantic Header -->
  <header>
    <nav class="navbar" id="student-nav">
      <div class="nav-container">
        <span class="brand">🎓 CourseHub</span>
        <div class="nav-user-area">
          <span class="user-welcome">Welcome, <strong><%= student.getName() %></strong></span>
          <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-logout" id="nav-btn-logout">Logout</a>
        </div>
      </div>
    </nav>
  </header>

  <main class="container">
    <!-- Hero Dashboard Intro -->
    <section class="dashboard-hero">
      <div class="hero-content">
        <h1>Explore Available Courses</h1>
        <p>Enroll in standard modules, review instructors, schedules, and monitor real-time class capacities.</p>
      </div>
    </section>

    <!-- Feedback messages -->
    <% String msg = request.getParameter("msg"); %>
    <% if("success".equals(msg)) { %>
      <div class="alert alert-success" id="alert-enroll-success" role="alert">
        <span class="alert-icon">✨</span> Enrolled in course successfully!
      </div>
    <% } %>
    <% if("dropped".equals(msg)) { %>
      <div class="alert alert-info" id="alert-enroll-drop" role="alert">
        <span class="alert-icon">ℹ️</span> Course dropped from schedule.
      </div>
    <% } %>
    <% if("failed".equals(msg)) { %>
      <div class="alert alert-error" id="alert-enroll-failed" role="alert">
        <span class="alert-icon">⚠️</span> Action failed: Course is full or you are already enrolled.
      </div>
    <% } %>

    <div class="dashboard-grid">
      <!-- Left Column: Available Courses -->
      <section class="main-content-col">
        <div class="section-header">
          <h2>Active Course Offerings</h2>
          <span class="count-badge"><%= courses != null ? courses.size() : 0 %> courses available</span>
        </div>

        <div class="course-grid">
        <% 
           if (courses != null) {
             for(Course c : courses) {
               int enrolled = courseDAO.getEnrolledCount(c.getId());
               boolean isFull = enrolled >= c.getCapacity();
               boolean isEnrolled = enrolledIds != null && enrolledIds.contains(c.getId());
               double fillPercentage = ((double) enrolled / c.getCapacity()) * 100;
        %>
          <article class="course-card <%= isEnrolled ? "enrolled-card" : "" %>" id="course-<%= c.getId() %>">
            <div class="course-card-header">
              <h3><%= c.getCourseName() %></h3>
              <div class="badges-row">
                <% if(isEnrolled) { %>
                  <span class="badge badge-success">Enrolled</span>
                <% } %>
                <% if(isFull && !isEnrolled) { %>
                  <span class="badge badge-danger">Class Full</span>
                <% } %>
              </div>
            </div>
            
            <p class="course-desc"><%= c.getDescription() %></p>
            
            <div class="course-meta">
              <div class="meta-item">
                <span class="meta-icon" aria-hidden="true">👤</span>
                <span class="meta-text"><strong>Instructor:</strong> <%= c.getInstructor() %></span>
              </div>
              <div class="meta-item">
                <span class="meta-icon" aria-hidden="true">📅</span>
                <span class="meta-text"><strong>Schedule:</strong> <%= c.getSchedule() %></span>
              </div>
              <div class="meta-item">
                <span class="meta-icon" aria-hidden="true">📚</span>
                <span class="meta-text"><strong>Credits:</strong> <%= c.getCredits() %> Units</span>
              </div>
              <div class="meta-item">
                <span class="meta-icon" aria-hidden="true">👥</span>
                <span class="meta-text"><strong>Class Size:</strong> <%= enrolled %> / <%= c.getCapacity() %></span>
              </div>
            </div>

            <!-- Capacity Progress Bar -->
            <div class="capacity-progress-wrapper" aria-label="Course capacity progress">
              <div class="capacity-progress-bar">
                <div class="progress-fill <%= fillPercentage >= 100 ? "progress-full" : (fillPercentage >= 80 ? "progress-warning" : "") %>" 
                     style="width: <%= fillPercentage %>%;"></div>
              </div>
            </div>

            <div class="course-actions">
              <form action="${pageContext.request.contextPath}/student/enroll" method="post">
                <input type="hidden" name="courseId" value="<%= c.getId() %>"/>
                <% if(isEnrolled) { %>
                  <input type="hidden" name="action" value="drop"/>
                  <button type="submit" class="btn btn-danger btn-block btn-sm" id="btn-drop-<%= c.getId() %>">
                    Drop Course
                  </button>
                <% } else if(!isFull) { %>
                  <input type="hidden" name="action" value="enroll"/>
                  <button type="submit" class="btn btn-primary btn-block btn-sm" id="btn-enroll-<%= c.getId() %>">
                    Register Course
                  </button>
                <% } else { %>
                  <button type="button" disabled class="btn btn-disabled btn-block btn-sm" id="btn-full-<%= c.getId() %>">
                    Course Full
                  </button>
                <% } %>
              </form>
            </div>
          </article>
        <% 
             } 
           } 
        %>
        </div>
      </section>

      <!-- Right Column: My Schedule Summary -->
      <aside class="sidebar-col">
        <div class="card my-schedule-card">
          <h2>My Active Schedule</h2>
          <p class="sidebar-intro">Review your current registrations and semester load.</p>

          <% if(myEnrollments != null && !myEnrollments.isEmpty()) { %>
            <div class="schedule-summary-stat">
              <% 
                int totalCredits = 0;
                for(Enrollment e : myEnrollments) {
                    Course c = courseDAO.getCourseById(e.getCourseId());
                    if(c != null) {
                        totalCredits += c.getCredits();
                    }
                }
              %>
              <div class="stat-number"><%= myEnrollments.size() %></div>
              <div class="stat-label">Registered Courses</div>
              <div class="stat-detail">Total Credits: <strong><%= totalCredits %> Units</strong></div>
            </div>

            <ul class="schedule-list">
              <% for(Enrollment e : myEnrollments) { 
                  Course c = courseDAO.getCourseById(e.getCourseId());
                  String schedule = (c != null) ? c.getSchedule() : "N/A";
              %>
                <li class="schedule-item">
                  <div class="schedule-item-info">
                    <span class="schedule-course-title"><%= e.getCourseName() %></span>
                    <span class="schedule-course-time">🕒 <%= schedule %></span>
                  </div>
                  <form action="${pageContext.request.contextPath}/student/enroll" method="post" class="schedule-drop-form">
                    <input type="hidden" name="courseId" value="<%= e.getCourseId() %>"/>
                    <input type="hidden" name="action" value="drop"/>
                    <button type="submit" class="btn-icon-danger" title="Drop Course" aria-label="Drop <%= e.getCourseName() %>">
                      ✕
                    </button>
                  </form>
                </li>
              <% } %>
            </ul>
          <% } else { %>
            <div class="empty-schedule-state">
              <span class="empty-icon" aria-hidden="true">📅</span>
              <p>No active registrations.</p>
              <p class="subtext">Select a course and click "Register Course" to begin.</p>
            </div>
          <% } %>
        </div>
      </aside>
    </div>
  </main>
</body>
</html>
