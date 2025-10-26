@echo off
REM Reset LegacyBank Database - Drops and recreates the entire database

echo ========================================
echo  LegacyBank Database Reset Utility
echo ========================================
echo.
echo WARNING: This will DELETE the existing database and all its data!
echo.
set /p CONFIRM="Are you sure you want to continue? (yes/no): "

if /i not "%CONFIRM%"=="yes" (
    echo Operation cancelled.
    exit /b 0
)

echo.
echo Dropping existing database...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -Q "IF EXISTS (SELECT name FROM sys.databases WHERE name = 'LegacyBank') DROP DATABASE LegacyBank"
if %errorlevel% neq 0 (
    echo Warning: Could not drop database (it may not exist)
)

echo.
echo Recreating database...
call "%~dp0CreateDatabase.bat"
