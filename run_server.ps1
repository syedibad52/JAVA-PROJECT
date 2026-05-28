# PowerShell Script to Setup, Compile and Run Course Registration System on Tomcat 10

$ErrorActionPreference = "Stop"

# Define Paths
$PROJECT_DIR = "c:\Users\User\OneDrive\Desktop\JAVA PROJECT"
$TOMCAT_DIR = "$PROJECT_DIR\backend\apache-tomcat"
$WEBAPP_NAME = "CourseRegistrationSystem"
$WEBAPP_DIR = "$TOMCAT_DIR\webapps\$WEBAPP_NAME"
$MYSQL_JAR_URL = "https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.4.0/mysql-connector-j-8.4.0.jar"
$TOMCAT_URL = "https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.55/bin/apache-tomcat-10.1.55-windows-x64.zip"

Write-Host '=============================================' -ForegroundColor Cyan
Write-Host 'STARTING COURSE REGISTRATION PORTAL SETUP' -ForegroundColor Cyan
Write-Host '=============================================' -ForegroundColor Cyan

# 1. Download & Extract Tomcat if not exists
if (-not (Test-Path $TOMCAT_DIR)) {
    Write-Host 'Downloading Apache Tomcat 10.1.55...' -ForegroundColor Yellow
    $zipPath = "$PROJECT_DIR\tomcat.zip"
    Invoke-WebRequest -Uri $TOMCAT_URL -OutFile $zipPath
    Write-Host "Extracting Tomcat zip file..." -ForegroundColor Yellow
    $tempExtract = "$PROJECT_DIR\temp-tomcat"
    Expand-Archive -Path $zipPath -DestinationPath $tempExtract
    Write-Host "Configuring directories..." -ForegroundColor Yellow
    Move-Item -Path "$tempExtract\apache-tomcat-10.1.55" -Destination $TOMCAT_DIR
    # Cleanup
    Remove-Item $zipPath
    Remove-Item $tempExtract -Recurse
    Write-Host 'Tomcat successfully downloaded and set up.' -ForegroundColor Green
} else {
    Write-Host "Tomcat directory already exists." -ForegroundColor Green
}

# Auto-configure local Tomcat port to 8085 and shutdown port to 8006 to avoid conflicts with global system services (e.g. Tomcat 11)
$serverXmlPath = "$TOMCAT_DIR\conf\server.xml"
if (Test-Path $serverXmlPath) {
    (Get-Content $serverXmlPath) -replace 'port="8080"', 'port="8085"' -replace 'port="8005"', 'port="8006"' | Set-Content $serverXmlPath
}

# 2. Download MySQL JDBC Connector if not exists
$libDir = "$PROJECT_DIR\frontend\WEB-INF\lib"
if (-not (Test-Path $libDir)) {
    New-Item -ItemType Directory -Path $libDir | Out-Null
}
$mysqlJarPath = "$libDir\mysql-connector-j-8.4.0.jar"
if (-not (Test-Path $mysqlJarPath)) {
    Write-Host 'Downloading MySQL Connector/J driver...' -ForegroundColor Yellow
    Invoke-WebRequest -Uri $MYSQL_JAR_URL -OutFile $mysqlJarPath
    Write-Host 'MySQL JDBC Driver downloaded.' -ForegroundColor Green
}

# 3. Create deployment directories
Write-Host 'Preparing webapp deployment directories...' -ForegroundColor Yellow
if (Test-Path $WEBAPP_DIR) {
    Remove-Item $WEBAPP_DIR -Recurse -Force
}
New-Item -ItemType Directory -Path "$WEBAPP_DIR\WEB-INF\classes" | Out-Null
New-Item -ItemType Directory -Path "$WEBAPP_DIR\WEB-INF\lib" | Out-Null

# 4. Copy frontend resources
Write-Host 'Copying JSPs, CSS, and web configurations...' -ForegroundColor Yellow
Copy-Item -Path "$PROJECT_DIR\frontend\*" -Destination $WEBAPP_DIR -Recurse -Force

# 5. Compile Java source files
Write-Host 'Compiling Java Servlet and DAO classes...' -ForegroundColor Yellow
$javaFiles = Get-ChildItem -Path "$PROJECT_DIR\backend\src" -Filter "*.java" -Recurse | Select-Object -ExpandProperty FullName

if ($javaFiles.Count -eq 0) {
    Write-Error "No Java source files found under 'src' directory!"
}

$classpath = "$TOMCAT_DIR\lib\servlet-api.jar;$mysqlJarPath"
$classesOut = "$WEBAPP_DIR\WEB-INF\classes"

# Run compiler
& javac -encoding UTF-8 -cp $classpath -d $classesOut $javaFiles

if ($LASTEXITCODE -ne 0) {
    Write-Error "Java compilation failed! Check syntax errors above."
}
Write-Host 'Java compilation successful. Classes built.' -ForegroundColor Green

# 6. Stop any existing Tomcat on port 8085
Write-Host 'Checking for existing Tomcat processes on port 8085...' -ForegroundColor Yellow
try {
    $existingPid = (Get-NetTCPConnection -LocalPort 8085 -ErrorAction SilentlyContinue).OwningProcess | Select-Object -Unique
    if ($existingPid) {
        Write-Host "Stopping existing process on port 8085 (PID: $existingPid)..." -ForegroundColor Yellow
        Stop-Process -Id $existingPid -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }
} catch {
    # No process on 8085, continue
}

# 7. Launch Tomcat Server (foreground - press Ctrl+C to stop)
Write-Host '=============================================' -ForegroundColor Green
Write-Host 'SUCCESS! Starting server...' -ForegroundColor Green
Write-Host 'Open your browser at: http://localhost:8085/CourseRegistrationSystem/' -ForegroundColor Cyan
Write-Host 'Press Ctrl+C to stop the server.' -ForegroundColor Yellow
Write-Host '=============================================' -ForegroundColor Green

$env:CATALINA_HOME = $TOMCAT_DIR
$env:CATALINA_BASE = $TOMCAT_DIR
& "$TOMCAT_DIR\bin\catalina.bat" run
