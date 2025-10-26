# LegacyBank Database Setup

This directory contains scripts for creating and managing the LegacyBank SQL Server LocalDB database.

## Files

- **schema-sqlserver.sql** - Database schema for SQL Server LocalDB
- **data-sqlserver.sql** - Sample data for the database
- **CreateDatabase.bat** - Batch script to create and initialize the database (recommended)
- **CreateDatabase.ps1** - PowerShell script alternative (requires proper LocalDB configuration)

## Quick Start

### Using Batch Script (Recommended)

1. Open a Command Prompt or PowerShell window
2. Navigate to the Database directory
3. Run the batch script:
   ```
   .\CreateDatabase.bat
   ```

This will:
- Create a new SQL Server LocalDB database named "LegacyBank"
- Apply the schema (tables, indexes)
- Insert sample data
- Display verification statistics

### Manual Setup

If you prefer to set up the database manually:

1. **Create the database:**
   ```cmd
   sqlcmd -S "(LocalDB)\MSSQLLocalDB" -Q "CREATE DATABASE LegacyBank"
   ```

2. **Apply schema:**
   ```cmd
   sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d LegacyBank -i schema-sqlserver.sql
   ```

3. **Insert data:**
   ```cmd
   sqlcmd -S "(LocalDB)\MSSQLLocalDB" -d LegacyBank -i data-sqlserver.sql
   ```

## Database Details

### Connection Strings

The application uses this connection string (configured in Web.config):
```
Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=LegacyBank;Integrated Security=True;Connect Timeout=30
```

### Database Schema

The database includes the following tables:

- **Customers** - Customer information (Id, Name, NationalId, RiskRating)
- **Accounts** - Bank accounts (Id, CustomerId, IBAN, Balance)
- **Transactions** - Transaction history (Id, AccountId, TxDate, Amount, Type)
- **LoanApplications** - Loan applications (Id, CustomerId, Amount, TermMonths, Status, CreatedAt)
- **Notifications** - Customer notifications (Id, CustomerId, Subject, Body, CreatedAt, Status)

### Sample Data

The database is populated with:
- 3 customers (John Smith, Jane Doe, Robert Johnson)
- 5 bank accounts across the customers
- 33 transactions (spanning the last 3-6 months)
- 3 loan applications
- 2 notifications

## Prerequisites

- SQL Server LocalDB (included with Visual Studio 2017+)
- sqlcmd utility (included with SQL Server tools)

## Troubleshooting

### LocalDB not found

If you get an error about LocalDB not being found, you may need to create the instance:

```cmd
sqllocaldb create MSSQLLocalDB
sqllocaldb start MSSQLLocalDB
```

### Check LocalDB instances

To see available LocalDB instances:
```cmd
sqllocaldb info
```

### Connect to the database manually

To explore the database using SQL Server Management Studio or Azure Data Studio:
- Server name: `(LocalDB)\MSSQLLocalDB`
- Database: `LegacyBank`
- Authentication: Windows Authentication

## Migration from SQLite

This project was migrated from SQLite to SQL Server LocalDB. Key changes:

1. **Data Types:**
   - `INTEGER` ? `INT`
   - `TEXT` ? `NVARCHAR`
   - `REAL` ? `DECIMAL(18,2)`
   - `TEXT` (for dates) ? `DATETIME`

2. **SQL Syntax:**
   - `AUTOINCREMENT` ? `IDENTITY(1,1)`
   - `LIMIT` ? `TOP`
   - `strftime()` ? `FORMAT()`, `YEAR()`, `MONTH()`
   - `date()` ? `DATEADD()`, `GETDATE()`

3. **Code Changes:**
   - `System.Data.SQLite` ? `System.Data.SqlClient`
   - `SQLiteConnection` ? `SqlConnection`
   - `SQLiteCommand` ? `SqlCommand`
   - `SQLiteParameter` ? `SqlParameter`
   - `SQLiteDataAdapter` ? `SqlDataAdapter`

## Cleanup

To remove the database:

```cmd
sqlcmd -S "(LocalDB)\MSSQLLocalDB" -Q "DROP DATABASE LegacyBank"
```

Or delete the physical files from `LegacyBank.Web\App_Data\`:
- LegacyBank.mdf
- LegacyBank_log.ldf
