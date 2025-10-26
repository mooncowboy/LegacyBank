-- LegacyBank Database Schema
-- SQLite version

-- Customers table
CREATE TABLE IF NOT EXISTS Customers (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL,
    NationalId TEXT NOT NULL,
    RiskRating INTEGER DEFAULT 0
);

-- Accounts table
CREATE TABLE IF NOT EXISTS Accounts (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    CustomerId INTEGER NOT NULL,
    IBAN TEXT NOT NULL,
    Balance REAL NOT NULL DEFAULT 0,
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id)
);

-- Transactions table
CREATE TABLE IF NOT EXISTS Transactions (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    AccountId INTEGER NOT NULL,
    TxDate TEXT NOT NULL,
    Amount REAL NOT NULL,
    Type TEXT NOT NULL,
    FOREIGN KEY (AccountId) REFERENCES Accounts(Id)
);

-- LoanApplications table
CREATE TABLE IF NOT EXISTS LoanApplications (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    CustomerId INTEGER NOT NULL,
    Amount REAL NOT NULL,
    TermMonths INTEGER NOT NULL,
    Status TEXT NOT NULL,
    CreatedAt TEXT NOT NULL,
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id)
);

-- Notifications table
CREATE TABLE IF NOT EXISTS Notifications (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    CustomerId INTEGER NOT NULL,
    Subject TEXT NOT NULL,
    Body TEXT,
    CreatedAt TEXT NOT NULL,
    Status TEXT NOT NULL,
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_accounts_customerid ON Accounts(CustomerId);
CREATE INDEX IF NOT EXISTS idx_transactions_accountid ON Transactions(AccountId);
CREATE INDEX IF NOT EXISTS idx_loanapplications_customerid ON LoanApplications(CustomerId);
CREATE INDEX IF NOT EXISTS idx_notifications_customerid ON Notifications(CustomerId);
