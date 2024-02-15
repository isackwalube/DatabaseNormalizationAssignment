--Create a non-normalized table, and add the columns
CREATE TABLE Parks_Info (
    ID SERIAL PRIMARY KEY,  -- simply means that the ID column will auto-generated an integer for every new row. 
    ParkName VARCHAR(255),  --VARCHAR - variable character with maximum length of 255 characters
    Facilities VARCHAR(255)
);

--Insert data into the table
INSERT INTO Parks_Info (ParkName, Facilities) VALUES 
('Central Park', 'Playground, Restroom, Picnic area'),
('Liberty Park', 'Restroom, Picnic area'),
('Riverside Park', 'Playground, Bike Path');

-- create a Parks table
CREATE TABLE Parks (
    ParkID SERIAL PRIMARY KEY,
    ParkName VARCHAR(255)
);

--Insert data into the new table 
INSERT INTO Parks (ParkName)
SELECT DISTINCT ParkName FROM Parks_Info; --data gotten directly from the Parks_info table

--Create a facilities table
--foreign key relating the two tables
CREATE TABLE Facilities (
    FacilityID SERIAL PRIMARY KEY,
    ParkID INT,   --data type here is integer(INT) storing integer values.
    FacilityName VARCHAR(255),
    FOREIGN KEY (ParkID) REFERENCES Parks(ParkID)  --Thus establishes a foreighn key ensuring the values in 'ParkID'
);													--  column match in both the tables.

--Insert data into the new table 
INSERT INTO Facilities (ParkID, FacilityName) VALUES
(1, 'Playground'),
(1, 'Restroom'),
(1, 'Picnic area'),
(2, 'Restroom'),
(2, 'Picnic area'),
(3, 'Playground'),
(3, 'Bike Path');


--2NF--
--Create a new table 
CREATE TABLE ParkFacilities (
    FacilityID SERIAL PRIMARY KEY,
    FacilityName VARCHAR(255)
);

--Insert data into the table
INSERT INTO ParkFacilities (FacilityName) VALUES 
('Playground'),('Restroom'), ('Picnic area'), ('Bike Path')

--Add column(ParkFacilityID) into the the Facilities table
ALTER TABLE Facilities ADD COLUMN ParkFacilityID INT;

--Link the facility in ‘Facilities’ to a unique identifier in ‘ParkFacilities’
ALTER TABLE Facilities
ADD CONSTRAINT fk_parkfacilityid FOREIGN KEY (ParkFacilityID) REFERENCES ParkFacilities(FacilityID); --

--Add a foreign key constraint to ‘Facilities’ to enforce the relationship between ‘Facilities’ and ‘ParkFacilities’.
--ensuring that every ‘FacilityID’ in ‘Facilities’ corresponds to a valid ‘FacilityID’ in ‘ParkFacilities’.
UPDATE Facilities
SET ParkFacilityID = (
    SELECT FacilityID 
    FROM ParkFacilities 
    WHERE FacilityName = Facilities.FacilityName
);


--make changes to Facilities by deleting the column FacilityName.
ALTER TABLE Facilities DROP COLUMN FacilityName;;



