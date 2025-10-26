# LegacyBank Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                         User (Web Browser)                           │
└────────────────────────────────┬────────────────────────────────────┘
                                 │ HTTP
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        IIS Express / IIS                             │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │              LegacyBank.Web (WebForms)                       │   │
│  │                                                               │   │
│  │  ┌──────────────────┐  ┌──────────────────┐                │   │
│  │  │   ASPX Pages     │  │    Services      │                │   │
│  │  │  ┌────────────┐  │  │  ┌────────────┐  │                │   │
│  │  │  │ Loans/     │  │  │  │ ASMX       │  │                │   │
│  │  │  │ Payments/  │  │  │  │ (.asmx)    │  │                │   │
│  │  │  │ Customers/ │  │  │  │            │  │                │   │
│  │  │  │ Accounts/  │  │  │  └────────────┘  │                │   │
│  │  │  │ Statements/│  │  │                   │                │   │
│  │  │  │ Notific./ │  │  │  ┌────────────┐  │                │   │
│  │  │  │ Admin/     │  │  │  │ WCF        │  │                │   │
│  │  │  │ Audit/     │  │  │  │ (.svc)     │  │                │   │
│  │  │  └────────────┘  │  │  └────────────┘  │                │   │
│  │  └──────────────────┘  └──────────────────┘                │   │
│  │           │                      │                           │   │
│  │           │                      │                           │   │
│  │           ▼                      ▼                           │   │
│  │  ┌─────────────────────────────────────────────────────┐   │   │
│  │  │             App_Code (Shared)                        │   │   │
│  │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐          │   │   │
│  │  │  │ Models   │  │   Data   │  │ Logging  │          │   │   │
│  │  │  │ (POCOs)  │  │ (Db.cs)  │  │ (Log.cs) │          │   │   │
│  │  │  └──────────┘  └──────────┘  └──────────┘          │   │   │
│  │  └─────────────────────────────────────────────────────┘   │   │
│  │                           │                                 │   │
│  └───────────────────────────┼─────────────────────────────────┘   │
│                              │                                      │
│  ┌───────────────────────────┼─────────────────────────────────┐   │
│  │                           │                                  │   │
│  │     LegacyBank.BackOffice (WCF Service Library)            │   │
│  │                           │                                  │   │
│  │         ┌─────────────────▼───────────────┐                │   │
│  │         │   IBackOfficeService            │                │   │
│  │         │   BackOfficeService             │                │   │
│  │         │   - PostPayment()               │                │   │
│  │         │   - GetCustomerBalance()        │                │   │
│  │         └─────────────────┬───────────────┘                │   │
│  │                           │                                  │   │
│  └───────────────────────────┼──────────────────────────────────┘   │
└────────────────────────────────┼──────────────────────────────────┘
                                 │ ADO.NET / SQLite
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    SQLite Database (LegacyBank.db)                   │
│                     (App_Data/LegacyBank.db)                         │
│                                                                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐             │
│  │  Customers   │  │   Accounts   │  │ Transactions │             │
│  └──────────────┘  └──────────────┘  └──────────────┘             │
│                                                                       │
│  ┌──────────────┐  ┌──────────────┐                                │
│  │LoanApplications│ │Notifications │                                │
│  └──────────────┘  └──────────────┘                                │
└─────────────────────────────────────────────────────────────────────┘

                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│                 File System (App_Data/logs/)                         │
│                      log4net RollingFile                             │
│                      legacybank.log                                  │
└─────────────────────────────────────────────────────────────────────┘
```

## Component Details

### Presentation Layer (ASPX Pages)

**Loans Module**
- `LoanEligibility.aspx`: Credit check + eligibility calculation
- `LoanApplications.aspx`: CRUD for loan applications

**Payments Module**
- `PaymentPosting.aspx`: Post payments via WCF
- `PaymentHistory.aspx`: View transaction history, export CSV

**Customers Module**
- `CustomerSearch.aspx`: Search with N+1 anti-pattern
- `CustomerDetails.aspx`: View customer details with accounts

**Accounts Module**
- `AccountList.aspx`: List customer accounts
- `AccountTransactions.aspx`: View transactions (SQL injection demo)

**Statements Module**
- `MonthlyStatement.aspx`: Generate and export statements

**Notifications Module**
- `EmailNotifications.aspx`: Send notifications (mock SMTP)

**Admin Module**
- `Config.aspx`: Edit configuration (insecure)

**Audit Module**
- `AuditLogs.aspx`: View and download logs

### Service Layer

**ASMX Web Service** (CreditScoreService.asmx)
- Legacy SOAP 1.1 service
- Synchronous operations
- Used by LoanEligibility page
- Returns deterministic credit scores

**WCF Service** (BackOfficeService.svc)
- BasicHttpBinding
- Returns DataSets (legacy pattern)
- Used by PaymentPosting page
- Direct database access (no transaction scope)

### Data Access Layer

**Db.cs** (Naive ADO.NET Helper)
- `ExecuteScalar()`: Single value queries
- `ExecuteNonQuery()`: INSERT/UPDATE/DELETE
- `ExecuteDataTable()`: SELECT queries
- `ExecuteDataSet()`: Multiple result sets
- `ExecuteReader()`: Streaming results

**Direct SQL**
- Mixed pattern: Some pages use Db helper, others use inline ADO.NET
- No ORM, no Entity Framework
- Raw SQL strings (SQL injection risk in demos)

### Business Logic Layer

**Models (POCOs)**
- Customer.cs
- Account.cs
- Transaction.cs
- LoanApplication.cs
- Notification.cs

*Note: Models are inconsistently used*

### Cross-Cutting Concerns

**Logging** (log4net)
- RollingFileAppender
- Logs to `App_Data/logs/legacybank.log`
- No structured logging
- No correlation IDs

**Caching**
- ASP.NET Cache (in-memory)
- Session State (InProc)
- No distributed cache
- Arbitrary TTLs

**Configuration**
- Web.config (secrets in plain text)
- appSettings for API keys
- connectionStrings for database

## Data Flow Examples

### Loan Eligibility Check

```
User Input (CustomerID)
    │
    ▼
LoanEligibility.aspx
    │
    ├──────────────────────┐
    │                      │
    ▼                      ▼
Check Cache          CreditScoreService.asmx
(Session/Cache)            │
    │                      │
    │                      ▼
    │              Calculate Score
    │              (customerId * 137 % 301 + 500)
    │                      │
    ▼                      │
If cache miss ────────────┘
    │
    ├─────────────┐
    │             │
    ▼             ▼
Inline SQL   Db.ExecuteScalar()
(DTI calc)   (Avg Monthly Inflow)
    │             │
    └──────┬──────┘
           │
           ▼
    Business Rules
    (score >= 650 AND
     inflow >= 1500 AND
     DTI <= 0.35)
           │
           ▼
    Store in Cache
    Store in Session
           │
           ▼
    Display Result
```

### Payment Posting

```
User Input (CustomerID, Amount)
    │
    ▼
PaymentPosting.aspx
    │
    ▼
Create WCF Channel
(BasicHttpBinding)
    │
    ▼
BackOfficeService.PostPayment()
    │
    ├─────────────────┐
    │                 │
    ▼                 ▼
Find Account   Update Balance
(SQL Query)    (No Transaction!)
    │                 │
    └────────┬────────┘
             │
             ▼
    Insert Transaction
             │
             ▼
    Create DataSet
    (Receipt table)
             │
             ▼
    Return DataSet
             │
             ▼
PaymentPosting.aspx
    │
    ▼
Bind DataSet to GridView
    │
    ▼
Display Receipt
```

### Customer Search (N+1 Pattern)

```
User Input (Search Term)
    │
    ▼
CustomerSearch.aspx
    │
    ▼
Load ALL Customers
(SELECT * FROM Customers)
    │
    ▼
Store in DataTable
    │
    ▼
Filter in Memory
(DataTable.Select())
    │
    ▼
For Each Customer ────┐
    │                 │
    │                 ▼
    │         Get Latest Balance
    │         (Separate SQL Query)
    │                 │
    │                 │
    └─────────┬───────┘
              │
              ▼
    Bind to GridView
              │
              ▼
      Display Results

N+1 Issue: 1 query for customers + N queries for balances
```

## Legacy Patterns Present

### Data Access Smells
- ✗ Inline SQL everywhere
- ✗ String concatenation (SQL injection)
- ✗ Mixed patterns (inconsistent)
- ✗ No ORM
- ✗ No repository pattern
- ✗ N+1 queries
- ✗ No query caching
- ✗ No connection pooling management

### Architecture Smells
- ✗ No layering/separation of concerns
- ✗ Business logic in code-behind
- ✗ Synchronous operations only
- ✗ No dependency injection
- ✗ Tight coupling
- ✗ DataSets instead of DTOs
- ✗ SOAP/WCF (legacy protocols)

### Performance Smells
- ✗ Load all data to memory
- ✗ Blocking I/O on UI thread
- ✗ No pagination
- ✗ Cache misuse
- ✗ Session abuse
- ✗ ViewState bloat

### Security Smells
- ✗ Secrets in web.config
- ✗ No authentication
- ✗ No authorization
- ✗ SQL injection risks
- ✗ No input validation
- ✗ No CSRF protection
- ✗ Connection strings exposed

### Operational Smells
- ✗ File-based logging
- ✗ No structured logs
- ✗ No distributed tracing
- ✗ No health checks
- ✗ No metrics
- ✗ No monitoring hooks

## Modernization Strategy

### Phase 1: Observability
- Add OpenTelemetry
- Implement structured logging
- Add health checks
- Add metrics

### Phase 2: Security
- Move secrets to Azure Key Vault
- Add authentication (Azure AD)
- Add authorization
- Fix SQL injection risks

### Phase 3: Data Access
- Introduce EF Core
- Implement repository pattern
- Add proper transaction management
- Eliminate N+1 queries

### Phase 4: Architecture
- Extract microservices (strangler pattern)
- Migrate to .NET 8
- Implement async/await
- Add API gateway

### Phase 5: Modern Protocols
- Replace ASMX with REST APIs
- Replace WCF with gRPC
- Implement GraphQL for queries
- Add message queue for async ops

## Microservices Target State

```
┌────────────────────┐
│   API Gateway      │
│   (YARP/Ocelot)    │
└──────────┬─────────┘
           │
    ┌──────┴──────┬──────────┬──────────┬──────────┐
    │             │          │          │          │
    ▼             ▼          ▼          ▼          ▼
┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐
│ Loan   │  │Payment │  │Customer│  │Account │  │Statement│
│Service │  │Service │  │Service │  │Service │  │Service  │
└────────┘  └────────┘  └────────┘  └────────┘  └────────┘
    │             │          │          │          │
    └──────┬──────┴──────────┴──────────┴──────────┘
           │
           ▼
    ┌────────────┐
    │  Event Bus │
    │  (RabbitMQ)│
    └────────────┘
```

Each service would have:
- REST API (ASP.NET Core)
- Own database (database per service)
- Event publishing/subscribing
- OpenTelemetry instrumentation
- Health checks
- Proper authentication/authorization
