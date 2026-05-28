# =========================================================
# Multi-Stage Dockerfile for Course Registration System
# =========================================================

# --- STAGE 1: Build Stage (Compilation) ---
FROM openjdk:17-jdk-slim AS builder
WORKDIR /app

# Copy the backend source files and frontend resources
COPY backend/src /app/src
COPY frontend /app/frontend

# Create directory for compiled .class files
RUN mkdir -p /app/classes

# Download Tomcat 10 Servlet API (Jakarta EE) and MySQL JDBC connector
RUN apt-get update && apt-get install -y wget && \
    wget https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.0.0/jakarta.servlet-api-6.0.0.jar -O /app/servlet-api.jar && \
    wget https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.4.0/mysql-connector-j-8.4.0.jar -O /app/mysql-connector.jar

# Recursively locate all Java files and compile them
RUN find src -name "*.java" > sources.txt && \
    javac -encoding UTF-8 -cp "/app/servlet-api.jar:/app/mysql-connector.jar" -d /app/classes @sources.txt

# --- STAGE 2: Runtime Stage (Tomcat 10 Deployment) ---
FROM tomcat:10.1-jdk17-temurin
WORKDIR /usr/local/tomcat

# Clean up default Tomcat webapps
RUN rm -rf webapps/ROOT webapps/CourseRegistrationSystem

# Copy frontend pages into the ROOT webapp directory
COPY --from=builder /app/frontend webapps/ROOT

# Copy the compiled Java classes into the WEB-INF/classes folder
COPY --from=builder /app/classes webapps/ROOT/WEB-INF/classes

# Ensure the MySQL connector JAR is in the webapp's lib folder
COPY --from=builder /app/mysql-connector.jar webapps/ROOT/WEB-INF/lib/

# Expose Tomcat default HTTP port
EXPOSE 8080

# Launch Tomcat
CMD ["catalina.sh", "run"]
