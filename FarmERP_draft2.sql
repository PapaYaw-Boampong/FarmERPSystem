DROP DATABASE if exists farmERPSystem;
Create DataBase farmERPSystem;
Use farmERPSystem;

-- Create a Person table
CREATE TABLE IF NOT EXISTS Person (
    PersonID INT PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE
);

-- Workers Table
CREATE TABLE IF NOT EXISTS Workers (
    WorkerID INT PRIMARY KEY,
    PersonID INT,
    Position ENUM('FarmWorker', 'Supervisor', 'Manager', 'Other') CHECK (Position IN ('FarmWorker', 'Supervisor', 'Manager', 'Other')) NOT NULL,
    Salary DOUBLE,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

-- Customer Table
CREATE TABLE IF NOT EXISTS Customer (
    CustomerID INT PRIMARY KEY,
    PersonID INT,
    ContactNumber VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);


-- Create a Produce table
CREATE TABLE IF NOT EXISTS Produce (
    ProduceID INT PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    QuantityAvailable INT NOT NULL,
    Unit_price DOUBLE,
    PurchaseDate DATETIME,
    Notes TEXT
);

-- Livestock Table
CREATE TABLE IF NOT EXISTS Livestock (
    LivestockID INT PRIMARY KEY,
    ProduceID INT,
    AnimalType VARCHAR(255) NOT NULL,
    DateOfBirth DATETIME,
    Breed VARCHAR(255) NOT NULL,
    FOREIGN KEY (ProduceID) REFERENCES Produce(ProduceID)
);

-- Crops Table
CREATE TABLE IF NOT EXISTS Crops (
    CropID INT PRIMARY KEY,
    ProduceID INT,
    PlantingDate DATETIME,
    HarvestDate DATETIME,
    QuantityPlanted INT,
    QuantityHarvested INT,
    CropStatus ENUM('Growing', 'Harvested'),
    FOREIGN KEY (ProduceID) REFERENCES Produce(ProduceID)
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
    ExpenseCategory ENUM('Vehicle Expenses', 'Fertilizer Expenses', 'Chemicals Expenses', 'Rent', 'Other') NOT NULL,
    Amount DOUBLE CHECK (Amount >= 0) NOT NULL,
    Notes TEXT
);

-- Transactions Table
CREATE TABLE IF NOT EXISTS Transactions (
    TransactionID VARCHAR(255) PRIMARY KEY,
    AuthID INT NOT NULL,
    OrderID INT,
    ExpenseID VARCHAR(255),
    TransactionType ENUM('External Transaction','Cash Transaction', 'Internal Transaction','Non-Cash Transaction', 'Other') NOT NULL,
    Amount DOUBLE CHECK (Amount >= 0) NOT NULL,
    Reciept_photo BLOB,
    TransactionDate DATETIME NOT NULL,
    FOREIGN KEY (AuthID) REFERENCES Workers(WorkerID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ExpenseID) REFERENCES Expenses_Record(ExpenseID)
);

-- Works_On Table
CREATE TABLE IF NOT EXISTS Works_On (
    WorkerID INT NOT NULL,
    PlotID VARCHAR(255),
    PenID INT,
    FOREIGN KEY (WorkerID) REFERENCES Workers(WorkerID) ON DELETE CASCADE,
    FOREIGN KEY (PlotID) REFERENCES Crop_Plot(PlotID) ON DELETE CASCADE,
    FOREIGN KEY (PenID) REFERENCES Livestock_Pens(PenID) ON DELETE CASCADE
);

-- Inserting data into Person table
INSERT INTO Person (PersonID, FirstName, LastName, Address, Email) VALUES
(1, 'John', 'Doe', '123 Main St', 'john@email.com'),
(2, 'Jane', 'Smith', '456 Oak St', 'jane@email.com'),
(3, 'Mike', 'Johnson', '789 Pine St', 'mike@email.com'),
(4, 'Emily', 'Williams', '567 Maple Ave', 'emily@email.com'),
(5, 'Robert', 'Brown', '890 Cedar Rd', 'robert@email.com'),
(6, 'Linda', 'Anderson', '234 Birch Ln', 'linda@email.com'),
(7, 'David', 'Miller', '678 Pine St', 'david@email.com'),
(8, 'Eve', 'Taylor', '111 Elm St', 'eve@email.com'),
(9, 'Charlie', 'Brown', '222 Pine St', 'charlie@email.com'),
(10, 'Grace', 'Williams', '333 Oak St', 'grace@email.com');

-- Inserting data into Workers table
INSERT INTO Workers (WorkerID, PersonID, Position, Salary) VALUES
(1, 1, 'FarmWorker', 30000),
(2, 2, 'Supervisor', 45000),
(3, 3, 'Manager', 60000),
(4, 4, 'FarmWorker', 32000),
(5, 5, 'Supervisor', 48000),
(6, 6, 'Manager', 65000),
(7, 7, 'FarmWorker', 31000),
(8, 8, 'Supervisor', 47000),
(9, 9, 'Manager', 62000),
(10, 10, 'FarmWorker', 33000);

-- Inserting data into Customer table
INSERT INTO Customer (CustomerID, PersonID, ContactNumber) VALUES
(1, 8, '555-1234'),
(2, 9, '555-5678'),
(3, 10, '555-9876'),
(4, 1, '555-4321'),
(5, 2, '555-6789'),
(6, 3, '555-1111'),
(7, 4, '555-2222'),
(8, 5, '555-3333'),
(9, 6, '555-4444'),
(10, 7, '555-5555');

-- Inserting data into Produce table
INSERT INTO Produce (ProduceID, ProductName, QuantityAvailable, Unit_price, PurchaseDate, Notes) VALUES
(1, 'Tomatoes', 100, 2, '2022-04-01', 'Planted in greenhouse'),
(2, 'Wheat', 200, 1.5, '2022-05-01', 'Field near the barn'),
(3, 'Corn', 120, 1.8, '2022-06-10', 'Large cornfield'),
(4, 'Potatoes', 80, 1.2, '2022-07-15', 'Planted in rows'),
(5, 'Soybeans', 150, 1.4, '2022-08-01', 'Fields near the river'),
(6, 'Cabbage', 50, 2.5, '2022-09-10', 'Garden plot'),
(7, 'Carrots', 70, 1.0, '2022-10-15', 'Vegetable garden'),
(8, 'Apples', 100, 2.0, '2022-11-20', 'Orchard'),
(9, 'Pumpkins', 30, 3.0, '2022-12-25', 'Harvested for Halloween'),
(10, 'Berries', 60, 4.0, '2023-01-30', 'Berry farm');

-- Inserting data into Livestock table
INSERT INTO Livestock (LivestockID, ProduceID, AnimalType, DateOfBirth, Breed) VALUES
(1, 1, 'Cow', '2022-01-01', 'Holstein'),
(2, 2, 'Chicken', '2022-02-15', 'Rhode Island Red'),
(3, 3, 'Pig', '2022-03-10', 'Yorkshire'),
(4, 4, 'Goat', '2022-04-05', 'Nubian'),
(5, 5, 'Sheep', '2022-05-20', 'Dorper'),
(6, 6, 'Horse', '2022-06-25', 'Thoroughbred'),
(7, 7, 'Duck', '2022-07-05', 'Pekin'),
(8, 8, 'Turkey', '2022-08-10', 'Broad Breasted White'),
(9, 9, 'Fish', '2022-09-15', 'Tilapia'),
(10, 10, 'Bee', '2022-10-20', 'Honey Bee');

-- Inserting data into Crops table
INSERT INTO Crops (CropID, ProduceID, PlantingDate, HarvestDate, QuantityPlanted, QuantityHarvested, CropStatus) VALUES
(1, 1, '2022-04-01', '2022-06-15', 80, 0, 'Growing'),
(2, 2, '2022-05-01', '2022-07-30', 150, 0, 'Growing'),
(3, 3, '2022-06-10', '2022-08-25', 100, 0, 'Growing'),
(4, 4, '2022-07-15', '2022-09-30', 70, 0, 'Growing'),
(5, 5, '2022-08-01', '2022-10-20', 130, 0, 'Growing'),
(6, 6, '2022-09-10', '2022-11-30', 40, 0, 'Growing'),
(7, 7, '2022-10-15', '2022-12-15', 60, 0, 'Growing'),
(8, 8, '2022-11-20', '2023-01-10', 90, 0, 'Growing'),
(9, 9, '2022-12-25', '2023-02-28', 20, 0, 'Growing'),
(10, 10, '2023-01-30', '2023-03-25', 50, 0, 'Growing');

-- Inserting data into Crop_Plot table
INSERT INTO Crop_Plot (PlotID, CropID, SoilType, Size, Location, Notes) VALUES
('A1', 1, 'Loamy', 10, 'Greenhouse', 'Plot for tomatoes'),
-- Inserting data into Crop_Plot table (continued)
('B2', 2, 'Sandy', 20, 'Field', 'Large wheat field'),
('C3', 3, 'Clay', 15, 'Field', 'Cornfield near the barn'),
('D4', 4, 'Loamy', 12, 'Field', 'Potato field with irrigation'),
('E5', 5, 'Sandy', 18, 'Riverbank', 'Soybean plantation by the river'),
('F6', 6, 'Loamy', 8, 'Garden', 'Cabbage and carrot plot'),
('G7', 7, 'Clay', 10, 'Pond', 'Duck habitat'),
('H8', 8, 'Sandy', 15, 'Orchard', 'Apple orchard'),
('I9', 9, 'Loamy', 5, 'Aquarium', 'Fish tank for tilapia'),
('J10', 10, 'Sandy', 3, 'Beehive', 'Bee farm near flowers');

-- Inserting data into Equipment table
INSERT INTO Equipment (EquipmentID, EquipmentName, QuantityAvailable, PurchaseDate, WarrantyExpirationDate, MaintenanceDate) VALUES
(1, 'Tractor', 2, '2022-01-10', '2025-01-10', '2022-06-01'),
(2, 'Plow', 1, '2022-02-05', '2024-02-05', '2022-08-15'),
(3, 'Harvester', 1, '2022-03-20', '2025-03-20', '2022-07-10'),
(4, 'Seeder', 2, '2022-04-15', '2024-04-15', '2022-09-05'),
(5, 'Sprayer', 1, '2022-05-30', '2024-05-30', '2022-10-15'),
(6, 'Plow', 1, '2022-06-20', '2024-06-20', '2022-11-01'),
(7, 'Harvester', 1, '2022-07-25', '2025-07-25', '2022-12-10'),
(8, 'Tractor', 2, '2022-08-30', '2025-08-30', '2023-01-25'),
(9, 'Seeder', 1, '2022-09-15', '2024-09-15', '2023-02-10'),
(10, 'Sprayer', 1, '2022-10-10', '2024-10-10', '2023-03-05');

-- Inserting data into Livestock_Pens table
INSERT INTO Livestock_Pens (PenID, LivestockID, Size, Location) VALUES
(1, 1, 100, 'Barn A'),
(2, 2, 50, 'Chicken Coop'),
(3, 3, 80, 'Pig Pen'),
(4, 4, 60, 'Goat Enclosure'),
(5, 5, 70, 'Sheep Barn'),
(6, 6, 40, 'Horse Stable'),
(7, 7, 30, 'Duck Pond'),
(8, 8, 25, 'Turkey Roost'),
(9, 9, 10, 'Fish Tank'),
(10, 10, 5, 'Beehive Area');

-- Inserting data into Orders table
INSERT INTO Orders (OrderID, CustomerID, Date, Total_amount) VALUES
(1, 1, '2022-07-01', 50),
(2, 2, '2022-08-15', 30),
(3, 3, '2022-09-05', 80),
(4, 4, '2022-10-20', 40),
(5, 5, '2022-11-15', 60),
(6, 6, '2022-12-01', 25),
(7, 7, '2023-01-10', 70),
(8, 8, '2023-02-20', 35),
(9, 9, '2023-03-15', 90),
(10, 10, '2023-04-25', 20);

-- Inserting data into OrderItems table
INSERT INTO OrderItems (ItemID, OrderID, CropID, LivestockID, QuantityOfCrop, QuantityOfLivestock) VALUES
('A001', 1, 1, NULL, 5, NULL),
('B002', 2, NULL, 2, NULL, 10),
('C003', 3, 3, NULL, 0, NULL),
('D004', 4, 4, NULL, 8, NULL),
('E005', 5, NULL, 5, NULL, 15),
('F006', 6, 6, NULL, 0, NULL),
('G007', 7, 7, NULL, 0, NULL),
('H008', 8, 8, NULL, 0, NULL),
('I009', 9, 9, NULL, 0, NULL),
('J010', 10, NULL, 10, NULL, 5);

-- Inserting data into Tools_In_Use table
INSERT INTO Tools_In_Use (ToolUseID, WorkerID, EquipmentID, QuantityAcquired, TimeAcquired, TimeReturned) VALUES
('T001', 1, 1, 1, '2022-05-01', '2022-05-02'),
('T002', 2, 2, 1, '2022-06-01', '2022-06-01'),
('T003', 3, 3, 2, '2022-07-10', '2022-07-11'),
('T004', 4, 1, 1, '2022-08-15', '2022-08-15'),
('T005', 5, 4, 1, '2022-09-20', '2022-09-20'),
('T006', 6, 6, 1, '2022-10-05', '2022-10-05'),
('T007', 7, 7, 1, '2022-11-10', '2022-11-10'),
('T008', 8, 8, 1, '2022-12-15', '2022-12-15'),
('T009', 9, 9, 1, '2023-01-20', '2023-01-20'),
('T010', 10, 10, 1, '2023-02-25', '2023-02-25');

-- Inserting data into Expenses_Record table
INSERT INTO Expenses_Record (ExpenseID, ExpenseCategory, Amount, Notes) VALUES
('E001', 'Vehicle Expenses', 200, 'Vehicle Expenses'),
('E002', 'Rent', 500, 'Monthly rent for the farm'),
('E003', 'Chemicals Expenses', 300, 'Pesticides and fertilizers'),
('E004', 'Other', 150, 'Miscellaneous expenses'),
('E005', 'Fertilizer Expenses', 250, 'Fertilizers for crops'),
('E006', 'Fertilizer Expenses', 120, 'Purchase of crop seeds'),
('E007', 'Other', 80, 'Tools and equipment maintenance'),
('E008', 'Chemicals Expenses', 90, 'Purchase of feed for livestock'),
('E009', 'Rent', 60, 'Electricity and water bills'),
('E010', 'Vehicle Expenses', 75, 'Insurance coverage for the farm');

-- Inserting data into Transactions table
INSERT INTO Transactions (TransactionID, AuthID, OrderID, ExpenseID, TransactionType, Amount, Reciept_photo, TransactionDate) VALUES
('TR001', 1, 1, 'E001', 'Cash Transaction', 50, NULL, '2022-07-05'),
('TR002', 2, 2, 'E002', 'Non-Cash Transaction', 30, NULL, '2022-08-20'),
('TR003', 3, 3, 'E003', 'Cash Transaction', 80, NULL, '2022-09-15'),
('TR004', 4, 4, 'E004', 'Non-Cash Transaction', 40, NULL, '2022-10-10'),
('TR005', 5, 5, 'E005', 'Cash Transaction', 60, NULL, '2022-11-25'),
('TR006', 1, 2, 'E002', 'Non-Cash Transaction', 25, NULL, '2022-12-05'),
('TR007', 2, 3, 'E001', 'Cash Transaction', 70, NULL, '2023-01-15'),
('TR008', 3, 4, 'E004', 'Non-Cash Transaction', 35, NULL, '2023-02-20'),
('TR009', 4, 5, 'E005', 'Cash Transaction', 85, NULL, '2023-03-10'),
('TR010', 5, 6, 'E006', 'Non-Cash Transaction', 55, NULL, '2023-04-01');

-- Inserting data into Works_On table
INSERT INTO Works_On (WorkerID, PlotID, PenID) VALUES
(1, 'A1', NULL),
(2, NULL, 1),
(3, 'C3', NULL),
(4, 'D4', 2),
(5, 'E5', 3),
(6, 'F6', 4),
(7, 'G7', NULL),
(8, 'H8', NULL),
(9, 'I9', NULL),
(10, 'J10', 6);



-- View to show workers and their assigned tools
CREATE VIEW WorkerTools AS
SELECT p.FirstName, p.LastName, t.ToolUseID, e.EquipmentName
FROM Workers w
JOIN Tools_In_Use t ON w.WorkerID = t.WorkerID
JOIN Equipment e ON t.EquipmentID = e.EquipmentID
JOIN Person p ON w.PersonID = p.PersonID;

-- View to show livestock and their pens 
CREATE VIEW LivestockPens AS
SELECT l.AnimalType, l.Breed, lp.PenID, lp.Location
FROM Livestock l
JOIN Livestock_Pens lp ON l.LivestockID = lp.LivestockID;

CREATE VIEW CropPlots AS
SELECT p.ProductName AS CropName, cp.PlotID, cp.Location
FROM Crops c
JOIN Crop_Plot cp ON c.CropID = cp.CropID
JOIN Produce p ON c.ProduceID = p.ProduceID;

-- Views for all the strong entities
CREATE VIEW People_VIEW AS
SELECT PersonID, FirstName, LastName, Address, Email
FROM Person;


CREATE VIEW Produce_VIEW AS
SELECT ProduceID, ProductName, QuantityAvailable, Unit_price, PurchaseDate, Notes
FROM Produce;

CREATE VIEW Workers_VIEW AS
SELECT w.WorkerID, p.FirstName, p.LastName, p.Address, w.Position, w.Salary
FROM Workers w
JOIN Person p ON w.PersonID = p.PersonID;

CREATE VIEW Livestock_VIEW AS
SELECT l.LivestockID, l.AnimalType, l.Breed, p.QuantityAvailable, p.Unit_price, l.DateOfBirth, p.PurchaseDate, p.Notes AS AnimalNotes
FROM Livestock l
JOIN Produce p ON l.ProduceID = p.ProduceID;

CREATE VIEW Crops_VIEW AS
SELECT c.CropID, p.ProductName AS CropName, p.QuantityAvailable, p.Unit_price, c.PlantingDate, c.HarvestDate, c.QuantityPlanted, c.QuantityHarvested, c.CropStatus, p.Notes AS PlantNotes
FROM Crops c
JOIN Produce p ON c.ProduceID = p.ProduceID;

CREATE VIEW Equipment_VIEW AS
SELECT EquipmentID, EquipmentName, QuantityAvailable, PurchaseDate, WarrantyExpirationDate, MaintenanceDate 
FROM Equipment;

CREATE VIEW Customers_VIEW AS
SELECT c.CustomerID, p.FirstName, p.LastName, c.ContactNumber, p.Email
FROM Customer c
JOIN Person p ON c.PersonID = p.PersonID;


CREATE VIEW Orders_VIEW AS
SELECT OrderID, CustomerID, Date, Total_amount
FROM Orders;

CREATE VIEW Expenses_VIEW AS
SELECT ExpenseID, ExpenseCategory, Amount, Notes
FROM Expenses_Record;



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

-- Display transactions made in July 2022 the transaction happened

SELECT *
FROM Transactions
WHERE MONTH(TransactionDate) = 07
AND YEAR(TransactionDate) = 2022;

-- Display the number of Workers that are FarmWorker

SELECT COUNT(Position) 
FROM Workers 
WHERE Position = 'FarmWorker';

-- Display all Worker that are Supervisor

SELECT * 
FROM Workers 
WHERE Position = 'Supervisor'; 

-- Display all Worker

SELECT * 
FROM Workers;

-- Display what each worker is working on 

SELECT * 
FROM Works_On; 

-- Display the Crops harvested that where harvested in January of 2023 

SELECT *
FROM Crops
WHERE CropStatus = 'Harvested'
AND MONTH(HarvestDate) = 01
AND YEAR(HarvestDate) = 2023;

-- Display the Crops that are currently growing and were planted in Apirl of 2022

SELECT *
FROM Crops
WHERE CropStatus = 'Growing'
AND MONTH(PlantingDate) = 04
AND YEAR(PlantingDate) = 2022;

