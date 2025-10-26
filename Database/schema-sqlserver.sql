-- LegacyBank Database Schema
-- SQL Server LocalDB version

-- Customers table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customers]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Customers] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [Name] NVARCHAR(255) NOT NULL,
        [NationalId] NVARCHAR(50) NOT NULL,
        [RiskRating] INT DEFAULT 0
    );
END
GO

-- Accounts table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Accounts]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Accounts] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [CustomerId] INT NOT NULL,
        [IBAN] NVARCHAR(50) NOT NULL,
        [Balance] DECIMAL(18,2) NOT NULL DEFAULT 0,
        FOREIGN KEY ([CustomerId]) REFERENCES [Customers]([Id])
    );
END
GO

-- Transactions table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Transactions]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Transactions] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [AccountId] INT NOT NULL,
        [TxDate] DATETIME NOT NULL,
        [Amount] DECIMAL(18,2) NOT NULL,
        [Type] NVARCHAR(20) NOT NULL,
        FOREIGN KEY ([AccountId]) REFERENCES [Accounts]([Id])
    );
END
GO

-- LoanApplications table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoanApplications]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[LoanApplications] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [CustomerId] INT NOT NULL,
        [Amount] DECIMAL(18,2) NOT NULL,
        [TermMonths] INT NOT NULL,
        [Status] NVARCHAR(50) NOT NULL,
        [CreatedAt] DATETIME NOT NULL,
        FOREIGN KEY ([CustomerId]) REFERENCES [Customers]([Id])
    );
END
GO

-- Notifications table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notifications]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Notifications] (
        [Id] INT PRIMARY KEY IDENTITY(1,1),
        [CustomerId] INT NOT NULL,
        [Subject] NVARCHAR(255) NOT NULL,
        [Body] NVARCHAR(MAX),
        [CreatedAt] DATETIME NOT NULL,
        [Status] NVARCHAR(50) NOT NULL,
        FOREIGN KEY ([CustomerId]) REFERENCES [Customers]([Id])
    );
END
GO

-- Create indexes for better query performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_accounts_customerid' AND object_id = OBJECT_ID('Accounts'))
BEGIN
    CREATE INDEX [idx_accounts_customerid] ON [Accounts]([CustomerId]);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_transactions_accountid' AND object_id = OBJECT_ID('Transactions'))
BEGIN
    CREATE INDEX [idx_transactions_accountid] ON [Transactions]([AccountId]);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_loanapplications_customerid' AND object_id = OBJECT_ID('LoanApplications'))
BEGIN
    CREATE INDEX [idx_loanapplications_customerid] ON [LoanApplications]([CustomerId]);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_notifications_customerid' AND object_id = OBJECT_ID('Notifications'))
BEGIN
    CREATE INDEX [idx_notifications_customerid] ON [Notifications]([CustomerId]);
END
GO
