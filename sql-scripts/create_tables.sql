USE RetailDB;
GO

-- Preparing the Data For Tableau

CREATE TABLE Gold_ProductPerformance (
    Description NVARCHAR(250),
    TotalQuantitySold INT,
    TotalRevenue DECIMAL(18, 2), 
    LastRefreshed DATETIME
);
GO
