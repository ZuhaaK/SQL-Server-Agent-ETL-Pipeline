USE RetailDB;
GO

-- Wrap the Transformation into a Procedure
CREATE PROCEDURE dbo.RefreshTableauBackend
AS
BEGIN
    SET NOCOUNT ON;

    -- Wipe out yesterday's pre-aggregated data
    TRUNCATE TABLE Gold_ProductPerformance;

    -- Clean, transform, and load the 541,909 rows into a tight summary
    INSERT INTO Gold_ProductPerformance (Description, TotalQuantitySold, TotalRevenue, LastRefreshed)
    SELECT 
        ISNULL(Description, 'Unknown Product') AS Description,
        SUM(Quantity) AS TotalQuantitySold,
        SUM(CAST(Quantity AS DECIMAL(18,2)) * CAST(UnitPrice AS DECIMAL(18,2))) AS TotalRevenue,
        GETDATE() AS LastRefreshed
    FROM Bronze_OnlineRetail
    WHERE Quantity > 0               -- Filters out return/cancellation anomalies!
      AND UnitPrice > 0.00           -- Filters out free samples or broken price logs
      AND Description IS NOT NULL    -- Drops rows missing descriptions
    GROUP BY Description;
END;
GO
