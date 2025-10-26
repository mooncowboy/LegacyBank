@echo off
REM LegacyBank Setup Script for Windows
REM Run this script to initialize the database and verify the setup

echo ========================================
echo LegacyBank Setup Script
echo ========================================
echo.

REM Check if SQLite is available
where sqlite3 >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo WARNING: sqlite3 not found in PATH
    echo Please install SQLite from https://www.sqlite.org/download.html
    echo Or the database should already be initialized in LegacyBank.Web\App_Data\
    echo.
) else (
    echo SQLite found - checking database...
    if exist LegacyBank.Web\App_Data\LegacyBank.db (
        echo Database already exists at LegacyBank.Web\App_Data\LegacyBank.db
    ) else (
        echo Creating new database...
        sqlite3 LegacyBank.Web\App_Data\LegacyBank.db < Database\schema.sql
        sqlite3 LegacyBank.Web\App_Data\LegacyBank.db < Database\data.sql
        echo Database created successfully!
    )
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Open LegacyBank.sln in Visual Studio 2022
echo 2. Restore NuGet packages (should happen automatically)
echo 3. Build the solution
echo 4. Set LegacyBank.Web as startup project
echo 5. Press F5 to run with IIS Express
echo.
echo The application should open at http://localhost:8080/
echo.
pause
