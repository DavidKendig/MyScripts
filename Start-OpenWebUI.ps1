# Start Open WebUI server
# Requires: pip install open-webui

param(
    [string]$Host = "0.0.0.0",
    [int]$Port = 8080
)

$env:PYTHONIOENCODING = "utf-8"

# Check that open-webui is installed
if (-not (Get-Command open-webui -ErrorAction SilentlyContinue)) {
    Write-Error "open-webui is not installed. Install it with: pip install open-webui"
    exit 1
}

Write-Host "Starting Open WebUI on http://${Host}:${Port}"
open-webui serve --host $Host --port $Port
