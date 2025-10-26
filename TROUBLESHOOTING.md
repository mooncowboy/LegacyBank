# Troubleshooting Guide - SQL Server LocalDB Connection Issues

## Issue: "%1 is not a valid Win32 application" Error

This error occurs when there's a platform mismatch between the web application and SQL Server LocalDB.

### Root Cause
- The web application was configured to run as ARM64
- SQL Server LocalDB requires x64 architecture
- IIS Express may be running in 32-bit mode

### Solution Applied

? **Project files have been updated** to use x64 platform target instead of ARM64.

## ?? IMPORTANT: LocalDB Must Be Running

**LocalDB automatically stops when idle.** Before running your application, you MUST start LocalDB:

### Quick Start (Recommended)
Run the startup script before launching Visual Studio:
```cmd
StartLocalDB.bat
```

### Manual Start
```cmd
sqllocaldb start MSSQLLocalDB
```

### Check if Running
```cmd
sqllocaldb info MSSQLLocalDB
```
Look for: **State: Running**

## Steps to Fix in Visual Studio

### 1. Enable 64-bit IIS Express (IMPORTANT!)

1. Open Visual Studio
2. Go to: **Tools ? Options ? Projects and Solutions ? Web Projects**
3. **CHECK** the option: **"Use the 64 bit version of IIS Express for web sites and projects"**
4. Click **OK**

### 2. Verify Platform Configuration

1. In Solution Explorer, right-click **LegacyBank.Web** project
2. Select **Properties**
3. Go to the **Build** tab
4. Verify **Platform target** is set to **x64** (not ARM64 or AnyCPU)
5. Save changes

### 3. Clean and Rebuild

1. In Visual Studio menu: **Build ? Clean Solution**
2. Then: **Build ? Rebuild Solution**
3. Verify build succeeds

### 4. Start LocalDB (REQUIRED EVERY TIME)

Before running the application, ensure LocalDB is started:

**Option A - Use the batch file:**
```cmd
StartLocalDB.bat
```

**Option B - Manual command:**
```cmd
sqllocaldb start MSSQLLocalDB
```

### 5. Run the Application

Press **F5** to run the application with debugging.

## Verification Steps

### Check LocalDB Status

```cmd
sqllocaldb info MSSQLLocalDB
```

Should show: **State: Running**

### Test Database Connection

```cmd
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d LegacyBank -Q "SELECT COUNT(*) FROM Customers"
```

Should return: **3**

### Check IIS Express Process

When the app is running, open Task Manager and look for `iisexpress.exe`. Verify it's running as 64-bit:
- Right-click on the process
- If you see **"32-bit"** in the name, IIS Express is running in 32-bit mode (bad)
- If no **"32-bit"**, it's running in 64-bit mode (good)

## Why LocalDB Keeps Stopping

LocalDB is designed to **automatically stop** after a period of inactivity (typically 5-10 minutes with no connections). This is normal behavior to conserve resources.

### Solutions for Auto-Stopping:

#### Option 1: Use the Startup Script (Easiest)
Just run `StartLocalDB.bat` before opening Visual Studio each time.

#### Option 2: Add to Windows Startup (Automatic)
1. Press `Win + R`, type `shell:startup`, press Enter
2. Create a shortcut to `StartLocalDB.bat` in that folder
3. LocalDB will start automatically when Windows starts

#### Option 3: Use SQL Server Express Instead (Always Running)
If you prefer a database that stays running, see "Alternative Solutions" below.

#### Option 4: Keep a Connection Open
Create a simple PowerShell script to keep a connection alive:

```powershell
# KeepLocalDBAlive.ps1
while ($true) {
    sqlcmd -S "(LocalDB)\MSSQLLocalDB" -Q "SELECT 1" -o nul 2>&1
    Start-Sleep -Seconds 300  # Check every 5 minutes
}
```

Run in a separate PowerShell window while developing.

## Alternative Solutions

### Option A: Use SQL Server Express Instead

If LocalDB continues to cause issues, you can use SQL Server Express:

1. Start SQL Server Express:
   ```cmd
   net start MSSQLSERVER
   ```

2. Update connection string in `Web.config`:
   ```xml
   <add name="LegacyBankDb" 
        connectionString="Data Source=localhost;Initial Catalog=LegacyBank;Integrated Security=True" 
        providerName="System.Data.SqlClient" />
   ```

3. Create the database on SQL Server Express:
   ```cmd
   sqlcmd -S localhost -Q "CREATE DATABASE LegacyBank"
   sqlcmd -S localhost -d LegacyBank -i "Database\schema-sqlserver.sql"
   sqlcmd -S localhost -d LegacyBank -i "Database\data-sqlserver.sql"
   ```

### Option B: Use Docker SQL Server

For a clean environment, use SQL Server in Docker:

```cmd
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong@Passw0rd" ^
   -p 1433:1433 --name sqlserver -d ^
   mcr.microsoft.com/mssql/server:2019-latest
```

Connection string:
```xml
<add name="LegacyBankDb" 
     connectionString="Data Source=localhost,1433;Initial Catalog=LegacyBank;User ID=sa;Password=YourStrong@Passw0rd" 
     providerName="System.Data.SqlClient" />
```

## Common Issues and Fixes

### Issue: LocalDB is Stopped

**Solution:** This is NORMAL! LocalDB stops automatically. Just start it:
```cmd
sqllocaldb start MSSQLLocalDB
```
Or run: `StartLocalDB.bat`

### Issue: LocalDB not found

**Solution:**
```cmd
sqllocaldb create MSSQLLocalDB
sqllocaldb start MSSQLLocalDB
```

### Issue: Database doesn't exist

**Solution:**
```cmd
cd Database
CreateDatabase.bat
```

### Issue: Access denied

**Solution:** Run Visual Studio as Administrator

### Issue: Port conflict (8080 already in use)

**Solution:**
1. In Solution Explorer, right-click the web project
2. Select **Properties**
3. Go to **Web** tab
4. Change the **Project Url** port number
5. Click **Create Virtual Directory**

## Project Configuration Summary

### Current Settings

| Project | Platform Target | IIS Express |
|---------|----------------|-------------|
| LegacyBank.Web | **x64** | **64-bit mode** |
| LegacyBank.BackOffice | **x64** | N/A |

### Connection String

```
Data Source=(LocalDB)\MSSQLLocalDB;
Initial Catalog=LegacyBank;
Integrated Security=True;
Connect Timeout=30
```

## Testing the Fix

After applying the fixes above:

1. **Start LocalDB:**
   ```cmd
   StartLocalDB.bat
   ```
   Or manually:
   ```cmd
   sqllocaldb start MSSQLLocalDB
   ```

2. **Verify it's running:**
   ```cmd
   sqllocaldb info MSSQLLocalDB
   ```
   Should show: **State: Running**

3. **Stop any running instances** of the application

4. **Close Visual Studio**

5. **Reopen Visual Studio**

6. **Ensure 64-bit IIS Express is enabled** (see step 1 above)

7. **Open the solution**

8. **Press F5** to run

You should now see the application running without the Win32 error!

## Quick Reference: Common Commands

```cmd
# Start LocalDB
sqllocaldb start MSSQLLocalDB

# Stop LocalDB
sqllocaldb stop MSSQLLocalDB

# Check status
sqllocaldb info MSSQLLocalDB

# Restart LocalDB
sqllocaldb stop MSSQLLocalDB
sqllocaldb start MSSQLLocalDB

# List all instances
sqllocaldb info

# Test database connection
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d LegacyBank -Q "SELECT COUNT(*) FROM Customers"
```

## Still Having Issues?

If you continue to experience problems:

1. Check the Output window in Visual Studio for detailed error messages
2. Check Event Viewer (Windows Logs ? Application) for SQL Server errors
3. Verify your system has:
   - .NET Framework 4.8 installed
   - SQL Server LocalDB installed (comes with Visual Studio)
   - Visual Studio 2019 or later

## Files Modified

- `LegacyBank.Web\LegacyBank.Web.csproj` - Platform target changed from ARM64 to x64
- `LegacyBank.BackOffice\LegacyBank.BackOffice.csproj` - Platform target changed from ARM64 to x64

## Files Created

- `StartLocalDB.bat` - Quick script to start LocalDB
- `Database\CreateDatabase.bat` - Script to create and populate the database
- `Database\ResetDatabase.bat` - Script to reset the database

## Additional Resources

- [SQL Server LocalDB Documentation](https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/sql-server-express-localdb)
- [IIS Express 64-bit Support](https://docs.microsoft.com/en-us/iis/extensions/introduction-to-iis-express/iis-express-overview)
- [.NET Framework Data Providers](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers)
