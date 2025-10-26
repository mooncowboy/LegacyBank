# LegacyBank Quick Reference

## Sample Data

### Customers
| ID | Name | National ID | Risk Rating |
|----|------|-------------|-------------|
| 1 | John Smith | NID-12345678 | 650 |
| 2 | Jane Doe | NID-87654321 | 720 |
| 3 | Robert Johnson | NID-11223344 | 580 |

### Accounts
| ID | Customer ID | IBAN | Balance |
|----|-------------|------|---------|
| 1 | 1 | GB29NWBK60161331926819 | $5,500.00 |
| 2 | 1 | GB82WEST12345698765432 | $12,000.00 |
| 3 | 2 | GB33BUKB20201555555555 | $25,000.00 |
| 4 | 2 | GB94BARC10201530093459 | $8,500.00 |
| 5 | 3 | GB60NAIA07011610909132 | $1,200.00 |

### Loan Applications
| ID | Customer ID | Amount | Term | Status | Created |
|----|-------------|--------|------|--------|---------|
| 1 | 1 | $15,000 | 36 mo | Pending | 2025-10-15 |
| 2 | 2 | $50,000 | 60 mo | Approved | 2025-09-20 |
| 3 | 3 | $5,000 | 12 mo | Rejected | 2025-10-01 |

## Configuration

### AppSettings (Web.config)
- `creditScoreApiKey`: `legacy-credit-api-key-12345`
- `smtpHost`: `smtp.legacybank.local`
- `smtpPort`: `25`
- `smtpUsername`: `noreply@legacybank.local`
- `smtpPassword`: `P@ssw0rd123` (insecure - intentional)

### Connection String
```
Data Source=|DataDirectory|LegacyBank.db;Version=3;
```

## Services

### ASMX Service (CreditScoreService)
- **Endpoint**: `/Services/CreditScoreService.asmx`
- **Method**: `GetScore(int customerId, string apiKey)`
- **Returns**: int (credit score 500-800)
- **Algorithm**: Deterministic based on customerId

### WCF Service (BackOfficeService)
- **Endpoint**: `/Services/BackOfficeService.svc`
- **Binding**: BasicHttpBinding
- **Methods**:
  - `PostPayment(int customerId, decimal amount, string currency, string reference)` → DataSet
  - `GetCustomerBalance(int customerId)` → DataSet

## URL Patterns

### Pages
```
/Pages/Loans/LoanEligibility.aspx
/Pages/Loans/LoanApplications.aspx
/Pages/Payments/PaymentPosting.aspx
/Pages/Payments/PaymentHistory.aspx
/Pages/Customers/CustomerSearch.aspx
/Pages/Customers/CustomerDetails.aspx?id={customerId}
/Pages/Accounts/AccountList.aspx?customerId={customerId}
/Pages/Accounts/AccountTransactions.aspx?accountId={accountId}
/Pages/Statements/MonthlyStatement.aspx?accountId={accountId}&year={year}&month={month}
/Pages/Notifications/EmailNotifications.aspx
/Pages/Admin/Config.aspx
/Pages/Audit/AuditLogs.aspx
```

## Business Rules

### Loan Eligibility
A customer is eligible for a loan if:
- Credit score ≥ 650
- Average monthly inflow (last 3 months) ≥ $1,500
- Debt-to-Income (DTI) ratio ≤ 0.35 (35%)

### Credit Score Algorithm
```
baseScore = 500
variance = abs((customerId * 137) % 301)
score = baseScore + variance
```
Result: Deterministic score between 500-800

## Database Schema

### Tables
- **Customers**: Id, Name, NationalId, RiskRating
- **Accounts**: Id, CustomerId, IBAN, Balance
- **Transactions**: Id, AccountId, TxDate, Amount, Type
- **LoanApplications**: Id, CustomerId, Amount, TermMonths, Status, CreatedAt
- **Notifications**: Id, CustomerId, Subject, Body, CreatedAt, Status

### Transaction Types
- `Credit`: Money in (positive amount)
- `Debit`: Money out (negative amount shown as negative)

### Loan Application Statuses
- `Pending`: Awaiting review
- `Approved`: Loan approved
- `Rejected`: Loan rejected

## Common Tasks

### Add New Customer
```sql
INSERT INTO Customers (Name, NationalId, RiskRating) 
VALUES ('New Customer', 'NID-99999999', 650);
```

### Add New Account
```sql
INSERT INTO Accounts (CustomerId, IBAN, Balance) 
VALUES (1, 'GB99BANK12345678901234', 1000.00);
```

### Add Transaction
```sql
INSERT INTO Transactions (AccountId, TxDate, Amount, Type) 
VALUES (1, datetime('now'), 500.00, 'Credit');
```

### Reset Database
```bash
cd Database
sqlite3 ../LegacyBank.Web/App_Data/LegacyBank.db < schema.sql
sqlite3 ../LegacyBank.Web/App_Data/LegacyBank.db < data.sql
```

## Logging

Logs are written to: `LegacyBank.Web/App_Data/logs/legacybank.log`

View logs via: `/Pages/Audit/AuditLogs.aspx`

## Known Issues (By Design)

1. **SQL Injection**: AccountTransactions uses string concatenation
2. **No Authentication**: All pages are publicly accessible
3. **Secrets Exposed**: Config page shows connection string
4. **N+1 Queries**: CustomerSearch loads all data then queries each row
5. **Blocking Operations**: CSV exports block UI thread
6. **Session Abuse**: Business data stored in Session state
7. **Cache Misuse**: Short-lived cache with arbitrary TTL
8. **No Transactions**: Database operations not wrapped in transactions

## Demo Talking Points

### Loan Eligibility Page
- Synchronous ASMX call blocks UI thread
- Mixed data access (inline SQL + Db helper)
- Session and Cache both used (redundant)
- No error boundaries
- Business logic in code-behind

### Payment Posting Page
- Synchronous WCF call
- Returns DataSet (legacy pattern)
- No transaction scope
- Direct database updates

### Customer Search Page
- Loads ALL customers (memory issue at scale)
- N+1 anti-pattern for balance lookups
- In-memory filtering instead of SQL WHERE
- No pagination

### Admin Config Page
- Shows secrets in plain text
- Edits XML files directly
- No security/authentication
- Writes to App_Data folder

## Microservice Boundaries

Suggested carve-out candidates:
1. **LoanService**: Eligibility + Applications
2. **PaymentService**: Posting + History
3. **CustomerService**: Search + Details
4. **AccountService**: Accounts + Transactions
5. **StatementService**: Statement generation
6. **NotificationService**: Email/SMS
7. **ConfigService**: Centralized settings
8. **AuditService**: Logging/monitoring
