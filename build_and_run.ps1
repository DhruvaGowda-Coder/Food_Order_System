$ErrorActionPreference = "Stop"

$ProjectDir = "c:\Users\dhruv\Food Order System"
$ToolsDir = "$ProjectDir\.tools"
if (-not (Test-Path $ToolsDir)) { New-Item -ItemType Directory -Path $ToolsDir | Out-Null }

$JdkUrl = "https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_windows-x64_bin.zip"
$JdkZip = "$ToolsDir\jdk.zip"
$JdkDir = "$ToolsDir\jdk-17.0.2"

$TomcatUrl = "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89-windows-x64.zip"
$TomcatZip = "$ToolsDir\tomcat.zip"
$TomcatDir = "$ToolsDir\apache-tomcat-9.0.89"

$SqliteConnectorUrl = "https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.41.2.1/sqlite-jdbc-3.41.2.1.jar"
$SqliteConnectorJar = "$ProjectDir\WebContent\WEB-INF\lib\sqlite-jdbc-3.41.2.1.jar"

Write-Host "1. Checking and Installing JDK 17..."
if (-not (Test-Path "$JdkDir\bin\javac.exe")) {
    Write-Host "Downloading JDK..."
    Invoke-WebRequest -Uri $JdkUrl -OutFile $JdkZip
    Write-Host "Extracting JDK..."
    Expand-Archive -Path $JdkZip -DestinationPath $ToolsDir -Force
}

Write-Host "2. Checking and Installing Apache Tomcat 9..."
if (-not (Test-Path "$TomcatDir\bin\catalina.bat")) {
    Write-Host "Downloading Tomcat..."
    Invoke-WebRequest -Uri $TomcatUrl -OutFile $TomcatZip
    Write-Host "Extracting Tomcat..."
    Expand-Archive -Path $TomcatZip -DestinationPath $ToolsDir -Force
}

Write-Host "3. Checking and Installing SQLite JDBC..."
$LibDir = "$ProjectDir\WebContent\WEB-INF\lib"
if (-not (Test-Path $LibDir)) { New-Item -ItemType Directory -Path $LibDir | Out-Null }
if (-not (Test-Path $SqliteConnectorJar)) {
    Write-Host "Downloading SQLite JDBC..."
    Invoke-WebRequest -Uri $SqliteConnectorUrl -OutFile $SqliteConnectorJar
}

Write-Host "4. Compiling Java Servlets..."
$ClassesDir = "$ProjectDir\WebContent\WEB-INF\classes"
if (-not (Test-Path $ClassesDir)) { New-Item -ItemType Directory -Path $ClassesDir | Out-Null }

$JavacExe = "$JdkDir\bin\javac.exe"
$ServletApi = "$TomcatDir\lib\servlet-api.jar"

# Find all .java files
$JavaFiles = Get-ChildItem -Path "$ProjectDir\src" -Filter *.java -Recurse | Select-Object -ExpandProperty FullName
if ($JavaFiles.Count -gt 0) {
    Write-Host "Compiling $($JavaFiles.Count) Java files..."
    & $JavacExe -cp "$ServletApi" -d $ClassesDir $JavaFiles
    if ($LASTEXITCODE -ne 0) {
        throw "Java compilation failed!"
    }
}

Write-Host "5. Database setup is now handled automatically by SQLite during server startup!"

Write-Host "6. Deploying to Tomcat..."
# Create a context XML file in Tomcat conf to point to our WebContent directory
$ContextXmlPath = "$TomcatDir\conf\Catalina\localhost\FoodOrderSystem.xml"
$ContextXmlContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<Context docBase="$ProjectDir\WebContent" reloadable="true" />
"@
$ContextDir = "$TomcatDir\conf\Catalina\localhost"
if (-not (Test-Path $ContextDir)) { New-Item -ItemType Directory -Path $ContextDir -Force | Out-Null }
Set-Content -Path $ContextXmlPath -Value $ContextXmlContent

Write-Host "7. Starting Tomcat..."
# Set JAVA_HOME and CATALINA_HOME for Tomcat
$env:JAVA_HOME = $JdkDir
$env:CATALINA_HOME = $TomcatDir
$StartScript = "$TomcatDir\bin\startup.bat"

& cmd.exe /c $StartScript

Write-Host ""
Write-Host "=========================================================="
Write-Host "🚀 SERVER STARTED SUCCESSFULLY!"
Write-Host "You can access the application at:"
Write-Host "http://localhost:8080/FoodOrderSystem/"
Write-Host "=========================================================="
Write-Host "Note: Keep this window open or Tomcat will run in a separate command prompt window."
