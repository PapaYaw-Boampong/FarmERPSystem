Use farmERPSystem;

-- Workers Table
CREATE TABLE IF NOT EXISTS Workers (
    WorkerID VARCHAR(255) PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Address VARCHAR(255),
    Position ENUM('FarmWorker', 'Supervisor', 'Manager', 'Other'),
    Salary DOUBLE
);

-- Livestock Table
CREATE TABLE IF NOT EXISTS Livestock (
    LivestockID VARCHAR(255) PRIMARY KEY,
    AnimalType VARCHAR(255),
    Breed VARCHAR(255),
    QuantityAvailable DOUBLE,
    Unit_price DOUBLE,
    DateOfBirth DATETIME,
    PurchaseDate DATETIME,
    AnimalNotes TEXT
);

-- Crops Table
CREATE TABLE IF NOT EXISTS Crops (
    CropID VARCHAR(255) PRIMARY KEY,
    CropName VARCHAR(255),
    CropType ENUM('TypeA', 'TypeB', 'TypeC'),
    QuantityAvailable DOUBLE,
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
    CropID VARCHAR(255),
    SoilType ENUM('Type1', 'Type2', 'Type3'),
    Size VARCHAR(255),
    Location VARCHAR(255),
    Notes TEXT,
    FOREIGN KEY (CropID) REFERENCES Crops(CropID)
);

-- Equipment Table
CREATE TABLE IF NOT EXISTS Equipment (
    EquipmentID VARCHAR(255) PRIMARY KEY,
    EquipmentName VARCHAR(255),
    QuantityAvailable DOUBLE,
    PurchaseDate DATETIME,
    WarrantyExpirationDate DATETIME,
    MaintenanceDate DATETIME
);

-- Livestock_Pens Table
CREATE TABLE IF NOT EXISTS Livestock_Pens (
    PenID VARCHAR(255) PRIMARY KEY,
    LivestockID VARCHAR(255),
    Size VARCHAR(255),
    Location VARCHAR(255),
    FOREIGN KEY (LivestockID) REFERENCES Livestock(LivestockID)
);

-- Customer Table
CREATE TABLE IF NOT EXISTS Customer (
    CustomerID VARCHAR(255) PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    ContactNumber VARCHAR(255),
    Email VARCHAR(255)
);

-- Orders Table
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID VARCHAR(255),
    Date DATETIME,
    Total_amount DOUBLE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- OrderItems Table
CREATE TABLE IF NOT EXISTS OrderItems (
    ItemID VARCHAR(255) PRIMARY KEY,
    OrderID INT,
    ProduceID VARCHAR(255),
    LivestockID VARCHAR(255),
    Quantity DOUBLE,
    Amount DOUBLE,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProduceID) REFERENCES Crops(CropID),
    FOREIGN KEY (LivestockID) REFERENCES Livestock(LivestockID)
);

-- Tools_In_Use Table
CREATE TABLE IF NOT EXISTS Tools_In_Use (
    ToolUseID VARCHAR(255) PRIMARY KEY,
    WorkerID VARCHAR(255),
    EquipmentID VARCHAR(255),
    TimeAcquired DATETIME,
    TimeReturned DATETIME,
    FOREIGN KEY (WorkerID) REFERENCES Workers(WorkerID),
    FOREIGN KEY (EquipmentID) REFERENCES Equipment(EquipmentID)
);

-- Expenses_Record Table
CREATE TABLE IF NOT EXISTS Expenses_Record (
    ExpenseID VARCHAR(255) PRIMARY KEY,
    ExpenseCategoryID ENUM('Category1', 'Category2', 'Category3'),
    Amount DOUBLE,
    Notes TEXT
);

-- Transactions Table
CREATE TABLE IF NOT EXISTS Transactions (
    TransactionID VARCHAR(255) PRIMARY KEY,
    AuthID VARCHAR(255),
    OrderID INT,
    Worker_payID VARCHAR(255),
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
    WorkerID VARCHAR(255),
    PlotID VARCHAR(255),
    PenID VARCHAR(255),
    PRIMARY KEY (WorkerID, PlotID, PenID),
    FOREIGN KEY (WorkerID) REFERENCES Workers(WorkerID),
    FOREIGN KEY (PlotID) REFERENCES Crop_Plot(PlotID),
    FOREIGN KEY (PenID) REFERENCES Livestock_Pens(PenID)
);
