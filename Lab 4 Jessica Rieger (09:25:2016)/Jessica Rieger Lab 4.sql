--Jessica Rieger--
--Lab 4
--09/23/2016

--1 Get	the	cities	of	agents	booking	an	order	for	a	customer	whose	cid	is	'c006'.	
Select city
FROM Agents
WHERE aid in (SELECT aid
	          FROM Orders
              WHERE cid = 'c006');

/*2 Get	the	ids	of	products ordered through any agent who takes at	least one order	from a	
customer in	Kyoto, sorted by pid from highest to lowest. */
SELECT distinct pid
FROM Orders
WHERE aid in (SELECT aid
	          FROM Orders
              WHERE cid in (SELECT cid
			    			FROM Customers
	                        WHERE city = 'Kyoto')
	     )
Order By pid DESC;

--3 Get	the	ids	and	names	of	customers	who	did	not	place	an	order	through	agent	a03.
SELECT cid, name
FROM CUSTOMERS
WHERE cid in (SELECT distinct cid
	          FROM Orders
	          WHERE aid != 'a03');

--4  Get	the	ids	of	customers	who	ordered	both	product	p01	and	p07.	
SELECT cid
FROM Orders
WHERE pid = 'p07'
	INTERSECT
SELECT cid
FROM Orders
WHERE pid = 'p01';

/*5 Get	the	ids	of	products	not	ordered	by	any	customers	who	placed	any	order	through	
agent	a08	in	pid	order	from	highest	to	lowest.	*/
SELECT pid
FROM Products
WHERE pid not in (SELECT DISTINCT pid
		  		  FROM Orders
		  		  WHERE cid IN (SELECT cid
		  	        		    FROM Orders
								WHERE aid = 'a08')
		  		  )
ORDER BY pid DESC;

/*6 Get	the	name,	discounts,	and	city	for	all	customers	who	place	orders	through	agents	
in	Dallas	or	New	York.	*/
SELECT name, discount, city
FROM Customers
WHERE cid in (SELECT cid
	      	  FROM Orders
	          WHERE aid in (SELECT aid
		            		FROM Agents
			    			WHERE city in ('Dallas', 'New York')
			    )
	     );

/*7 Get	all	customers	who	have	the	same	discount	as	that	of	any	customers	in	Dallas	or	
London*/
SELECT *
FROM Customers
WHERE discount in (SELECT discount
		  		   FROM Customers
		  		   WHERE city in ('Dallas', 'London')
		 		   )

--8 
--What are check constraints? What are they good for? What is the advantage of putting that sort of thing in the database?
/*A check constraint is a condition that limits what you can put as a value in a particular column. 
If the value you are trying to insert into the column violates the constraint then it is not inserted into the column. They are good 
because they allow us to ensure that only the correct values for the data are entered into certain columns.  One of the benefits of check constraints
is that they allow us to set rules for data insertion at the database level so that they hold true for any application that may use the SQL code. Another 
way of saying this is that the constraint can not be bypassed by the application.  Essentially, check constraints provide consistency (data integrity) so that all 
applications follow the same rules regarding data without having to be programmed individually.  As well, if the constraint is wrong, it is only wrong in one
place so only that one error must be fixed. 
Good way to use check constraint:
A good example of a check constraint would be using it in a scenario where you want the ages of the users.  Obviously know that the ages can not be negative.
Due to this, you would want to put a constraint on your input for that column that says age > 0.  Though this may seem like a simple example, the rule would not be enforced
without this constraint because your value would probably be defined as an integer which can be negative. 
Bad way to use check constraint: 
One bad way to use a check constraint would be when the values that you want to check are going to change. For example, it would not be proper to use a Check Constraint for the 
military bases of the US because they are changing often so it would be better to use a foreign key constraint in this circumstance. If you were to use a check constraint it would
be much harder to change the database rules because you would have to drop the table and completely redo its outline and its data.  On the other hand, with a foreign key you could simply 
add or remove the bases as they change in the real world.  