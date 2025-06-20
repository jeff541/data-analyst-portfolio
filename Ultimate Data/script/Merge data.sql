Use Ultimate;
Go

SELECT *
INTO dbo.SalesData
FROM (
    SELECT * FROM dbo.SalesCanada
    UNION ALL
    SELECT * FROM dbo.SalesChina
    UNION ALL
    SELECT * FROM dbo.SalesIndia
    UNION ALL
    SELECT * FROM dbo.SalesNigeria
    UNION ALL
    SELECT * FROM dbo.SalesUK
    UNION ALL
    SELECT * FROM dbo.SalesUS
) AS CombinedTables;
ALTER TABLE SalesData ALTER COLUMN [date] date;
