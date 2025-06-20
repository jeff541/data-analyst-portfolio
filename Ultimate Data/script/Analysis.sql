-- Analyse des ventes de la semaine allant du '2025-02-10' au '2025-02-14'

-- Revenu et Profit par pays sur la période dédiée
Use Ultimate;
SELECT 
    Country, 
    SUM(TotalAmount) AS TotaRevenue,
    SUM(Profit) AS TotalProfit
FROM dbo.SalesData
WHERE [Date] BETWEEN '2025-02-10' AND '2025-02-14'
GROUP BY Country
ORDER BY SUM(TotalAmount) DESC;


-- Top 5 des produits sur la période dédiée
SELECT TOP 5
    ProductName, 
    SUM(QuantityPurchased) AS TotalUnitsSold
FROM dbo.SalesData
WHERE [Date] BETWEEN '2025-02-10' AND '2025-02-14'
GROUP BY ProductName
ORDER BY SUM(QuantityPurchased)  DESC
;

-- Top 5 des vendeurs sur la période dédiée

SELECT TOP 5
    SalesRepresentative, 
    SUM(TotalAmount) AS TotalSales
FROM dbo.SalesData
WHERE [Date] BETWEEN '2025-02-10' AND '2025-02-14'
GROUP BY SalesRepresentative
ORDER BY TotalSales DESC
;

-- top 5 des lieux de stockage les plus profitables
SELECT 
	TOP 5
    StoreLocation, 
    SUM(TotalAmount) AS TotalSales,
    SUM(Profit) AS TotalProfit
FROM dbo.SalesData
WHERE [Date] BETWEEN '2025-02-10' AND '2025-02-14'
GROUP BY StoreLocation
ORDER BY TotalSales DESC
;
-- Indices de performances sur la période

SELECT 
    MIN(TotalAmount) AS MinSalesValue,
    MAX(TotalAmount) AS MaxSalesValue,
    AVG(TotalAmount) AS AvgSalesValue,
    SUM(TotalAmount) AS TotalSalesValue,
    MIN(Profit) AS MinProfit,
    MAX(Profit) AS MaxProfit,
    AVG(Profit) AS AvgProfit,
    SUM(Profit) AS TotalProfit
FROM dbo.SalesData
WHERE [Date] BETWEEN '2025-02-10' AND '2025-02-14'


SELECT * from dbo.SalesData;