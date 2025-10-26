# ?? Quick Start Guide - LegacyBank Application

## Before You Start - EVERY TIME

### Step 1: Start LocalDB (REQUIRED!)

**Run this command FIRST:**
```cmd
StartLocalDB.bat
```

Or manually:
```cmd
sqllocaldb start MSSQLLocalDB
```

### Step 2: Verify LocalDB is Running
```cmd
sqllocaldb info MSSQLLocalDB
```

You should see: **State: Running**

---

## First Time Setup (One-Time Only)

### 1. Enable 64-bit IIS Express
1. Open Visual Studio
2. Go to: **Tools ? Options ? Projects and Solutions ? Web Projects**
3. **CHECK**: "Use the 64 bit version of IIS Express for web sites and projects"
4. Click **OK**
5. Restart Visual Studio

### 2. Verify Platform Configuration
The projects have been configured to use **x64** platform. No changes needed unless you see errors.

---

## Daily Development Workflow

### Every Day Before Coding:

1. **Start LocalDB** (it stops automatically overnight):
   ```cmd
   StartLocalDB.bat
   ```

2. **Open Visual Studio**

3. **Open the LegacyBank solution**

4. **Build the solution** (Ctrl+Shift+B)

5. **Run the application** (F5)

---

## Alternative: Keep LocalDB Running

If you don't want to manually start LocalDB every time:

### Option 1: Auto-start on Windows Boot
1. Press `Win + R`
2. Type: `shell:startup`
3. Press Enter
4. Create a shortcut to `StartLocalDB.bat` in that folder

### Option 2: Keep-Alive Script (While Developing)
Open a PowerShell window and run:
```powershell
.\KeepLocalDBAlive.ps1
```

Leave this window open while developing. LocalDB will stay running.

### Option 3: Use SQL Server Express (Always Running)
See `TROUBLESHOOTING.md` for instructions on switching to SQL Server Express.

---

## Common Scenarios

### Scenario 1: "Cannot connect to database" Error

**Cause:** LocalDB is stopped

**Solution:**
```cmd
sqllocaldb start MSSQLLocalDB
```

### Scenario 2: "Win32 application" Error

**Cause:** IIS Express is not running in 64-bit mode

**Solution:**
1. Close Visual Studio
2. Reopen Visual Studio
3. Tools ? Options ? Projects and Solutions ? Web Projects
4. Check "Use the 64 bit version of IIS Express"
5. Restart Visual Studio

### Scenario 3: "Database does not exist" Error

**Cause:** Database hasn't been created yet

**Solution:**
```cmd
cd Database
CreateDatabase.bat
```

---

## Application URLs

Once running, the application will be available at:
- **Main Application:** http://localhost:8080/
- **Loan Applications:** http://localhost:8080/Pages/Loans/LoanApplications.aspx
- **Customer Search:** http://localhost:8080/Pages/Customers/CustomerSearch.aspx
- **Account Transactions:** http://localhost:8080/Pages/Accounts/AccountTransactions.aspx

---

## Quick Reference Commands

```cmd
# Start LocalDB
sqllocaldb start MSSQLLocalDB

# Check if running
sqllocaldb info MSSQLLocalDB

# Stop LocalDB (if needed)
sqllocaldb stop MSSQLLocalDB

# Restart LocalDB
sqllocaldb stop MSSQLLocalDB
sqllocaldb start MSSQLLocalDB

# Test database connection
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d LegacyBank -Q "SELECT COUNT(*) FROM Customers"

# Reset database (WARNING: Deletes all data!)
cd Database
ResetDatabase.bat
```

---

## Files You Need to Know About

| File | Purpose | When to Use |
|------|---------|-------------|
| `StartLocalDB.bat` | Start LocalDB | **Every time before coding** |
| `KeepLocalDBAlive.ps1` | Keep LocalDB running | Optional - run once and leave open |
| `Database\CreateDatabase.bat` | Create/recreate database | First time or after reset |
| `Database\ResetDatabase.bat` | Delete and recreate database | When you want fresh data |
| `TROUBLESHOOTING.md` | Detailed troubleshooting | When something goes wrong |

---

## Development Tips

### Tip 1: Create a Development Startup Script
Create a batch file called `StartDev.bat`:
```cmd
@echo off
echo Starting development environment...
call StartLocalDB.bat
echo Opening Visual Studio...
start "" "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe" LegacyBank.sln
```

### Tip 2: Add LocalDB Status to PowerShell Prompt
Add this to your PowerShell profile:
```powershell
function prompt {
    $localDbStatus = (sqllocaldb info MSSQLLocalDB | Select-String "State").ToString().Split(':')[1].Trim()
    Write-Host "LocalDB: " -NoNewline
    if ($localDbStatus -eq "Running") {
        Write-Host "?" -ForegroundColor Green -NoNewline
    } else {
        Write-Host "?" -ForegroundColor Red -NoNewline
    }
    Write-Host " | " -NoNewline
    "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
}
```

### Tip 3: Visual Studio Task
Create a Visual Studio task to start LocalDB automatically:
1. In Solution Explorer, right-click solution
2. Configure Startup Projects
3. Add pre-launch command: `sqllocaldb start MSSQLLocalDB`

---

## Need Help?

1. **LocalDB won't start:** See `TROUBLESHOOTING.md` ? "Common Issues and Fixes"
2. **Connection errors:** Make sure LocalDB is running: `sqllocaldb info MSSQLLocalDB`
3. **Platform errors:** See `TROUBLESHOOTING.md` ? "Win32 application Error"
4. **Database errors:** Try resetting: `Database\ResetDatabase.bat`

---

## Summary Checklist

Before running the application, ensure:
- [ ] LocalDB is running (`sqllocaldb info MSSQLLocalDB` shows "Running")
- [ ] Database exists (if not, run `Database\CreateDatabase.bat`)
- [ ] Visual Studio is configured for 64-bit IIS Express
- [ ] Solution builds successfully (Ctrl+Shift+B)

If all checkboxes are checked, press F5 and enjoy coding! ??
