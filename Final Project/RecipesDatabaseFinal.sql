----------------------------------------------------------------------------------------
-- Recipes Database Tables
-- by Jessica Rieger
-- Tested on Postgres 9.3.2
----------------------------------------------------------------------------------------
drop view if exists entirerecipe;
drop view if exists ingredientaffinities;
drop view if exists publicationinformation;
drop table if exists Published;
drop table if exists CookbookAuthors;
drop table if exists BlogAuthors;
drop table if exists Chefs;
drop table if exists PublishMethodsThemesList;
drop table if exists Blogs;
drop table if exists steps;
drop table if exists Cookbooks;
drop table if exists IngredientsList;
drop table if exists PhotosList;
drop table if exists Photos;
drop table if exists AffinitiesList;
drop table if exists FlavorAffinities;
drop table if exists RecipeThemesList;
drop table if exists recipegroups;
drop table if exists IngredientsOfSubstitution;
drop table if exists Substitutions;
drop table if exists PartsList;
drop table if exists UtensilsList;
drop table if exists Utensils;
drop table if exists Ingredients;
drop table if exists Recipes;
drop table if exists Parts;
drop table if exists Themes;
drop table if exists Authors;
drop table if exists People;
drop table if exists PublishMethods;

--
--People Table
--

CREATE TABLE People (
    PerID  		text not null,
    Fname 		text not null,
    Lname 		text not null,
    Birthday	date not null,
  PRIMARY KEY (PerID)
);
--
--Chefs Table
--

CREATE TABLE Chefs (
    PerID  		text not null references People(PerID),
    Title 		text,
    CurrentJob  text,
  PRIMARY KEY (PerID)
);

--
--Authors Table
--
CREATE TABLE Authors (
	PerID  		text not null references People(PerID),
    Inspiration	text,
  PRIMARY KEY (PerID)
);

--
--Cookbook Authors Table
--

CREATE TABLE CookbookAuthors (
    PerID  			text not null references Authors(PerID),
    NumCookbooks	int,
  PRIMARY KEY (PerID)
);

--
--Blog Authors Table
--

CREATE TABLE BlogAuthors (
    PerID  		text not null references Authors(PerID),
    FreqOfPost 	text,
  PRIMARY KEY (PerID)
);

--
--Publish Methods
--

CREATE TABLE PublishMethods (
    PID  			text not null,
    YearPublished 	text not null,
    Title  			text not null,
    ContentDescr 	text,
  PRIMARY KEY (PID)
);

--Published Table--
--

CREATE TABLE Published (
    PID  			text not null references PublishMethods(PID),
    PerID			text not null references Authors(PerID),
  PRIMARY KEY (PerID, PID)
);


--
--Blogs
--

CREATE TABLE Blogs (
    PID  			text not null references PublishMethods(PID),
    URL 			text not null,
  PRIMARY KEY (PID)
);

--
--Cookbooks
--

CREATE TABLE Cookbooks (
    PID  			text not null references PublishMethods(PID),
    NumRecipes 		integer,
    PriceUSD	  	decimal,
    Publisher		text,
  PRIMARY KEY (PID)
);


--
-- The table of Recipes
--
CREATE TABLE Recipes (
    RID      		text not null,
    Name     		text not null,
    DateCreated  	date not null,
    DateUpdated 	date not null,
    PrepTimeMin  	integer not null,	
    CookTimeMin  	integer not null,
    TotalTimeMin    integer,
    Serves		 	integer,
    Category		text,
    SRC				text not null,
    PRIMARY KEY (RID)
);

--
-- Recipe Groupings
--

CREATE TABLE RecipeGroups (
	PID 			text not null references PublishMethods(PID),
    RID  			text not null references Recipes(RID),
  PRIMARY KEY (PID, RID)
);

--
--Themes Table
--

CREATE TABLE Themes (
    TID  	text not null,
    Name 	text not null,
    Descr  	text,
  PRIMARY KEY (TID)
);

--
--Recipe Themes List Table
--

CREATE TABLE RecipeThemesList (
    TID  	text not null references Themes(TID),
    RID		text not null references Recipes(RID),
  PRIMARY KEY (TID, RID)
);


--
-- Utensils Table
--
CREATE TABLE Utensils (
    UID  				text not null,
    Name 				text not null,
    Brand 	 			text,
    AlternateUtensil 	text,
    Material 			text,
  PRIMARY KEY (UID)
);


--
--Utensils List
--

CREATE TABLE UtensilsList (
    RID  			text not null references Recipes(RID),
    UID 			text not null references Utensils(UID),
    Quantity  		integer not null,
  PRIMARY KEY (UID, RID)
);

--
-- Photos Table
--
CREATE TABLE Photos (
    PhID  		text not null,
    HeightPX 	integer not null,
    WidthPX  	integer not null,
    DateAdded 	date not null,
    Edited 		boolean not null,
  PRIMARY KEY (PhID)
);

--
--Photos List
--

CREATE TABLE PhotosList (
	PhID 			text not null references Photos(PhID),
    RID  			text not null references Recipes(RID),
  PRIMARY KEY (PhID, RID)
);


--
--Steps
--

CREATE TABLE Steps (
    StepNum  	integer not null,
    RID			text not null references Recipes(RID),
    Descr 		text not null,
  PRIMARY KEY (StepNum, RID)
);

--
--Ingredients
--

CREATE TABLE Ingredients (
    IID  text not null,
    Name text not null,
    Season text not null,
    Allergen boolean,
  PRIMARY KEY (IID)
);

--
--Parts Table
--

CREATE TABLE Parts (
	ParID 			text not null,
    Name			text not null,
  PRIMARY KEY (ParID)
);

--
--Ingredients List
--

CREATE TABLE IngredientsList (
	IID 			text not null references Ingredients(IID),
    ParID			text not null references Parts(ParID),
    WayPrep			text not null,
    Quantity  		text not null,
  PRIMARY KEY (IID, ParID, WayPrep)
);



--
--Parts of Recipes List
--

CREATE TABLE PartsList (
	ParID 			text not null references Parts(ParID),
    RID  			text not null references Recipes(RID),
  PRIMARY KEY (ParID, RID)
);

--
--Substitutions
--

CREATE TABLE Substitutions (
    SLID  			text not null,
    IID 			text not null references Ingredients(IID),
    HowMuchMake  	text not null,
    Instructions	text not null,
  PRIMARY KEY (SLID)
);

--
--Ingredients of each substitution
--

CREATE TABLE IngredientsOfSubstitution (
    SLID  			text not null references Substitutions(SLID),
    IID 			text not null references Ingredients(IID),
    Quantity  		text not null,
  PRIMARY KEY (SLID, IID)
);

--
--Flavor Affinities
--

CREATE TABLE FlavorAffinities (
    AID  				text not null,
    Origin				text, 
  PRIMARY KEY (AID)
);

--
--Affinities List
--

CREATE TABLE AffinitiesList (
    AID  			text not null references FlavorAffinities(AID),
    IID 			text not null references Ingredients(IID),
  PRIMARY KEY (AID, IID)
);


--
--Publish Methods Themes List Table
--

CREATE TABLE PublishMethodsThemesList (
    TID  	text not null references Themes(TID),
    PID		text not null references PublishMethods(PID),
  PRIMARY KEY (TID, PID)
);

----------------------------------------------------------------------------------------
-- Recipes Database Insert Statements
-- by Jessica Rieger
-- Tested on Postgres 9.3.2
----------------------------------------------------------------------------------------
--INSERT STATEMENTS--

--Recipe 1--

--INFORMATION ASSOCIATED WITH RECIPE--

INSERT INTO People(PerID, Fname, Lname, Birthday)
VALUES ('PER09', 'Jessica' , 'Rieger', '1997-03-23');

INSERT INTO Authors(PerID, Inspiration)
VALUES ('PER09', 'All different types of cuisine!');

INSERT INTO BlogAuthors(PerID, FreqOfPost)
VALUES ('PER09', 'Once a Week');

INSERT INTO People(PerID, Fname, Lname, Birthday)
VALUES ('PER01', 'Kathryne', 'Smith', '1990-01-15');

INSERT INTO Authors(PerID, Inspiration)
VALUES ('PER01', 'Healthy');

INSERT INTO BlogAuthors(PerID, FreqOfPost)
VALUES ('PER01', 'Everyday');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U01', 'High-Performance Blender', 'Vitamix',  'Immersion Blender', 'n/a');

INSERT INTO Photos(PhID, HeightPX, WidthPX, DateAdded, Edited)
VALUES ('PH01', '640', '800',  '2016-11-23', TRUE);

INSERT INTO Parts(ParID, Name)
VALUES ('PAR01', 'Soup');

INSERT INTO PublishMethods(PID, YearPublished, Title, ContentDescr)
VALUES ('P01', '2010', 'COOKIE & kate', 'Healthy, simple cooking that has recipes for any time of day.' );

INSERT INTO PublishMethods(PID, YearPublished, Title, ContentDescr)
VALUES ('P08', '2016', 'The Gourmet College Chef', 'Whatever I feel like cooking.' );

--Blogs--

INSERT INTO Blogs(PID, URL)
VALUES ('P01', 'http://cookieandkate.com');

INSERT INTO Blogs(PID, URL)
VALUES ('P08', 'http://thegourmetcollegechef.weebly.com/');
--Recipes--

INSERT INTO Recipes(RID, Name, DateCreated, DateUpdated, PrepTimeMin, CookTimeMin, TotalTimeMin, Serves, Category, SRC)
VALUES ('R01', 'Butternut Squash Soup', '2015-11-11', '2015-11-11', 10, 55, 65, 4, 'Soup', 'Original');

--Published--

INSERT INTO Published(PID, PerID)
VALUES ('P01', 'PER01');

INSERT INTO Published(PID, PerID)
VALUES ('P08', 'PER09');

--Recipe Groups--

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P01', 'R01');

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P08', 'R01');

--INGREDIENTS INSERTIONS--

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I01', 'Butternut Squash', 'Fall', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I02', 'Olive Oil', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I03', 'Shallot', 'Fall', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I04', 'Salt', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I05', 'Garlic', 'Summer', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I06', 'Maple Syrup', 'Winter', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I07', 'Nutmeg', 'Fall', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I08', 'Black Pepper', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I09', 'Vegetable Broth', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I10', 'Butter', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I49', 'Anchovies', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I50', 'Rosemary', 'Fall/Winter', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I51', 'Apples', 'Fall', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I52', 'Caramel', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I53', 'Asparagus', 'Spring', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I55', 'Jalapeno Chiles', 'Summer', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I56', 'Lime', 'Summer', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I57', 'Cilantro', 'All', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I58', 'Milk', 'All', TRUE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I59', 'Fontina', 'All', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I60', 'Thyme', 'Summer/Fall/Winter', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I61', 'Leeks', 'Fall/Winter/Spring', FALSE);

--CONNECTING UTENSILS, INGREDIENTS, AND STEPS TO THEIR RECIPES--

--Ingredients List--

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I01', 'PAR01', 'Chop in half and seed', '1 Large');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I02', 'PAR01', 'None', '1 Tablespoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I03', 'PAR01', 'Chopped', '1/2 cup');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I04', 'PAR01', 'None', '1 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I05', 'PAR01', 'Pressed or Minced', '4 or 5');

INSERT INTO IngredientsList(IID,ParID, WayPrep, Quantity)
VALUES ('I06', 'PAR01', 'None', '1 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I07', 'PAR01', 'None', '1/8 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I08', 'PAR01', 'Grind', 'To Taste');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I09', 'PAR01', 'None', 'Vegetable Broth');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I10', 'PAR01', 'None', '1 or 2 Tablespoons');

--Parts List--

INSERT INTO PartsList(ParID, RID)
VALUES ('PAR01', 'R01');

--Utensils List--

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U01', 'R01', 1);

--Photos List--

INSERT INTO PhotosList(PhID, RID)
VALUES ('PH01', 'R01');

--Steps--

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (1, 'R01', 'Preheat the oven to 425 degrees Fahrenheit and line a rimmed baking sheet with parchment paper. Place the butternut squash on the pan and drizzle each half with just enough olive oil to lightly coat the squash on the inside (about 1 teaspoon each). Rub the oil over the inside of the squash and sprinkle it with salt and pepper.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (2, 'R01', 'Turn the squash face down and roast until it is tender and completely cooked through, about 45 to 50 minutes. Set the squash aside until it’s cool enough to handle, about 10 minutes. Then use a large spoon to scoop the butternut squash flesh into a bowl and discard the tough skin.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (3, 'R01', 'Meanwhile, in a medium skillet (or large soup pot, if you’ll be serving soup from that pot), warm 1 tablespoon olive oil over medium heat until shimmering. Add the chopped shallot and 1 teaspoon salt. Cook, stirring often, until the shallot has softened and is starting to turn golden on the edges, about 3 to 4 minutes. Add the garlic and cook until fragrant, about 30 seconds, stirring frequently.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (4, 'R01', 'If you have a high performance blender like a Vitamix (see notes if you are using an immersion blender instead), transfer the cooked shallot and garlic to your blender. Add the reserved butternut, maple syrup, nutmeg and a few twists of freshly ground black pepper. Pour in 3 cups vegetable broth, being careful not to fill the container past the maximum fill line (you can stir in any remaining broth later). Secure the lid and select the soup preset. The blender will stop running once the soup is super creamy and hot.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (5, 'R01', 'If you would like to thin out your soup a bit more, add the remaining cup of broth (I used the full 4 cups, but if you used a small squash, you might want to leave it as is). Add 1 to 2 tablespoons butter or olive oil, to taste, and blend well. Taste and blend in more salt and pepper, if necessary.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (6, 'R01', 'Serve immediately (I like to top each bowl with a little more black pepper). Let leftover soup cool completely before transferring it to a proper storage container and refrigerating it for up to 4 days (leftovers taste even better the next day!). Or, freeze this soup for up to 3 months.');


--Themes--

INSERT INTO Themes(TID, Name, Descr)
VALUES ('T01', 'Comfort', 'Food you want to eat on a cold day with family.');

INSERT INTO Themes(TID, Name, Descr)
VALUES ('T02', 'Vegetarian', 'To cook without the use of any meat.');

--Recipe Themes List--

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T01', 'R01');

--Publish Method Themes List--

INSERT INTO PublishMethodsThemesList(TID, PID)
VALUES ('T02', 'P01');

--Recipe 2--

--INFORMATION ASSOCIATED WITH RECIPE--

INSERT INTO People(PerID, Fname, Lname, Birthday)
VALUES ('PER02', 'Ina',  'Garten', '1948-02-02');

INSERT INTO Authors(PerID, Inspiration)
VALUES ('PER02', 'Home Cooking');

INSERT INTO CookbookAuthors(PerID, NumCookbooks)
VALUES ('PER02', '4');

INSERT INTO Parts(ParID, Name)
VALUES ('PAR02', 'Lemon Cake');

INSERT INTO Parts(ParID, Name)
VALUES ('PAR03', 'Lemon Glaze');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U02', '8 1/2 by 4 1/4 by 2 1/2 inch loaf pan', 'William Sonoma',  'alternate size loaf pans', 'aluminum');

INSERT INTO Photos(PhID, HeightPX, WidthPX, DateAdded, Edited)
VALUES ('PH02', '406', '305',  '2016-11-24', TRUE);

INSERT INTO PublishMethods(PID, YearPublished, Title, ContentDescr)
VALUES ('P02', '2003', 'Barefoot Contessa at Home', 'Easy, simple, home cooking.' );

--Cookbooks--

INSERT INTO Cookbooks(PID, NumRecipes, PriceUSD, Publisher)
VALUES ('P02', '150', '18.99', 'Clarkson Potter/Publishers');

--Recipes--

INSERT INTO Recipes(RID, Name, DateCreated, DateUpdated, PrepTimeMin, CookTimeMin, TotalTimeMin, Serves, Category, SRC)
VALUES ('R02', 'Lemon Cake', '2003-01-25', '2016-11-11', 30, 60, 90, 12, 'Cake', 'Original');

--Published--
INSERT INTO Published(PID, PerID)
VALUES ('P02', 'PER02');

--Cookbook Recipes--

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P02', 'R02');

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P08', 'R02');


--INGREDIENTS INSERTIONS--

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I11', 'Granulated Sugar', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I12', 'Eggs', 'All', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I13', 'Lemon', 'Summer/Fall', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I14', 'Flour', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I15', 'Baking Powder', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I16', 'Baking Soda', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I17', 'Buttermilk', 'Fall', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I18', 'Vanilla Extract', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I19', 'Confectioners Sugar', 'n/a', FALSE);



--CONNECTING UTENSILS, INGREDIENTS, AND STEPS TO THEIR RECIPES--

--Ingredients List--

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I11', 'PAR02', 'Divided', '2 1/2 Cups');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I12', 'PAR02', 'at room temperature.', '4 Large');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I13', 'PAR02', 'Zest', '1/3 cup');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I13', 'PAR02', 'Juice', '3/4 Cup');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I14', 'PAR02','None', '3 Cups');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I15', 'PAR02', 'None', '1/2 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I16', 'PAR02', 'None', '1/2 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I17', 'PAR02', 'at room temperature.', '3/4 Cup');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I18', 'PAR02', 'pure', '1 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I10', 'PAR02', 'at room temperature', '2 Sticks');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I19', 'PAR03', 'sifted', '2 Cups');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I04', 'PAR03', 'Juice', '3 1/2 Tablespoons');

--Parts List--

INSERT INTO PartsList(ParID, RID)
VALUES ('PAR02', 'R02');

INSERT INTO PartsList(ParID, RID)
VALUES ('PAR03', 'R02');

--Utensils List--

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U02', 'R02', 2);

--Photos List--

INSERT INTO PhotosList(PhID, RID)
VALUES ('PH02', 'R02');

--Steps--

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (1, 'R02', 'Preheat the oven to 350 degrees F. Grease and flour 2 (8 1/2 by 4 1/4 by 2 1/2-inch) loaf pans. You may also line the bottom with parchment paper, if desired.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (2, 'R02', 'Cream the butter and 2 cups granulated sugar in the bowl of an electric mixer fitted with the paddle attachment, until light and fluffy, about 5 minutes. With the mixer on medium speed, add the eggs, 1 at a time, and the lemon zest.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (3, 'R02', 'Sift together the flour, baking powder, baking soda, and salt in a bowl. In another bowl, combine 1/4 cup lemon juice, the buttermilk, and vanilla. Add the flour and buttermilk mixtures alternately to the batter, beginning and ending with the flour. Divide the batter evenly between the pans, smooth the tops, and bake for 45 minutes to 1 hour, until a cake tester comes out clean.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (4, 'R02', 'Combine 1/2 cup granulated sugar with 1/2 cup lemon juice in a small saucepan and cook over low heat until the sugar dissolves. When the cakes are done, allow to cool for 10 minutes. Remove the cakes from the pans and set them on a rack set over a tray or sheet pan; spoon the lemon syrup over them. Allow the cakes to cool completely.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (5, 'R02', 'For the glaze, combine the confectioners sugar and the lemon juice in a bowl, mixing with a wire whisk until smooth. Pour over the tops of the cakes and allow the glaze to drizzle down the sides.');

--Recipe Themes--

INSERT INTO Themes(TID, Name, Descr)
VALUES ('T03', 'Dessert', 'A nice way to finish a meal.');

INSERT INTO Themes(TID, Name, Descr)
VALUES ('T04', 'Simple', 'Good for mid-week cooking/baking.');

--Recipe Themes List--

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T03', 'R02');

--Publish Method Themes List--

INSERT INTO PublishMethodsThemesList(TID, PID)
VALUES ('T04', 'P02');

--Recipe 3--

--INFORMATION ASSOCIATED WITH RECIPE--

INSERT INTO People(PerID, Fname, Lname, Birthday)
VALUES ('PER03', 'Andie', 'Mitchell', '1985-03-20');

INSERT INTO Authors(PerID, Inspiration)
VALUES ('PER03', 'Healthy and Quick');

INSERT INTO BlogAuthors(PerID, FreqOfPost)
VALUES ('PER03', 'Once a Week');

INSERT INTO Parts(ParID, Name)
VALUES ('PAR04', 'Pulled Pork');

INSERT INTO Parts(ParID, Name)
VALUES ('PAR05', 'Taco Assembly');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U03', 'Crockpot', 'William Sonoma',  'None', 'Clay');

INSERT INTO Photos(PhID, HeightPX, WidthPX, DateAdded, Edited)
VALUES ('PH03', '406', '305',  '2016-11-24', TRUE);

INSERT INTO Photos(PhID, HeightPX, WidthPX, DateAdded, Edited)
VALUES ('PH04', '440', '400',  '2016-11-26', TRUE);

INSERT INTO PublishMethods(PID, YearPublished, Title, ContentDescr)
VALUES ('P03', '2010', 'Andie Mitchell', 'Recipes * Inspiration * Life' );

--Blogs--

INSERT INTO Blogs(PID, URL)
VALUES ('P03', 'http://andiemitchell.com');

--Recipes--

INSERT INTO Recipes(RID, Name, DateCreated, DateUpdated, PrepTimeMin, CookTimeMin, TotalTimeMin, Serves, Category, SRC)
VALUES ('R03', 'Slow Cooker Mexican Pulled Pork Tacos', '2011-03-08', '2016-11-24', 15, 480, 495, 4,'Tacos', 'Original');

--Published--
INSERT INTO Published(PID, PerID)
VALUES ('P03', 'PER03');


--Blog Recipes--

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P03', 'R03');

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P08', 'R03');

--INGREDIENTS INSERTIONS--

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I20', 'Pork Tenderloin', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I21', 'Tomato Sauce', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I22', 'Chili Powder', 'Winter', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I23', 'Ground Cumin', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I24', 'Brown Sugar', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I25', 'Cayenne Pepper', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I26', 'Tortillas', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I27', 'Lettuce', 'Summer', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I28', 'Bell Peppers', 'Summer', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I29', 'Tomatoes', 'Summer', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I30', 'Black Olives', 'Fall', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I31', 'Cheddar Cheese', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I32', 'Sour Cream', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I33', 'Scallions', 'Spring', FALSE);


--CONNECTING UTENSILS, INGREDIENTS, AND STEPS TO THEIR RECIPES--

--Ingredients List--

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I20', 'PAR04', 'Cleaned', '1 lb');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I21', 'PAR04', 'None', '1 15oz. can');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I22', 'PAR04', 'None', '1 Tablespoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I23', 'PAR04', 'None', '1 Tablespoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I24', 'PAR04', 'None', '1 Tablespoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I25', 'PAR04', 'None', '1/2 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I04', 'PAR04', 'None', '1/2 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I05', 'PAR04', 'Minced', '3 Cloves');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I26', 'PAR05', 'Warmed', '1');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I27', 'PAR05', 'Chopped', 'Personal preference');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I28', 'PAR05', 'Sliced', 'Personal Preference');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I29', 'PAR05', 'Chopped', 'Personal Preference');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I30', 'PAR05', 'Chopped', 'Personal Preference');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I31', 'PAR05', 'Grated', 'Personal Preference');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I32', 'PAR05', 'Dollop', 'Personal Preference');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I33', 'PAR05', 'Chopped', 'Personal Preference');

--Parts List--

INSERT INTO PartsList(ParID, RID)
VALUES ('PAR04', 'R03');

INSERT INTO PartsList(ParID, RID)
VALUES ('PAR05', 'R03');

--Utensils List--

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U03', 'R03', 1);

--Photos List--

INSERT INTO PhotosList(PhID, RID)
VALUES ('PH03', 'R03');

INSERT INTO PhotosList(PhID, RID)
VALUES ('PH04', 'R03');

--Steps--

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (1, 'R03', 'Place the pork and all the ingredients in part 1 into the crockpot and cook on low for 8 hours.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (2, 'R03', 'Pull the pork apart with a fork.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (3, 'R03', 'Assemble the taco using all the ingredients in part 2.');

--Recipe Themes--

INSERT INTO Themes(TID, Name, Descr)
VALUES ('T05', 'Mexican', 'Spicy and sweet.');

--Recipe Themes List--

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T05', 'R03');


--Publish Method Themes List--

INSERT INTO PublishMethodsThemesList(TID, PID)
VALUES ('T04', 'P03');

--Recipe 4--

--INFORMATION ASSOCIATED WITH RECIPE--

INSERT INTO People(PerID, Fname, Lname, Birthday)
VALUES ('PER04', 'Tessa', 'Bramley', '1985-01-01');

INSERT INTO Authors(PerID, Inspiration)
VALUES ('PER04', 'Vegetarian');

INSERT INTO CookbookAuthors(PerID, NumCookbooks)
VALUES ('PER04', '2');

INSERT INTO Parts(ParID, Name)
VALUES ('PAR06', 'Entire Recipe');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U04', 'Large Saucepan', 'All-Clad',  'Pasta Pot', 'Calphalon');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U05', 'Strainer', 'None',  'None', 'Any');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U06', 'Pizza Stone', 'Old Stone',  'Baking Sheet', 'Stone');

INSERT INTO Photos(PhID, HeightPX, WidthPX, DateAdded, Edited)
VALUES ('PH05', '206', '605',  '2016-11-30', TRUE);

INSERT INTO PublishMethods(PID, YearPublished, Title, ContentDescr)
VALUES ('P04', '2007', 'Easy Vegetarian', 'Simple recipes for lunch, brunch, and dinner.' );

--Cookbooks--

INSERT INTO Cookbooks(PID, NumRecipes, PriceUSD, Publisher)
VALUES ('P04', '75', '13.19', 'Ryland Peters & Small, Inc.');

--Recipes--

INSERT INTO Recipes(RID, Name, DateCreated, DateUpdated, PrepTimeMin, CookTimeMin, TotalTimeMin, Serves, Category, SRC)
VALUES ('R04', 'Fiorentina', '2007-01-01', '2016-11-20', 30, 20, 50, 4, 'Pizza', 'Original');

--Published--
INSERT INTO Published(PID, PerID)
VALUES ('P04', 'PER04');

--Cookbook Recipes--

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P04', 'R04');

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P08', 'R04');

--INGREDIENTS INSERTIONS--

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I34', 'Baby Spinach', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I35', 'Pizza Dough', 'Winter', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I36', 'Mozzarella', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I37', 'Gruyere', 'n/a', FALSE);



--CONNECTING UTENSILS, INGREDIENTS, AND STEPS TO THEIR RECIPES--

--Ingredients List--

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I34', 'PAR06', 'Cleaned', '3 Cups');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I10', 'PAR06', 'None', '1 Tablespoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I05', 'PAR06', 'Crushed', '2 Cloves');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I35', 'PAR06', 'Make from scratch', '1 batch');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I02', 'PAR06', 'None', '1-2 Tablespoons');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I21', 'PAR06', 'None', '1 Cup');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I36', 'PAR06', 'Drained and thinly sliced.', '1 Cup');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I12', 'PAR06', 'None', '4');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I37', 'PAR06', 'Grated', '1/2 Cup');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I04', 'PAR06', 'None', 'Personal preference');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I08', 'PAR06', 'None', 'Personal preference');

--Parts List--

INSERT INTO PartsList(ParID, RID)
VALUES ('PAR06', 'R04');

--Utensils List--

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U04', 'R04', 1);

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U05', 'R04', 1);

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U06', 'R04', 1);

--Photos List--

INSERT INTO PhotosList(PhID, RID)
VALUES ('PH05', 'R04');

--Steps--

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (1, 'R04', 'Put stone in oven and preheat it to 425 degrees F.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (2, 'R04', 'Wash Spinach, put in saucepan, put top on and cook until wilted (2-3 min.)  Drain and squeeze out excess water.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (3, 'R04', 'Put oil and garlic in skillet and cook for 1 min. Then add spinach for additional 3-4 min. Season with salt and pepper.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (4, 'R04', 'Divide dough in 4. Roll out on floured surface.  Spread oil and tomato sauce on top.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (5, 'R04', 'Spread 1/4 spinach on each pizza, leaving room for egg in middle. Cover spinach with mozzarella.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (6, 'R04', 'Transfer to stone, cook for 10 min. Crack egg in middle and cover with gruyere and cook until egg done. (5-10 min)');

--Recipe Themes List--

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T02', 'R04');

--Publish Method Themes List--

INSERT INTO PublishMethodsThemesList(TID, PID)
VALUES ('T02', 'P04');


--Recipe 5--

--INFORMATION ASSOCIATED WITH RECIPE--

INSERT INTO People(PerID, Fname, Lname, Birthday)
VALUES ('PER05', 'Rick', 'Bayless', '1953-11-23');

INSERT INTO People(PerID, Fname, Lname, Birthday)
VALUES ('PER06', 'Deann', 'Groen Bayless', '1948-10-30');

INSERT INTO Authors(PerID, Inspiration)
VALUES ('PER05', 'Mexican Cuisine');

INSERT INTO Authors(PerID, Inspiration)
VALUES ('PER06', 'Mexican Cuisine');

INSERT INTO CookbookAuthors(PerID, NumCookbooks)
VALUES ('PER05', '1');

INSERT INTO CookbookAuthors(PerID, NumCookbooks)
VALUES ('PER06', '7');

INSERT INTO Parts(ParID, Name)
VALUES ('PAR07', 'The Chicken Mixture');

INSERT INTO Parts(ParID, Name)
VALUES ('PAR08', 'Finishing the dish');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U07', 'Medium Saucepan', 'William Sonoma',  'Pasta Pot', 'Calphalon');

INSERT INTO Photos(PhID, HeightPX, WidthPX, DateAdded, Edited)
VALUES ('PH06', '606', '405',  '2016-11-24', TRUE);

INSERT INTO PublishMethods(PID, YearPublished, Title, ContentDescr)
VALUES ('P05', '1987', 'Authentic Mexican: Regional Cooking from the Heart of Mexico', 'Classic Mexican Cuisine.' );

--Cookbooks--

INSERT INTO Cookbooks(PID, NumRecipes, PriceUSD, Publisher)
VALUES ('P05', '200', '26.99', 'Clarkson Potter/Publishers');

--Recipes--

INSERT INTO Recipes(RID, Name, DateCreated, DateUpdated, PrepTimeMin, CookTimeMin, TotalTimeMin, Serves, Category, SRC)
VALUES ('R05', 'Cold Chicken and Avocado with Chile Chipotle', '1987-01-01', '2016-11-11', 30, 85,105, 4, 'Chicken', 'Original');

--Published--
INSERT INTO Published(PID, PerID)
VALUES ('P05', 'PER05');

INSERT INTO Published(PID, PerID)
VALUES ('P05', 'PER06');

--Cookbook Recipes--

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P05', 'R05');

--INGREDIENTS INSERTIONS--

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I38', 'Chicken', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I39', 'Red-Skinned Boiling Potatoes', 'Winter', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I40', 'Carrots', 'Fall/Winter', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I41', 'Cider Vinegar', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I42', 'Oregano', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I43', 'Chiles Chipotles', 'Summer', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I44', 'Onion', 'Winter', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I45', 'Avocado', 'Spring/Summer', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I46', 'Vegetable Oil', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I47', 'Onion Rings', 'n/a', FALSE);

--CONNECTING UTENSILS, INGREDIENTS, AND STEPS TO THEIR RECIPES--

--Ingredients List--

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I38', 'PAR07', 'Cleaned', '1 Large Breast');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I04', 'PAR07', 'None', '1/2 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I39', 'PAR07','Halved', '2');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I40', 'PAR07', 'Peeled and cut into 1 1/2 inch lengths', '2 medium');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I41', 'PAR07', 'None', '1/4 Cup');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I42', 'PAR07', 'None', '1 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I43', 'PAR07', 'Seeded and sliced', '2-4 canned');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I44', 'PAR07', 'Finely Diced', '1 Small');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I27', 'PAR08', 'sliced in 3/8 inch strips.', '4 large romaine leave');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I45', 'PAR08', 'peeled, pitted, and diced', '1');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I46', 'PAR08', 'None', '1/4 cup');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I47', 'PAR08', 'Make from scratch.', '4 portions');

--Parts List--

INSERT INTO PartsList(ParID, RID)
VALUES ('PAR07', 'R05');

INSERT INTO PartsList(ParID, RID)
VALUES ('PAR08', 'R05');

--Utensils List--

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U07', 'R05', 1);

--Photos List--

INSERT INTO PhotosList(PhID, RID)
VALUES ('PH06', 'R05');

--Steps--

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (1, 'R05', 'Bring 2 cups of water to boil in saucepan with the salt.  Add chicken, return to boil, then simmer for 13 min.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (2, 'R05', 'Boil potatoes and carrots, cut and put in mixing bowl.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (3, 'R05', 'Skin the chicken, tear into shreds, and add to the carrots and potatoes.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (4, 'R05', 'Mix 3 tablespoons broth, vinegar, oregano, and salt in small bowl. Add to chicken with chiles and onion and let stand for 45 min.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (5, 'R05', 'Before serving, add avocado, lettuce, oil and salt to taste.  Lay onion rings on top.');

--Recipe Themes--

INSERT INTO Themes(TID, Name, Descr)
VALUES ('T06', 'Chipolte', 'Spicy.');


--Recipe Themes List--

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T06', 'R05');

--Publish Method Themes List--

INSERT INTO PublishMethodsThemesList(TID, PID)
VALUES ('T05', 'P05');

--Recipe 6--

--INFORMATION ASSOCIATED WITH RECIPE--

INSERT INTO People(PerID, Fname, Lname, Birthday)
VALUES ('PER07', 'Natalie', 'Smith', '1953-11-23');

INSERT INTO Authors(PerID, Inspiration)
VALUES ('PER07', 'Favorite Foods');

INSERT INTO BlogAuthors(PerID, FreqOfPost)
VALUES ('PER07', 'Once a week');

INSERT INTO Parts(ParID, Name)
VALUES ('PAR09', 'Entire Recipe');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U08', 'Baking Sheet', 'Nordic Ware',  'aluminum foil', 'aluminum');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U09', 'Large Knife', 'William Sonoma',  'Medium Knife', 'Stainless Steel');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U10', 'Medium skillet', 'Cuisinart',  'Large skillet', 'Stainless Steel');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U11', 'Tongs', 'KitchenAid',  'Fork', 'Stainless Steel');

INSERT INTO Photos(PhID, HeightPX, WidthPX, DateAdded, Edited)
VALUES ('PH07', '606', '405',  '2016-11-24', TRUE);

INSERT INTO PublishMethods(PID, YearPublished, Title, ContentDescr)
VALUES ('P06', '2014', 'Ce que J''aime', 'Indulgence Foods' );

--Blogs--

INSERT INTO Blogs(PID, URL)
VALUES ('P06', 'http://natandmac.tumblr.com/post/97603276107/bacon-brie-avocado-foodgasm?crlt.pid=camp.TAJXivS9eaDm');

--Recipes--

INSERT INTO Recipes(RID, Name, DateCreated, DateUpdated, PrepTimeMin, CookTimeMin, TotalTimeMin, Serves, Category, SRC)
VALUES ('R06', 'Bacon, Brie, and Avocado Sandwich', '2014-09-15', '2016-11-11', 15, 10, 25, 2, 'Sandwich', 'Original');

--Published--
INSERT INTO Published(PID, PerID)
VALUES ('P06', 'PER07');

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P06', 'R06');

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P08', 'R06');

--INGREDIENTS INSERTIONS--

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I62', 'English Muffin', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I63', 'Brie Cheese', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I54', 'Bacon', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I48', 'Peanuts', 'Fall', TRUE);


--CONNECTING UTENSILS, INGREDIENTS, AND STEPS TO THEIR RECIPES--

--Ingredients List--

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I45', 'PAR09', 'Halved, pitted, and sliced.', '1');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I54', 'PAR09', 'None', '4 slices');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I48', 'PAR09','Split in half', '2');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I02', 'PAR09', 'None', '1 Tablespoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I49', 'PAR09', 'cut slices', '2-4 oz.');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I29', 'PAR09', 'Cut slices', '1');

--Parts List--

INSERT INTO PartsList(ParID, RID)
VALUES ('PAR09', 'R06');

--Utensils List--

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U08', 'R06', 1);

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U09', 'R06', 1);

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U10', 'R06', 1);

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U11', 'R06', 1);

--Photos List--

INSERT INTO PhotosList(PhID, RID)
VALUES ('PH07', 'R06');

--Steps--

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (1, 'R06', 'Place bacon slices in a pan on med-heat and cook until they are cooked how you like them. Place a paper towel on a plate and set the bacon on top to cool.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (2, 'R06', 'Place the two halves of the English muffin on a baking sheet.  Place thin slices of Brie cheese on both sides. ');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (3, 'R06', 'Put the muffins in the oven and turn it on to broil.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (4, 'R06', 'While the muffins are toasting, slice the tomato and avocado.');

INSERT INTO Steps(StepNum, RID, Descr) 
VALUES (5, 'R06', 'Once the English muffins are toasted and the Brie has melted, take them out of the oven and place the remaining ingredients on top.');

--Recipe Themes--

INSERT INTO Themes(TID, Name, Descr)
VALUES ('T07', 'Indulgence', 'Foods you love but dont eat that often.');


--Recipe Themes List--

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T07', 'R06');

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T01', 'R06');

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T04', 'R06');

--Publish Method Themes List--

INSERT INTO PublishMethodsThemesList(TID, PID)
VALUES ('T07', 'P06');

--Recipe 7--

--INFORMATION ASSOCIATED WITH RECIPE--

INSERT INTO People(PerID, Fname, Lname, Birthday)
VALUES ('PER08', 'Jane', 'Moorhead', '1895-11-23');

INSERT INTO Authors(PerID, Inspiration)
VALUES ('PER08', 'Her Grandma''s Recipes');

INSERT INTO CookbookAuthors(PerID, NumCookbooks)
VALUES ('PER08', '1');

INSERT INTO Parts(ParID, Name)
VALUES ('PAR15', 'Entire Recipe');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U12', 'Large Skillet', 'Cuisinart',  'Medium Skillet', 'Stainless Steel');

INSERT INTO Photos(PhID, HeightPX, WidthPX, DateAdded, Edited)
VALUES ('PH08', '206', '315',  '2016-11-24', TRUE);

INSERT INTO Photos(PhID, HeightPX, WidthPX, DateAdded, Edited)
VALUES ('PH09', '706', '915',  '2016-11-24', TRUE);

INSERT INTO PublishMethods(PID, YearPublished, Title, ContentDescr)
VALUES ('P07', '1915', 'Peoria Women''s Cook Book', 'Your Grandma''s Recipes' );

--Cookbooks--

INSERT INTO Cookbooks(PID, NumRecipes, PriceUSD, Publisher)
VALUES ('P07', '170', '10.00', 'J.W. Franks and Sons Printers');

--Recipes--

INSERT INTO Recipes(RID, Name, DateCreated, DateUpdated, PrepTimeMin, CookTimeMin, TotalTimeMin, Serves, Category, SRC)
VALUES ('R07', 'Steak A La Creole', '1915-09-15', '2016-11-11', 25, 120, 145, 4, 'Steak', 'Original');

--Published--
INSERT INTO Published(PID, PerID)
VALUES ('P07', 'PER06');

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P07', 'R07');

--INGREDIENTS INSERTIONS--

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I64', 'Round Steak', 'Clean and remove fat', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I65', 'Green Peppers', 'Summer', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I66', 'Parsley', 'n/a', FALSE);


--CONNECTING UTENSILS, INGREDIENTS, AND STEPS TO THEIR RECIPES--

--Ingredients List--

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I64', 'PAR15', 'Clean and remove fat', '1 lb.');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I10', 'PAR15', 'Melt butter in pan.', '1 Tablespoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I65', 'PAR15','Seeded and chopped', '2 medium');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I44', 'PAR15', 'Minced fine', '1');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I29', 'PAR15', 'Dice', '1 cup');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I66', 'PAR15', 'Mince', 'Garnish');

--Parts List--

INSERT INTO PartsList(ParID, RID)
VALUES ('PAR15', 'R07');

--Utensils List--

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U12', 'R07', 1);

--Photos List--

INSERT INTO PhotosList(PhID, RID)
VALUES ('PH08', 'R07');

INSERT INTO PhotosList(PhID, RID)
VALUES ('PH09', 'R07');

--Steps--

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (1, 'R07', 'Brown Steak in butter.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (2, 'R07', 'Add tomatoes, onion and green pepper.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (3, 'R07', 'Simmer 2 hours or until done, either in the oven or on top of stove.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (4, 'R07', 'Garnish with parsley.');

--Recipe Themes--

INSERT INTO Themes(TID, Name, Descr)
VALUES ('T08', 'Classics', 'The basic recipes.');


--Recipe Themes List--

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T08', 'R07');

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T01', 'R07');

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T04', 'R07');

--Publish Method Themes List--

INSERT INTO PublishMethodsThemesList(TID, PID)
VALUES ('T08', 'P07');

--Recipe 8--

--INFORMATION ASSOCIATED WITH RECIPE--

INSERT INTO People(PerID, Fname, Lname, Birthday)
VALUES ('PER10', 'Peggy', 'Wilson', '1896-11-23');

INSERT INTO Authors(PerID, Inspiration)
VALUES ('PER10', 'Her Grandma''s Recipes');

INSERT INTO CookbookAuthors(PerID, NumCookbooks)
VALUES ('PER10', '1');

INSERT INTO Parts(ParID, Name)
VALUES ('PAR11', 'Entire Recipe');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U13', 'Large Saucepan', 'All-Clad',  'Medium Skillet', 'Stainless Steel');

INSERT INTO Photos(PhID, HeightPX, WidthPX, DateAdded, Edited)
VALUES ('PH10', '406', '315',  '2016-11-24', TRUE);

--Recipes--

INSERT INTO Recipes(RID, Name, DateCreated, DateUpdated, PrepTimeMin, CookTimeMin, TotalTimeMin, Serves, Category, SRC)
VALUES ('R08', 'Mexican Chili', '1915-09-15', '2016-11-12', 20, 30, 50, 4, 'Chili', 'Original');

--Published--
INSERT INTO Published(PID, PerID)
VALUES ('P07', 'PER10');

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P07', 'R08');

--INGREDIENTS INSERTIONS--
INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I67', 'Ground Beef', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I68', 'Kidney Beans', 'n/a', FALSE);

--CONNECTING UTENSILS, INGREDIENTS, AND STEPS TO THEIR RECIPES--

--Ingredients List--
INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I67', 'PAR11', 'None', '.75 lb');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I68', 'PAR11', 'None', '1 15 oz. can');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I05', 'PAR11','Minced', '2 cloves');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I29', 'PAR11', 'Canned', '1 can');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I44', 'PAR11', 'Dice', '3');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I54', 'PAR11', 'None', '2 slices');

--Parts List--

INSERT INTO PartsList(ParID, RID)
VALUES ('PAR11', 'R08');

--Utensils List--

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U13', 'R08', 1);

--Photos List--

INSERT INTO PhotosList(PhID, RID)
VALUES ('PH10', 'R08');

--Steps--

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (1, 'R08', 'Heat olive oil on med. heat then add onions and garlic. ');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (2, 'R08', 'Add the ground beef and cook until mostly cooked.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (3, 'R08', 'Once fragrant, add the rest of the ingredients and season to taste.  Let cook 20 min.');


--Recipe Themes List--

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T08', 'R08');

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T01', 'R08');

--Recipe 9--

--INFORMATION ASSOCIATED WITH RECIPE--

INSERT INTO Parts(ParID, Name)
VALUES ('PAR12', 'Entire Recipe');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U14', ' Stand Mixer', 'KitchenAid',  'Spatula', 'Stainless Steel');

INSERT INTO Photos(PhID, HeightPX, WidthPX, DateAdded, Edited)
VALUES ('PH11', '406', '315',  '2016-11-24', TRUE);

--Recipes--

INSERT INTO Recipes(RID, Name, DateCreated, DateUpdated, PrepTimeMin, CookTimeMin, TotalTimeMin, Serves, Category, SRC)
VALUES ('R09', 'Chocolate Chip Cookies', '1915-09-15', '2016-11-12', 140, 12, 152, 20, 'Cookies', 'My Mother');

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P08', 'R09');

--INGREDIENTS INSERTIONS--
INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I69', 'Semi-Sweet Chocolate Chips', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I70', 'Oats', 'n/a', FALSE);

--CONNECTING UTENSILS, INGREDIENTS, AND STEPS TO THEIR RECIPES--

--Ingredients List--
INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I10', 'PAR12', 'Refrigerated', '2 sticks');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I16', 'PAR12', 'None', '1 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I12', 'PAR12','Refrigerated', '2 Large');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I24', 'PAR12', 'Packed into the measuring cup', '1 cup');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I69', 'PAR12', 'None', '2 cups and a handful');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I18', 'PAR12', 'None', '1 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I04', 'PAR12', 'None', '1 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I14', 'PAR12', 'None', '2 1/2 cups');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I70', 'PAR12', 'None', '1 Cup');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I11', 'PAR12', 'None', '6/8 of an inch (measured from top of inside of measuring cup) less than 1 cup');

--Parts List--

INSERT INTO PartsList(ParID, RID)
VALUES ('PAR12', 'R09');

--Utensils List--

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U14', 'R09', 1);

--Photos List--

INSERT INTO PhotosList(PhID, RID)
VALUES ('PH11', 'R09');

--Steps--

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (1, 'R09', 'Add 2 sticks of refrigerated butter to the kitchen Aid mixer bowl and beat on low until it’s just a little mushed.  Roughly 30 sec.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (2, 'R09', 'Add brown sugar and white sugar, then cover with hands while beating on high until med/small clumps form.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (3, 'R09', 'Take the bowl out from under the kitchen aid and using a rice spoon/paddle mash the clumps of butter against the side of the bowl until most of them are broken up and gone. ');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (4, 'R09', 'Add eggs, baking soda, salt, and vanilla then mix. of butter against the side of the bowl until most of them are broken up and gone. ');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (5, 'R09', 'Add flour then mix.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (6, 'R09', 'Add oats and chocolate chips then mix. ');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (7, 'R09', 'Refrigerate for an hour or 2 but NOT overnight!');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (8, 'R09', 'Preheat oven 350 degrees.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (9, 'R09', 'Scoop onto baking stone or greased cookie sheet and bake for 10-12 min or to your preference.');

--Recipe Themes--

INSERT INTO Themes(TID, Name, Descr)
VALUES ('T09', 'In the Family', 'Passed down recipes.');

--Recipe Themes List--

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T08', 'R09');

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T09', 'R09');


--Publish Method Themes List--

INSERT INTO PublishMethodsThemesList(TID, PID)
VALUES ('T08', 'P08');


--Recipe 10--

--INFORMATION ASSOCIATED WITH RECIPE--

INSERT INTO People(PerID, Fname, Lname, Birthday)
VALUES ('PER11', 'Lidia', 'Bastianich', '1947-02-21');

INSERT INTO Authors(PerID, Inspiration)
VALUES ('PER11', 'Italian Cuisine');

INSERT INTO CookbookAuthors(PerID, NumCookbooks)
VALUES ('PER11', '30');

INSERT INTO Parts(ParID, Name)
VALUES ('PAR13', 'Dough');

INSERT INTO Parts(ParID, Name)
VALUES ('PAR14', 'Coffee Cream');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U15', ' Food Processor', 'Cuisinart',  'Blender', 'n/a');

INSERT INTO Utensils(UID, Name, Brand, AlternateUtensil, Material)
VALUES ('U16', ' 4-½–inch fluted -mini–tart pan', 'Wilton',  '6-½–inch fluted -mini–tart pan', 'Stoneware');

INSERT INTO Photos(PhID, HeightPX, WidthPX, DateAdded, Edited)
VALUES ('PH12', '404', '315',  '2016-11-24', TRUE);

INSERT INTO PublishMethods(PID, YearPublished, Title, ContentDescr)
VALUES ('P09', '2013-10-15', 'Lidia''s Commonsense Italian Cooking', 'Easy, simple, Italian cooking.' );

INSERT INTO PublishMethods(PID, YearPublished, Title, ContentDescr)
VALUES ('P10', '2013', 'Lidia''s Recipe Archives', 'Italian cooking.' );


--Recipes--

INSERT INTO Recipes(RID, Name, DateCreated, DateUpdated, PrepTimeMin, CookTimeMin, TotalTimeMin, Serves, Category, SRC)
VALUES ('R10', 'Almond and Coffee Cream Mini-Tarts', '2013-10-15', '2016-11-12', 75, 25, 100, 8, 'Tarts', 'Original');


INSERT INTO RecipeGroups(PID, RID)
VALUES ('P09', 'R10');

INSERT INTO RecipeGroups(PID, RID)
VALUES ('P10', 'R10');

--INGREDIENTS INSERTIONS--
INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I71', 'Ice Water', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I72', 'Instant Espresso Powder', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I73', 'Cornstarch', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I74', 'Almond Extract', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I75', 'Heavy Cream', 'n/a', FALSE);

INSERT INTO Ingredients(IID, Name, Season, Allergen)
VALUES ('I76', 'Almonds', 'n/a', FALSE);


--CONNECTING UTENSILS, INGREDIENTS, AND STEPS TO THEIR RECIPES--

--Ingredients List--
INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I10', 'PAR13', 'Refrigerated and cut into pieces', '1 1/2 sticks');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I04', 'PAR13', 'None', '1/4 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I12', 'PAR13', 'Yolks', '3 Large');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I11', 'PAR13', 'None', '3 Tablespoons');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I14', 'PAR13','None', '2 Cups');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I71', 'PAR13','None', '2 Tablespoons');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I58', 'PAR14', 'None', '1 1/2 cups');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I72', 'PAR14', 'None', '1 Tablespoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I12', 'PAR14', 'Yolks', '3 Large');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I11', 'PAR14', 'None', '6 Tablespoons');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I04', 'PAR14','None', 'Pinch');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I14', 'PAR14','None', '1 Tablespoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I73', 'PAR14','None', '2 Tablespoons');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I74', 'PAR14','None', '1/2 Teaspoon');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I75', 'PAR14','Whipped to soft peaks', '1/2 Cup');

INSERT INTO IngredientsList(IID, ParID, WayPrep, Quantity)
VALUES ('I75', 'PAR14','Sliced and toasted for serving', '1/4 Cup');




--Parts List--

INSERT INTO PartsList(ParID, RID)
VALUES ('PAR13', 'R10');

INSERT INTO PartsList(ParID, RID)
VALUES ('PAR14', 'R10');

--Utensils List--

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U15', 'R10', 1);

INSERT INTO UtensilsList(UID, RID, Quantity)
VALUES ('U16', 'R10', 1);

--Photos List--

INSERT INTO PhotosList(PhID, RID)
VALUES ('PH12', 'R10');

--Steps--

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (1, 'R10', 'For the dough:');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (2, 'R10', 'In a food processor, pulse together the flour, sugar, and salt. Drop in the butter, and pulse until the mixture looks like coarse crumbs. Beat together the egg yolks and water, and pour into the processor. Pulse until the dough just comes together, adding a little water if crumbly, or a little flour if it is too wet.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (3, 'R10', 'On the counter, knead the dough a few times; then flatten it into a disk, wrap in plastic, and chill for at least 30 minutes.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (4, 'R10', 'Preheat the oven to 400 degrees F. Roll out the dough on a floured surface to about ¹⁄8-inch thick. Cut out eight rounds to fit into eight individual 4-½–inch fluted -mini–tart pans. Fit the dough into the pans, and trim so the dough is flush with the rims. Chill for 15 minutes, then place on a sheet pan. ');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (5, 'R10', 'Dock the dough with a fork, and place parchment circles filled with pie weights or beans in each tart. Bake until the dough is set but still blond in color, about 10 minutes. Remove the parchment and the weights, and continue baking until the dough is crisp and golden, about 10 to 15 minutes more. Remove from the oven, and cool on racks.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (6, 'R10', 'For the coffee cream:');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (7, 'R10', 'In a saucepan, bring the milk just to a simmer, and whisk in the espresso powder. In a medium bowl, whisk together the egg yolks, sugar, salt, cornstarch, and flour until smooth. Whisk in the hot milk a little at a time, tempering the eggs. Pour the mixture back into the saucepan over low heat until it just begins to simmer and thickens.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (8, 'R10', 'Strain it into a clean bowl, stir in the almond extract, and chill, covering the surface with plastic wrap to keep it from forming a skin.When the cream is chilled, fold in the whipped cream. Dollop the coffee cream into cooled tart shells, and garnish with almonds.');

INSERT INTO Steps(StepNum, RID, Descr)
VALUES (9, 'R10', 'Serve.');

--Recipe Themes--

INSERT INTO Themes(TID, Name, Descr)
VALUES ('T10', 'Italian Dessert', 'Classic to the Italian cuisine and a good way to end a meal.');

--Recipe Themes List--

INSERT INTO RecipeThemesList(TID, RID)
VALUES ('T10', 'R10');


--Publish Method Themes List--

INSERT INTO PublishMethodsThemesList(TID, PID)
VALUES ('T04', 'P09');

INSERT INTO PublishMethodsThemesList(TID, PID)
VALUES ('T04', 'P10');

--Chefs--
INSERT INTO People(PerID, Fname, Lname, Birthday)
VALUES ('PER12', 'Cassidy', 'Mazelin', '1997-05-21');

INSERT INTO Chefs(PerID, Title, CurrentJob)
VALUES ('PER09', 'Chef (The Gourmet College Chef)', 'Home Chef');

INSERT INTO Chefs(PerID, Title, CurrentJob)
VALUES ('PER12', 'Sous Chef', 'The Gourmet College Chef''s Sous Chef'); 


INSERT INTO Chefs(PerID, Title, CurrentJob)
VALUES ('PER02', 'Chef', 'TV Chef');

INSERT INTO Chefs(PerID, Title, CurrentJob)
VALUES ('PER03', 'Chef in training', 'Home Chef');

INSERT INTO Chefs(PerID, Title, CurrentJob)
VALUES ('PER04', 'Sous Chef', 'Pastabilities');

INSERT INTO Chefs(PerID, Title, CurrentJob)
VALUES ('PER11', 'Chef', 'TV Chef');

--Select statements--
select *
from Recipes;

select *
From Utensils;

Select * 
From Chefs;

Select * 
From Blogs;

Select *
From Photos;

--Affinities--

INSERT INTO FlavorAffinities(AID, Origin)
VALUES ('A01', 'African Cuisine West');

INSERT INTO FlavorAffinities(AID, Origin)
VALUES ('A02', 'Spanish Cuisine');

INSERT INTO FlavorAffinities(AID, Origin)
VALUES ('A03', 'American Cuisine');

INSERT INTO FlavorAffinities(AID, Origin)
VALUES ('A04', 'Asian Cuisine');

INSERT INTO FlavorAffinities(AID, Origin)
VALUES ('A05', 'French Cuisine');

INSERT INTO FlavorAffinities(AID, Origin)
VALUES ('A06', 'Mexican Cuisine');

INSERT INTO FlavorAffinities(AID, Origin)
VALUES ('A07', 'Mexican Cuisine');




--Affinities List--
INSERT INTO AffinitiesList(AID, IID)
VALUES ('A01', 'I43');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A01', 'I29');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A01', 'I48');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A02', 'I49');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A02', 'I50');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A02', 'I02');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A02', 'I13');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A03', 'I51');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A03', 'I52');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A03', 'I48');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A04', 'I53');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A04', 'I10');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A04', 'I25');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A04', 'I12');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A05', 'I05');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A06', 'I45');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A06', 'I33');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A06', 'I29');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A06', 'I54');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A07', 'I45');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A07', 'I55');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A07', 'I23');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A07', 'I05');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A07', 'I56');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A07', 'I57');

INSERT INTO AffinitiesList(AID, IID)
VALUES ('A07', 'I44');

--Substitution--

--Buttermilk--
INSERT INTO Substitutions(SLID, IID, howMuchMake, Instructions)
VALUES ('SL01', 'I17', '2 Cups', 'Put the lemon juice in the 1 Cup measuring cup then fill the rest with milk.');
--Gruyere--
INSERT INTO Substitutions(SLID, IID, howMuchMake, Instructions)
VALUES ('SL02', 'I37', 'Any', 'Do direct substitution.');
--Oregano--
INSERT INTO Substitutions(SLID, IID, howMuchMake, Instructions)
VALUES ('SL03', 'I42', 'Any', 'Do direct substitution.');
--Scallions
INSERT INTO Substitutions(SLID, IID, howMuchMake, Instructions)
VALUES ('SL04', 'I33', 'Any', 'Do direct substitution.');


--Ingredients associated with substitutions--

INSERT INTO IngredientsOfSubstitution(SLID, IID, Quantity)
VALUES ('SL01', 'I58', 'About 1 Cup');

INSERT INTO IngredientsOfSubstitution(SLID, IID, Quantity)
VALUES ('SL01', 'I13', '1 Tablespoon');

INSERT INTO IngredientsOfSubstitution(SLID, IID, Quantity)
VALUES ('SL02', 'I37', 'As much as the recipe calls for.');

INSERT INTO IngredientsOfSubstitution(SLID, IID, Quantity)
VALUES ('SL03', 'I42', 'As much as the recipe calls for.');

INSERT INTO IngredientsOfSubstitution(SLID, IID, Quantity)
VALUES ('SL04', 'I61', 'As much as the recipe calls for.');

----------------------------------------------------------------------------------------
-- Recipes Database Views
-- by Jessica Rieger
-- Tested on Postgres 9.3.2
----------------------------------------------------------------------------------------
--Views--

--Entire Recipe Information--

create view EntireRecipe AS
select r.name, r.datecreated, r.preptimemin, r.cooktimemin, r.serves, r.src, ul.uid, pl.ParID, rg.pid, phl.phid, s.descr
from Recipes r inner join utensilslist ul ON r.rid = ul.rid
		inner join PartsList pl ON r.rid = pl.rid
		inner join recipegroups rg ON r.rid = rg.rid
		inner join photoslist phl ON r.rid = phl.rid
		inner join Steps s ON r.rid = s.rid
		inner join RecipeThemesList rtl ON r.rid = rtl.rid;
		
--Ingredient Affinities--

create view IngredientAffinities AS
Select al.aid, i.name, i.allergen, fa.origin
from Affinitieslist al inner join ingredients i ON i.iid = al.iid
			inner join flavoraffinities fa ON fa.aid = al.aid;
			
--Publish Methods, their themes and their authors--

create view publicationinformation AS
Select 	p.pid, 
	p.title, 
	p.yearpublished, 
	p.contentdescr, 
	peo.perid, 
	peo.fname,
	peo.lname,
	t.tid,
	t.name 
from 	Published pd, 
	publishmethods p, 
	authors a, 
	people peo,
	Publishmethodsthemeslist ptl,
	Themes t
Where pd.pid = p.pid 
     and pd.perid = a.perid 
     and peo.perid = a.perid
     and ptl.pid = p.pid
     and ptl.tid = t.tid;
  
----------------------------------------------------------------------------------------
-- Recipes Database Reports
-- by Jessica Rieger
-- Tested on Postgres 9.3.2
----------------------------------------------------------------------------------------

--Number of publications associated with a particular author in a year--
select 	peo.fname, 
		peo.lname, 
		count(*) as NumberOfPublications 
from 	publishmethods p, 
        published pu, 
		authors a, 
		people peo 
where peo.perid = a.perid 
  and p.pid = pu.pid  
  and pu.perid = a.perid 
  and yearpublished = '2016' --as an example
  group by peo.fname, peo.lname;

--Complexity of recipes--
select *
from (select avg(num) as averageUtensils
	from (Select count(ul.uid) as num
		from recipes r, utensilslist ul, utensils u
		where r.rid = ul.rid
		and ul.uid = u.uid
		group by r.rid
		) as utensilcount
	) as utensils, 
	(select avg(num1) as averageSteps
	from (Select count(steps.stepnum) as num1
	      from recipes r, steps
	      where r.rid = steps.rid
	      group by r.rid
	     ) as stepscount
	) as average2,
	(select avg(num2) as averageParts
	from (Select count(pl.parid) as num2
	      from recipes r, parts p, partslist pl
	      where r.rid = pl.rid
	      and pl.parid = p.parid
	      group by r.rid
	     ) as partscount
	) as average3;

	
--themes cleanup--
select 	COALESCE(recipetheme.rtheme,'Not Used') AS RThemes,
		COALESCE(recipetheme.ruse,'0') AS RNumTimesUsed, 
		COALESCE(publishtheme.ptheme,'Not Used') AS PThemes,
		COALESCE(publishtheme.puse,'0') AS PNumTimesUsed   
from (select 	count(rtl.rid) as ruse, 
	     	  	rtl.tid as rtheme
	  from 	recipes r, 
			recipethemeslist rtl 
	  where r.rid = rtl.rid
	  group by rtl.tid
     ) as recipetheme full outer join (select 	count(ptl.tid) as puse, 
     											ptl.tid as ptheme
      								   from 	publishmethodsthemeslist ptl, 
												publishmethods pm
      								   where pm.pid = ptl.pid
      								   group by ptl.tid
      								   ) as publishtheme ON recipetheme.rtheme = publishtheme.ptheme
order by rthemes;


--Potential Tweaks to a Recipe--
select 	r.rid,  	
	r.name,  	
	fa.origin,  	
	al.*,  	
	i.name 
from 	recipes r,  	
	partslist pl,  	
	ingredientslist il,  	
	ingredients i,  	
	flavoraffinities fa,  	
	affinitieslist al 
where r.rid = pl.rid   
    and pl.parid = il.parid   
    and il.iid = i.iid   
    and fa.aid = al.aid   
    and i.iid = al.iid 
order by r.rid;

----------------------------------------------------------------------------------------
-- Recipes Database Stored Procedures
-- by Jessica Rieger
-- Tested on Postgres 9.3.2
----------------------------------------------------------------------------------------

--Stored Procedures--

--gets ingredients for recipe by id--
create or replace function get_recipe_ingredientslist_byID(text) 
returns table (iid        text, 
               recipename text,
               parid      text, 
               wayprep    text,
               quantity   text)
as 
$$
declare
   recipeID text := $1;
begin
   return query
      select ingredients.iid, 
             ingredients.name, 
             ingredientslist.parid, 
             ingredientslist.wayprep, 
             ingredientslist.quantity
      from Ingredients, 
           Ingredientslist,         
           partslist
      where Ingredients.iid = Ingredientslist.iid 
        and partslist.parid = ingredientslist.parid
        and partslist.rid = recipeID;
end;
$$ 
language plpgsql;

--gets ingredients for recipe by name--
create or replace function get_recipe_ingredientslist_byName(text) 
returns table (iid        text, 
               recipename text,
               parid      text, 
               wayprep    text,
               quantity   text)
as 
$$
declare
   recipeName text := $1;
begin
   return query
      select ingredients.iid, 
             ingredients.name, 
             ingredientslist.parid, 
             ingredientslist.wayprep, 
             ingredientslist.quantity
      from Ingredients, 
           Ingredientslist,         
           partslist,
           recipes
      where Ingredients.iid = Ingredientslist.iid 
        and partslist.parid = ingredientslist.parid
        and partslist.rid = recipes.rid
        and recipes.name = recipeName;
end;
$$ 
language plpgsql;


--Get Ingredients List by Name or ID-- (enter NULL as the value you do not wish to have searched by)
create or replace function get_recipe_ingredientslist_byNameOrId(text, text, REFCURSOR) returns refcursor as 
$$
declare
   recipeName text      := $1;
   recipeId   text      := $2;
   resultset  REFCURSOR := $3;
begin
   if (recipeId IS NOT NULL) then
      open resultset for 
         select * 
         FROM get_recipe_ingredientslist_byId(recipeId);
	else 
		open resultset for
			select *
			From get_recipe_ingredientslist_byName(recipeName);
   end if; 
    
   return resultset;
end;
$$ 
language plpgsql;

--example use--
select get_recipe_ingredientslist_byNameORID('Butternut Squash Soup', NULL, 'results');
fetch all from results;

--Calculate the Total Time for a recipe record--
create or replace function calculateTotalTimeMin() returns trigger as 
$$
declare
   
   total integer := cast(new.preptimemin as Integer) + cast(new.cooktimemin as integer);
begin
		
		new.totaltimemin = total;
		return NEW;
   
end;
$$ 
language plpgsql;

----------------------------------------------------------------------------------------
-- Recipes Database Triggers
-- by Jessica Rieger
-- Tested on Postgres 9.3.2
----------------------------------------------------------------------------------------

--Updates or calculates the total time for a recipe record after insert or update on recipes table.--
create trigger totalTime
BEFORE INSERT OR UPDATE ON Recipes
	FOR EACH ROW EXECUTE PROCEDURE calculateTotalTimeMin();



