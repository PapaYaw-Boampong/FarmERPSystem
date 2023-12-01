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
    ExpenseCategory ENUM('Vehicle Expenses', 'Fertilier Expenses', 'Chemicals Expenses', 'Rent', 'Other') NOT NULL,
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
    PRIMARY KEY (WorkerID, PlotID, PenID),
    FOREIGN KEY (WorkerID) REFERENCES Workers(WorkerID) ON DELETE CASCADE,
    FOREIGN KEY (PlotID) REFERENCES Crop_Plot(PlotID) ON DELETE CASCADE,
    FOREIGN KEY (PenID) REFERENCES Livestock_Pens(PenID) ON DELETE CASCADE
);