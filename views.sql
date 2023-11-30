/*Default views*/

CREATE VIEW Workers_VIEW AS
SELECT WorkerID, FirstName, LastName, Address, Position, Salary
FROM Workers;
GO

CREATE VIEW Livestock_VIEW AS
SELECT LivestockID, AnimalType, Breed, QuantityAvailable, Unit_price, DateOfBirth, PurchaseDate, AnimalNotes
FROM Livestock;
GO

CREATE VIEW Crops_VIEW AS
SELECT CropID, CropName, QuantityAvailable, Unit_price, PlantingDate, HarvestDate, QuantityPlanted, QuantityHarvested, CropStatus, PlantNotes
FROM Crops;
GO

CREATE VIEW Equipment_VIEW AS
SELECT EquipmentID, EquipmentName, QuantityAvailable, PurchaseDate, WarrantyExpirationDate, MaintenanceDate
FROM Equipment
GO

CREATE VIEW Customers_VIEW AS
SELECT CustomerID,FirstName,LastName,ContactNumber,Email
FROM Customer
GO

CREATE VIEW Orders_VIEW AS
SELECT OrderID,CustomerID,Date,Total_amount
FROM Orders
GO

CREATE VIEW Expenses_VIEW AS
SELECT ExpenseID,ExpenseCategory,Amount,Notes
FROM Expenses
GO

/*Worker Views*/

CREATE VIEW Managers_VIEW AS
SELECT WorkerID, FirstName, LastName, Address, Position, Salary
FROM Workers
WHERE Position = 'Manager';
GO

CREATE VIEW Supervisors_VIEW AS
SELECT WorkerID, FirstName, LastName, Address, Position, Salary
FROM Workers
WHERE Position = 'Supervisor';
GO

CREATE VIEW Farmers_VIEW AS
SELECT WorkerID, FirstName, LastName, Address, Position, Salary
FROM Workers
WHERE Position = 'FarmWorker';
GO

CREATE VIEW Workers_Expanded_VIEW AS
SELECT WorkerID, FirstName, LastName, Address, Position, Salary, ToolUseID, EquipmentID, PlotID, PenID
FROM Workers, Tools_In_Use, Works_On;
GO

/* Livestock Views */
CREATE VIEW Livestock_Expanded_VIEW AS
SELECT LivestockID, AnimalType, Breed, QuantityAvailable, Unit_price, DateOfBirth, PurchaseDate, AnimalNotes, PenID, LivestockID, Location
FROM Livestock, Livestock_Pens;
GO

/* Crop Views */
CREATE VIEW Crops_Expanded_VIEW AS
SELECT CropID, PlotID, CropName, QuantityAvailable, Unit_price, PlantingDate, HarvestDate, QuantityPlanted, QuantityHarvested, CropStatus, PlantNotes, SoilType, Size, Location
FROM Crops, Crop_Plot;
GO

/* Customer and Order Views */
CREATE VIEW Customers_Expanded_VIEW AS
SELECT CustomerID, OrderID, FirstName,LastName,ContactNumber,Email,Date,Total_amount
FROM Customer, Orders;
GO

CREATE VIEW Orders_Expanded_VIEW AS
SELECT OrderID,CustomerID,Date,Total_amount,CropID,LivestockID,QuantityOfCrop,QuantityOfLivestock
FROM Orders, OrderItems
GO

/* Expense Views */
CREATE VIEW Expenses_Expanded_VIEW AS
SELECT ExpenseID,ExpenseCategory,Amount,Notes,TransactionID,AuthID,OrderID,Worker_payID,TransactionType,Reciept_photo,TransactionDate
FROM Expenses, Transactions
GO