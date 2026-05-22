# 🎓 Course Hub – Course Registration System

A creative, high-end course registration system built using **Java Servlets (Tomcat 10+ / Jakarta EE)**, **JSP**, **JDBC**, and **MySQL**. The interface features a premium dark-mode glassmorphic theme with animated alerts, real-time class capacity progress bars, and administrative database reports.

---

## 🚀 Step-by-Step Setup & Run Procedure

Follow these detailed steps to compile, deploy, and run this project on your local machine:

### 1. System Prerequisites

Before starting, ensure you have the following software installed:

| Tool | Recommended Version | Purpose |
| :--- | :--- | :--- |
| **Java Development Kit (JDK)** | JDK 17 or higher | Java compiler and runtime environment |
| **Apache Tomcat** | 10.1.x or higher | Web server container supporting Jakarta EE 9+ |
| **MySQL Server** | 8.x or higher | Relational database server |
| **MySQL Connector/J** | 8.x (JAR) | JDBC driver to connect Java with MySQL |
| **IDE (Eclipse / IntelliJ)** | Latest release | Developer tools for deployment and compilation |

---

### 2. Database Initialization (MySQL)

1. Open your MySQL Command Line Client or tool of choice (e.g., MySQL Workbench, phpMyAdmin).
2. Open the [schema.sql](file:///c:/Users/User/OneDrive/Desktop/JAVA%20PROJECT/schema.sql) file.
3. Copy and run the queries inside MySQL. This will:
   - Create a database called `course_db`.
   - Create tables: `students`, `admins`, `courses`, and `enrollments`.
   - Seed sample courses (Java Programming, Full-Stack Web Development, etc.).
   - Seed test administrators (Username: `admin`, Password: `admin123`).
   - Seed sample students and initial registrations for testing.

---

### 3. Setup Project Structure in Eclipse or IntelliJ

#### Option A: Eclipse IDE (Dynamic Web Project)
1. Open Eclipse and go to **File ➔ New ➔ Dynamic Web Project**.
2. Set the **Project Name** to `CourseRegistrationSystem`.
3. Set the **Target Runtime** to **Apache Tomcat v10.x** (If Tomcat is not registered, click *New Runtime* and select your Tomcat installation directory).
4. For **Configuration**, make sure **Jakarta EE 9+ Web Profile** is active. Click **Finish**.
5. Copy the code files from the local directories into the Eclipse project:
   - Copy contents of `src/` to your Eclipse project `src/` folder.
   - Copy contents of `WebContent/` to your Eclipse project `WebContent/` (or `src/main/webapp/`) folder.
6. Place the JDBC Driver:
   - Copy the `mysql-connector-j-8.x.x.jar` file and paste it into the `WebContent/WEB-INF/lib/` folder. (This adds it to Tomcat's deployment classpath).

#### Option B: IntelliJ IDEA Ultimate
1. Open IntelliJ and click **New Project**.
2. Select **Jakarta EE** on the left menu.
3. Name the project `CourseRegistrationSystem`, select **Web Application** template, choose Java version, and select **Tomcat Server** under Application Server. Click **Next**.
4. Set the Specifications version to **Jakarta EE 10**. Click **Create**.
5. Replace the generated directories with the code files:
   - Place Java files into the `src/` directory.
   - Place JSP and CSS files into the web application directory (usually `src/main/webapp` or `web`).
6. Configure Database Driver Dependency:
   - Go to **File ➔ Project Structure ➔ Libraries**.
   - Click the **+** icon (Java), locate your downloaded `mysql-connector-j-8.x.x.jar`, and add it to the project.
   - Ensure the driver is marked as a dependency in the Artifacts tab.

---

### 4. Database Credentials Configuration

1. Locate [DBUtil.java](file:///c:/Users/User/OneDrive/Desktop/JAVA%20PROJECT/src/util/DBUtil.java).
2. Modify the `PASSWORD` static constant to match your local MySQL Root user password:
   ```java
   private static final String PASSWORD = "your_mysql_password_here";
   ```
3. Save the file.

---

### 5. Running and Deploying the Web App

1. **In Eclipse**: Right-click the project `CourseRegistrationSystem` ➔ **Run As ➔ Run on Server**. Select your Tomcat 10 server and click **Finish**.
2. **In IntelliJ**: Select the **Tomcat** run configuration in the top toolbar and click the **Run** button.
3. Once Tomcat compiles and deploys the application, it will launch your default browser at:
   `http://localhost:8080/CourseRegistrationSystem/`

---

## 🛠️ Verification & Demo Credentials

To test the system features, use the following seeded accounts:


### 🧑🎓 Student Portal Verification
- **Email**: `alice@university.edu` | **Password**: `student123`
- **Email**: `bob@university.edu` | **Password**: `student123`
- **Features to Verify**:
  - Browse available courses in a responsive card grid.
  - Review courses credits, schedule times, and instructors.
  - Click **Register Course** to enroll. Notice the real-time capacity progress bar update (e.g. `3/30` filled).
  - Click **Drop Course** to drop a module.
  - View current schedules and total enrolled semester credit units on the sidebar.
  - Test registration of a new student via the **Create an account** form.


### 👩💼 Admin Panel Verification
- **Username**: `admin` | **Password**: `admin123`
- **Features to Verify**:
  - Live dashboards displaying total numbers of Courses, Students, and Enrollments.
  - Fill in the **Add New Course** form to add curriculum offerings.
  - Click **Delete** in the course management table to remove courses.
  - Click **Delete Student** to remove student profiles (which cascades and deletes their enrollments too).
  - Review the **Real-Time Enrollment Report** at the bottom, which lists all students, what courses they registered in, and precise registration timestamps queried directly via JDBC.
