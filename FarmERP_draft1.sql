DROP DATABASE if exists farmERPSystem;
Create DataBase farmERPSystem;
Use farmERPSystem;

-- Workers Table
CREATE TABLE IF NOT EXISTS Workers (
    WorkerID INT PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Position ENUM('FarmWorker', 'Supervisor', 'Manager', 'Other')  CHECK (Position IN ('FarmWorker', 'Supervisor', 'Manager', 'Other')) NOT NULL,
    Salary DOUBLE
);

-- Livestock Table
CREATE TABLE IF NOT EXISTS Livestock (
    LivestockID INT PRIMARY KEY,
    AnimalType VARCHAR(255) NOT NULL,
    Breed VARCHAR(255) NOT NULL,
    QuantityAvailable INT NOT NULL,
    Unit_price DOUBLE,
    DateOfBirth DATETIME ,
    PurchaseDate DATETIME,
    AnimalNotes TEXT
);

-- Crops Table
CREATE TABLE IF NOT EXISTS Crops (
    CropID INT PRIMARY KEY,
    CropName VARCHAR(255) NOT NULL,
    QuantityAvailable INT NOT NULL,
    Unit_price DOUBLE,
    PlantingDate DATETIME,
    HarvestDate DATETIME,
    QuantityPlanted INT,
    QuantityHarvested INT,
    CropStatus ENUM('Growing', 'Harvested'),
    PlantNotes TEXT
);

-- Crop_Plot Table
CREATE TABLE IF NOT EXISTS Crop_Plot (
    PlotID VARCHAR(255) PRIMARY KEY,
    CropID INT,
    SoilType ENUM('Sandy', 'Clay', 'Loamy') NOT NULL,
    Size DOUBLE CHECK (Size >= 0) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    Notes TEXT,
    FOREIGN KEY (CropID) REFERENCES Crops(CropID)
);

-- Equipment Table
CREATE TABLE IF NOT EXISTS Equipment (
    EquipmentID INT PRIMARY KEY,
    EquipmentName VARCHAR(255) NOT NULL,
    QuantityAvailable INT CHECK (QuantityAvailable >= 0) NOT NULL,
    PurchaseDate DATETIME NOT NULL,
    WarrantyExpirationDate DATETIME,
    MaintenanceDate DATETIME
);

-- Livestock_Pens Table
CREATE TABLE IF NOT EXISTS Livestock_Pens (
    PenID INT PRIMARY KEY,
    LivestockID INT,
    Size DOUBLE CHECK (Size >= 0) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    FOREIGN KEY (LivestockID) REFERENCES Livestock(LivestockID) ON DELETE CASCADE
);

-- Customer Table
CREATE TABLE IF NOT EXISTS Customer (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    ContactNumber VARCHAR(255) UNIQUE NOT NULL,
    Email VARCHAR(255) UNIQUE
);

-- Orders Table
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    Date DATETIME NOT NULL,
    Total_amount DOUBLE CHECK (Total_amount >= 0),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- OrderItems Table
CREATE TABLE IF NOT EXISTS OrderItems (
    ItemID VARCHAR(255) PRIMARY KEY,
    OrderID INT NOT NULL,
    CropID INT,
    LivestockID INT,
    QuantityOfCrop INT CHECK (QuantityOfCrop >= 0),
    QuantityOfLivestock INT CHECK (QuantityOfLivestock >= 0),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (CropID) REFERENCES Crops(CropID) ON DELETE CASCADE,
    FOREIGN KEY (LivestockID) REFERENCES Livestock(LivestockID) ON DELETE CASCADE
);

-- Tools_In_Use Table
CREATE TABLE IF NOT EXISTS Tools_In_Use (
    ToolUseID VARCHAR(255) PRIMARY KEY,
    WorkerID INT NOT NULL,
    EquipmentID INT NOT NULL,
    QuantityAcquired INT CHECK (QuantityAcquired >= 0) NOT NULL,
    TimeAcquired DATETIME NOT NULL,
    TimeReturned DATETIME NOT NULL,
    FOREIGN KEY (WorkerID) REFERENCES Workers(WorkerID),
    FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID)
);

-- Expenses_Record Table
CREATE TABLE IF NOT EXISTS Expenses_Record (
    ExpenseID VARCHAR(255) PRIMARY KEY,
    ExpenseCategory ENUM('Vehicle Expenses', 'Fertilier Expenses', 'Chemicals Expenses', 'Rent', 'Other') NOT NULL,
    Amount DOUBLE CHECK (Amount >= 0) NOT NULL,
    Notes TEXT
);

-- Transactions Table
CREATE TABLE IF NOT EXISTS Transactions (
    TransactionID VARCHAR(255) PRIMARY KEY,
    AuthID INT NOT NULL,
    OrderID INT,
    Worker_payID INT,
    ExpenseID VARCHAR(255),
    TransactionType ENUM('External Transaction','Cash Transaction', 'Internal Transaction','Non-Cash Transaction', 'Other') NOT NULL,
    Amount DOUBLE CHECK (Amount >= 0) NOT NULL,
    Reciept_photo BLOB,
    TransactionDate DATETIME NOT NULL,
    FOREIGN KEY (AuthID) REFERENCES Workers(WorkerID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (Worker_payID) REFERENCES Workers(WorkerID),
    FOREIGN KEY (ExpenseID) REFERENCES Expenses_Record(ExpenseID)
);

-- Works_On Table
CREATE TABLE IF NOT EXISTS Works_On (
    WorkerID INT NOT NULL,
    PlotID VARCHAR(255),
    PenID INT,
    PRIMARY KEY (WorkerID, PlotID, PenID),
    FOREIGN KEY (WorkerID) REFERENCES Workers(WorkerID) ON DELETE CASCADE,
    FOREIGN KEY (PlotID) REFERENCES Crop_Plot(PlotID) ON DELETE CASCADE,
    FOREIGN KEY (PenID) REFERENCES Livestock_Pens(PenID) ON DELETE CASCADE
);

-- Inserting Workers
INSERT INTO Workers (WorkerID, FirstName, LastName, Address, Position, Salary) VALUES
(1, 'John', 'Doe', '123 Main St', 'FarmWorker', 30000),
(2, 'Jane', 'Smith', '456 Oak St', 'Supervisor', 45000),
(3, 'Mike', 'Johnson', '789 Pine St', 'Manager', 60000);

-- Inserting Livestock
INSERT INTO Livestock (LivestockID, AnimalType, Breed, QuantityAvailable, Unit_price, DateOfBirth, PurchaseDate, AnimalNotes) VALUES
(1, 'Cow', 'Holstein', 10, 800, '2022-01-01', '2022-03-15', 'Black and white markings'),
(2, 'Chicken', 'Rhode Island Red', 50, 20, '2022-02-15', '2022-04-01', 'Free-range birds');

-- Inserting Crops
INSERT INTO Crops (CropID, CropName, QuantityAvailable, Unit_price, PlantingDate, HarvestDate, QuantityPlanted, QuantityHarvested, CropStatus, PlantNotes) VALUES
(1, 'Tomatoes', 100, 2, '2022-04-01', '2022-06-15', 80, 0, 'Growing', 'Planted in greenhouse'),
(2, 'Wheat', 200, 1.5, '2022-05-01', '2022-07-30', 150, 0, 'Growing', 'Field near the barn');

-- Inserting Crop_Plot
INSERT INTO Crop_Plot (PlotID, CropID, SoilType, Size, Location, Notes) VALUES
('A1', 1, 'Loamy', 10, 'Greenhouse', 'Plot for tomatoes'),
('B2', 2, 'Sandy', 20, 'Field', 'Large wheat field');

-- Inserting Equipment
INSERT INTO Equipment (EquipmentID, EquipmentName, QuantityAvailable, PurchaseDate, WarrantyExpirationDate, MaintenanceDate) VALUES
(1, 'Tractor', 2, '2022-01-10', '2025-01-10', '2022-06-01'),
(2, 'Plow', 1, '2022-02-05', '2024-02-05', '2022-08-15');

-- Inserting Livestock_Pens
INSERT INTO Livestock_Pens (PenID, LivestockID, Size, Location) VALUES
(1, 1, 100, 'Barn A'),
(2, 2, 50, 'Chicken Coop');

-- Inserting Customer
INSERT INTO Customer (CustomerID, FirstName, LastName, ContactNumber, Email) VALUES
(1, 'Alice', 'Johnson', '555-1234', 'alice@email.com'),
(2, 'Bob', 'Smith', '555-5678', 'bob@email.com');

-- Inserting Orders
INSERT INTO Orders (OrderID, CustomerID, Date, Total_amount) VALUES
(1, 1, '2022-07-01', 50),
(2, 2, '2022-08-15', 30);

-- Inserting OrderItems
INSERT INTO OrderItems (ItemID, OrderID, CropID, LivestockID, QuantityOfCrop, QuantityOfLivestock) VALUES
('A001', 1, 1, NULL, 5, NULL),
('B002', 2, NULL, 2, NULL, 10);

-- Inserting Tools_In_Use
INSERT INTO Tools_In_Use (ToolUseID, WorkerID, EquipmentID, QuantityAcquired, TimeAcquired, TimeReturned) VALUES
('T001', 1, 1, 1, '2022-05-01', '2022-05-02'),
('T002', 2, 2, 1, '2022-06-01', '2022-06-01');

-- Inserting Expenses_Record
INSERT INTO Expenses_Record (ExpenseID, ExpenseCategory, Amount, Notes) VALUES
('E001', 'Vehicle Expenses', 200, 'Vehicle Expenses'),
('E002', 'Rent', 500, 'Monthly rent for the farm');

-- Inserting Transactions
INSERT INTO Transactions (TransactionID, AuthID, OrderID, Worker_payID, ExpenseID, TransactionType, Amount, Reciept_photo, TransactionDate) VALUES
('TR001', 1, 1, NULL, 'E001', 'Cash Transaction', 50, NULL, '2022-07-05'),
('TR002', 2, 2, NULL, 'E002', 'Non-Cash Transaction', 30, NULL, '2022-08-20');

-- Inserting Works_On
-- INSERT INTO Works_On (WorkerID, PlotID, PenID) VALUES
-- (1, 'A1', NULL),
-- (2, NULL, 1);


-- View to show workers and their assigned tools
CREATE VIEW WorkerTools AS
SELECT w.FirstName, w.LastName, t.ToolUseID, e.EquipmentName
FROM Workers w
JOIN Tools_In_Use t ON w.WorkerID = t.WorkerID
JOIN Equipment e ON t.EquipmentID = e.EquipmentID;

-- View to show livestock and their pens 
CREATE VIEW LivestockPens AS
SELECT l.AnimalType, l.Breed, lp.PenID, lp.Location
FROM Livestock l
JOIN Livestock_Pens lp ON l.LivestockID = lp.LivestockID;


-- View to show crops and the plots they are planted in
CREATE VIEW CropPlots AS
SELECT c.CropName, cp.PlotID, cp.Location
FROM Crops c
JOIN Crop_Plot cp ON c.CropID = cp.CropID;

-- Update the salary of a worker
UPDATE Workers
SET Salary = 35000
WHERE WorkerID = 1;

-- Update the status of a crop to 'Harvested'
UPDATE Crops
SET CropStatus = 'Harvested', QuantityHarvested = 80
WHERE CropID = 1;

-- Update the maintenance date of equipment
UPDATE Equipment
SET MaintenanceDate = '2022-09-10'
WHERE EquipmentID = 1;

-- View total expenses by category
SELECT ExpenseCategory, SUM(Amount) AS TotalExpense
FROM Expenses_Record
GROUP BY ExpenseCategory;

-- View transactions by transaction type
SELECT TransactionType, COUNT(TransactionID) AS TransactionCount
FROM Transactions
GROUP BY TransactionType;

