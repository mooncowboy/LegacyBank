-- LegacyBank Database Sample Data
-- SQL Server LocalDB version

-- Insert sample customers
SET IDENTITY_INSERT [dbo].[Customers] ON;
GO

INSERT INTO [Customers] ([Id], [Name], [NationalId], [RiskRating]) VALUES
(1, 'John Smith', 'NID-12345678', 650),
(2, 'Jane Doe', 'NID-87654321', 720),
(3, 'Robert Johnson', 'NID-11223344', 580);
GO

SET IDENTITY_INSERT [dbo].[Customers] OFF;
GO

-- Insert sample accounts
SET IDENTITY_INSERT [dbo].[Accounts] ON;
GO

INSERT INTO [Accounts] ([Id], [CustomerId], [IBAN], [Balance]) VALUES
(1, 1, 'GB29NWBK60161331926819', 5500.00),
(2, 1, 'GB82WEST12345698765432', 12000.00),
(3, 2, 'GB33BUKB20201555555555', 25000.00),
(4, 2, 'GB94BARC10201530093459', 8500.00),
(5, 3, 'GB60NAIA07011610909132', 1200.00);
GO

SET IDENTITY_INSERT [dbo].[Accounts] OFF;
GO

-- Insert sample transactions for the last 3-6 months
-- Customer 1, Account 1 transactions
INSERT INTO [Transactions] ([AccountId], [TxDate], [Amount], [Type]) VALUES
(1, '2025-07-15 10:30:00', 2500.00, 'Credit'),
(1, '2025-07-20 14:22:00', -150.00, 'Debit'),
(1, '2025-08-01 09:15:00', 2500.00, 'Credit'),
(1, '2025-08-05 11:45:00', -200.00, 'Debit'),
(1, '2025-08-12 16:30:00', -75.50, 'Debit'),
(1, '2025-09-01 09:10:00', 2500.00, 'Credit'),
(1, '2025-09-10 12:00:00', -300.00, 'Debit'),
(1, '2025-09-15 15:20:00', -125.00, 'Debit'),
(1, '2025-10-01 09:05:00', 2500.00, 'Credit'),
(1, '2025-10-10 13:30:00', -400.00, 'Debit'),
(1, '2025-10-20 10:15:00', -250.00, 'Debit');
GO

-- Customer 1, Account 2 transactions
INSERT INTO [Transactions] ([AccountId], [TxDate], [Amount], [Type]) VALUES
(2, '2025-07-10 11:00:00', 5000.00, 'Credit'),
(2, '2025-08-15 14:30:00', 3000.00, 'Credit'),
(2, '2025-09-20 16:45:00', 4000.00, 'Credit');
GO

-- Customer 2, Account 3 transactions
INSERT INTO [Transactions] ([AccountId], [TxDate], [Amount], [Type]) VALUES
(3, '2025-07-05 10:00:00', 8000.00, 'Credit'),
(3, '2025-07-12 14:20:00', -500.00, 'Debit'),
(3, '2025-08-05 09:30:00', 8000.00, 'Credit'),
(3, '2025-08-18 11:15:00', -1200.00, 'Debit'),
(3, '2025-09-05 10:05:00', 8000.00, 'Credit'),
(3, '2025-09-22 15:40:00', -800.00, 'Debit'),
(3, '2025-10-05 09:00:00', 8000.00, 'Credit'),
(3, '2025-10-15 12:25:00', -600.00, 'Debit');
GO

-- Customer 2, Account 4 transactions
INSERT INTO [Transactions] ([AccountId], [TxDate], [Amount], [Type]) VALUES
(4, '2025-08-10 10:30:00', 3000.00, 'Credit'),
(4, '2025-09-10 11:45:00', 3000.00, 'Credit'),
(4, '2025-10-10 12:00:00', 2500.00, 'Credit');
GO

-- Customer 3, Account 5 transactions
INSERT INTO [Transactions] ([AccountId], [TxDate], [Amount], [Type]) VALUES
(5, '2025-07-25 14:00:00', 800.00, 'Credit'),
(5, '2025-07-28 10:30:00', -250.00, 'Debit'),
(5, '2025-08-25 13:45:00', 600.00, 'Credit'),
(5, '2025-08-30 09:20:00', -150.00, 'Debit'),
(5, '2025-09-25 15:10:00', 700.00, 'Credit'),
(5, '2025-09-28 11:00:00', -200.00, 'Debit'),
(5, '2025-10-25 14:30:00', 500.00, 'Credit'),
(5, '2025-10-26 10:45:00', -100.00, 'Debit');
GO

-- Insert sample loan applications
SET IDENTITY_INSERT [dbo].[LoanApplications] ON;
GO

INSERT INTO [LoanApplications] ([Id], [CustomerId], [Amount], [TermMonths], [Status], [CreatedAt]) VALUES
(1, 1, 15000.00, 36, 'Pending', '2025-10-15 10:00:00'),
(2, 2, 50000.00, 60, 'Approved', '2025-09-20 14:30:00'),
(3, 3, 5000.00, 12, 'Rejected', '2025-10-01 11:15:00');
GO

SET IDENTITY_INSERT [dbo].[LoanApplications] OFF;
GO

-- Insert sample notifications
SET IDENTITY_INSERT [dbo].[Notifications] ON;
GO

INSERT INTO [Notifications] ([Id], [CustomerId], [Subject], [Body], [CreatedAt], [Status]) VALUES
(1, 1, 'Loan Application Received', 'Your loan application has been received and is under review.', '2025-10-15 10:05:00', 'Sent'),
(2, 2, 'Loan Approved', 'Congratulations! Your loan application has been approved.', '2025-09-21 09:00:00', 'Sent');
GO

SET IDENTITY_INSERT [dbo].[Notifications] OFF;
GO
