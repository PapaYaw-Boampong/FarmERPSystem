DROP DATABASE if exists farmERPSystem;
Create DataBase farmERPSystem;
Use farmERPSystem;

-- Workers Table
CREATE TABLE IF NOT EXISTS Workers (
    WorkerID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Address VARCHAR(255),
    Position ENUM('FarmWorker', 'Supervisor', 'Manager', 'Other'),
    Salary DOUBLE
);

-- Livestock Table
CREATE TABLE IF NOT EXISTS Livestock (
    LivestockID INT PRIMARY KEY,
    AnimalType VARCHAR(255),
    Breed VARCHAR(255),
    QuantityAvailable INT,
    Unit_price DOUBLE,
    DateOfBirth DATETIME,
    PurchaseDate DATETIME,
    AnimalNotes TEXT
);

-- Crops Table
CREATE TABLE IF NOT EXISTS Crops (
    CropID INT PRIMARY KEY,
    CropName VARCHAR(255),
    QuantityAvailable INT,
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
    SoilType ENUM('Type1', 'Type2', 'Type3'),
    Size DOUBLE,
    Location VARCHAR(255),
    Notes TEXT,
    FOREIGN KEY (CropID) REFERENCES Crops(CropID)
);

-- Equipment Table
CREATE TABLE IF NOT EXISTS Equipment (
    EquipmentID INT PRIMARY KEY,
    EquipmentName VARCHAR(255),
    QuantityAvailable INT,
    PurchaseDate DATETIME,
    WarrantyExpirationDate DATETIME,
    MaintenanceDate DATETIME
);

-- Livestock_Pens Table
CREATE TABLE IF NOT EXISTS Livestock_Pens (
    PenID INT PRIMARY KEY,
    LivestockID INT,
    Size DOUBLE,
    Location VARCHAR(255),
    FOREIGN KEY (LivestockID) REFERENCES Livestock(LivestockID)
);

-- Customer Table
CREATE TABLE IF NOT EXISTS Customer (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    ContactNumber VARCHAR(255),
    Email VARCHAR(255)
);

-- Orders Table
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    Date DATETIME,
    Total_amount DOUBLE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- OrderItems Table
CREATE TABLE IF NOT EXISTS OrderItems (
    ItemID VARCHAR(255) PRIMARY KEY,
    OrderID INT,
    CropID INT,
    LivestockID INT,
    QuantityOfCrop INT,
    QuantityOfLivestock INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (CropID) REFERENCES Crops(CropID),
    FOREIGN KEY (LivestockID) REFERENCES Livestock(LivestockID)
);

-- Tools_In_Use Table
CREATE TABLE IF NOT EXISTS Tools_In_Use (
    ToolUseID VARCHAR(255) PRIMARY KEY,
    WorkerID INT,
    EquipmentID INT,
    QuantityAcquired INT,
    TimeAcquired DATETIME,
    TimeReturned DATETIME,
    FOREIGN KEY (WorkerID) REFERENCES Workers(WorkerID),
    FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID)
);

-- Expenses_Record Table
CREATE TABLE IF NOT EXISTS Expenses_Record (
    ExpenseID VARCHAR(255) PRIMARY KEY,
    ExpenseCategory ENUM('Category1', 'Category2', 'Category3'),
    Amount DOUBLE,
    Notes TEXT
);

-- Transactions Table
CREATE TABLE IF NOT EXISTS Transactions (
    TransactionID VARCHAR(255) PRIMARY KEY,
    AuthID INT NOT NULL,
    OrderID INT,
    Worker_payID INT,
    ExpenseID VARCHAR(255),
    TransactionType VARCHAR(255),
    Amount DOUBLE,
    Reciept_photo BLOB,
    TransactionDate DATETIME,
    FOREIGN KEY (AuthID) REFERENCES Workers(WorkerID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (Worker_payID) REFERENCES Workers(WorkerID),
    FOREIGN KEY (ExpenseID) REFERENCES Expenses_Record(ExpenseID)
);

-- Works_On Table
CREATE TABLE IF NOT EXISTS Works_On (
    WorkerID INT,
    PlotID VARCHAR(255),
    PenID INT,
    PRIMARY KEY (WorkerID, PlotID, PenID),
    FOREIGN KEY (WorkerID) REFERENCES Workers(WorkerID),
    FOREIGN KEY (PlotID) REFERENCES Crop_Plot(PlotID),
    FOREIGN KEY (PenID) REFERENCES Livestock_Pens(PenID)
);
