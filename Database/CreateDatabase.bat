@echo off
REM Create LegacyBank SQL Server LocalDB Database
REM This script creates the database and applies schema and data

echo Creating LegacyBank LocalDB Database...
echo.

set APP_DATA_PATH=%~dp0..\LegacyBank.Web\App_Data
set DATABASE_PATH=%APP_DATA_PATH%\LegacyBank.mdf
set LOG_PATH=%APP_DATA_PATH%\LegacyBank_log.ldf
set SCHEMA_SCRIPT=%~dp0schema-sqlserver.sql
set DATA_SCRIPT=%~dp0data-sqlserver.sql

REM Ensure App_Data directory exists
if not exist "%APP_DATA_PATH%" (
    echo Creating App_Data directory...
    mkdir "%APP_DATA_PATH%"
)

REM Remove existing database files if they exist
if exist "%DATABASE_PATH%" (
    echo Removing existing database file...
    del /F "%DATABASE_PATH%"
)
if exist "%LOG_PATH%" (
    del /F "%LOG_PATH%"
)

REM Create the database
echo Creating database at: %DATABASE_PATH%
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -Q "CREATE DATABASE LegacyBank ON PRIMARY (NAME = LegacyBank, FILENAME = '%DATABASE_PATH%', SIZE = 10MB, MAXSIZE = 100MB, FILEGROWTH = 5MB) LOG ON (NAME = LegacyBank_log, FILENAME = '%LOG_PATH%', SIZE = 5MB, MAXSIZE = 50MB, FILEGROWTH = 5MB);"
if %errorlevel% neq 0 (
    echo Error creating database!
    exit /b 1
)
echo Database created successfully!
echo.

REM Apply schema
echo Applying schema...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d LegacyBank -i "%SCHEMA_SCRIPT%"
if %errorlevel% neq 0 (
    echo Error applying schema!
    exit /b 1
)
echo Schema applied successfully!
echo.

REM Apply data
echo Applying sample data...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d LegacyBank -i "%DATA_SCRIPT%"
if %errorlevel% neq 0 (
    echo Error applying data!
    exit /b 1
)
echo Sample data applied successfully!
echo.

REM Verify the database
echo Verifying database...
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d LegacyBank -Q "SELECT (SELECT COUNT(*) FROM Customers) as Customers, (SELECT COUNT(*) FROM Accounts) as Accounts, (SELECT COUNT(*) FROM Transactions) as Transactions, (SELECT COUNT(*) FROM LoanApplications) as Loans, (SELECT COUNT(*) FROM Notifications) as Notifications"
echo.

echo Database setup completed successfully!
echo.
echo Database location: %DATABASE_PATH%
echo Connection string: Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=%DATABASE_PATH%;Integrated Security=True;Connect Timeout=30
echo Or use: Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=LegacyBank;Integrated Security=True;Connect Timeout=30

pause
