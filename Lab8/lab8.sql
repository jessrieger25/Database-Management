----------------------------------------------------------------------------------------
-- Postgres creation of movie database
--
-- SQL statements for movie database
-- 
-- Modified several times by Jessica Rieger

--ADD REFERENCES KEYWORDS!!!-------------------------------------------------------------------------------

DROP TABLE IF EXISTS CastMembers;
Drop Table IF EXISTS Roles;
DROP TABLE IF EXISTS Actors;
DROP TABLE IF EXISTS Directors;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS People;

-- People --
CREATE TABLE People (
  PID			char(4) not null
  name			text,
  Address		text, 
  SpouseName	text,
  primary key(PID)
);  

-- Actors --
CREATE TABLE Actors (
  PID      			char(4) not null references People(PID),
  BirthDate			Date,
  HairColor			text,
  EyeColor			text,
  HeightINCH		text,
  WeightLBS			numeric(5,2),
  FavoriteColor 	text,
  SAGAnniversary 	Date,
  primary key(PID)
);

-- Directors --
CREATE TABLE Directors (
  PID      				char(4) not null references People(PID),
  FilmSchoolAttended	text,
  DGAnniversary			Date,
  FavoriteLensMaker		text,
  primary key(PID)
);

--Roles--
CREATE TABLE Roles (
  RoleID	char(3) not null,
  name		text 
);

-- Movies -- 
CREATE TABLE Movies (
  MPAANumber		int not null,
  Name				text,
  YearReleased		int,
  domesticBOSUSD	text,
  foreignBOSUSD		text,
  DVD/Blu-raySUSD	text,
  primary key(MPAANumber)
);

-- CastMembers --
CREATE TABLE CastMembers (
  PID      		   char(4) not null references People(PID),
  RoleID   		   char(3) not null references Roles(RoleID),
  MPAANumber	   char(4) not null references Movies(MPAANumber),
  primary key(PID, RoleID, MPAANumber)
);




--4. Query

Select * 
From Directors d Inner Join CastMembers c ON d.PID = c.PID
Where MPAANumber in (Select MPAANumber
		     		 From CastMembers c Inner Join People p ON c.PID = p.PID
		    		 Where name = "Sean Connery" );



  
  
  
              				 


 




 




