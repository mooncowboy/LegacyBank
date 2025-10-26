@echo off
echo Enabling 64-bit mode for IIS Express...

REM This script modifies the applicationhost.config to enable 64-bit mode

set CONFIG_PATH=%USERPROFILE%\Documents\IISExpress\config\applicationhost.config

if not exist "%CONFIG_PATH%" (
    echo IIS Express config not found. Creating default...
    mkdir "%USERPROFILE%\Documents\IISExpress\config" 2>nul
)

echo.
echo Please follow these steps:
echo.
echo 1. Close Visual Studio
echo 2. Open Visual Studio as Administrator
echo 3. Go to Tools ^> Options ^> Projects and Solutions ^> Web Projects
echo 4. Check "Use the 64 bit version of IIS Express for web sites and projects"
echo 5. Restart Visual Studio
echo 6. Rebuild and run the project
echo.
echo Alternatively, you can:
echo 1. In Solution Explorer, right-click the web project
echo 2. Select Properties
echo 3. Go to the Build tab
echo 4. Set Platform target to "x64"
echo 5. Save and rebuild
echo.

pause
