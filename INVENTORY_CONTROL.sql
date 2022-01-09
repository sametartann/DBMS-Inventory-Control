-- drop tables if any same named table exists in database

drop table Inventory cascade constraints;
drop table Customer cascade constraints;
drop table Stock cascade constraints;
drop table Supplier cascade constraints;
drop table Payment cascade constraints;
drop table SystemLogin cascade constraints;
drop table Has cascade constraints;
drop table Login cascade constraints;
drop table Manage cascade constraints;




-- CREATE TABLE STATEMENTS


CREATE TABLE Inventory(
	
	inv_id NUMBER(3) PRIMARY KEY,	   
	inv_type VARCHAR(25) NOT NULL,
	inv_name VARCHAR(15) NOT NULL,
	inv_desc CHAR(100) NOT NULL,	
	inv_bnum NUMBER(8) UNIQUE
);



CREATE TABLE Customer(
	
	cust_id   		NUMBER(3) PRIMARY KEY,
	cust_fname		CHAR(25) NOT NULL,		
	cust_lname		CHAR(25) NOT NULL,
	cust_phone		NUMBER(12) UNIQUE,
	cust_mail		VARCHAR(25) UNIQUE,
	cust_addr		VARCHAR(100)
);



CREATE TABLE Supplier(

	supp_id			NUMBER(3)	PRIMARY KEY,
	supp_compName	CHAR(25)	NOT NULL,
	supp_phone		NUMBER(12)	UNIQUE,
	supp_addr		VARCHAR(100)		
);



CREATE TABLE Stock(

	stock_id		NUMBER(3) PRIMARY KEY,
	stock_type		VARCHAR(25) NOT NULL,
	stock_desc		CHAR(100) NOT NULL,
	stock_amount    NUMBER(5),
    supp_id         NUMBER(3)
);

alter table Stock add constraint Stock_fk foreign key(supp_id) references supplier(supp_id);




CREATE TABLE Payment(

	pay_id			NUMBER(3)	PRIMARY KEY,
	pay_customerid	NUMBER(3)	UNIQUE,
	pay_date		date,
	pay_amount		NUMBER(5)		NOT NULL,
	pay_desc		CHAR(100)	NOT NULL
);



CREATE TABLE SystemLogin(
login_id NUMBER(5) PRIMARY KEY,
passwd VARCHAR(10) NOT NULL
);



CREATE TABLE Has
(stock_id NUMBER(3),
inv_id NUMBER(3),
PRIMARY KEY(stock_id, inv_id),
FOREIGN KEY(stock_id) references Stock(stock_id),
FOREIGN KEY(inv_id) references Inventory(inv_id));



CREATE TABLE Manage
(pay_id NUMBER(3),
inv_id NUMBER(3),
cust_id Number(3),
PRIMARY KEY(pay_id, inv_id, cust_id),
FOREIGN KEY(pay_id) references Payment(pay_id),
FOREIGN KEY(inv_id) references Inventory(inv_id),
FOREIGN KEY(cust_id) references Customer(cust_id));



CREATE TABLE Login
(supp_id NUMBER(3),
login_id NUMBER(5),
cust_id NUMBER(3),
PRIMARY KEY(supp_id, login_id, cust_id),
FOREIGN KEY(supp_id) references Supplier(supp_id),
FOREIGN KEY(login_id) references SystemLogin(login_id),
FOREIGN KEY(cust_id) references Customer(cust_id));





-- DATA INSERTION INTO CREATED TABLES




INSERT INTO Inventory VALUES (199,'smartPhone', 'Iphone12', 'descA', '36363636');
INSERT INTO Inventory VALUES (299,'sunGlasses', 'Ray-banA23', 'descB', '36696969');
INSERT INTO Inventory VALUES (390,'refrigerator', 'Arcelik', 'descC', '36444444');



INSERT INTO Customer VALUES (123,'Samet', 'Artan', 5531515901, 'samet.artan', 'TR');
INSERT INTO Customer VALUES (456,'Volkan', 'Nisanci', 5357485927, 'emre.nisanci', 'USA');
INSERT INTO Customer VALUES (789,'Ali', 'Ure', 5446816559, 'aliberkay.ure', 'AZE');



INSERT INTO Supplier VALUES (333, 'Apple', '02162821512', 'AppleParkWayCupertino');
INSERT INTO Supplier VALUES (444, 'MSI', '022222765', 'NewYorkUSA');
INSERT INTO Supplier VALUES (136, 'Arcelik', '08502100888', 'TuzlaIstanbul');
INSERT INTO Supplier VALUES (666, 'RayBan', '123456', 'Kadikoy');



INSERT INTO Stock VALUES (111, 'Electronic', 'DescForElectronic', 112, 333);
INSERT INTO Stock VALUES (151, 'Electronic', 'DescForElectronic', 102, 444);
INSERT INTO Stock VALUES (222, 'Optic', 'DescForOptic', 97, 666);
INSERT INTO Stock VALUES (366, 'Deep-Frozen', 'DescForDeepFrozen', 536, 136);



INSERT INTO Payment VALUES (100, 123, TO_DATE ('10/11/1936', 'mm/dd/yyyy'), 74281, 'DescFor100');
INSERT INTO Payment VALUES (200, 456, TO_DATE ('05/19/1881', 'mm/dd/yyyy'), 1229, 'DescFor200');
INSERT INTO Payment VALUES (360, 789, TO_DATE ('11/10/1938', 'mm/dd/yyyy'), 2289, 'DescFor300');



INSERT INTO SystemLogin VALUES (44325, 'password1');
INSERT INTO SystemLogin VALUES (32927, 'password2');
INSERT INTO SystemLogin VALUES (77316, 'password3');



INSERT INTO Has VALUES (111, 199);
INSERT INTO Has VALUES (222, 299);
INSERT INTO Has VALUES (366, 390);



INSERT INTO Manage VALUES (100, 199, 123);
INSERT INTO Manage VALUES (200, 299, 456);
INSERT INTO Manage VALUES (360, 390, 789);



INSERT INTO Login VALUES (333, 44325, 123);
INSERT INTO Login VALUES (444, 32927, 456);
INSERT INTO Login VALUES (136, 77316, 789);




-- SQL QUERIES


-- 2 JOINS

SELECT pay_amount as "PAYMENT AMOUNT" FROM Customer a INNER JOIN Payment b on a.cust_id = b.pay_customerid WHERE a.cust_addr = 'TR';
SELECT cust_fname as FIRSTNAME, cust_lname as LASTNAME, pay_desc as DESCRIPTION FROM Customer c LEFT OUTER JOIN Payment p ON c.cust_id = p.pay_customerid;


-- 2 Nested Queries

SELECT stock_id FROM Stock WHERE supp_id =(SELECT supp_id FROM Supplier s WHERE s.supp_compName='Apple');
SELECT* FROM Customer WHERE cust_id =(SELECT pay_customerid FROM Payment p WHERE p.pay_amount=2289);


-- 2 Sets Operations

(SELECT inv_id as "Inventory ID", inv_type as Type, inv_name as Name FROM Inventory WHERE inv_type = 'smartPhone') UNION (SELECT inv_id, inv_type, inv_name FROM Inventory WHERE inv_type='refrigerator');
(SELECT stock_type as Type FROM Stock WHERE supp_id=333) Intersect (SELECT stock_type as Type FROM Stock WHERE supp_id=444);


-- 2 Aggregate Operations

SELECT Sum(pay_amount) as "Sum of Total Payment" FROM Payment INNER JOIN Customer ON Customer.cust_id = Payment.pay_customerid;
SELECT MIN(Stock_amount) as "Minimum Stock Amount" FROM Stock INNER JOIN Has ON Has.stock_id = Stock.stock_id;