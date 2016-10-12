--Lab 6
--Jessica Rieger
--10/08/2016

--1. Display the name and city of customers who live in any city that makes the most different kinds of products. 
--(There are two cities that make the most different products. Return the name and city of customers from either one of those.)
Select name, city
FROM Customers
WHERE city in (Select city
	       From Products
	       group by city
	       order by count(pid) DESC
	       limit 1
	       );

   
--2. Display the names of products whose priceUSD is strictly below the average priceUSD, in reverse-alphabetical order.

SELECT name
FROM Products
WHERE priceUSD < (SELECT avg(priceUSD)
		   		  FROM Products)
ORDER BY name DESC;

--3. Display the customer name, pid ordered, and the total for all orders, sorted by total from low to high.

select c2.name, c1.cid, o.pid, sum(totalUSD) as total
FROM Customers c1, Orders o, Customers c2 
WHERE c2.cid = c1.cid
  AND c1.cid = o.cid
GROUP BY c1.cid, o.pid, c2.name
ORDER BY total ASC;

--4. Display all customer names (in alphabetical order) and their total ordered, and nothing more. Use coalesce to avoid showing NULLs.
SELECT Customers.name, coalesce(sum(totalUSD), '0') as sumToTalUSD
FROM Customers Left Outer Join Orders ON Customers.cid = Orders.cid
GROUP BY Orders.cid, customers.name
ORDER BY Customers.name ASC;


--5. Display the names of all customers who bought products from agents based in
-- New York along with the names of the products they ordered, 
--and the names of the agents who sold it to them.

SELECT Customers.name as Cname, Agents.name as Aname, Products.name as Pname
FROM Customers, Agents, Orders, Products
WHERE Customers.cid = Orders.cid
  AND Agents.aid = Orders.aid
  AND Products.pid = Orders.pid
  AND Agents.city = 'New York';
  
--6. Write	a	query	to	check the accuracy of	the	dollars	column	in	the	Orders	table.	This	
--means	calculating	Orders.totalUSD	from data in other tables and comparing	those	
--values to	the	values in Orders.totalUSD. Display	all	rows in	Orders	where	
--Orders.totalUSD is incorrect,	if	any.	

drop view if exists myCalc;

Create view myCalc
AS
SELECT Orders.ordnum as Num, Products.priceUSD as price, Customers.discount as discount, Orders.qty as Oqty, ((Products.priceUSD*Orders.qty) - (Products.priceUSD*Orders.qty) * (Customers.discount/100)) as total
FROM Customers, Products, Orders
WHERE Customers.cid = Orders.cid
  AND Products.pid = Orders.pid;

SELECT *
FROM myCalc Right outer join Orders ON myCalc.Num = Orders.ordnum 
WHERE myCalc.total != Orders.totalUSD;

--7. What’s the difference between a LEFT OUTER JOIN and a RIGHT OUTER JOIN? Give example queries in SQL to demonstrate. 
--(Feel free to use the CAP database to make your points here.)

/* The difference between a left outer join and a right outer join lies in which table you select completely. The side (right or
left) refers to the table that you would like to select (either on the right side of the "outer join" words or the left.)  For 
example, by saying Customers right outer join Orders, we would select all the rows where the two tables have the same value
for the condition that we define, plus all of the other rows from Orders (since that is on the right.)  A more specific example 
would be that if we say "Customers left outer join Orders ON Customers.cid = Orders.cid" then the query would return all the rows 
of the joined table where the cid is the same, and the rows of customers that do not have a cid that is present in Orders.  In the
CAP database, that would be Weyland. */
  




