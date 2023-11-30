/*Worker sample records*/
INSERT INTO Workers (WorkerID, FirstName, LastName, Address, Position, Salary)
VALUES (1, "Forster", "Meringue", "25 Palm Lane, ABH County Square", "Supervisor", 80000),
(2, "Ludwig", "Exsecrab", "512 Hunter's Lane, Cainhurst", "Manager", 34500),
(3, "Gherman", "Venat", "12HD, Old Yharnam", "Manager", 128000),
(4, "Jeremy", "Reiner", "21 Edgehill RD, Stow", "Manager", 79000),
(5, "Kwame", "Mukisa", "Mbale", "FarmWorker", 20000),
(6, "Rob", "Lucci", "Shipyard, Water 7", "FarmWorker", 15000);

/*Livestock Sample Records*/
INSERT INTO Livestock (LivestockID, AnimalType, Breed, QuantityAvailable, Unit_price, DateOfBirth, PurchaseDate, AnimalNotes)
VALUES (1, "Cow", "Hereford Cattle", 35, 2000, NULL, '2014-10-31', NULL),
(2, "Cow", "Bos taurus", 50, 800, NULL, '2011-02-22', 'Black and white markings'),
(3, "Chicken", "Leghorn", 250, 24, NULL, '2013-08-13', NULL),
(4, "Sheep", "Merino", 100, 50, NULL, '2016-06-21', NULL),
(5, "Pig", "Berkshire", 120, 40, NULL, '2013-04-13', NULL);

/*Crop Sample Records*/
INSERT INTO Crops (CropID, CropName, QuantityAvailable, Unit_price, PlantingDate, HarvestDate, QuantityPlanted, QuantityHarvested, CropStatus, PlantNotes)
VALUES (1, "Barley", 60, 2.5, '2009-05-23', NULL, 210, 150, "Growing", NULL),
(2, 'Tomatoes', 100, 2, '2022-04-01', '2022-06-15', 80, 0, 'Growing', 'Planted in greenhouse'),
(3, 'Wheat', 200, 1.5, '2022-05-01', '2022-07-30', 150, 0, 'Growing', 'Field near the barn');

/*Crop_Plot Sample Records*/
INSERT INTO Crop_Plot (PlotID, CropID, SoilType, Size, Location, Notes)
VALUES ("Z2", 1, "Loamy", 100, "Valley field", NULL),
('A1', 2, 'Loamy', 10, 'Greenhouse', 'Plot for tomatoes'),
('B2', 3, 'Sandy', 20, 'Field', 'Large wheat field');

/* Equipment Sample Records */
INSERT INTO Equipment(EquipmentID, EquipmentName, QuantityAvailable, PurchaseDate, WarrantyExpirationDate, MaintenanceDate)
VALUES (1, "Tractor", 10, '2009-05-23', '2029-06-01', '2024-06-17'),
(2, 'Plow', 1, '2022-02-05', '2024-02-05', '2022-08-15');

/* Livestock_Pens Sample Records */
INSERT INTO Livestock_Pens(PenID,LivestockID,Size,Location)
VALUES (1, 4, 150, "Ranch fields"),
(2, 1, 100, 'Barn A'),
(3, 2, 50, 'Chicken Coop');

/* Customer Sample Records */
INSERT INTO Customer(CustomerID,FirstName,LastName,ContactNumber,Email)
VALUES(1, 'Alice', 'Johnson', '555-1234', 'alice@email.com'),
(2, 'Bob', 'Smith', '555-5678', 'bob@email.com'),
(3, "Joshua", "Graham", "999-934-2345", "jgraham@gmail.com");

/*Order Sample Records*/
INSERT INTO Orders(OrderID,CustomerID,Date,Total_amount)
VALUES(1, 1, '2021-11-30', 40000),
(2, 1, '2022-07-01', 50),
(3, 2, '2022-08-15', 30);

/*OrderItems Sample Records*/
INSERT INTO OrderItems(ItemID,OrderID,CropID,LivestockID,QuantityOfCrop,QuantityOfLivestock)
VALUES("Z001", 1, 2, 3, 20, 20),
('A001', 1, 1, NULL, 5, NULL),
('B002', 2, NULL, 2, NULL, 10);

/*Tools_In_Use Sample Records*/
INSERT INTO Tools_In_Use(ToolUseID,WorkerID,EquipmentID,QuantityAcquired,TimeAcquired,TimeReturned)
VALUES("T005", 6, 1, 8, '2023-11-09', '2023-11-21'),
('T001', 1, 1, 1, '2022-05-01', '2022-05-02'),
('T002', 2, 2, 1, '2022-06-01', '2022-06-01');

/*Expenses_record Sample Records*/
INSERT INTO Expenses_Record(ExpenseID,ExpenseCategory,Amount,Notes)
VALUES("E001", "Chemicals Expenses", 25, "DMT; pesticide"),
('E002', 'Vehicle Expenses', 200, 'Vehicle Expenses'),
('E003', 'Rent', 500, 'Monthly rent for the farm'),
("E004", "Other", 3, "Old Blood; Keep away from Ludwig"),
("E008", "Other", 1, "Pluton schematic; Keep away from Lucci");

/*Transactions Sample Records*/
INSERT INTO Transactions(TransactionID,AuthID,OrderID,Worker_payID,ExpenseID,TransactionType,Amount,Reciept_photo,TransactionDate)
VALUES("TR003", 3, 1, 3, "004", "External Transaction", 2000, NULL, '2021-11-30'),
('TR001', 1, 1, NULL, 'E001', 'Cash Transaction', 50, NULL, '2022-07-05'),
('TR002', 2, 2, NULL, 'E002', 'Non-Cash Transaction', 30, NULL, '2022-08-20');

/*Works_On Sample Records*/
INSERT INTO Works_On(WorkerID,PlotID,PenID)
VALUES(6, "001", 1),
(1, 'A1', NULL),
(2, NULL, 1);