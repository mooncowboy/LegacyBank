<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>LegacyBank - Home</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #007bff;
            border-bottom: 3px solid #007bff;
            padding-bottom: 10px;
        }
        h2 {
            color: #333;
            margin-top: 30px;
        }
        .section {
            margin: 20px 0;
        }
        .links {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        .link-card {
            border: 1px solid #ddd;
            padding: 15px;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .link-card h3 {
            margin: 0 0 10px 0;
            color: #007bff;
        }
        .link-card a {
            color: #007bff;
            text-decoration: none;
            font-weight: bold;
        }
        .link-card a:hover {
            text-decoration: underline;
        }
        .link-card p {
            margin: 5px 0;
            font-size: 14px;
            color: #666;
        }
        .warning {
            background-color: #fff3cd;
            border: 1px solid #ffc107;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🏦 LegacyBank - Legacy Banking Application</h1>
        
        <div class="warning">
            <strong>⚠️ Notice:</strong> This is a demonstration application built with intentional legacy patterns 
            for modernization and microservices carve-out demonstrations. Not for production use.
        </div>

        <div class="section">
            <h2>💰 Loans</h2>
            <div class="links">
                <div class="link-card">
                    <h3>Loan Eligibility</h3>
                    <p>Check if a customer is eligible for a loan</p>
                    <a href="/Pages/Loans/LoanEligibility.aspx">Check Eligibility →</a>
                    <p><em>Demo: ASMX service, Session/Cache, mixed data access</em></p>
                </div>
                <div class="link-card">
                    <h3>Loan Applications</h3>
                    <p>Submit and manage loan applications</p>
                    <a href="/Pages/Loans/LoanApplications.aspx">Manage Applications →</a>
                    <p><em>Demo: Inline SQL, no validation</em></p>
                </div>
            </div>
        </div>

        <div class="section">
            <h2>💳 Payments</h2>
            <div class="links">
                <div class="link-card">
                    <h3>Payment Posting</h3>
                    <p>Post payments via WCF service</p>
                    <a href="/Pages/Payments/PaymentPosting.aspx">Post Payment →</a>
                    <p><em>Demo: Synchronous WCF, DataSets</em></p>
                </div>
                <div class="link-card">
                    <h3>Payment History</h3>
                    <p>View payment history with CSV export</p>
                    <a href="/Pages/Payments/PaymentHistory.aspx">View History →</a>
                    <p><em>Demo: In-memory paging, blocking CSV export</em></p>
                </div>
            </div>
        </div>

        <div class="section">
            <h2>👥 Customers</h2>
            <div class="links">
                <div class="link-card">
                    <h3>Customer Search</h3>
                    <p>Search customers (loads all in memory)</p>
                    <a href="/Pages/Customers/CustomerSearch.aspx">Search Customers →</a>
                    <p><em>Demo: N+1 anti-pattern, in-memory filtering</em></p>
                </div>
                <div class="link-card">
                    <h3>Customer Details</h3>
                    <p>View detailed customer information</p>
                    <a href="/Pages/Customers/CustomerDetails.aspx?id=1">View Customer #1 →</a>
                    <p><em>Demo: Session usage, mixed data access</em></p>
                </div>
            </div>
        </div>

        <div class="section">
            <h2>🏦 Accounts</h2>
            <div class="links">
                <div class="link-card">
                    <h3>Account List</h3>
                    <p>List accounts for a customer</p>
                    <a href="/Pages/Accounts/AccountList.aspx?customerId=1">View Accounts →</a>
                    <p><em>Demo: GridView with server events</em></p>
                </div>
                <div class="link-card">
                    <h3>Account Transactions</h3>
                    <p>View transactions with filters</p>
                    <a href="/Pages/Accounts/AccountTransactions.aspx?accountId=1">View Transactions →</a>
                    <p><em>Demo: SQL injection risk (string concatenation)</em></p>
                </div>
            </div>
        </div>

        <div class="section">
            <h2>📄 Other Features</h2>
            <div class="links">
                <div class="link-card">
                    <h3>Monthly Statement</h3>
                    <p>Generate monthly account statements</p>
                    <a href="/Pages/Statements/MonthlyStatement.aspx?accountId=1&year=2025&month=10">Generate Statement →</a>
                    <p><em>Demo: Cache misuse, blocking CSV generation</em></p>
                </div>
                <div class="link-card">
                    <h3>Email Notifications</h3>
                    <p>Send email notifications to customers</p>
                    <a href="/Pages/Notifications/EmailNotifications.aspx">Send Notification →</a>
                    <p><em>Demo: Mock SMTP, Session storage</em></p>
                </div>
                <div class="link-card">
                    <h3>Configuration</h3>
                    <p>Edit application settings (insecure)</p>
                    <a href="/Pages/Admin/Config.aspx">Manage Config →</a>
                    <p><em>Demo: Secrets exposed, XML file editing</em></p>
                </div>
                <div class="link-card">
                    <h3>Audit Logs</h3>
                    <p>View application logs</p>
                    <a href="/Pages/Audit/AuditLogs.aspx">View Logs →</a>
                    <p><em>Demo: File-based logs, text parsing</em></p>
                </div>
            </div>
        </div>

        <div class="section">
            <h2>🛠️ Sample Data</h2>
            <p>The application comes with pre-seeded data:</p>
            <ul>
                <li><strong>Customers:</strong> 3 customers (IDs: 1, 2, 3)</li>
                <li><strong>Accounts:</strong> 5 accounts across customers</li>
                <li><strong>Transactions:</strong> 33 transactions for the last few months</li>
                <li><strong>Loan Applications:</strong> 3 applications with various statuses</li>
            </ul>
        </div>

        <div class="section">
            <h2>📚 Documentation</h2>
            <p>For more information about the project, setup instructions, and legacy patterns, 
            see the <a href="https://github.com/mooncowboy/LegacyBank">README on GitHub</a>.</p>
        </div>
    </div>
</body>
</html>
