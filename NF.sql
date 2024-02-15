--Create a non-normalized table, and add the columns
--ID SERIAL PRIMARY KEY - simply means that the ID column will auto-henerated integer for every new row. 
--VARCHAR - variable character with maximum length of 255 characters

CREATE TABLE Parks_Info (
    ID SERIAL PRIMARY KEY,
    ParkName VARCHAR(255),
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

INSERT INTO Parks (ParkName)
SELECT DISTINCT ParkName FROM Parks_Info;

--Create a facilities table
--foreign key relating the two tables
CREATE TABLE Facilities (
    FacilityID SERIAL PRIMARY KEY,
    ParkID INT,
    FacilityName VARCHAR(255),
    FOREIGN KEY (ParkID) REFERENCES Parks(ParkID)
);

INSERT INTO Facilities (ParkID, FacilityName) VALUES
(1, 'Playground'),
(1, 'Restroom'),
(1, 'Picnic area'),
(2, 'Restroom'),
(2, 'Picnic area'),
(3, 'Playground'),
(3, 'Bike Path');


INSERT INTO Facilities (FacilityID, FacilityName)
SELECT DISTINCT Facilities FROM Parks_Info;
SELECT DISTINCT ParkID FROM Parks_Info
drop table Parks



--select * from Parks
--select * from Facilities
--DROP TABLE ParkFacilities

CREATE TABLE Facilities (
FacilityID SERIAL PRIMARY KEY,
ParkID INT,
FacilityName VARCHAR(255),
FOREIGN KEY (ParkID) REFERENCES Parks(ParkID)
);


--2NF--

CREATE TABLE ParkFacilities (
    FacilityID SERIAL PRIMARY KEY,
    FacilityName VARCHAR(255)
);

INSERT INTO ParkFacilities (FacilityName)
VALUES 
('Playground'),('Restroom'), ('Picnic area'), ('Bike Path')


ALTER TABLE Facilities ADD COLUMN ParkFacilityID INT;

ALTER TABLE Facilities
ADD CONSTRAINT fk_parkfacilityid FOREIGN KEY (ParkFacilityID) REFERENCES ParkFacilities(FacilityID);

UPDATE Facilities
SET ParkFacilityID = (
    SELECT FacilityID 
    FROM ParkFacilities 
    WHERE FacilityName = Facilities.FacilityName
);


UPDATE Facilities
SET ParkFacilityID = (SELECT FacilityID FROM ParkFacilities WHERE FacilityName = Facilities.FacilityName);

-- Cleanup redundant columns
ALTER TABLE Facilities DROP COLUMN FacilityName;;

INSERT INTO ParkFacilities (FacilityName)
SELECT DISTINCT FacilityName FROM Facilities;

ALTER TABLE ParkFacilities ADD COLUMN ParkFacilityID INT;





