-- Rechecherchons les valeurs nulles
USE Ultimate;
SELECT * 
FROM dbo.SalesData
WHERE
    Country is null
	or PricePerUnit is null
	or QuantityPurchased is null
	or CostPrice is null
	or DiscountApplied is null;

-- Nous avons 2 valeurs nulles une dans la colonne QuantityPurchased et l'autre dans PricePerUnit

-- Remplissons le vide de QuantityPurchased

UPDATE dbo.SalesData
SET QuantityPurchased = 3
WHERE TransactionID = '00a30472-89a0-4688-9d33-67ea8ccf7aea';

-- Remplissons le vide de PricePerUnit par la moyenne des prix

update dbo.SalesData
set PricePerUnit = (
    SELECT AVG(PricePerUnit)
	FROM dbo.SalesData
	WHERE PricePerUnit is not null
)
where TransactionID = '001898f7-b696-4356-91dc-8f2b73d09c63';


-- Rechecherchons les doublons
SELECT TransactionID, Count(*)
FROM SalesData
group by TransactionID
having count(*)>1;

-- Ajoutons la colonne TotalAmount
ALTER TABLE dbo.SalesData
ADD TotalAmount Numeric(10,2);

-- Remplissons la colonne TotalAmount
UPDATE dbo.SalesData
SET TotalAmount =(PricePerUnit * QuantityPurchased) - DiscountApplied;


-- Ajoutons la colonne Profit
ALTER TABLE dbo.SalesData
ADD Profit Numeric(10,2);

-- Remplissons la colonne Profit
UPDATE dbo.SalesData
SET Profit = TotalAmount - (CostPrice * QuantityPurchased);