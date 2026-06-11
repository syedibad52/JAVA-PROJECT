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

# Download Apache POI libraries for Excel export
RUN mkdir -p /opt/poi && \
    curl -fsSL https://repo1.maven.org/maven2/org/apache/poi/poi/5.2.5/poi-5.2.5.jar -o /opt/poi/poi-5.2.5.jar && \
    curl -fsSL https://repo1.maven.org/maven2/org/apache/poi/poi-ooxml/5.2.5/poi-ooxml-5.2.5.jar -o /opt/poi/poi-ooxml-5.2.5.jar && \
    curl -fsSL https://repo1.maven.org/maven2/org/apache/poi/poi-ooxml-lite/5.2.5/poi-ooxml-lite-5.2.5.jar -o /opt/poi/poi-ooxml-lite-5.2.5.jar && \
    curl -fsSL https://repo1.maven.org/maven2/org/apache/xmlbeans/xmlbeans/5.1.1/xmlbeans-5.1.1.jar -o /opt/poi/xmlbeans-5.1.1.jar && \
    curl -fsSL https://repo1.maven.org/maven2/org/apache/commons/commons-collections4/4.4/commons-collections4-4.4.jar -o /opt/poi/commons-collections4-4.4.jar && \
    curl -fsSL https://repo1.maven.org/maven2/commons-io/commons-io/2.15.1/commons-io-2.15.1.jar -o /opt/poi/commons-io-2.15.1.jar && \
    curl -fsSL https://repo1.maven.org/maven2/org/apache/commons/commons-compress/1.25.0/commons-compress-1.25.0.jar -o /opt/poi/commons-compress-1.25.0.jar && \
    curl -fsSL https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.22.1/log4j-api-2.22.1.jar -o /opt/poi/log4j-api-2.22.1.jar && \
    curl -fsSL https://repo1.maven.org/maven2/org/apache/commons/commons-math3/3.6.1/commons-math3-3.6.1.jar -o /opt/poi/commons-math3-3.6.1.jar && \
    curl -fsSL https://repo1.maven.org/maven2/com/zaxxer/SparseBitSet/1.3/SparseBitSet-1.3.jar -o /opt/poi/SparseBitSet-1.3.jar

WORKDIR /build

# Copy source code
COPY backend/src/ ./src/
COPY frontend/ ./webapp/

# Compile Java files (include POI JARs in classpath)
RUN mkdir -p ./webapp/WEB-INF/classes ./webapp/WEB-INF/lib && \
    cp /opt/mysql-connector-j-8.4.0.jar ./webapp/WEB-INF/lib/ && \
    cp /opt/poi/*.jar ./webapp/WEB-INF/lib/ && \
    find ./src -name "*.java" > sources.txt && \
    javac -encoding UTF-8 \
          -cp "/opt/tomcat/lib/servlet-api.jar:/opt/mysql-connector-j-8.4.0.jar:/opt/poi/*" \
          -d ./webapp/WEB-INF/classes \
          @sources.txt

# ---- Stage 2: Runtime ----
FROM tomcat:10.1-jdk17-temurin

# Install MariaDB server and clean apt cache to keep image small
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built web application (includes all JARs in WEB-INF/lib)
COPY --from=builder /build/webapp/ /usr/local/tomcat/webapps/ROOT/

# Copy the schema file for database initialization
COPY backend/schema.sql /usr/local/tomcat/schema.sql

# Create data directory for Excel exports on the server
RUN mkdir -p /data/exports

# Configure Tomcat to listen on Render's dynamic PORT environment variable (defaults to 8080)
RUN sed -i 's/port="8080"/port="${PORT:-8080}"/g' /usr/local/tomcat/conf/server.xml

# Expose port
EXPOSE 8080

# Copy startup script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Start services using entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
