-- 1- Liste des clients français.;
SELECT CompanyName AS Société, ContactName AS contact, ContactTitle AS Fonction, Phone AS Téléphone
FROM customers
WHERE country = 'France'
ORDER BY Société;

-- 2- Liste des produits vendus par le fournisseur "Exotic Liquids".;
SELECT ProductName AS produit, UnitPrice AS Prix
FROM products
JOIN suppliers ON suppliers.SupplierID = products.supplierId
WHERE suppliers.supplierID = (
SELECT supplierID
FROM suppliers
WHERE CompanyName = 'Exotic Liquids');

-- 3- Nombre de produits mis à disposition par les fournisseurs français (tri par nombre de produits décroissant).;
SELECT CompanyName AS Fournisseur, COUNT(ProductID) AS Nbre_produits
FROM suppliers
JOIN products ON products.SupplierID = suppliers.SupplierID
WHERE Country = 'France'
GROUP BY Fournisseur
ORDER BY Nbre_produits DESC;

-- 4- Liste des clients français ayant passé plus de 10 commandes.;
SELECT CompanyName AS Client, COUNT(orderID) AS Nbre_commandes
FROM customers
JOIN orders ON orders.CustomerID = customers.CustomerID
WHERE Country = 'France'
GROUP BY CLIENT
HAVING Nbre_commandes > 10;

-- 5- Liste des clients dont le montant cumulé de toutes les commandes passées est supérieur à 30000€.;
SELECT CompanyName AS CLIENT, SUM(UnitPrice*Quantity) AS CA, Country AS Pays
FROM customers
JOIN orders ON orders.CustomerID = customers.CustomerID
JOIN order_details ON order_details.OrderID = orders.OrderID
GROUP BY CLIENT
HAVING CA > 30000
ORDER BY CA DESC;

-- 6- Liste des pays dans lesquels des produits fournis par "Exotic Liquids" ont été livrés.;
SELECT DISTINCT ShipCountry AS Pays
FROM orders
JOIN order_details ON order_details.OrderID = orders.OrderID
JOIN products ON products.ProductID = order_details.ProductID
JOIN suppliers ON suppliers.SupplierID = products.SupplierID
WHERE suppliers.SupplierID = (
SELECT SupplierID
FROM suppliers
WHERE CompanyName = "Exotic Liquids")
ORDER BY Pays;

-- 7- Chiffre d'affaires global sur les ventes de 1997.;
SELECT SUM(UnitPrice*Quantity) AS 'Montant Ventes 97'
FROM order_details
JOIN orders ON orders.OrderID = order_details.OrderID
WHERE YEAR(OrderDate) = 1997;

-- 8- Chiffre d'affaires détaille par mois, sur les ventes de 1997.;
SELECT MONTH(OrderDate) AS 'Mois 97', SUM(UnitPrice*Quantity) AS 'Montant ventes'
FROM order_details
JOIN orders ON orders.OrderID = order_details.OrderID
WHERE YEAR(OrderDate) = 1997
GROUP BY MONTH(OrderDate);

-- 9- A Quand remonte la dernière commande du client nommé "Du monde entier".;
SELECT OrderDate AS 'Date de dernière commande'
FROM orders
JOIN customers ON customers.CustomerID = orders.CustomerID
WHERE customers.CustomerID = (
SELECT CustomerID
FROM customers
WHERE CompanyName = 'Du monde entier')
ORDER BY OrderDate DESC
LIMIT 1;

-- 10- Quel est le délai moyen de livraison en jours.;
SELECT ROUND(AVG(DATEDIFF(ShippedDate, OrderDate))) AS 'Délai moyen de livraison en jours'
FROM orders;