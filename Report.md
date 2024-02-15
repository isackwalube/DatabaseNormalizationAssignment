# **Database Normalization Assignment**

## *Part 1: Introduction*
Database Normalization is a process in which data can be structured to minimize redundancy and dependency, 
to improve data integrity and ensure efficient data management. 



### **Overall significance**
1. *First Normal Form (1NF):*
  - The rationale behind normalizing a database to 1NF is to eliminate repeating groups within individual rows and ensure data atomicity. 
    Atomicity means that each attribute in a table should contain only one value and not a set of values.
  - By achieving 1NF, the database becomes more structured, making it easier to manage and query data.
  - For example, from our non-normalized **Parks_info** table, we had multiple facilities in a single column, we normalized it to 1NF breaking it down to have each facility identified uniquely 
    in a new **Facilities** table.

2. *Second Normal Form (2NF):*
  - The rationale behind normalizing to 2NF is to remove partial dependencies within a table.
    Partial dependency is when non-key attributes depend on only a part of the primary key.
  - By moving data that is dependent on only part of the primary key to separate tables, redundancy is reduced, and data integrity 
    is improved ensuring that each table represents a single entity.
  - 2NF reduces the risk of inconsistency by ensuring that each piece of data is stored in only one place.
  - For example, if you have a composite primary key in a table and some non-key attributes depend only on one part of that 
    composite key, you would decompose the table into multiple tables to eliminate such partial dependencies, similar to what we did to the first *Facilities* table where we further broke it down and created the *ParkFacilities* table

## *Part 2: Code Block*

1. Create a non-normalized table, and add the columns

`CREATE TABLE Parks_Info (
    ID SERIAL PRIMARY KEY,  
    ParkName VARCHAR(255), 
    Facilities VARCHAR(255)
);`



2. Insert data into the table

`INSERT INTO Parks_Info (ParkName, Facilities) VALUES 
('Central Park', 'Playground, Restroom, Picnic area'),
('Liberty Park', 'Restroom, Picnic area'),
('Riverside Park', 'Playground, Bike Path');`
![Parks_Info](https://github.com/isackwalube/in346/assets/156945477/e4ddee70-3755-430d-afcc-e1959e6417ae)


3. Create a Parks table

`CREATE TABLE Parks (
    ParkID SERIAL PRIMARY KEY,
    ParkName VARCHAR(255)
);`


4. Insert data into the new table

INSERT INTO Parks (ParkName)
SELECT DISTINCT ParkName FROM Parks_Info;
![Parks](https://github.com/isackwalube/in346/assets/156945477/842d21b7-0054-4d87-ad3f-5c13dd5a90eb)


5. Create a facilities table and foreign key relating the two tables

`CREATE TABLE Facilities (
    FacilityID SERIAL PRIMARY KEY,
    ParkID INT,  
    FacilityName VARCHAR(255),
    FOREIGN KEY (ParkID) REFERENCES Parks(ParkID)  
);`		


6. Insert data into the new table 

`INSERT INTO Facilities (ParkID, FacilityName) VALUES
(1, 'Playground'),
(1, 'Restroom'),
(1, 'Picnic area'),
(2, 'Restroom'),
(2, 'Picnic area'),
(3, 'Playground'),
(3, 'Bike Path');`
![1st_Facilities_Table](https://github.com/isackwalube/in346/assets/156945477/3ca621aa-3716-477a-b097-8856ad36d2a1)


## **2NF**
1. Create a new table 

`CREATE TABLE ParkFacilities (
    FacilityID SERIAL PRIMARY KEY,
    FacilityName VARCHAR(255)
);`


2. Insert data into the table

`INSERT INTO ParkFacilities (FacilityName) VALUES 
('Playground'),('Restroom'), ('Picnic area'), ('Bike Path')`

![ParkFacilities](https://github.com/isackwalube/in346/assets/156945477/4829c757-9e68-4f46-808e-b06b76460a67)


3. Add column(ParkFacilityID) into the the Facilities table

`ALTER TABLE Facilities ADD COLUMN ParkFacilityID INT;`


4. Link the facility in ‘Facilities’ to a unique identifier in ‘ParkFacilities’

`ALTER TABLE Facilities
ADD CONSTRAINT fk_parkfacilityid FOREIGN KEY (ParkFacilityID) REFERENCES ParkFacilities(FacilityID);`


4. Add a foreign key constraint to ‘Facilities’ to enforce the relationship between ‘Facilities’ and ‘ParkFacilities’.
Ensuring that every ‘FacilityID’ in ‘Facilities’ corresponds to a valid ‘FacilityID’ in ‘ParkFacilities’.

`UPDATE Facilities
SET ParkFacilityID = (
    SELECT FacilityID 
    FROM ParkFacilities 
    WHERE FacilityName = Facilities.FacilityName
);`

![Facilities_Table](https://github.com/isackwalube/in346/assets/156945477/ad0ff3a9-ffcf-447e-ae94-24cfb3195e5d)


5. Make changes to Facilities by deleting the column FacilityName.

`ALTER TABLE Facilities DROP COLUMN FacilityName;;`

![Final_Facilities_Table](https://github.com/isackwalube/in346/assets/156945477/65339143-4b61-4025-8eea-0d7b9a3ab904)

 



### *Challenge*

   - The only challenge encountered in this assignment was importing data from another table. This dataset was small, therefore manual import was possible.
For big data cases, it'd be tiresome to type in all those rows, meaning there is a need to find an automatic query to import the data without typing manually. 


### *Solution*

From `https://www.atlassian.com/data/sql/copying-data-between-tables#:~:text=Copy%20into%20pre%2Dexisting%20table,run%20than%20a%20normal%20query.`

INSERT INTO [Table to copy To] 
SELECT [Columns to Copy] 
FROM [Table to copy From] 
WHERE [Optional Condition];
