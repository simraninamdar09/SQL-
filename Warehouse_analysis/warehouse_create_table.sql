create database warehouse;

CREATE TABLE warehouse.warehouses (
   Code INTEGER NOT NULL,
   Location VARCHAR(255) NOT NULL ,
   Capacity INTEGER NOT NULL,
   PRIMARY KEY (Code)
 );
 
 CREATE TABLE warehouse.boxes (
    Code CHAR(4) NOT NULL,
    Contents VARCHAR(255) NOT NULL ,
    Value REAL NOT NULL ,
    W_H INTEGER NOT NULL,
    PRIMARY KEY (Code),
    FOREIGN KEY (W_H) REFERENCES Warehouses(Code)
 );
 
 describe warehouse.warehouses;
 describe warehouse.boxes;
 
 INSERT INTO warehouse.warehouses(Code,Location,Capacity) VALUES(1,'Chicago',3);
 INSERT INTO warehouse.warehouses(Code,Location,Capacity) VALUES(2,'Chicago',4);
 INSERT INTO warehouse.warehouses(Code,Location,Capacity) VALUES(3,'New York',7);
 INSERT INTO warehouse.warehouses(Code,Location,Capacity) VALUES(4,'Los Angeles',2);
 INSERT INTO warehouse.warehouses(Code,Location,Capacity) VALUES(5,'San Francisco',8);
 
 select * from warehouse.warehouses;
 
 INSERT INTO warehouse.boxes(Code,Contents,Value,W_H) VALUES('0MN7','Rocks',180,3);
 INSERT INTO warehouse.boxes(Code,Contents,Value,W_H) VALUES('4H8P','Rocks',250,1);
 INSERT INTO warehouse.boxes(Code,Contents,Value,W_H) VALUES('4RT3','Scissors',190,4);
 INSERT INTO warehouse.boxes(Code,Contents,Value,W_H) VALUES('7G3H','Rocks',200,1);
 INSERT INTO warehouse.boxes(Code,Contents,Value,W_H) VALUES('8JN6','Papers',75,1);
 INSERT INTO warehouse.boxes(Code,Contents,Value,W_H) VALUES('8Y6U','Papers',50,3);
 INSERT INTO warehouse.boxes(Code,Contents,Value,W_H) VALUES('9J6F','Papers',175,2);
 INSERT INTO warehouse.boxes(Code,Contents,Value,W_H) VALUES('LL08','Rocks',140,4);
 INSERT INTO warehouse.boxes(Code,Contents,Value,W_H) VALUES('P0H6','Scissors',125,1);
 INSERT INTO warehouse.boxes(Code,Contents,Value,W_H) VALUES('P2T6','Scissors',150,2);
 INSERT INTO warehouse.boxes(Code,Contents,Value,W_H) VALUES('TU55','Papers',90,5);
  
  select * from warehouse.boxes;
