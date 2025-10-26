# Keep LocalDB Alive Script
# This script maintains a connection to LocalDB to prevent it from auto-stopping

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " LocalDB Keep-Alive Service" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if LocalDB is running
$status = sqllocaldb info MSSQLLocalDB | Select-String "State"

if ($status -notmatch "Running") {
    Write-Host "LocalDB is not running. Starting..." -ForegroundColor Yellow
    sqllocaldb start MSSQLLocalDB
    Start-Sleep -Seconds 2
}

Write-Host "? LocalDB is running" -ForegroundColor Green
Write-Host ""
Write-Host "This window will keep LocalDB alive by maintaining a connection." -ForegroundColor Yellow
Write-Host "DO NOT CLOSE this window while developing." -ForegroundColor Yellow
Write-Host ""
Write-Host "Press Ctrl+C to stop and allow LocalDB to shut down naturally." -ForegroundColor Gray
Write-Host ""

$count = 0
try {
    while ($true) {
        $count++
        $timestamp = Get-Date -Format "HH:mm:ss"
        
        # Execute a simple query to keep connection alive
        $result = sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d LegacyBank -Q "SELECT @@VERSION" -h -1 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[$timestamp] ? Connection #$count - LocalDB is alive" -ForegroundColor Green
        } else {
            Write-Host "[$timestamp] ? Connection failed - LocalDB may have stopped" -ForegroundColor Red
            Write-Host "Attempting to restart LocalDB..." -ForegroundColor Yellow
            sqllocaldb start MSSQLLocalDB
        }
        
        # Wait 5 minutes before next check
        Start-Sleep -Seconds 300
    }
}
catch {
    Write-Host ""
    Write-Host "Keep-Alive service stopped." -ForegroundColor Yellow
}
finally {
    Write-Host ""
    Write-Host "LocalDB will now stop automatically after being idle." -ForegroundColor Gray
}
