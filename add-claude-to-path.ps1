# Add Claude to PATH (PowerShell)
# Replace this with your actual Claude installation path
$claudePath = "$env:LOCALAPPDATA\Programs\Claude"

# Get current PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Add Claude path if not already present
if ($currentPath -notlike "*$claudePath*") {
    $newPath = "$currentPath;$claudePath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Claude added to PATH successfully!"
    Write-Host "Please restart your terminal for changes to take effect."
} else {
    Write-Host "Claude is already in PATH."
}
