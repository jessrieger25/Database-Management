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
FROM Orders
WHERE cid Not in (SELECT cid
		  	      FROM Orders
	              WHERE aid = 'a08');

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
      and city not in ('Dallas', 'London');

--8 
--What are check constraints? What are they good for? What is the advantage of putting that sort of thing in the database?
/*A check constraint is a condition that limits what you can put as a value in a particular column. 
If the value you are trying to insert into the column violates the constraint then it is not inserted into the column. They are good 
because they allow us to ensure that only the correct type of data is entered into certain columns.  One of the benefits of check constraints
is that they allow us to set rules for data insertion at the database level so that they hold true for any application that may use the SQL code. Another 
way of saying this is that the constraint can not be bypassed by the application.  Essentially, check constraints provide consistency (data integrity) so that all 
applications follow the same rules regarding data without having to be programmed individually.  As well, if the constraint is wrong, it is only wrong in one
place so only one thing has to be fixed. 
Good way to use check constraint:
A good example of a check constraint would be using it in a scenario where you want the ages of the users, but you obviously know that the ages can not be negative.
Due to this, you would want to put a constraint on your inout for that column that says age > 0.  Though this may seem like a simple example, the rule would not be enforced
without this constraint because your value would probably be defined as an integer which can be negative. 
Bad way to use check constraint: 
One bad way to use a check constraint would be when trying to limit the values entered in a particular column that may contain null values.  The reason for this is that when
the check constraint evaluates a statement with null it will return UNKNOWN not False so it will basically allow any value to be entered. For example, if you want to change the
amount of money a worker is paid from NULL to 9, but you type it wrong as 9.0, the value will be inserted even though it is a double when the value in that column should be an INT. 
Another small example of when it is bad to use constraints is when you are trying to restrict the exact string that you want within a column.  For example if you want a column to 
contain either "yes", or "NO", or "maybe", but not "no" or "YES" or any other variation, simply setting a constraint would not work.  This is because constraints are case insensitive so
they would not see the difference between all of the strings.  
