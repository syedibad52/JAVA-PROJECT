<%-- frontend/jsp/admin/dashboard.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.*, dao.*" %>
<%
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Student> students = (List<Student>) request.getAttribute("students");
    List<Enrollment> report = (List<Enrollment>) request.getAttribute("report");
    CourseDAO courseDAO = new CourseDAO();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Administrative control panel for Course Registration System. Manage courses, student profiles, and view registration reports.">
  <title>Course Hub – Admin Dashboard</title>
  <!-- Google Fonts Outfit -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <!-- Navigation Header -->
  <header>
    <nav class="navbar" id="admin-nav">
      <div class="nav-container">
        <span class="brand">🎓 Admin Control Panel</span>
        <div class="nav-user-area">
          <span class="user-welcome">Active Session: <strong>Administrator</strong></span>
          <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-logout" id="nav-btn-logout">Logout</a>
        </div>
      </div>
    </nav>
  </header>

  <main class="container">
    <section class="dashboard-hero admin-hero">
      <div class="hero-content">
        <h1>Administrative Dashboard</h1>
        <p>Manage curriculum course lists, view registered student records, and generate real-time enrollment audit reports.</p>
      </div>
    </section>

    <!-- Stats Dashboard Row -->
    <section class="stats-row" id="stats-dashboard">
      <div class="stat-card" id="stat-courses">
        <div class="stat-icon-wrapper courses-icon">📚</div>
        <div class="stat-content">
          <h2><%= courses != null ? courses.size() : 0 %></h2>
          <p>Active Courses</p>
        </div>
      </div>
      
      <div class="stat-card" id="stat-students">
        <div class="stat-icon-wrapper students-icon">👤</div>
        <div class="stat-content">
          <h2><%= students != null ? students.size() : 0 %></h2>
          <p>Registered Students</p>
        </div>
      </div>
      
      <div class="stat-card" id="stat-enrollments">
        <div class="stat-icon-wrapper enrollments-icon">📊</div>
        <div class="stat-content">
          <h2><%= report != null ? report.size() : 0 %></h2>
          <p>Total Enrollments</p>
        </div>
      </div>
    </section>

    <!-- Form & Lists Grid -->
    <div class="admin-workspace-grid">
      
      <!-- Create Course Card -->
      <section class="card form-card" id="section-add-course">
        <h2>Add New Course</h2>
        <p class="section-intro">Define course attributes and capacity limits to create a curriculum module.</p>
        
        <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" id="add-course-form">
          <input type="hidden" name="action" value="addCourse"/>
          
          <div class="form-grid-row">
            <div class="form-group flex-2">
              <label for="courseName">Course Name</label>
              <input type="text" id="courseName" name="courseName" class="form-control" placeholder="e.g. Advanced Java Concepts" required/>
            </div>
            
            <div class="form-group flex-1">
              <label for="instructor">Instructor</label>
              <input type="text" id="instructor" name="instructor" class="form-control" placeholder="e.g. Dr. Jenkins" required/>
            </div>
          </div>

          <div class="form-grid-row">
            <div class="form-group flex-2">
              <label for="schedule">Weekly Schedule</label>
              <input type="text" id="schedule" name="schedule" class="form-control" placeholder="e.g. Mon/Wed 09:00 AM - 11:00 AM" required/>
            </div>
            
            <div class="form-group flex-1">
              <label for="credits">Credits</label>
              <input type="number" id="credits" name="credits" class="form-control" min="1" max="6" value="3" required/>
            </div>

            <div class="form-group flex-1">
              <label for="capacity">Student Capacity</label>
              <input type="number" id="capacity" name="capacity" class="form-control" min="1" max="100" value="30" required/>
            </div>
          </div>

          <div class="form-group">
            <label for="description">Course Description</label>
            <textarea id="description" name="description" class="form-control" placeholder="Provide a brief course outline..." rows="3" required></textarea>
          </div>

          <button type="submit" class="btn btn-primary" id="btn-add-course">Create Course Module</button>
        </form>
      </section>

      <!-- Manage Courses Card -->
      <section class="card table-card" id="section-manage-courses">
        <h2>Manage Active Courses</h2>
        <div class="table-wrapper">
          <table class="table" id="courses-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Course Name</th>
                <th>Instructor</th>
                <th>Credits</th>
                <th>Capacity</th>
                <th>Enrolled</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <% 
                if(courses != null && !courses.isEmpty()) {
                  for(Course c : courses) {
                    int enrolled = courseDAO.getEnrolledCount(c.getId());
                    boolean isFull = enrolled >= c.getCapacity();
              %>
                <tr>
                  <td><code><%= c.getId() %></code></td>
                  <td><strong><%= c.getCourseName() %></strong></td>
                  <td><%= c.getInstructor() %></td>
                  <td><%= c.getCredits() %> Units</td>
                  <td><%= c.getCapacity() %></td>
                  <td>
                    <span class="badge <%= isFull ? "badge-danger" : "badge-success" %>">
                      <%= enrolled %>
                    </span>
                  </td>
                  <td>
                    <form method="post" action="${pageContext.request.contextPath}/admin/dashboard" class="action-inline-form">
                      <input type="hidden" name="action" value="deleteCourse"/>
                      <input type="hidden" name="courseId" value="<%= c.getId() %>"/>
                      <button type="submit" class="btn btn-danger btn-sm" id="btn-delete-course-<%= c.getId() %>" onclick="return confirm('Confirm deletion of this course? This deletes associated enrollments.')">
                        Delete
                      </button>
                    </form>
                  </td>
                </tr>
              <% 
                  }
                } else {
              %>
                <tr>
                  <td colspan="7" class="empty-table-cell">No active courses. Use the form above to add a course.</td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </section>

      <!-- Manage Students Card -->
      <section class="card table-card" id="section-manage-students">
        <h2>Manage Registered Students</h2>
        <div class="table-wrapper">
          <table class="table" id="students-table">
            <thead>
              <tr>
                <th>Student ID</th>
                <th>Full Name</th>
                <th>Email Address</th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <% 
                if(students != null && !students.isEmpty()) {
                  for(Student s : students) {
              %>
                <tr>
                  <td><code><%= s.getId() %></code></td>
                  <td><strong><%= s.getName() %></strong></td>
                  <td><%= s.getEmail() %></td>
                  <td>
                    <form method="post" action="${pageContext.request.contextPath}/admin/dashboard" class="action-inline-form">
                      <input type="hidden" name="action" value="deleteStudent"/>
                      <input type="hidden" name="studentId" value="<%= s.getId() %>"/>
                      <button type="submit" class="btn btn-danger btn-sm" id="btn-delete-student-<%= s.getId() %>" onclick="return confirm('Confirm deletion of student <%= s.getName() %>? All their enrollments will be deleted.')">
                        Delete Student
                      </button>
                    </form>
                  </td>
                </tr>
              <% 
                  }
                } else {
              %>
                <tr>
                  <td colspan="4" class="empty-table-cell">No students registered in the portal.</td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </section>

      <!-- Enrollment Report Card -->
      <section class="card table-card" id="section-enrollment-report">
        <div class="report-header" style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 1rem; margin-bottom: 1.5rem;">
          <div>
            <h2>📊 Real-Time Enrollment Report</h2>
            <p class="section-intro" style="margin-bottom: 0;">JDBC generated registration audit report detailing student course associations.</p>
          </div>
          <a href="${pageContext.request.contextPath}/admin/export-enrollments" class="btn btn-primary" id="btn-export-enrollments" style="display: inline-flex; align-items: center; gap: 0.5rem; text-decoration: none;">
            <span>📥</span> Export to Excel (CSV)
          </a>
        </div>
        
        <div class="table-wrapper">
          <table class="table" id="report-table">
            <thead>
              <tr>
                <th>#</th>
                <th>Student</th>
                <th>Course Name</th>
                <th>Enrolled On</th>
              </tr>
            </thead>
            <tbody>
              <% 
                if(report != null && !report.isEmpty()) {
                  int index = 1;
                  for(Enrollment e : report) {
              %>
                <tr>
                  <td><%= index++ %></td>
                  <td><strong><%= e.getStudentName() %></strong></td>
                  <td><%= e.getCourseName() %></td>
                  <td><span class="report-timestamp"><%= e.getEnrolledAt() %></span></td>
                </tr>
              <% 
                  }
                } else {
              %>
                <tr>
                  <td colspan="4" class="empty-table-cell">No active enrollments recorded in the database.</td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </section>

    </div>
  </main>
</body>
</html>
