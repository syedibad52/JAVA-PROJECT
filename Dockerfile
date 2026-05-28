# ============================================================
# Dockerfile for Course Registration System (Tomcat 10 + JDK 17)
# ============================================================
# Multi-stage build:
#   Stage 1 (builder): Compile Java source files
#   Stage 2 (runtime): Deploy compiled classes + frontend to Tomcat

# ---- Stage 1: Build ----
FROM eclipse-temurin:17-jdk AS builder

# Install Tomcat for the servlet-api.jar (needed for compilation only)
ENV TOMCAT_VERSION=10.1.55
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    | tar xz -C /opt && \
    mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat

# Download MySQL JDBC connector
RUN curl -fsSL https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.4.0/mysql-connector-j-8.4.0.jar \
    -o /opt/mysql-connector-j-8.4.0.jar

WORKDIR /build

# Copy source code
COPY backend/src/ ./src/
COPY frontend/ ./webapp/

# Compile Java files
RUN mkdir -p ./webapp/WEB-INF/classes ./webapp/WEB-INF/lib && \
    cp /opt/mysql-connector-j-8.4.0.jar ./webapp/WEB-INF/lib/ && \
    find ./src -name "*.java" > sources.txt && \
    javac -encoding UTF-8 \
          -cp "/opt/tomcat/lib/servlet-api.jar:/opt/mysql-connector-j-8.4.0.jar" \
          -d ./webapp/WEB-INF/classes \
          @sources.txt

# ---- Stage 2: Runtime ----
FROM tomcat:10.1-jdk17-temurin

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built web application
COPY --from=builder /build/webapp/ /usr/local/tomcat/webapps/ROOT/

# Copy the MySQL connector JAR
COPY --from=builder /opt/mysql-connector-j-8.4.0.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# Expose the default Tomcat port
EXPOSE 8080

# Use Render's PORT env variable if available, otherwise default to 8080
CMD ["catalina.sh", "run"]
