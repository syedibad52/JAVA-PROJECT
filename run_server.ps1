# PowerShell Script to Setup, Compile and Run Course Registration System on Tomcat 10

$ErrorActionPreference = "Stop"

# Define Paths
$PROJECT_DIR = "c:\Users\User\OneDrive\Desktop\JAVA PROJECT"
$TOMCAT_DIR = "$PROJECT_DIR\apache-tomcat"
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

# 2. Download MySQL JDBC Connector if not exists
$libDir = "$PROJECT_DIR\WebContent\WEB-INF\lib"
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

# 4. Copy WebContent resources
Write-Host 'Copying JSPs, CSS, and web configurations...' -ForegroundColor Yellow
Copy-Item -Path "$PROJECT_DIR\WebContent\*" -Destination $WEBAPP_DIR -Recurse -Force

# 5. Compile Java source files
Write-Host 'Compiling Java Servlet and DAO classes...' -ForegroundColor Yellow
$javaFiles = Get-ChildItem -Path "$PROJECT_DIR\src" -Filter "*.java" -Recurse | Select-Object -ExpandProperty FullName

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

# 6. Launch Tomcat Server
Write-Host 'Starting Apache Tomcat Web Server...' -ForegroundColor Yellow
Start-Process -FilePath "$TOMCAT_DIR\bin\startup.bat" -WorkingDirectory "$TOMCAT_DIR\bin"

Write-Host '=============================================' -ForegroundColor Green
Write-Host 'SUCCESS! Server is starting up in a new terminal window.' -ForegroundColor Green
Write-Host 'Open your browser at: http://localhost:8080/CourseRegistrationSystem/' -ForegroundColor Cyan
Write-Host '=============================================' -ForegroundColor Green
