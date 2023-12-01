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
    ProduceID INT,
    QuantityOfCrop INT CHECK (QuantityOfCrop >= 0),
    QuantityOfLivestock INT CHECK (QuantityOfLivestock >= 0),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProduceID) REFERENCES Produce(ProduceID) ON DELETE CASCADE
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
    OrderID INT,
    ExpenseID VARCHAR(255),
    TransactionType ENUM('External Transaction','Cash Transaction', 'Internal Transaction','Non-Cash Transaction', 'Other') NOT NULL,
    Amount DOUBLE CHECK (Amount >= 0) NOT NULL,
    Reciept_photo BLOB,
    TransactionDate DATETIME NOT NULL,
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
(1, 1, 'Cow', '2021-03-05', 'Holstein'),
(2, 2, 'Chicken', '2020-06-15', 'Rhode Island Red'),
(3, 3, 'Pig', '2022-01-20', 'Yorkshire'),
(4, 4, 'Sheep', '2021-09-10', 'Suffolk'),
(5, 5, 'Goat', '2022-04-25', 'Nubian'),
(6, 6, 'Horse', '2020-11-30', 'Thoroughbred'),
(7, 7, 'Duck', '2022-07-08', 'Pekin'),
(8, 8, 'Turkey', '2022-12-12', 'Broad Breasted White'),
(9, 9, 'Rabbit', '2023-02-18', 'Holland Lop'),
(10, 10, 'Sheep', '2022-05-10', 'Dorset');

-- Inserting data into Crops table
INSERT INTO Crops (CropID, ProduceID, PlantingDate, HarvestDate, QuantityPlanted, QuantityHarvested, CropStatus) VALUES
(1, 1, '2022-03-10', '2022-06-30', 2000, 1800, 'Harvested'),
(2, 2, '2022-05-15', '2022-08-20', 5000, 4500, 'Harvested'),
(3, 3, '2022-06-25', '2022-10-15', 3000, 2500, 'Harvested'),
(4, 4, '2022-08-01', '2022-11-25', 2500, 2000, 'Harvested'),
(5, 5, '2022-09-15', '2022-12-10', 4000, 3500, 'Harvested'),
(6, 6, '2022-10-20', '2023-02-28', 1000, 800, 'Growing'),
(7, 7, '2022-11-25', '2023-03-05', 1200, 900, 'Growing'),
(8, 8, '2022-12-30', '2023-04-15', 1800, 1500, 'Growing'),
(9, 9, '2023-02-05', '2023-05-20', 800, 600, 'Growing'),
(10, 10, '2023-03-10', '2023-06-30', 1500, 1200, 'Growing');

-- Inserting data into Crop_Plot table
INSERT INTO Crop_Plot (PlotID, CropID, SoilType, Size, Location, Notes) VALUES
('Plot A', 1, 'Sandy', 10.0, 'Location A', 'Notes for Plot A'),
('Plot B', 2, 'Clay', 15.0, 'Location B', 'Notes for Plot B'),
('Plot C', 3, 'Loamy', 12.0, 'Location C', 'Notes for Plot C'),
('Plot D', 4, 'Sandy', 8.0, 'Location D', 'Notes for Plot D'),
('Plot E', 5, 'Clay', 20.0, 'Location E', 'Notes for Plot E'),
('Plot F', 6, 'Loamy', 18.0, 'Location F', 'Notes for Plot F'),
('Plot G', 7, 'Sandy', 14.0, 'Location G', 'Notes for Plot G'),
('Plot H', 8, 'Clay', 16.0, 'Location H', 'Notes for Plot H'),
('Plot I', 9, 'Loamy', 22.0, 'Location I', 'Notes for Plot I'),
('Plot J', 10, 'Sandy', 25.0, 'Location J', 'Notes for Plot J');


-- Inserting data into Equipment table
INSERT INTO Equipment (EquipmentID, EquipmentName, QuantityAvailable, PurchaseDate, WarrantyExpirationDate, MaintenanceDate) VALUES
(1, 'Tractor', 2, '2021-05-01', '2023-05-01', '2022-12-15'),
(2, 'Plow', 3, '2021-06-01', '2023-06-01', '2023-01-20'),
(3, 'Harvester', 1, '2021-07-10', '2023-07-10', '2023-02-28'),
(4, 'Seeder', 2, '2021-08-15', '2023-08-15', '2023-03-15'),
(5, 'Irrigation System', 1, '2021-09-20', '2023-09-20', '2023-04-20'),
(6, 'Fertilizer Spreader', 2, '2021-10-05', '2023-10-05', '2023-05-25'),
(7, 'Pruning Shears', 5, '2021-11-10', NULL, '2023-06-10'),
(8, 'Chain Saw', 2, '2021-12-15', NULL, '2023-07-15'),
(9, 'Wheelbarrow', 3, '2022-01-20', NULL, '2023-08-20'),
(10, 'Hoe', 5, '2022-02-25', NULL, '2023-09-25');

-- Inserting data into Livestock_Pens table
INSERT INTO Livestock_Pens (PenID, LivestockID, Size, Location) VALUES
(1, 1, 100, 'Barn A'),
(2, 2, 50, 'Coop A'),
(3, 3, 80, 'Sty A'),
(4, 4, 60, 'Enclosure A'),
(5, 5, 70, 'Pen A'),
(6, 6, 120, 'Stable A'),
(7, 7, 90, 'Pond Area'),
(8, 8, 110, 'Turkey Coop'),
(9, 9, 40, 'Rabbit Hutch'),
(10, 10, 85, 'Sheep Pen');

-- Inserting data into Orders table
INSERT INTO Orders (CustomerID, Date, Total_amount) VALUES
(1, '2023-03-01', 350.00),
(2, '2023-03-05', 480.00),
(3, '2023-03-10', 200.00),
(4, '2023-03-15', 600.00),
(5, '2023-03-20', 420.00),
(6, '2023-03-25', 150.00),
(7, '2023-03-30', 180.00),
(8, '2023-04-01', 300.00),
(9, '2023-04-05', 250.00),
(10, '2023-04-10', 400.00);

-- Inserting data into OrderItems table
INSERT INTO OrderItems (ItemID, OrderID, ProduceID, QuantityOfCrop, QuantityOfLivestock) VALUES
('A001', 1, 1, 0, 5),
('B002', 2, 2, 0, 10),
('C003', 3, 3, 0, 0),
('D004', 4, 4, 0, 8),
('E005', 5, 5, 0, 15),
('F006', 6, 6, 0, 0),
('G007', 7, 7, 0, 0),
('H008', 8, 8, 0, 0),
('I009', 9, 9, 0, 0),
('J010', 10, 10, 0, 5);

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
('EXP001', 'Vehicle Expenses', 150.00, 'Fuel and maintenance'),
('EXP002', 'Fertilizer Expenses', 200.00, 'Purchase of organic fertilizers'),
('EXP003', 'Chemicals Expenses', 100.00, 'Pesticides and herbicides'),
('EXP004', 'Rent', 500.00, 'Monthly rent for farmland'),
('EXP005', 'Other', 75.00, 'Miscellaneous expenses'),
('EXP006', 'Vehicle Expenses', 120.00, 'Repair costs'),
('EXP007', 'Fertilizer Expenses', 180.00, 'Additional soil nutrients'),
('EXP008', 'Chemicals Expenses', 90.00, 'New pest control chemicals'),
('EXP009', 'Rent', 550.00, 'Land lease payment'),
('EXP010', 'Other', 100.00, 'Supplies and miscellaneous costs');

-- Inserting data into Transactions table
INSERT INTO Transactions (TransactionID, OrderID, ExpenseID, TransactionType, Amount, Reciept_photo, TransactionDate) VALUES
('TR001', 1, 'EXP001', 'External Transaction', 150.00, NULL, '2023-03-02'),
('TR002', 2, 'EXP002', 'Cash Transaction', 200.00, NULL, '2023-03-06'),
('TR003', 3, 'EXP003', 'Internal Transaction', 100.00, NULL, '2023-03-11'),
('TR004', 4, 'EXP004', 'Non-Cash Transaction', 500.00, NULL, '2023-03-16'),
('TR005', 5, 'EXP005', 'Other', 75.00, NULL, '2023-03-21'),
('TR006', 6, 'EXP006', 'External Transaction', 120.00, NULL, '2023-03-26'),
('TR007', 7, 'EXP007', 'Cash Transaction', 180.00, NULL, '2023-03-31'),
('TR008', 8, 'EXP008', 'Internal Transaction', 90.00, NULL, '2023-04-02'),
('TR009', 9, 'EXP009', 'Non-Cash Transaction', 550.00, NULL, '2023-04-06'),
('TR010', 10, 'EXP010', 'Other', 100.00, NULL, '2023-04-11');

-- Inserting data into Works_On table
INSERT INTO Works_On (WorkerID, PlotID, PenID) VALUES
(1, 'Plot A', 1),
(2, 'Plot B', 2),
(3, 'Plot C', 3),
(4, 'Plot D', 4),
(5, 'Plot E', 5),
(6, 'Plot F', 6),
(7, 'Plot G', 7),
(8, 'Plot H', 8),
(9, 'Plot I', 9),
(10, 'Plot J', 10);

-- Retrieve all workers with their positions
SELECT WorkerID, Position FROM Workers;

-- Get the details of a specific worker along with their personal information
SELECT W.WorkerID, P.FirstName, P.LastName, P.Address, P.Email, W.Position, W.Salary
FROM Workers W
JOIN Person P ON W.PersonID = P.PersonID
WHERE W.WorkerID = 1;

-- List all customers with their contact numbers
SELECT C.CustomerID, P.FirstName, P.LastName, P.Address, P.Email, C.ContactNumber
FROM Customer C
JOIN Person P ON C.PersonID = P.PersonID;

-- Retrieve all livestock along with their types and breeds
SELECT L.LivestockID, P.ProductName, L.AnimalType, L.Breed
FROM Livestock L
JOIN Produce P ON L.ProduceID = P.ProduceID;

-- Find the total quantity of each produce available
SELECT ProductName, SUM(QuantityAvailable) AS TotalQuantity
FROM Produce
GROUP BY ProductName;

-- List all orders with the corresponding customer details
SELECT O.OrderID, O.Date, O.Total_amount, P.FirstName, P.LastName, P.Address, P.Email
FROM Orders O
JOIN Customer C ON O.CustomerID = C.CustomerID
JOIN Person P ON C.PersonID = P.PersonID;

-- Get the items in each order along with their quantities
SELECT O.OrderID, I.ItemID, P.ProductName, I.QuantityOfCrop, I.QuantityOfLivestock
FROM OrderItems I
JOIN Orders O ON I.OrderID = O.OrderID
JOIN Produce P ON I.ProduceID = P.ProduceID;

-- Find workers who have used tools and the corresponding equipment details
SELECT W.WorkerID, P.FirstName, P.LastName, T.ToolUseID, E.EquipmentName, T.QuantityAcquired, T.TimeAcquired, T.TimeReturned
FROM Workers W
JOIN Person P ON W.PersonID = P.PersonID
JOIN Tools_In_Use T ON W.WorkerID = T.WorkerID
JOIN Equipment E ON T.EquipmentID = E.EquipmentID;


-- Retrieve the expenses incurred along with their categories
SELECT * FROM Expenses_Record;

-- Get all transactions with their types and corresponding order or expense details
SELECT T.TransactionID, T.TransactionType, T.Amount, O.OrderID, E.ExpenseID, T.TransactionDate
FROM Transactions T
LEFT JOIN Orders O ON T.OrderID = O.OrderID
LEFT JOIN Expenses_Record E ON T.ExpenseID = E.ExpenseID;

-- List all workers with their positions and corresponding contact numbers
SELECT Workers.WorkerID, Person.FirstName, Person.LastName, Workers.Position, Customer.ContactNumber
FROM Workers
JOIN Person ON Workers.PersonID = Person.PersonID
LEFT JOIN Customer ON Workers.PersonID = Customer.PersonID;

-- Find the total quantity of crops and livestock ordered in each order
SELECT Orders.OrderID, SUM(OrderItems.QuantityOfCrop) AS TotalCropQuantity, SUM(OrderItems.QuantityOfLivestock) AS TotalLivestockQuantity
FROM Orders
LEFT JOIN OrderItems ON Orders.OrderID = OrderItems.OrderID
GROUP BY Orders.OrderID;

-- Retrieve the details of workers who have used equipment along with the equipment name
SELECT Workers.WorkerID, Person.FirstName, Person.LastName, Tools_In_Use.ToolUseID, Equipment.EquipmentName
FROM Workers
JOIN Person ON Workers.PersonID = Person.PersonID
JOIN Tools_In_Use ON Workers.WorkerID = Tools_In_Use.WorkerID
JOIN Equipment ON Tools_In_Use.EquipmentID = Equipment.EquipmentID;

-- Get a list of plots and pens along with the associated workers' names who are working on them
SELECT Works_On.PlotID, Works_On.PenID, Person.FirstName, Person.LastName
FROM Works_On
JOIN Workers ON Works_On.WorkerID = Workers.WorkerID
JOIN Person ON Workers.PersonID = Person.PersonID;

-- Retrieve the details of workers who have used equipment, including the equipment name and usage dates
SELECT Person.FirstName, Person.LastName, Equipment.EquipmentName, Tools_In_Use.TimeAcquired, Tools_In_Use.TimeReturned
FROM Person
JOIN Workers ON Person.PersonID = Workers.PersonID
JOIN Tools_In_Use ON Workers.WorkerID = Tools_In_Use.WorkerID
JOIN Equipment ON Tools_In_Use.EquipmentID = Equipment.EquipmentID;


-- View to get worker details with their positions
CREATE VIEW WorkerDetails AS
SELECT Person.FirstName, Person.LastName, Workers.Position
FROM Person
JOIN Workers ON Person.PersonID = Workers.PersonID;

-- View to get the total quantity and value of each produce item in stock
CREATE VIEW ProduceSummary AS
SELECT ProductName, SUM(QuantityAvailable) AS TotalQuantity, SUM(QuantityAvailable * Unit_price) AS TotalValue
FROM Produce
GROUP BY ProductName;

-- View to get the average salary for each position
CREATE VIEW AverageSalaryByPosition AS
SELECT Position, AVG(Salary) AS AverageSalary
FROM Workers
GROUP BY Position;

-- View to get details of orders with the total number of items in each order
CREATE VIEW OrderDetails AS
SELECT Orders.OrderID, Orders.Date, COUNT(OrderItems.ItemID) AS TotalItems
FROM Orders
LEFT JOIN OrderItems ON Orders.OrderID = OrderItems.OrderID
GROUP BY Orders.OrderID;

-- View to get a list of equipment names along with the number of times they have been used
CREATE VIEW EquipmentUsageCount AS
SELECT Equipment.EquipmentName, COUNT(Tools_In_Use.ToolUseID) AS UsageCount
FROM Equipment
LEFT JOIN Tools_In_Use ON Equipment.EquipmentID = Tools_In_Use.EquipmentID
GROUP BY Equipment.EquipmentName;


-- View to get the total expenses for each expense category
CREATE VIEW TotalExpensesByCategory AS
SELECT ExpenseCategory, SUM(Amount) AS TotalExpenses
FROM Expenses_Record
GROUP BY ExpenseCategory;

-- View to get details of workers who have used equipment, including the equipment name and usage dates
CREATE VIEW WorkerEquipmentUsage AS
SELECT Person.FirstName, Person.LastName, Equipment.EquipmentName, Tools_In_Use.TimeAcquired, Tools_In_Use.TimeReturned
FROM Person
JOIN Workers ON Person.PersonID = Workers.PersonID
JOIN Tools_In_Use ON Workers.WorkerID = Tools_In_Use.WorkerID
JOIN Equipment ON Tools_In_Use.EquipmentID = Equipment.EquipmentID;

-- View to get a list of plots and pens along with the associated workers' names who are working on them
CREATE VIEW WorksOnDetails AS
SELECT Works_On.PlotID, Works_On.PenID, Person.FirstName, Person.LastName
FROM Works_On
JOIN Workers ON Works_On.WorkerID = Workers.WorkerID
JOIN Person ON Workers.PersonID = Person.PersonID;






