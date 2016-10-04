--Jessica Rieger--
--Lab 5
--10/01/2016

--1 Get	the	cities	of	agents	booking	an	order	for	a	customer	whose	cid	is	'c006'.	
SELECT Agents.city
FROM Agents, Customers, Orders
WHERE Orders.cid = 'c006'
 AND Customers.cid = Orders.cid 
 AND Agents.aid = Orders.aid;
 
/*2 Get	the	ids	of	products ordered through any agent who takes at	least one order	from a	
customer in	Kyoto, sorted by pid from highest to lowest. */

Select distinct o2.pid
From Orders o1, Orders o2, Customers c
Where o1.cid = c.cid 
  AND o1.aid = o2.aid
  AND c.city = 'Kyoto'
Order by o2.pid DESC;


--3. Show the names of the customers who have never placed an order.
SELECT name
FROM Customers
WHERE cid not in (Select cid
		          From Orders
		          );

--4. Show the names of the customers who have never placed an order using an outer join.
SELECT Customers.name
FROM Customers Left Outer Join Orders ON Customers.cid = Orders.cid
WHERE Orders.cid IS NULL;

--5. Show	the	names	of	customers	who	placed	at	least	one	order	through	an	agent	in	their	
--own	city,	along	with	those	agent(s')	names.
SELECT DISTINCT Customers.name, Agents.name
FROM Agents, Customers, Orders
WHERE Agents.aid = Orders.aid
  AND Customers.cid = Orders.cid
  AND Customers.city = Agents.city;
  
--6. . Show	the	names	of	customers	and	agents	living	in	the	same	city,	along	with	the	name	
--of	the	shared	city,	regardless	of	whether	or	not	the	customer	has	ever	placed	an	order	
--with	that	agent.		
SELECT DISTINCT Customers.name, Agents.name
FROM Agents, Customers
WHERE Customers.city = Agents.city;

--7. Show	the	name	and	city	of	customers	who	live	in	the	city	that	makes	the	fewest
--different	kinds	of	products.	(Hint:	Use	count	and	group	by	on	the	Products	table.)
Select name, city
FROM Customers
WHERE city in (Select city
	       From Products
	       group by city
	       order by count(pid) ASC
	       limit 1
	       );

  
