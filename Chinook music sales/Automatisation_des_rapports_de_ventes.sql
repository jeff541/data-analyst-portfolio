use Chinook;

-- Clients non américains
SELECT CustomerId,
       CONCAT(FirstName,' ',LastName) as full_name,
	   Country
FROM Customer
WHERE Country != 'Usa';

-- Clients brésiliens

SELECT CustomerId,
       CONCAT(FirstName,' ',LastName) as full_name,
	   Country
FROM Customer
WHERE Country = 'Brazil';

-- Factures des clients brésiliens

SELECT i.InvoiceId,
       CONCAT(c.FirstName,' ',c.LastName) as full_name,
	   i.InvoiceDate,
	   i.Total as amount,
	   i.BillingCountry
FROM Customer c
INNER JOIN Invoice i
ON c.CustomerId = i.CustomerId
WHERE c.Country = 'Brazil';

-- Liste des agents de ventes

SELECT  CONCAT(FirstName,' ',LastName) as sales_agent
FROM Employee
WHERE Title LIKE '%sales%' 
AND title LIKE '%agent%'

-- Pays unique présent dans les factures

SELECT DISTINCT(billingcountry)
FROM Invoice;

-- Factures par agent de ventes

SELECT   CONCAT(e.FirstName,' ',e.LastName) as sales_agent, i.*
FROM Employee e
INNER JOIN Customer c
ON c.SupportRepId = e.EmployeeId
INNER JOIN Invoice i
ON i.CustomerId = c.CustomerId
WHERE e.Title LIKE '%sales%' 
AND e.title LIKE '%agent%'
ORDER BY sales_agent


-- Détails des factures

SELECT   CONCAT(e.FirstName,' ',e.LastName) as sales_agent, CONCAT(c.FirstName,' ',c.LastName) as customer, i.InvoiceId, i.BillingCountry, i.total
FROM Employee e
INNER JOIN Customer c
ON c.SupportRepId = e.EmployeeId
INNER JOIN Invoice i
ON i.CustomerId = c.CustomerId
WHERE e.Title LIKE '%sales%' 
AND e.title LIKE '%agent%'
ORDER BY total DESC

-- Ventes par années

SELECT count(*) as total_ventes,
	   sum(total) as montant_total_ventes,
	   MONTH(Invoicedate) as billing_month,
	   YEAR(Invoicedate) as billing_year
	  
from Invoice
GROUP BY MONTH(Invoicedate),  YEAR(Invoicedate) 

-- Nombre d'élément par facture
SELECT  InvoiceId, SUM(Quantity) as number_of_items
FROM InvoiceLine
GROUP BY InvoiceId
ORDER BY InvoiceId ASC

-- Nom des morceaux de chaque ligne de facture

SELECT t.name,
       i.*
FROM Track t
INNER JOIN InvoiceLine i
ON t.TrackId = i.TrackId

-- Nom des morçeau et artist de chaque ligne de facture

SELECT t.name as track_name,
	   a.name as artist_name,
       i.*
FROM Track t
INNER JOIN InvoiceLine i
ON t.TrackId = i.TrackId
INNER JOIN Album al
ON al.AlbumId = t.AlbumId
INNER JOIN Artist a
ON al.ArtistId = a.ArtistId

-- Nombre de facture par pays

SELECT  BillingCountry,
        COUNT(*) as total_invoice
FROM Invoice
GROUP BY BillingCountry
ORDER BY total_invoice DESC;

-- Nombre de morceaux par playlist

SELECT p.name,
	   COUNT(*) as total_track
FROM Playlist p
INNER JOIN PlaylistTrack pt
ON p.PlaylistId = pt.PlaylistId
INNER JOIN Track t
ON pt.TrackId = t.TrackId
GROUP BY p.name
ORDER BY total_track DESC;

-- Liste des morceaux 

SELECT t.name as track_name,
	   m.name as media_type,
	   g.name as gender_name	  
FROM Track t
INNER JOIN MediaType m
ON t.MediaTypeId = m.MediaTypeId
INNER JOIN genre g
ON g.GenreId = t.GenreId;

-- Factures et articles 

SELECT InvoiceId, SUM(quantity) as total_qty
FROM InvoiceLine
GROUP BY InvoiceId
ORDER BY  InvoiceId

-- Ventes par agent de vente
SELECT  e.EmployeeId, CONCAT(e.FirstName,' ',e.LastName) as sales_agent, COUNT(i.InvoiceId) as total_sales
FROM Employee e
INNER JOIN Customer c
ON c.SupportRepId = e.EmployeeId
INNER JOIN Invoice i
ON i.CustomerId = c.CustomerId
WHERE e.Title LIKE '%sales%' 
AND e.title LIKE '%agent%'
GROUP BY e.EmployeeId, CONCAT(e.FirstName,' ',e.LastName)

-- Ventes par agent de vente
SELECT  e.EmployeeId, CONCAT(e.FirstName,' ',e.LastName) as sales_agent, COUNT(i.InvoiceId) as total_sales
FROM Employee e
INNER JOIN Customer c
ON c.SupportRepId = e.EmployeeId
INNER JOIN Invoice i
ON i.CustomerId = c.CustomerId
WHERE e.Title LIKE '%sales%' 
AND e.title LIKE '%agent%'
GROUP BY e.EmployeeId, CONCAT(e.FirstName,' ',e.LastName);

-- Meilleur agent 2024
WITH Rankedsales AS ( 
SELECT  e.EmployeeId,
        CONCAT(e.FirstName,' ',e.LastName) as sales_agent,
		COUNT(i.InvoiceId) as total_sales,
		DENSE_RANK() OVER ( ORDER BY COUNT(i.InvoiceId) DESC) as Rank_sale
FROM Employee e
INNER JOIN Customer c
ON c.SupportRepId = e.EmployeeId
INNER JOIN Invoice i
ON i.CustomerId = c.CustomerId
WHERE e.Title LIKE '%sales%' 
AND e.title LIKE '%agent%'
AND YEAR(i.InvoiceDate) = 2024
GROUP BY e.EmployeeId, CONCAT(e.FirstName,' ',e.LastName))
SELECT EmployeeId, sales_agent, total_sales
FROM RankedSales
WHERE Rank_sale = 1;

-- Meilleur agent 2025
WITH Rankedsales AS ( 
SELECT  e.EmployeeId,
        CONCAT(e.FirstName,' ',e.LastName) as sales_agent,
		COUNT(i.InvoiceId) as total_sales,
		DENSE_RANK() OVER ( ORDER BY COUNT(i.InvoiceId) DESC) as Rank_sale
FROM Employee e
INNER JOIN Customer c
ON c.SupportRepId = e.EmployeeId
INNER JOIN Invoice i
ON i.CustomerId = c.CustomerId
WHERE e.Title LIKE '%sales%' 
AND e.title LIKE '%agent%'
AND YEAR(i.InvoiceDate) = 2025
GROUP BY e.EmployeeId, CONCAT(e.FirstName,' ',e.LastName))
SELECT EmployeeId, sales_agent, total_sales
FROM RankedSales
WHERE Rank_sale = 1;


-- Meilleur agent Global
WITH Rankedsales AS ( 
SELECT  e.EmployeeId,
        CONCAT(e.FirstName,' ',e.LastName) as sales_agent,
		COUNT(i.InvoiceId) as total_sales,
		DENSE_RANK() OVER ( ORDER BY COUNT(i.InvoiceId) DESC) as Rank_sale
FROM Employee e
INNER JOIN Customer c
ON c.SupportRepId = e.EmployeeId
INNER JOIN Invoice i
ON i.CustomerId = c.CustomerId
WHERE e.Title LIKE '%sales%' 
AND e.title LIKE '%agent%'
GROUP BY e.EmployeeId, CONCAT(e.FirstName,' ',e.LastName))
SELECT EmployeeId, sales_agent, total_sales
FROM RankedSales
WHERE Rank_sale = 1;

-- Client par agent de ventes

SELECT   CONCAT(e.FirstName,' ',e.LastName) as sales_agent, COUNT(c.SupportRepId) as total_customers
FROM Employee e
INNER JOIN Customer c
ON c.SupportRepId = e.EmployeeId
WHERE e.Title LIKE '%sales%' 
AND e.title LIKE '%agent%'
GROUP BY  CONCAT(e.FirstName,' ',e.LastName);

-- Ventes totales par pays 

SELECT  BillingCountry,
        SUM(total) as total_sales
FROM Invoice
GROUP BY BillingCountry
ORDER BY total_sales DESC;

-- Morceau le plus acheté en 2023
WITH track_ranking AS( SELECT t.name,
	   SUM(il.quantity) AS QTE,
	   RANK() OVER (ORDER BY SUM(il.quantity) DESC) as position
FROM track t
INNER JOIN InvoiceLine il
ON il.TrackId = t.TrackId
INNER JOIN Invoice i
ON i.InvoiceId = il.InvoiceId
WHERE YEAR(i.InvoiceDate) = 2023
GROUP BY t.name)
SELECT name, QTE
FROM track_ranking
WHERE position = 1;

-- Top 5 des morceaux les plus achetés

WITH track_ranking AS( SELECT t.name,
	   SUM(il.quantity) AS QTE,
	   ROW_NUMBER() OVER (ORDER BY SUM(il.quantity) DESC) as position
FROM track t
INNER JOIN InvoiceLine il
ON il.TrackId = t.TrackId
INNER JOIN Invoice i
ON i.InvoiceId = il.InvoiceId
GROUP BY t.name)
SELECT name, QTE
FROM track_ranking
WHERE position <= 5 ;

-- Top 3 des artistes les plus vendus

WITH artist_ranking AS( SELECT 
	   a.name as artist_name,
	   SUM(il.quantity) AS QTE,
	   ROW_NUMBER() OVER (ORDER BY SUM(il.quantity) DESC) as position
FROM track t
INNER JOIN InvoiceLine il
ON il.TrackId = t.TrackId
INNER JOIN Invoice i
ON i.InvoiceId = il.InvoiceId
INNER JOIN Album al
ON al.AlbumId = t.AlbumId
INNER JOIN Artist a
ON al.ArtistId = a.ArtistId
GROUP BY a.name)
SELECT artist_name, QTE
FROM artist_ranking
WHERE position <= 3 ;


-- Type de média le plus acheté

WITH media_type_ranking AS( SELECT 
	   m.name as media_type,
	   SUM(il.quantity) AS QTE,
	   RANK() OVER (ORDER BY SUM(il.quantity) DESC) as position
FROM track t
INNER JOIN InvoiceLine il
ON il.TrackId = t.TrackId
INNER JOIN Invoice i
ON i.InvoiceId = il.InvoiceId
INNER JOIN MediaType m
ON m.MediaTypeId = t.MediaTypeId
GROUP BY m.name)
SELECT media_type, QTE
FROM media_type_ranking
WHERE position = 1 ;