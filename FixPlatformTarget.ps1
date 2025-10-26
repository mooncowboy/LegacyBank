# Fix Platform Target for SQL Server LocalDB Compatibility

Write-Host "Fixing platform target for SQL Server LocalDB compatibility..." -ForegroundColor Green

$webProject = "LegacyBank.Web\LegacyBank.Web.csproj"
$backOfficeProject = "LegacyBank.BackOffice\LegacyBank.BackOffice.csproj"

foreach ($project in @($webProject, $backOfficeProject)) {
    Write-Host "`nProcessing $project..."
    
    $content = Get-Content $project -Raw
    
    # Replace ARM64 with x64 for better LocalDB compatibility
    $content = $content -replace '<PlatformTarget>ARM64</PlatformTarget>', '<PlatformTarget>x64</PlatformTarget>'
    
    $content | Set-Content $project
    
    Write-Host "Updated $project to use x64 platform target" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Platform targets updated successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Close and reopen Visual Studio" -ForegroundColor White
Write-Host "2. In Visual Studio, go to: Tools > Options > Projects and Solutions > Web Projects" -ForegroundColor White
Write-Host "3. CHECK: 'Use the 64 bit version of IIS Express for web sites and projects'" -ForegroundColor White
Write-Host "4. Rebuild the solution (Ctrl+Shift+B)" -ForegroundColor White
Write-Host "5. Run the application (F5)" -ForegroundColor White
Write-Host "`n" -ForegroundColor White
