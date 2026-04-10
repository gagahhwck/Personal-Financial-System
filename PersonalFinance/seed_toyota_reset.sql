-- ============================================================
-- RESET & RESEED - Toyota Finance Dummy Data (English / USD)
-- TransactionType: 1 = Income, 2 = Expense
-- ============================================================

USE PersonalFinanceDb;
GO

DECLARE @UserId NVARCHAR(450);
SELECT TOP 1 @UserId = Id FROM AspNetUsers ORDER BY UserName;

IF @UserId IS NULL
BEGIN
    RAISERROR('No user found. Please register an account first.', 16, 1);
    RETURN;
END

PRINT 'Using UserId: ' + @UserId;

-- ============================================================
-- DELETE OLD DUMMY DATA
-- ============================================================

DELETE FROM Transactions
WHERE UserId = @UserId
  AND CategoryId IN (
      SELECT Id FROM Categories
      WHERE UserId = @UserId
        AND Name IN (
            'Cicilan Toyota','Asuransi Kendaraan','Servis & Perawatan',
            'BBM / Bahan Bakar','Pajak Kendaraan','Parkir & Tol',
            'Gaji Bulanan','Bonus'
        )
  );

DELETE FROM Categories
WHERE UserId = @UserId
  AND Name IN (
      'Cicilan Toyota','Asuransi Kendaraan','Servis & Perawatan',
      'BBM / Bahan Bakar','Pajak Kendaraan','Parkir & Tol',
      'Gaji Bulanan','Bonus'
  );

PRINT 'Old dummy data deleted.';

-- ============================================================
-- INSERT CATEGORIES (English)
-- ============================================================

-- Expense (TransactionType = 2)
INSERT INTO Categories (Name, TransactionType, UserId) VALUES ('Toyota Loan Payment',    2, @UserId);
INSERT INTO Categories (Name, TransactionType, UserId) VALUES ('Car Insurance',          2, @UserId);
INSERT INTO Categories (Name, TransactionType, UserId) VALUES ('Maintenance & Service',  2, @UserId);
INSERT INTO Categories (Name, TransactionType, UserId) VALUES ('Fuel',                   2, @UserId);
INSERT INTO Categories (Name, TransactionType, UserId) VALUES ('Vehicle Tax',            2, @UserId);
INSERT INTO Categories (Name, TransactionType, UserId) VALUES ('Parking & Toll',         2, @UserId);

-- Income (TransactionType = 1)
INSERT INTO Categories (Name, TransactionType, UserId) VALUES ('Monthly Salary',         1, @UserId);
INSERT INTO Categories (Name, TransactionType, UserId) VALUES ('Bonus',                  1, @UserId);

-- ============================================================
-- RESOLVE CategoryIds
-- ============================================================

DECLARE @CatLoan     INT = (SELECT Id FROM Categories WHERE Name = 'Toyota Loan Payment'   AND UserId = @UserId);
DECLARE @CatInsur    INT = (SELECT Id FROM Categories WHERE Name = 'Car Insurance'          AND UserId = @UserId);
DECLARE @CatService  INT = (SELECT Id FROM Categories WHERE Name = 'Maintenance & Service'  AND UserId = @UserId);
DECLARE @CatFuel     INT = (SELECT Id FROM Categories WHERE Name = 'Fuel'                   AND UserId = @UserId);
DECLARE @CatTax      INT = (SELECT Id FROM Categories WHERE Name = 'Vehicle Tax'            AND UserId = @UserId);
DECLARE @CatParking  INT = (SELECT Id FROM Categories WHERE Name = 'Parking & Toll'         AND UserId = @UserId);
DECLARE @CatSalary   INT = (SELECT Id FROM Categories WHERE Name = 'Monthly Salary'         AND UserId = @UserId);
DECLARE @CatBonus    INT = (SELECT Id FROM Categories WHERE Name = 'Bonus'                  AND UserId = @UserId);

-- ============================================================
-- INSERT TRANSACTIONS (Nov 2025 - Apr 2026, USD)
-- ============================================================

-- ---- NOVEMBER 2025 ----
INSERT INTO Transactions (Amount, Description, TransactionDate, TransactionType, CategoryId, UserId, CreatedDate) VALUES
(4200.00, 'Monthly Salary - November 2025',             '2025-11-01', 1, @CatSalary,  @UserId, GETDATE()),
(385.00,  'Toyota Avanza Loan Payment - Nov 2025',      '2025-11-05', 2, @CatLoan,    @UserId, GETDATE()),
(95.00,   'Car Insurance Premium - Nov 2025',           '2025-11-05', 2, @CatInsur,   @UserId, GETDATE()),
(62.00,   'Fuel Refill - Nov 2025',                     '2025-11-10', 2, @CatFuel,    @UserId, GETDATE()),
(18.50,   'Parking & Toll Fees - Nov 2025',             '2025-11-15', 2, @CatParking, @UserId, GETDATE()),
(58.00,   'Fuel Refill (2nd) - Nov 2025',               '2025-11-25', 2, @CatFuel,    @UserId, GETDATE());

-- ---- DECEMBER 2025 ----
INSERT INTO Transactions (Amount, Description, TransactionDate, TransactionType, CategoryId, UserId, CreatedDate) VALUES
(4200.00, 'Monthly Salary - December 2025',             '2025-12-01', 1, @CatSalary,  @UserId, GETDATE()),
(800.00,  'Year-End Bonus 2025',                        '2025-12-20', 1, @CatBonus,   @UserId, GETDATE()),
(385.00,  'Toyota Avanza Loan Payment - Dec 2025',      '2025-12-05', 2, @CatLoan,    @UserId, GETDATE()),
(95.00,   'Car Insurance Premium - Dec 2025',           '2025-12-05', 2, @CatInsur,   @UserId, GETDATE()),
(210.00,  '20,000 Mile Service - Toyota Avanza',        '2025-12-12', 2, @CatService, @UserId, GETDATE()),
(65.00,   'Fuel Refill - Dec 2025',                     '2025-12-08', 2, @CatFuel,    @UserId, GETDATE()),
(22.00,   'Parking & Toll Fees - Dec 2025',             '2025-12-18', 2, @CatParking, @UserId, GETDATE()),
(60.00,   'Fuel Refill (2nd) - Dec 2025',               '2025-12-22', 2, @CatFuel,    @UserId, GETDATE());

-- ---- JANUARY 2026 ----
INSERT INTO Transactions (Amount, Description, TransactionDate, TransactionType, CategoryId, UserId, CreatedDate) VALUES
(4200.00, 'Monthly Salary - January 2026',              '2026-01-01', 1, @CatSalary,  @UserId, GETDATE()),
(385.00,  'Toyota Avanza Loan Payment - Jan 2026',      '2026-01-05', 2, @CatLoan,    @UserId, GETDATE()),
(95.00,   'Car Insurance Premium - Jan 2026',           '2026-01-05', 2, @CatInsur,   @UserId, GETDATE()),
(320.00,  'Annual Vehicle Registration Tax 2026',       '2026-01-15', 2, @CatTax,     @UserId, GETDATE()),
(63.00,   'Fuel Refill - Jan 2026',                     '2026-01-09', 2, @CatFuel,    @UserId, GETDATE()),
(15.00,   'Parking & Toll Fees - Jan 2026',             '2026-01-20', 2, @CatParking, @UserId, GETDATE()),
(59.00,   'Fuel Refill (2nd) - Jan 2026',               '2026-01-24', 2, @CatFuel,    @UserId, GETDATE());

-- ---- FEBRUARY 2026 ----
INSERT INTO Transactions (Amount, Description, TransactionDate, TransactionType, CategoryId, UserId, CreatedDate) VALUES
(4200.00, 'Monthly Salary - February 2026',             '2026-02-01', 1, @CatSalary,  @UserId, GETDATE()),
(385.00,  'Toyota Avanza Loan Payment - Feb 2026',      '2026-02-05', 2, @CatLoan,    @UserId, GETDATE()),
(95.00,   'Car Insurance Premium - Feb 2026',           '2026-02-05', 2, @CatInsur,   @UserId, GETDATE()),
(185.00,  'Oil Change & Filter Replacement - Avanza',   '2026-02-14', 2, @CatService, @UserId, GETDATE()),
(64.00,   'Fuel Refill - Feb 2026',                     '2026-02-10', 2, @CatFuel,    @UserId, GETDATE()),
(20.00,   'Parking & Toll Fees - Feb 2026',             '2026-02-17', 2, @CatParking, @UserId, GETDATE()),
(61.00,   'Fuel Refill (2nd) - Feb 2026',               '2026-02-26', 2, @CatFuel,    @UserId, GETDATE());

-- ---- MARCH 2026 ----
INSERT INTO Transactions (Amount, Description, TransactionDate, TransactionType, CategoryId, UserId, CreatedDate) VALUES
(4200.00, 'Monthly Salary - March 2026',                '2026-03-01', 1, @CatSalary,  @UserId, GETDATE()),
(385.00,  'Toyota Avanza Loan Payment - Mar 2026',      '2026-03-05', 2, @CatLoan,    @UserId, GETDATE()),
(95.00,   'Car Insurance Premium - Mar 2026',           '2026-03-05', 2, @CatInsur,   @UserId, GETDATE()),
(260.00,  '40,000 Mile Service + Tune-Up - Avanza',     '2026-03-20', 2, @CatService, @UserId, GETDATE()),
(66.00,   'Fuel Refill - Mar 2026',                     '2026-03-07', 2, @CatFuel,    @UserId, GETDATE()),
(19.00,   'Parking & Toll Fees - Mar 2026',             '2026-03-13', 2, @CatParking, @UserId, GETDATE()),
(63.00,   'Fuel Refill (2nd) - Mar 2026',               '2026-03-21', 2, @CatFuel,    @UserId, GETDATE());

-- ---- APRIL 2026 ----
INSERT INTO Transactions (Amount, Description, TransactionDate, TransactionType, CategoryId, UserId, CreatedDate) VALUES
(4200.00, 'Monthly Salary - April 2026',                '2026-04-01', 1, @CatSalary,  @UserId, GETDATE()),
(385.00,  'Toyota Avanza Loan Payment - Apr 2026',      '2026-04-05', 2, @CatLoan,    @UserId, GETDATE()),
(95.00,   'Car Insurance Premium - Apr 2026',           '2026-04-05', 2, @CatInsur,   @UserId, GETDATE()),
(67.00,   'Fuel Refill - Apr 2026',                     '2026-04-07', 2, @CatFuel,    @UserId, GETDATE()),
(16.50,   'Parking & Toll Fees - Apr 2026',             '2026-04-09', 2, @CatParking, @UserId, GETDATE());

-- ============================================================
-- VERIFY
-- ============================================================
SELECT 'Categories' AS TableName, COUNT(*) AS Total FROM Categories WHERE UserId = @UserId;
SELECT 'Transactions' AS TableName, COUNT(*) AS Total FROM Transactions WHERE UserId = @UserId;

PRINT 'Toyota finance seed data (English/USD) successfully inserted!';
GO
