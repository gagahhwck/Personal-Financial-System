-- ============================================================
-- SEED DATA - Toyota Personal Finance Dummy Data (English / USD)
-- TransactionType: 1 = Income, 2 = Expense
-- ============================================================

USE PersonalFinanceDb;
GO

-- Get the first UserId from AspNetUsers
DECLARE @UserId NVARCHAR(450);
SELECT TOP 1 @UserId = Id FROM AspNetUsers ORDER BY UserName;

IF @UserId IS NULL
BEGIN
    RAISERROR('No user found. Please register an account first.', 16, 1);
    RETURN;
END

PRINT 'Using UserId: ' + @UserId;

-- ============================================================
-- INSERT CATEGORIES
-- ============================================================

-- Expense Categories (TransactionType = 2)
INSERT INTO Categories (Name, TransactionType, UserId)
SELECT 'Cicilan Toyota', 2, @UserId
WHERE NOT EXISTS (SELECT 1 FROM Categories WHERE Name = 'Cicilan Toyota' AND UserId = @UserId);

INSERT INTO Categories (Name, TransactionType, UserId)
SELECT 'Asuransi Kendaraan', 2, @UserId
WHERE NOT EXISTS (SELECT 1 FROM Categories WHERE Name = 'Asuransi Kendaraan' AND UserId = @UserId);

INSERT INTO Categories (Name, TransactionType, UserId)
SELECT 'Servis & Perawatan', 2, @UserId
WHERE NOT EXISTS (SELECT 1 FROM Categories WHERE Name = 'Servis & Perawatan' AND UserId = @UserId);

INSERT INTO Categories (Name, TransactionType, UserId)
SELECT 'BBM / Bahan Bakar', 2, @UserId
WHERE NOT EXISTS (SELECT 1 FROM Categories WHERE Name = 'BBM / Bahan Bakar' AND UserId = @UserId);

INSERT INTO Categories (Name, TransactionType, UserId)
SELECT 'Pajak Kendaraan', 2, @UserId
WHERE NOT EXISTS (SELECT 1 FROM Categories WHERE Name = 'Pajak Kendaraan' AND UserId = @UserId);

INSERT INTO Categories (Name, TransactionType, UserId)
SELECT 'Parkir & Tol', 2, @UserId
WHERE NOT EXISTS (SELECT 1 FROM Categories WHERE Name = 'Parkir & Tol' AND UserId = @UserId);

-- Income Categories (TransactionType = 1)
INSERT INTO Categories (Name, TransactionType, UserId)
SELECT 'Gaji Bulanan', 1, @UserId
WHERE NOT EXISTS (SELECT 1 FROM Categories WHERE Name = 'Gaji Bulanan' AND UserId = @UserId);

INSERT INTO Categories (Name, TransactionType, UserId)
SELECT 'Bonus', 1, @UserId
WHERE NOT EXISTS (SELECT 1 FROM Categories WHERE Name = 'Bonus' AND UserId = @UserId);

-- ============================================================
-- AMBIL CategoryId
-- ============================================================

DECLARE @CatCicilan     INT = (SELECT Id FROM Categories WHERE Name = 'Cicilan Toyota'     AND UserId = @UserId);
DECLARE @CatAsuransi    INT = (SELECT Id FROM Categories WHERE Name = 'Asuransi Kendaraan' AND UserId = @UserId);
DECLARE @CatServis      INT = (SELECT Id FROM Categories WHERE Name = 'Servis & Perawatan' AND UserId = @UserId);
DECLARE @CatBBM         INT = (SELECT Id FROM Categories WHERE Name = 'BBM / Bahan Bakar'  AND UserId = @UserId);
DECLARE @CatPajak       INT = (SELECT Id FROM Categories WHERE Name = 'Pajak Kendaraan'    AND UserId = @UserId);
DECLARE @CatParkir      INT = (SELECT Id FROM Categories WHERE Name = 'Parkir & Tol'       AND UserId = @UserId);
DECLARE @CatGaji        INT = (SELECT Id FROM Categories WHERE Name = 'Gaji Bulanan'        AND UserId = @UserId);
DECLARE @CatBonus       INT = (SELECT Id FROM Categories WHERE Name = 'Bonus'               AND UserId = @UserId);

-- ============================================================
-- INSERT TRANSACTIONS (6 bulan terakhir - Nov 2025 s/d Apr 2026)
-- ============================================================

-- ---- NOVEMBER 2025 ----
INSERT INTO Transactions (Amount, Description, TransactionDate, TransactionType, CategoryId, UserId, CreatedDate) VALUES
(15000000, 'Gaji November 2025',                 '2025-11-01', 1, @CatGaji,     @UserId, GETDATE()),
(4500000,  'Cicilan Toyota Avanza Nov 2025',     '2025-11-05', 2, @CatCicilan,  @UserId, GETDATE()),
(520000,   'Premi Asuransi Kendaraan Nov 2025',  '2025-11-05', 2, @CatAsuransi, @UserId, GETDATE()),
(850000,   'Pengisian BBM Full Tank Nov 2025',   '2025-11-10', 2, @CatBBM,      @UserId, GETDATE()),
(180000,   'Tol & Parkir Nov 2025',              '2025-11-15', 2, @CatParkir,   @UserId, GETDATE()),
(750000,   'Pengisian BBM Full Tank Nov (2)',    '2025-11-25', 2, @CatBBM,      @UserId, GETDATE());

-- ---- DESEMBER 2025 ----
INSERT INTO Transactions (Amount, Description, TransactionDate, TransactionType, CategoryId, UserId, CreatedDate) VALUES
(15000000, 'Gaji Desember 2025',                 '2025-12-01', 1, @CatGaji,     @UserId, GETDATE()),
(5000000,  'Bonus Akhir Tahun 2025',             '2025-12-20', 1, @CatBonus,    @UserId, GETDATE()),
(4500000,  'Cicilan Toyota Avanza Des 2025',     '2025-12-05', 2, @CatCicilan,  @UserId, GETDATE()),
(520000,   'Premi Asuransi Kendaraan Des 2025',  '2025-12-05', 2, @CatAsuransi, @UserId, GETDATE()),
(1800000,  'Servis 20.000 KM Toyota Avanza',     '2025-12-12', 2, @CatServis,   @UserId, GETDATE()),
(900000,   'Pengisian BBM Full Tank Des 2025',   '2025-12-08', 2, @CatBBM,      @UserId, GETDATE()),
(200000,   'Tol & Parkir Des 2025',              '2025-12-18', 2, @CatParkir,   @UserId, GETDATE()),
(800000,   'Pengisian BBM Full Tank Des (2)',    '2025-12-22', 2, @CatBBM,      @UserId, GETDATE());

-- ---- JANUARI 2026 ----
INSERT INTO Transactions (Amount, Description, TransactionDate, TransactionType, CategoryId, UserId, CreatedDate) VALUES
(15000000, 'Gaji Januari 2026',                  '2026-01-01', 1, @CatGaji,     @UserId, GETDATE()),
(4500000,  'Cicilan Toyota Avanza Jan 2026',     '2026-01-05', 2, @CatCicilan,  @UserId, GETDATE()),
(520000,   'Premi Asuransi Kendaraan Jan 2026',  '2026-01-05', 2, @CatAsuransi, @UserId, GETDATE()),
(2500000,  'Pajak Tahunan Toyota Avanza 2026',   '2026-01-15', 2, @CatPajak,    @UserId, GETDATE()),
(870000,   'Pengisian BBM Full Tank Jan 2026',   '2026-01-09', 2, @CatBBM,      @UserId, GETDATE()),
(150000,   'Tol & Parkir Jan 2026',              '2026-01-20', 2, @CatParkir,   @UserId, GETDATE()),
(820000,   'Pengisian BBM Full Tank Jan (2)',    '2026-01-24', 2, @CatBBM,      @UserId, GETDATE());

-- ---- FEBRUARI 2026 ----
INSERT INTO Transactions (Amount, Description, TransactionDate, TransactionType, CategoryId, UserId, CreatedDate) VALUES
(15000000, 'Gaji Februari 2026',                 '2026-02-01', 1, @CatGaji,     @UserId, GETDATE()),
(4500000,  'Cicilan Toyota Avanza Feb 2026',     '2026-02-05', 2, @CatCicilan,  @UserId, GETDATE()),
(520000,   'Premi Asuransi Kendaraan Feb 2026',  '2026-02-05', 2, @CatAsuransi, @UserId, GETDATE()),
(1650000,  'Ganti Oli & Filter Toyota Avanza',   '2026-02-14', 2, @CatServis,   @UserId, GETDATE()),
(880000,   'Pengisian BBM Full Tank Feb 2026',   '2026-02-10', 2, @CatBBM,      @UserId, GETDATE()),
(210000,   'Tol & Parkir Feb 2026',              '2026-02-17', 2, @CatParkir,   @UserId, GETDATE()),
(840000,   'Pengisian BBM Full Tank Feb (2)',    '2026-02-26', 2, @CatBBM,      @UserId, GETDATE());

-- ---- MARET 2026 ----
INSERT INTO Transactions (Amount, Description, TransactionDate, TransactionType, CategoryId, UserId, CreatedDate) VALUES
(15000000, 'Gaji Maret 2026',                    '2026-03-01', 1, @CatGaji,     @UserId, GETDATE()),
(4500000,  'Cicilan Toyota Avanza Mar 2026',     '2026-03-05', 2, @CatCicilan,  @UserId, GETDATE()),
(520000,   'Premi Asuransi Kendaraan Mar 2026',  '2026-03-05', 2, @CatAsuransi, @UserId, GETDATE()),
(2200000,  'Servis 40.000 KM + Tune Up Avanza',  '2026-03-20', 2, @CatServis,   @UserId, GETDATE()),
(890000,   'Pengisian BBM Full Tank Mar 2026',   '2026-03-07', 2, @CatBBM,      @UserId, GETDATE()),
(190000,   'Tol & Parkir Mar 2026',              '2026-03-13', 2, @CatParkir,   @UserId, GETDATE()),
(860000,   'Pengisian BBM Full Tank Mar (2)',    '2026-03-21', 2, @CatBBM,      @UserId, GETDATE());

-- ---- APRIL 2026 ----
INSERT INTO Transactions (Amount, Description, TransactionDate, TransactionType, CategoryId, UserId, CreatedDate) VALUES
(15000000, 'Gaji April 2026',                    '2026-04-01', 1, @CatGaji,     @UserId, GETDATE()),
(4500000,  'Cicilan Toyota Avanza Apr 2026',     '2026-04-05', 2, @CatCicilan,  @UserId, GETDATE()),
(520000,   'Premi Asuransi Kendaraan Apr 2026',  '2026-04-05', 2, @CatAsuransi, @UserId, GETDATE()),
(900000,   'Pengisian BBM Full Tank Apr 2026',   '2026-04-07', 2, @CatBBM,      @UserId, GETDATE()),
(165000,   'Tol & Parkir Apr 2026',              '2026-04-09', 2, @CatParkir,   @UserId, GETDATE());

-- ============================================================
-- VERIFIKASI
-- ============================================================
SELECT 'Categories inserted:' AS Info, COUNT(*) AS Total FROM Categories WHERE UserId = @UserId;
SELECT 'Transactions inserted:' AS Info, COUNT(*) AS Total FROM Transactions WHERE UserId = @UserId;

PRINT 'Seed data Toyota berhasil dimasukkan!';
GO
