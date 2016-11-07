----------------------------------------------------------------------------------------
-- Postgres creation of movie database
--
-- SQL statements for movie database
-- 
-- Modified several times by Jessica Rieger
----------------------------------------------------------------------------------------

DROP TABLE IF EXISTS CastMembers;
DROP TABLE IF EXISTS Actors;
DROP TABLE IF EXISTS Directors;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS People;

-- People --
CREATE TABLE People (
  PID		char(4) not null
  Name		text,
  Address	text, 
  SpouseName	text,
  primary key(PID)
);  

-- Actors --
CREATE TABLE Actors (
  PID      		char(4) not null,
  BirthDate		Date,
  HairColor		text,
  EyeColor		text,
  HeightINCH		text,
  WeightLBS		numeric(5,2),
  FavoriteColor 	text,
  SAGAnniversary 	Date,
  primary key(PID)
);

-- Directors --
CREATE TABLE Directors (
  PID      			char(4) not null,
  FilmSchoolAttended		text,
  DGAnniversary			Date,
  FavoriteLensMaker		text,
  primary key(PID)
);

-- Movies -- 
CREATE TABLE Movies (
  MPAANumber		int not null,
  Name			text,
  YearReleased		int,
  domesticBOSUSD	text,
  foreignBOSUSD		text,
  DVD/Blu-raySUSD	text,
  primary key(MPAANumber)
);

-- CastMembers --
CREATE TABLE CastMembers (
  PID      		   char(4) not null,
  RoleID   		   default 'A' check (RoleID = 'A' or RoleID = 'D'),
  MPAANumber	   	   char(4) not null,
  primary key(PID, RoleID, MPAANumber)
);




--4. Query

  
Select * 
From Directors
Where PID in (Select pid
From CastMembers
Where MPAANumber IN ( Select MPAANumber
			   From CastMembers
			   Where pid in (Select PID 
			  				 From People
              				 Where name = "Sean Connery"); 

Select * 
From Directors d Inner Join CastMembers c ON d.PID = c.PID
Where MPAANumber in (Select MPAA
		     From CastMembers c Inner Join People p ON p.PID = c.PID
		     Where name = "Sean Connery" );



  
  
  
              				 


 




 




