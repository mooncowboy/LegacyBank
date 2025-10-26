# Create LegacyBank SQL Server LocalDB Database
# This script creates the database and applies schema and data

Write-Host "Creating LegacyBank LocalDB Database..." -ForegroundColor Green

# Define paths
$scriptPath = Split-Path -Parent $PSCommandPath
$rootPath = Split-Path -Parent $scriptPath
$appDataPath = Join-Path $rootPath "LegacyBank.Web\App_Data"
$databasePath = Join-Path $appDataPath "LegacyBank.mdf"
$logPath = Join-Path $appDataPath "LegacyBank_log.ldf"
$schemaScript = Join-Path $scriptPath "schema-sqlserver.sql"
$dataScript = Join-Path $scriptPath "data-sqlserver.sql"

# Ensure App_Data directory exists
if (-not (Test-Path $appDataPath)) {
    Write-Host "Creating App_Data directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $appDataPath -Force | Out-Null
}

# Remove existing database files if they exist
if (Test-Path $databasePath) {
    Write-Host "Removing existing database file..." -ForegroundColor Yellow
    Remove-Item $databasePath -Force
}
if (Test-Path $logPath) {
    Remove-Item $logPath -Force
}

# Connection strings
$masterConnectionString = "Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=master;Integrated Security=True;Connect Timeout=30"
$databaseConnectionString = "Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=$databasePath;Integrated Security=True;Connect Timeout=30"

try {
    # Load System.Data assembly
    Add-Type -AssemblyName "System.Data"

    # Create the database
    Write-Host "Creating database at: $databasePath" -ForegroundColor Cyan
    
    $createDbSql = @"
CREATE DATABASE LegacyBank
ON PRIMARY (
    NAME = LegacyBank,
    FILENAME = '$databasePath',
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
LOG ON (
    NAME = LegacyBank_log,
    FILENAME = '$logPath',
    SIZE = 5MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB
);
"@

    $masterConnection = New-Object System.Data.SqlClient.SqlConnection($masterConnectionString)
    $masterConnection.Open()
    
    $createDbCommand = New-Object System.Data.SqlClient.SqlCommand($createDbSql, $masterConnection)
    $createDbCommand.ExecuteNonQuery() | Out-Null
    
    $masterConnection.Close()
    $masterConnection.Dispose()
    
    Write-Host "Database created successfully!" -ForegroundColor Green

    # Apply schema
    Write-Host "`nApplying schema..." -ForegroundColor Cyan
    
    if (Test-Path $schemaScript) {
        $schemaSql = Get-Content $schemaScript -Raw
        
        $schemaConnection = New-Object System.Data.SqlClient.SqlConnection($databaseConnectionString)
        $schemaConnection.Open()
        
        # Split by GO statements and execute each batch
        $batches = $schemaSql -split '\r?\nGO\r?\n'
        
        foreach ($batch in $batches) {
            if ($batch.Trim() -ne "") {
                $schemaCommand = New-Object System.Data.SqlClient.SqlCommand($batch, $schemaConnection)
                $schemaCommand.ExecuteNonQuery() | Out-Null
            }
        }
        
        $schemaConnection.Close()
        $schemaConnection.Dispose()
        
        Write-Host "Schema applied successfully!" -ForegroundColor Green
    } else {
        Write-Host "Schema script not found at: $schemaScript" -ForegroundColor Red
        exit 1
    }

    # Apply data
    Write-Host "`nApplying sample data..." -ForegroundColor Cyan
    
    if (Test-Path $dataScript) {
        $dataSql = Get-Content $dataScript -Raw
        
        $dataConnection = New-Object System.Data.SqlClient.SqlConnection($databaseConnectionString)
        $dataConnection.Open()
        
        # Split by GO statements and execute each batch
        $batches = $dataSql -split '\r?\nGO\r?\n'
        
        foreach ($batch in $batches) {
            if ($batch.Trim() -ne "") {
                $dataCommand = New-Object System.Data.SqlClient.SqlCommand($batch, $dataConnection)
                $dataCommand.ExecuteNonQuery() | Out-Null
            }
        }
        
        $dataConnection.Close()
        $dataConnection.Dispose()
        
        Write-Host "Sample data applied successfully!" -ForegroundColor Green
    } else {
        Write-Host "Data script not found at: $dataScript" -ForegroundColor Red
        exit 1
    }

    # Verify the database
    Write-Host "`nVerifying database..." -ForegroundColor Cyan
    
    $verifyConnection = New-Object System.Data.SqlClient.SqlConnection($databaseConnectionString)
    $verifyConnection.Open()
    
    $verifySql = @"
SELECT 
    (SELECT COUNT(*) FROM Customers) as CustomerCount,
    (SELECT COUNT(*) FROM Accounts) as AccountCount,
    (SELECT COUNT(*) FROM Transactions) as TransactionCount,
    (SELECT COUNT(*) FROM LoanApplications) as LoanCount,
    (SELECT COUNT(*) FROM Notifications) as NotificationCount
"@
    
    $verifyCommand = New-Object System.Data.SqlClient.SqlCommand($verifySql, $verifyConnection)
    $reader = $verifyCommand.ExecuteReader()
    
    if ($reader.Read()) {
        Write-Host "`nDatabase Statistics:" -ForegroundColor Yellow
        Write-Host "  Customers: $($reader['CustomerCount'])" -ForegroundColor White
        Write-Host "  Accounts: $($reader['AccountCount'])" -ForegroundColor White
        Write-Host "  Transactions: $($reader['TransactionCount'])" -ForegroundColor White
        Write-Host "  Loan Applications: $($reader['LoanCount'])" -ForegroundColor White
        Write-Host "  Notifications: $($reader['NotificationCount'])" -ForegroundColor White
    }
    
    $reader.Close()
    $verifyConnection.Close()
    $verifyConnection.Dispose()

    Write-Host "`n? Database setup completed successfully!" -ForegroundColor Green
    Write-Host "`nDatabase location: $databasePath" -ForegroundColor Cyan
    Write-Host "Connection string: Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|LegacyBank.mdf;Integrated Security=True;Connect Timeout=30" -ForegroundColor Gray

} catch {
    Write-Host "`n? Error creating database:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host $_.Exception.StackTrace -ForegroundColor DarkGray
    exit 1
}
