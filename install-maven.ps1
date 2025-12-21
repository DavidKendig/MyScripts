# ========================================================================
# Maven Installation Script for WealthViz (PowerShell)
# This script downloads Maven and adds it to PATH automatically
# ========================================================================

Write-Host ""
Write-Host "========================================================================"
Write-Host "Maven Installation Script for WealthViz"
Write-Host "========================================================================"
Write-Host ""

# Check if Maven is already installed
$mavenInstalled = Get-Command mvn -ErrorAction SilentlyContinue
if ($mavenInstalled) {
    Write-Host "[OK] Maven is already installed and in PATH!" -ForegroundColor Green
    Write-Host ""
    & mvn -version
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 0
}

Write-Host "[!] Maven is not found in PATH." -ForegroundColor Yellow
Write-Host ""

# Configuration
$mavenVersion = "3.9.12"
$installDir = "C:\Program Files\Apache\Maven"
$mavenDir = "$installDir\apache-maven-$mavenVersion"
$downloadUrl = "https://dlcdn.apache.org/maven/maven-3/$mavenVersion/binaries/apache-maven-$mavenVersion-bin.zip"
$zipFile = "$env:TEMP\apache-maven-$mavenVersion-bin.zip"

Write-Host "This script will:"
Write-Host "  1. Download Maven $mavenVersion" -ForegroundColor Cyan
Write-Host "  2. Extract to: $installDir" -ForegroundColor Cyan
Write-Host "  3. Add Maven to your PATH" -ForegroundColor Cyan
Write-Host ""

$confirm = Read-Host "Continue? (Y/N)"
if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "Installation cancelled."
    exit 0
}

# Check if we need admin rights
try {
    if (-not (Test-Path $installDir)) {
        New-Item -ItemType Directory -Path $installDir -Force -ErrorAction Stop | Out-Null
    }
} catch {
    Write-Host ""
    Write-Host "[ERROR] Cannot write to $installDir" -ForegroundColor Red
    Write-Host "Please run this script as Administrator (right-click -> Run as Administrator)"
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Download Maven
Write-Host ""
Write-Host "========================================================================"
Write-Host "Downloading Maven $mavenVersion..."
Write-Host "========================================================================"
Write-Host ""
Write-Host "URL: $downloadUrl"
Write-Host "Saving to: $zipFile"
Write-Host ""
Write-Host "Please wait, this may take a few minutes..."
Write-Host ""

try {
    # Use System.Net.WebClient for better progress display
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($downloadUrl, $zipFile)
    Write-Host "[OK] Download completed!" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to download Maven." -ForegroundColor Red
    Write-Host "Error: $_"
    Write-Host ""
    Write-Host "Please check your internet connection and try again."
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Extract Maven
Write-Host ""
Write-Host "========================================================================"
Write-Host "Extracting Maven..."
Write-Host "========================================================================"
Write-Host ""

try {
    Expand-Archive -Path $zipFile -DestinationPath $installDir -Force
    Write-Host "[OK] Extraction completed!" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to extract Maven." -ForegroundColor Red
    Write-Host "Error: $_"
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Set environment variables
Write-Host ""
Write-Host "========================================================================"
Write-Host "Setting Environment Variables..."
Write-Host "========================================================================"
Write-Host ""

try {
    # Set MAVEN_HOME
    [System.Environment]::SetEnvironmentVariable("MAVEN_HOME", $mavenDir, [System.EnvironmentVariableTarget]::User)
    Write-Host "[OK] MAVEN_HOME set to: $mavenDir" -ForegroundColor Green

    # Add to PATH
    $currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

    # Check if Maven bin is already in PATH
    if ($currentPath -notlike "*$mavenDir\bin*") {
        $newPath = $currentPath + ";$mavenDir\bin"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::User)
        Write-Host "[OK] Added Maven to PATH" -ForegroundColor Green
    } else {
        Write-Host "[OK] Maven already in PATH" -ForegroundColor Green
    }
} catch {
    Write-Host "[ERROR] Failed to set environment variables." -ForegroundColor Red
    Write-Host "Error: $_"
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Clean up
Write-Host ""
Write-Host "Cleaning up..."
Remove-Item $zipFile -Force -ErrorAction SilentlyContinue

# Verify installation
Write-Host ""
Write-Host "========================================================================"
Write-Host "Installation Complete!"
Write-Host "========================================================================"
Write-Host ""
Write-Host "[OK] Maven $mavenVersion has been installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Installation location: $mavenDir" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT:" -ForegroundColor Yellow
Write-Host "  You need to restart your command prompt or PowerShell for changes to take effect."
Write-Host ""
Write-Host "After restarting, verify installation with:"
Write-Host "  mvn -version" -ForegroundColor Cyan
Write-Host ""
Write-Host "To run WealthViz:"
Write-Host "  cd 'c:\Users\trip1\Proton Drive\david.kendig\My files\GITHUB\WealthMap'"
Write-Host "  mvn javafx:run" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
