@echo off
echo ========================================
echo Starting SQL Server LocalDB
echo ========================================
echo.

REM Start LocalDB instance
echo Starting MSSQLLocalDB instance...
sqllocaldb start MSSQLLocalDB

IF %ERRORLEVEL% EQU 0 (
    echo.
    echo ? LocalDB started successfully!
    echo.
    
    REM Show instance info
    echo Instance Information:
    sqllocaldb info MSSQLLocalDB
    
    echo.
    echo ========================================
    echo LocalDB is now running and ready!
    echo ========================================
    echo.
    echo You can now run your application in Visual Studio.
    echo.
    echo Note: LocalDB will automatically stop after being idle.
    echo Run this script again if needed, or add it to your startup.
    echo.
) ELSE (
    echo.
    echo ? Failed to start LocalDB
    echo.
    echo Troubleshooting:
    echo 1. Check if LocalDB is installed
    echo 2. Try: sqllocaldb create MSSQLLocalDB
    echo 3. Check Windows Event Viewer for errors
    echo.
)

pause
