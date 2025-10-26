# LegacyBank

A legacy .NET Framework 4.8 WebForms application demonstrating intentional legacy patterns for modernization and microservices carve-out demonstrations.

## Overview

LegacyBank is a small Financial Services Institution (FSI) web application built with legacy technologies and patterns, including:
- ASP.NET WebForms with ViewState-heavy server controls
- Mixed data access patterns (inline ADO.NET SQL + naive DB helper)
- ASMX SOAP web services
- WCF services returning DataSets
- SQLite database
- InProc Session and ASP.NET Cache
- log4net file logging
- Secrets in web.config

## Prerequisites

- Visual Studio 2022 or later (Community Edition works)
- .NET Framework 4.8 Developer Pack
- SQLite (included via NuGet)

## Setup Instructions

### 1. Clone and Restore

```bash
git clone https://github.com/mooncowboy/LegacyBank.git
cd LegacyBank
```

Open `LegacyBank.sln` in Visual Studio and restore NuGet packages (should happen automatically).

### 2. Initialize Database

The application uses SQLite for the database. The database file will be created in `LegacyBank.Web/App_Data/`.

Execute the following scripts to set up the database:

```bash
# From the repository root
cd Database
sqlite3 ../LegacyBank.Web/App_Data/LegacyBank.db < schema.sql
sqlite3 ../LegacyBank.Web/App_Data/LegacyBank.db < data.sql
```

Or manually:
1. Open SQLite command line
2. Create database at `LegacyBank.Web/App_Data/LegacyBank.db`
3. Execute `Database/schema.sql`
4. Execute `Database/data.sql`

### 3. Verify Configuration

Check `LegacyBank.Web/Web.config`:
- Connection string points to `App_Data/LegacyBank.db`
- AppSettings contains:
  - `creditScoreApiKey`: API key for credit score service
  - SMTP settings (for notifications)

### 4. Run the Application

1. Set `LegacyBank.Web` as the startup project
2. Press F5 to run with IIS Express
3. The application should open at `http://localhost:8080/`

## Key Pages to Browse

### Loans
- `/Pages/Loans/LoanEligibility.aspx` - Check loan eligibility (uses ASMX service, caching)
- `/Pages/Loans/LoanApplications.aspx` - Submit and manage loan applications

### Payments
- `/Pages/Payments/PaymentPosting.aspx` - Post payments via WCF service
- `/Pages/Payments/PaymentHistory.aspx` - View payment history (with CSV export)

### Customers
- `/Pages/Customers/CustomerSearch.aspx` - Search customers (N+1 anti-pattern)
- `/Pages/Customers/CustomerDetails.aspx?id=1` - View customer details

### Accounts
- `/Pages/Accounts/AccountList.aspx?customerId=1` - List customer accounts
- `/Pages/Accounts/AccountTransactions.aspx?accountId=1` - View transactions

### Statements
- `/Pages/Statements/MonthlyStatement.aspx?accountId=1&year=2025&month=10` - Generate monthly statement

### Notifications
- `/Pages/Notifications/EmailNotifications.aspx` - Send email notifications

### Admin
- `/Pages/Admin/Config.aspx` - Edit configuration (insecure, demo only)

### Audit
- `/Pages/Audit/AuditLogs.aspx` - View application logs

## Legacy Smells (Intentional)

This application intentionally includes the following legacy patterns for demonstration purposes:

### Data Access
- **Inline SQL**: SQL queries embedded directly in code-behind files
- **Mixed patterns**: Some pages use inline ADO.NET, others use the Db helper
- **No ORM**: Raw SQL and DataTables everywhere
- **N+1 queries**: CustomerSearch loads all customers then queries balance for each
- **SQL injection risk**: AccountTransactions uses string concatenation (demo only)

### Architecture
- **Synchronous SOAP calls**: LoanEligibility blocks UI thread calling ASMX service
- **WCF DataSets**: BackOffice service returns DataSet objects
- **No async/await**: All operations are synchronous
- **No dependency injection**: Direct instantiation everywhere

### Caching & State
- **Session abuse**: Storing business data in InProc session
- **Cache misuse**: Using ASP.NET Cache for short-lived eligibility results
- **ViewState heavy**: WebForms server controls with full ViewState

### Security
- **Secrets in config**: API keys and passwords in web.config
- **No encryption**: Connection strings in plain text
- **Insecure admin page**: Config.aspx allows editing settings via web UI

### Performance
- **Blocking I/O**: CSV export blocks UI thread
- **In-memory operations**: Loading all data then filtering in memory
- **No pagination**: All results loaded at once

### Logging
- **File-based logs**: log4net writing to text files
- **No structured logging**: Plain text log entries
- **No distributed tracing**: No correlation IDs across services

## Microservice Carve-Out Candidates

The application is organized to demonstrate potential microservice boundaries:

1. **LoanService** - Eligibility checking and application management
2. **PaymentService** - Payment processing and history
3. **CustomerService** - Customer search and details
4. **AccountService** - Account and transaction management
5. **StatementService** - Statement generation
6. **NotificationService** - Email and notification management
7. **ConfigService** - Centralized configuration
8. **AuditService** - Centralized logging and auditing

## Project Structure

```
LegacyBank/
├── LegacyBank.sln
├── LegacyBank.Web/
│   ├── App_Code/
│   │   ├── Data/Db.cs              # ADO.NET helper
│   │   ├── Logging/Log.cs          # log4net wrapper
│   │   └── Models/                 # POCOs
│   ├── App_Data/
│   │   ├── logs/                   # log4net output
│   │   └── LegacyBank.db           # SQLite database
│   ├── Pages/                      # WebForms pages by feature
│   │   ├── Accounts/
│   │   ├── Admin/
│   │   ├── Audit/
│   │   ├── Customers/
│   │   ├── Loans/
│   │   ├── Notifications/
│   │   ├── Payments/
│   │   └── Statements/
│   ├── Services/
│   │   ├── CreditScoreService.asmx # SOAP service
│   │   └── BackOfficeService.svc   # WCF service
│   ├── Global.asax
│   └── Web.config
├── LegacyBank.BackOffice/          # WCF service library
│   ├── IBackOfficeService.cs
│   └── BackOfficeService.cs
└── Database/
    ├── schema.sql                  # Database schema
    └── data.sql                    # Sample data
```

## Demo Scenarios

### 1. Loan Eligibility Check
1. Navigate to `/Pages/Loans/LoanEligibility.aspx`
2. Enter Customer ID: `1`
3. Click "Check Eligibility"
4. Observe: Synchronous ASMX call, mixed data access, Session/Cache usage

### 2. Payment Posting
1. Navigate to `/Pages/Payments/PaymentPosting.aspx`
2. Enter Customer ID: `1`, Amount: `100.00`
3. Click "Post Payment"
4. Observe: Synchronous WCF call returning DataSet

### 3. Customer Search with N+1
1. Navigate to `/Pages/Customers/CustomerSearch.aspx`
2. Page loads all customers
3. For each customer, separate query for balance
4. Observe: N+1 anti-pattern in action

### 4. SQL Injection Risk (Demo Only)
1. Navigate to `/Pages/Accounts/AccountTransactions.aspx?accountId=1`
2. Note: String concatenation in SQL query (intentional for demo)
3. Do not use in production!

## Known Issues (By Design)

- No authentication/authorization
- No input validation on many pages
- No CSRF protection
- Secrets in plain text
- Blocking synchronous operations
- In-memory data operations
- No error boundaries
- File-based logging

## Modernization Path

This application is designed to demonstrate:
- Strangler fig pattern for gradual modernization
- Extracting microservices from a monolith
- Migration to .NET 8+ and modern patterns
- Implementing proper security (secrets management, auth)
- Adding OpenTelemetry for observability
- Migrating to async/await patterns
- Implementing proper data access with EF Core
- Adding API gateway patterns

## License

This is a demonstration project. Use at your own risk. Not intended for production use.

## Notes

- Target framework is .NET Framework 4.8 (not 4.0 as originally specified, due to tooling availability)
- All legacy patterns are intentional for demonstration purposes
- The application is fully functional and can run in Visual Studio with IIS Express
- SQLite is used instead of SQL Server LocalDB for simplicity