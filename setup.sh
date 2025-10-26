#!/bin/bash
# LegacyBank Setup Script for Linux/Mac
# Run this script to initialize the database and verify the setup

echo "========================================"
echo "LegacyBank Setup Script"
echo "========================================"
echo ""

# Check if SQLite is available
if ! command -v sqlite3 &> /dev/null; then
    echo "WARNING: sqlite3 not found"
    echo "Please install SQLite3:"
    echo "  Ubuntu/Debian: sudo apt-get install sqlite3"
    echo "  macOS: brew install sqlite3"
    echo "Or the database should already be initialized in LegacyBank.Web/App_Data/"
    echo ""
else
    echo "SQLite found - checking database..."
    if [ -f "LegacyBank.Web/App_Data/LegacyBank.db" ]; then
        echo "Database already exists at LegacyBank.Web/App_Data/LegacyBank.db"
    else
        echo "Creating new database..."
        mkdir -p LegacyBank.Web/App_Data
        sqlite3 LegacyBank.Web/App_Data/LegacyBank.db < Database/schema.sql
        sqlite3 LegacyBank.Web/App_Data/LegacyBank.db < Database/data.sql
        echo "Database created successfully!"
    fi
fi

echo ""
echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Open LegacyBank.sln in Visual Studio 2022"
echo "2. Restore NuGet packages (should happen automatically)"
echo "3. Build the solution"
echo "4. Set LegacyBank.Web as startup project"
echo "5. Press F5 to run with IIS Express"
echo ""
echo "The application should open at http://localhost:8080/"
echo ""
