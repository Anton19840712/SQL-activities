--1. Create conceptual and logical models (3nf) for given domain (save it as PNG files). Describe business process (process of how business adds new data to this 
--database). It is expected that your database will populate over time, so your transaction table needs to have "timestamp of transaction" field.
--You can see them in commit

--2. Create physical database design (DDL scripts for tables). Make sure your database is in 3NF and has meaningful keys and constraints. Use ALTER TABLE to 
--add constraints (except NOT NULL, UNIQUE and keys). Give meaningful names to your CHECK constraints. Use DEFAULT and STORED AS where appropriate.
--You can see alter scripts after inserts part

--\i D:/Databases/household_appliances_store.sql

-- drops

--DROP DATABASE household appliances store ;
--drop table customers;
--drop table customer_gender;
--drop table customer_address;
--drop table customer_purchases;
--drop table shop_names
--drop table shop_class;
--drop table shop_locations;
--drop table orders_purchases;
--drop table orders_appliances;
--drop table shops_appliances;
--drop table home_appliances_names;
--drop table home_appliances_size;
--drop table appliance_price_category;

-- creates

CREATE DATABASE household_appliances_store;

CREATE TABLE customers(
    customer_id SERIAL NOT NULL PRIMARY KEY, -- SERIAL, autoincrementing four-byte integer - that's more than enough
    first_name VARCHAR (150) NOT NULL --VARCHAR - universally, but it could be TEXT also
);

CREATE TABLE customer_gender (
    id SERIAL NOT NULL PRIMARY KEY,
    gender_name VARCHAR (7) NULL,
    customer_id INT REFERENCES customers(customer_id),
	UNIQUE(customer_id)
);

CREATE TABLE customer_address (
    id SERIAL NOT NULL PRIMARY KEY,
    address_name VARCHAR (150) NULL,
    customer_id INT REFERENCES customers(customer_id)
);

CREATE TABLE customer_purchases (
    purchase_id SERIAL NOT NULL PRIMARY KEY,
    amount BIGINT,
	payment_date DATE,
    customer_id INT REFERENCES customers(customer_id)
);

CREATE TABLE shop_names(
    shop_name_id SERIAL NOT NULL PRIMARY KEY, -- SERIAL, autoincrementing four-byte integer - that's more than enough
    shop_name VARCHAR (150) NOT NULL --VARCHAR - universally, but it could be TEXT also
);

CREATE TABLE shop_class(
    id SERIAL NOT NULL PRIMARY KEY,
    shop_class_name VARCHAR (10) NULL,
    shop_id INT REFERENCES shop_names(shop_name_id),
	UNIQUE(shop_id)
);

CREATE TABLE shop_locations (
    district_location_id SERIAL NOT NULL PRIMARY KEY,
    district_location_name VARCHAR (150) NULL,
    shop_id INT REFERENCES shop_names(shop_name_id),
	UNIQUE(shop_id)
);

CREATE TABLE home_appliances_names(
    appliance_id SERIAL NOT NULL PRIMARY KEY, -- SERIAL, autoincrementing four-byte integer - that's more than enough
    appliance_name VARCHAR (150) NOT NULL --VARCHAR - universally, but it could be TEXT also
);

CREATE TABLE home_appliances_size(
    home_appliances_size_categories_id SERIAL NOT NULL PRIMARY KEY,
    home_appliances_size_category VARCHAR (10) NULL,
    ha_id INT REFERENCES home_appliances_names(appliance_id),
	UNIQUE(ha_id)
);

CREATE TABLE appliance_price_category (
    appliance_price_category_id SERIAL NOT NULL PRIMARY KEY,
    appliance_price_category_name VARCHAR (50) NULL,
    ha_id INT REFERENCES home_appliances_names(appliance_id)
);

CREATE TABLE orders_purchases (
    id SERIAL NOT NULL PRIMARY KEY,
    order_id BIGINT,
	purchase_id BIGINT REFERENCES customer_purchases(purchase_id)
);

CREATE TABLE orders_appliances (
    order_id  INT NOT NULL,
    appliance_id INT NOT NULL,
    CONSTRAINT orders_appliances_pkey PRIMARY KEY (order_id, appliance_id),
    CONSTRAINT orders_appliances_orders_purchases_fkey FOREIGN KEY (order_id) REFERENCES orders_purchases(id),
    CONSTRAINT orders_appliances_home_appliances_names_fkey FOREIGN KEY (appliance_id) REFERENCES home_appliances_names (appliance_id)
);

CREATE TABLE shops_appliances (
    shop_id  INT NOT NULL,
    appliance_id INT NOT NULL,
    CONSTRAINT shops_appliances_pkey PRIMARY KEY (shop_id, appliance_id),
    CONSTRAINT shops_appliances_shop_names_fkey FOREIGN KEY (shop_id) REFERENCES shop_names(shop_name_id),
    CONSTRAINT shops_appliances_home_appliances_names_fkey FOREIGN KEY (appliance_id) REFERENCES home_appliances_names (appliance_id)
);

--3. Add fictional data to your database (5+ rows per table, 50+ rows total across all tables). Save your data as DML scripts. Make sure your surrogate keys' values 
--are not included in DML scripts (they should be created runtime by the database, as well as DEFAULT values where appropriate). DML scripts must 
--successfully pass all previously created constraints.

-- inserts

insert into shop_names (shop_name) values ('Renos Appliance');
insert into shop_names (shop_name) values ('AJ Madison Kitchen and Home Appliances Showroom');
insert into shop_names (shop_name) values ('Brothers Supply Corporation');
insert into shop_names (shop_name) values ('Daley Service and Installation');
insert into shop_names (shop_name) values ('Dyson Demo Store');
insert into shop_names (shop_name) values ('Fastech 2000');
insert into shop_names (shop_name) values ('Flamtech Appliances');
insert into shop_names (shop_name) values ('Gringer & Sons');
insert into shop_names (shop_name) values ('Harlem');
insert into shop_names (shop_name) values ('J & R Television & Air Conditioning');
insert into shop_names (shop_name) values ('JB Prince Company');
insert into shop_names (shop_name) values ('Len Harris');
insert into shop_names (shop_name) values ('Little Italy');
insert into shop_names (shop_name) values ('Nordam Appliance');
insert into shop_names (shop_name) values ('NY Viking Services');
insert into shop_names (shop_name) values ('Pelham Bay');
insert into shop_names (shop_name) values ('Precision Appliance Services');
insert into shop_names (shop_name) values ('Subzero and Viking Repair Group');

insert into shop_class (shop_class_name, shop_id) values ('Premium', 1);
insert into shop_class (shop_class_name, shop_id) values ('Middle', 2);
insert into shop_class (shop_class_name, shop_id) values ('A', 3);
insert into shop_class (shop_class_name, shop_id) values ('B', 4);
insert into shop_class (shop_class_name, shop_id) values ('C', 5);
insert into shop_class (shop_class_name, shop_id) values ('D', 6);
insert into shop_class (shop_class_name, shop_id) values ('F', 7);
insert into shop_class (shop_class_name, shop_id) values ('Optima', 8);
insert into shop_class (shop_class_name, shop_id) values ('Premium', 9);
insert into shop_class (shop_class_name, shop_id) values ('Middle', 10);
insert into shop_class (shop_class_name, shop_id) values ('A', 11);
insert into shop_class (shop_class_name, shop_id) values ('B', 12);
insert into shop_class (shop_class_name, shop_id) values ('C', 13);
insert into shop_class (shop_class_name, shop_id) values ('D', 14);
insert into shop_class (shop_class_name, shop_id) values ('F', 15);
insert into shop_class (shop_class_name, shop_id) values ('Optima', 16);
insert into shop_class (shop_class_name, shop_id) values ('Premium', 17);
insert into shop_class (shop_class_name, shop_id) values ('Middle', 18);

insert into shop_locations (district_location_name, shop_id) values ('Bronx', 1);
insert into shop_locations (district_location_name, shop_id) values ('Brooklyn', 2);
insert into shop_locations (district_location_name, shop_id) values ('Manhattan', 3);
insert into shop_locations (district_location_name, shop_id) values ('Queens', 4);
insert into shop_locations (district_location_name, shop_id) values ('Staten', 5);
insert into shop_locations (district_location_name, shop_id) values ('Island', 6);
insert into shop_locations (district_location_name, shop_id) values ('Bronx', 7);
insert into shop_locations (district_location_name, shop_id) values ('Brooklyn', 8);
insert into shop_locations (district_location_name, shop_id) values ('Manhattan', 9);
insert into shop_locations (district_location_name, shop_id) values ('Queens', 10);
insert into shop_locations (district_location_name, shop_id) values ('Staten', 11);
insert into shop_locations (district_location_name, shop_id) values ('Island', 12);
insert into shop_locations (district_location_name, shop_id) values ('Bronx', 13);
insert into shop_locations (district_location_name, shop_id) values ('Brooklyn', 14);
insert into shop_locations (district_location_name, shop_id) values ('Manhattan', 15);
insert into shop_locations (district_location_name, shop_id) values ('Queens', 16);
insert into shop_locations (district_location_name, shop_id) values ('Staten', 17);
insert into shop_locations (district_location_name, shop_id) values ('Island', 18);

insert into customers (first_name) values ('Foss');
insert into customers (first_name) values ('Adele');
insert into customers (first_name) values ('Giselbert');
insert into customers (first_name) values ('Joane');
insert into customers (first_name) values ('Gradeigh');
insert into customers (first_name) values ('Dal');

insert into customer_gender (gender_name, customer_id) values ('Male', 1);
insert into customer_gender (gender_name, customer_id) values ('Female', 2);
insert into customer_gender (gender_name, customer_id) values ('Male', 3);
insert into customer_gender (gender_name, customer_id) values ('Female', 4);
insert into customer_gender (gender_name, customer_id) values ('Male', 5);
insert into customer_gender (gender_name, customer_id) values ('Male', 6);

insert into customer_address (address_name, customer_id) values ('249 Anderson Pass', 1);
insert into customer_address (address_name, customer_id) values ('0708 Namekagon Point', 2);
insert into customer_address (address_name, customer_id) values ('26345 Declaration Center', 3);
insert into customer_address (address_name, customer_id) values ('27352 Armistice Drive', 4);
insert into customer_address (address_name, customer_id) values ('9282 Gerald Point', 5);
insert into customer_address (address_name, customer_id) values ('2631 Hansons Pass', 6);
insert into customer_address (address_name, customer_id) values ('6 School Pass', 1);
insert into customer_address (address_name, customer_id) values ('69 Bowman Plaza', 2);
insert into customer_address (address_name, customer_id) values ('64 Schurz Street', 1);
insert into customer_address (address_name, customer_id) values ('3306 Lakewood Circle', 1);
insert into customer_address (address_name, customer_id) values ('48621 Farwell Plaza', 1);
insert into customer_address (address_name, customer_id) values ('12213 Alpine Road', 1);

insert into customer_purchases (amount, payment_date, customer_id) values (1,'2020-08-07', 1);
insert into customer_purchases (amount, payment_date, customer_id) values (2,'2020-05-24', 2);
insert into customer_purchases (amount, payment_date, customer_id) values (3,'2020-03-16', 3);
insert into customer_purchases (amount, payment_date, customer_id) values (4,'2020-03-18', 4);
insert into customer_purchases (amount, payment_date, customer_id) values (5,'2020-06-18', 5);
insert into customer_purchases (amount, payment_date, customer_id) values (6,'2019-10-25', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (7,'2019-12-01', 1);
insert into customer_purchases (amount, payment_date, customer_id) values (8,'2019-12-14', 2);
insert into customer_purchases (amount, payment_date, customer_id) values (9,'2020-06-18', 3);
insert into customer_purchases (amount, payment_date, customer_id) values (10,'2020-05-14', 4);
insert into customer_purchases (amount, payment_date, customer_id) values (11,'2019-12-30', 5);
insert into customer_purchases (amount, payment_date, customer_id) values (12,'2020-04-06', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (13,'2020-04-19', 1);
insert into customer_purchases (amount, payment_date, customer_id) values (14,'2020-03-20', 2);
insert into customer_purchases (amount, payment_date, customer_id) values (15,'2020-05-12', 3);
insert into customer_purchases (amount, payment_date, customer_id) values (16,'2019-11-20', 4);
insert into customer_purchases (amount, payment_date, customer_id) values (17,'2020-08-16', 5);
insert into customer_purchases (amount, payment_date, customer_id) values (18,'2020-03-26', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (19,'2020-05-08', 1);
insert into customer_purchases (amount, payment_date, customer_id) values (20,'2020-04-26', 2);
insert into customer_purchases (amount, payment_date, customer_id) values (21,'2020-03-27', 3);
insert into customer_purchases (amount, payment_date, customer_id) values (22,'2019-10-21', 4);
insert into customer_purchases (amount, payment_date, customer_id) values (23,'2020-09-23', 5);
insert into customer_purchases (amount, payment_date, customer_id) values (24,'2020-02-29', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (25,'2020-10-11', 1);
insert into customer_purchases (amount, payment_date, customer_id) values (26,'2019-12-24', 2);
insert into customer_purchases (amount, payment_date, customer_id) values (27,'2020-05-06', 3);
insert into customer_purchases (amount, payment_date, customer_id) values (28,'2020-06-12', 4);
insert into customer_purchases (amount, payment_date, customer_id) values (29,'2020-08-19', 5);
insert into customer_purchases (amount, payment_date, customer_id) values (30,'2020-04-24', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (31,'2020-04-30', 1);
insert into customer_purchases (amount, payment_date, customer_id) values (32,'2020-01-01', 2);
insert into customer_purchases (amount, payment_date, customer_id) values (33,'2019-10-21', 3);
insert into customer_purchases (amount, payment_date, customer_id) values (34,'2020-06-01', 4);
insert into customer_purchases (amount, payment_date, customer_id) values (35,'2019-12-13', 5);
insert into customer_purchases (amount, payment_date, customer_id) values (36,'2020-04-30', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (37,'2020-09-12', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (38,'2019-12-21', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (39,'2020-05-17', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (40,'2020-01-03', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (41,'2020-08-22', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (42,'2019-10-26', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (43,'2020-09-06', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (44,'2019-10-16', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (45,'2020-01-29', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (46,'2020-02-26', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (47,'2020-03-26', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (48,'2020-10-05', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (49,'2019-11-14', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (50,'2020-06-13', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (51,'2020-05-08', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (52,'2019-10-17', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (53,'2020-10-14', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (54,'2019-12-27', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (55,'2019-12-14', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (56,'2020-04-27', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (57,'2020-06-15', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (58,'2020-06-04', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (59,'2020-06-04', 6);
insert into customer_purchases (amount, payment_date, customer_id) values (60,'2020-07-10', 6);

insert into home_appliances_names (appliance_name) values ('Dishwasher');
insert into home_appliances_names (appliance_name) values ('Washing Machine');
insert into home_appliances_names (appliance_name) values ('Dryer');
insert into home_appliances_names (appliance_name) values ('Microwave');
insert into home_appliances_names (appliance_name) values ('Oven');
insert into home_appliances_names (appliance_name) values ('Toaster');
insert into home_appliances_names (appliance_name) values ('Waffle Iron');
insert into home_appliances_names (appliance_name) values ('Refrigerator');
insert into home_appliances_names (appliance_name) values ('Freezer');
insert into home_appliances_names (appliance_name) values ('Vacuum Cleaner');
insert into home_appliances_names (appliance_name) values ('Air Conditioner');
insert into home_appliances_names (appliance_name) values ('Air Purifier');
insert into home_appliances_names (appliance_name) values ('Blender');
insert into home_appliances_names (appliance_name) values ('Ceiling Fan');
insert into home_appliances_names (appliance_name) values ('Domestic Robot');
insert into home_appliances_names (appliance_name) values ('Heater');
insert into home_appliances_names (appliance_name) values ('Garbage Disposal Unit');
insert into home_appliances_names (appliance_name) values ('Hair Dryer');
insert into home_appliances_names (appliance_name) values ('Humidifier');
insert into home_appliances_names (appliance_name) values ('Dehumidifier');
insert into home_appliances_names (appliance_name) values ('Sewing Machine');
insert into home_appliances_names (appliance_name) values ('Water Purifier');
insert into home_appliances_names (appliance_name) values ('Coffee Makers');
insert into home_appliances_names (appliance_name) values ('Bread Machine');
insert into home_appliances_names (appliance_name) values ('Baking Mixer');
insert into home_appliances_names (appliance_name) values ('Food Processor');
insert into home_appliances_names (appliance_name) values ('Juicer');
insert into home_appliances_names (appliance_name) values ('Rice Cooker');
insert into home_appliances_names (appliance_name) values ('Smokers');
insert into home_appliances_names (appliance_name) values ('Types of Water Heaters');
insert into home_appliances_names (appliance_name) values ('Popcorn Makers');
insert into home_appliances_names (appliance_name) values ('Ice Cream Makers');
insert into home_appliances_names (appliance_name) values ('Compact Appliances');
insert into home_appliances_names (appliance_name) values ('Smart Home Appliances and Gadgets');
insert into home_appliances_names (appliance_name) values ('Water Appliances');
insert into home_appliances_names (appliance_name) values ('Steam Cleaners');
insert into home_appliances_names (appliance_name) values ('Yogurt Makers');
insert into home_appliances_names (appliance_name) values ('Generators');
insert into home_appliances_names (appliance_name) values ('Coffee Grinders');
insert into home_appliances_names (appliance_name) values ('Food Dehydrators');

insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Big', 1);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Middle', 2);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Small', 3);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Big', 4);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Middle', 5);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Small', 6);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Big', 7);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Middle', 8);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Small', 9);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Big', 10);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Middle', 11);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Small', 12);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Big', 13);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Middle', 14);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Small', 15);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Big', 16);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Middle', 17);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Small', 18);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Big', 19);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Middle', 20);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Small', 21);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Big', 22);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Middle', 23);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Small', 24);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Big', 25);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Middle', 26);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Small', 27);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Big', 28);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Middle', 29);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Big', 30);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Middle', 31);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Small', 32);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Big', 33);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Middle', 34);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Small', 35);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Big', 36);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Middle', 37);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Small', 38);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Big', 39);
insert into home_appliances_size (home_appliances_size_category, ha_id) values ('Middle', 40);

insert into appliance_price_category (appliance_price_category_name, ha_id) values ('A', 1);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('B', 2);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('C', 3);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('D', 4);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('F', 5);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('I', 6);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('G', 7);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('K', 8);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('L', 9);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('A', 10);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('B', 11);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('C', 12);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('D', 13);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('F', 14);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('I', 15);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('G', 16);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('K', 17);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('L', 18);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('A', 19);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('B', 20);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('C', 21);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('D', 22);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('F', 23);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('I', 24);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('G', 25);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('K', 26);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('L', 27);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('A', 28);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('B', 29);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('C', 30);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('D', 31);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('F', 32);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('I', 33);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('G', 34);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('K', 35);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('L', 36);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('A', 37);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('B', 38);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('C', 39);
insert into appliance_price_category (appliance_price_category_name, ha_id) values ('D', 40);

insert into orders_purchases (order_id, purchase_id) values (1, 1);
insert into orders_purchases (order_id, purchase_id) values (2, 2);
insert into orders_purchases (order_id, purchase_id) values (3, 3);
insert into orders_purchases (order_id, purchase_id) values (4, 4);
insert into orders_purchases (order_id, purchase_id) values (5, 5);
insert into orders_purchases (order_id, purchase_id) values (6, 6);
insert into orders_purchases (order_id, purchase_id) values (7, 7);
insert into orders_purchases (order_id, purchase_id) values (8, 8);
insert into orders_purchases (order_id, purchase_id) values (9, 9);
insert into orders_purchases (order_id, purchase_id) values (10, 10);
insert into orders_purchases (order_id, purchase_id) values (11, 11);
insert into orders_purchases (order_id, purchase_id) values (12, 12);
insert into orders_purchases (order_id, purchase_id) values (13, 13);
insert into orders_purchases (order_id, purchase_id) values (14, 14);
insert into orders_purchases (order_id, purchase_id) values (15, 15);
insert into orders_purchases (order_id, purchase_id) values (16, 16);
insert into orders_purchases (order_id, purchase_id) values (17, 17);
insert into orders_purchases (order_id, purchase_id) values (18, 18);
insert into orders_purchases (order_id, purchase_id) values (19, 19);
insert into orders_purchases (order_id, purchase_id) values (20, 20);
insert into orders_purchases (order_id, purchase_id) values (21, 21);
insert into orders_purchases (order_id, purchase_id) values (22, 22);
insert into orders_purchases (order_id, purchase_id) values (23, 23);
insert into orders_purchases (order_id, purchase_id) values (24, 24);
insert into orders_purchases (order_id, purchase_id) values (25, 25);
insert into orders_purchases (order_id, purchase_id) values (26, 26);
insert into orders_purchases (order_id, purchase_id) values (27, 27);
insert into orders_purchases (order_id, purchase_id) values (28, 28);
insert into orders_purchases (order_id, purchase_id) values (29, 29);
insert into orders_purchases (order_id, purchase_id) values (30, 30);
insert into orders_purchases (order_id, purchase_id) values (31, 31);
insert into orders_purchases (order_id, purchase_id) values (32, 32);
insert into orders_purchases (order_id, purchase_id) values (33, 33);
insert into orders_purchases (order_id, purchase_id) values (34, 34);
insert into orders_purchases (order_id, purchase_id) values (35, 35);
insert into orders_purchases (order_id, purchase_id) values (36, 36);
insert into orders_purchases (order_id, purchase_id) values (37, 37);
insert into orders_purchases (order_id, purchase_id) values (38, 38);
insert into orders_purchases (order_id, purchase_id) values (39, 39);
insert into orders_purchases (order_id, purchase_id) values (40, 40);
insert into orders_purchases (order_id, purchase_id) values (41, 41);
insert into orders_purchases (order_id, purchase_id) values (42, 42);
insert into orders_purchases (order_id, purchase_id) values (43, 43);
insert into orders_purchases (order_id, purchase_id) values (44, 44);
insert into orders_purchases (order_id, purchase_id) values (45, 45);
insert into orders_purchases (order_id, purchase_id) values (46, 46);
insert into orders_purchases (order_id, purchase_id) values (47, 47);
insert into orders_purchases (order_id, purchase_id) values (48, 48);
insert into orders_purchases (order_id, purchase_id) values (49, 49);
insert into orders_purchases (order_id, purchase_id) values (50, 50);
insert into orders_purchases (order_id, purchase_id) values (51, 51);
insert into orders_purchases (order_id, purchase_id) values (52, 52);
insert into orders_purchases (order_id, purchase_id) values (53, 53);
insert into orders_purchases (order_id, purchase_id) values (54, 54);
insert into orders_purchases (order_id, purchase_id) values (55, 55);
insert into orders_purchases (order_id, purchase_id) values (56, 56);
insert into orders_purchases (order_id, purchase_id) values (57, 57);
insert into orders_purchases (order_id, purchase_id) values (58, 58);
insert into orders_purchases (order_id, purchase_id) values (59, 59);
insert into orders_purchases (order_id, purchase_id) values (60, 60);

insert into orders_appliances (order_id, appliance_id) values (1, 39);
insert into orders_appliances (order_id, appliance_id) values (2, 26);
insert into orders_appliances (order_id, appliance_id) values (3, 27);
insert into orders_appliances (order_id, appliance_id) values (4, 3);
insert into orders_appliances (order_id, appliance_id) values (5, 21);
insert into orders_appliances (order_id, appliance_id) values (6, 29);
insert into orders_appliances (order_id, appliance_id) values (7, 11);
insert into orders_appliances (order_id, appliance_id) values (8, 14);
insert into orders_appliances (order_id, appliance_id) values (9, 10);
insert into orders_appliances (order_id, appliance_id) values (9, 33);
insert into orders_appliances (order_id, appliance_id) values (9, 32);
insert into orders_appliances (order_id, appliance_id) values (10, 39);
insert into orders_appliances (order_id, appliance_id) values (10, 23);
insert into orders_appliances (order_id, appliance_id) values (10, 25);
insert into orders_appliances (order_id, appliance_id) values (11, 38);
insert into orders_appliances (order_id, appliance_id) values (11, 1);
insert into orders_appliances (order_id, appliance_id) values (11, 18);
insert into orders_appliances (order_id, appliance_id) values (12, 11);
insert into orders_appliances (order_id, appliance_id) values (12, 25);
insert into orders_appliances (order_id, appliance_id) values (12, 12);
insert into orders_appliances (order_id, appliance_id) values (13, 16);
insert into orders_appliances (order_id, appliance_id) values (13, 15);
insert into orders_appliances (order_id, appliance_id) values (13, 1);
insert into orders_appliances (order_id, appliance_id) values (14, 22);
insert into orders_appliances (order_id, appliance_id) values (14, 38);
insert into orders_appliances (order_id, appliance_id) values (14, 3);
insert into orders_appliances (order_id, appliance_id) values (15, 27);
insert into orders_appliances (order_id, appliance_id) values (15, 21);
insert into orders_appliances (order_id, appliance_id) values (15, 17);
insert into orders_appliances (order_id, appliance_id) values (16, 5);
insert into orders_appliances (order_id, appliance_id) values (16, 22);
insert into orders_appliances (order_id, appliance_id) values (16, 34);
insert into orders_appliances (order_id, appliance_id) values (17, 39);
insert into orders_appliances (order_id, appliance_id) values (17, 10);
insert into orders_appliances (order_id, appliance_id) values (17, 21);
insert into orders_appliances (order_id, appliance_id) values (18, 22);
insert into orders_appliances (order_id, appliance_id) values (18, 6);
insert into orders_appliances (order_id, appliance_id) values (19, 16);
insert into orders_appliances (order_id, appliance_id) values (19, 21);
insert into orders_appliances (order_id, appliance_id) values (20, 3);

insert into shops_appliances (shop_id, appliance_id) values (1, 1);
insert into shops_appliances (shop_id, appliance_id) values (1, 19);
insert into shops_appliances (shop_id, appliance_id) values (2, 2);
insert into shops_appliances (shop_id, appliance_id) values (2, 20);
insert into shops_appliances (shop_id, appliance_id) values (3, 3);
insert into shops_appliances (shop_id, appliance_id) values (3, 21);
insert into shops_appliances (shop_id, appliance_id) values (4, 4);
insert into shops_appliances (shop_id, appliance_id) values (4, 22);
insert into shops_appliances (shop_id, appliance_id) values (5, 5);
insert into shops_appliances (shop_id, appliance_id) values (5, 23);
insert into shops_appliances (shop_id, appliance_id) values (6, 6);
insert into shops_appliances (shop_id, appliance_id) values (6, 24);
insert into shops_appliances (shop_id, appliance_id) values (6, 30);
insert into shops_appliances (shop_id, appliance_id) values (7, 7);
insert into shops_appliances (shop_id, appliance_id) values (7, 25);
insert into shops_appliances (shop_id, appliance_id) values (7, 31);
insert into shops_appliances (shop_id, appliance_id) values (8, 8);
insert into shops_appliances (shop_id, appliance_id) values (8, 26);
insert into shops_appliances (shop_id, appliance_id) values (8, 32);
insert into shops_appliances (shop_id, appliance_id) values (9, 9);
insert into shops_appliances (shop_id, appliance_id) values (9, 27);
insert into shops_appliances (shop_id, appliance_id) values (9, 33);
insert into shops_appliances (shop_id, appliance_id) values (10, 10);
insert into shops_appliances (shop_id, appliance_id) values (10, 28);
insert into shops_appliances (shop_id, appliance_id) values (10, 34);
insert into shops_appliances (shop_id, appliance_id) values (11, 11);
insert into shops_appliances (shop_id, appliance_id) values (11, 29);
insert into shops_appliances (shop_id, appliance_id) values (11, 35);
insert into shops_appliances (shop_id, appliance_id) values (12, 12);
insert into shops_appliances (shop_id, appliance_id) values (12, 30);
insert into shops_appliances (shop_id, appliance_id) values (12, 36);
insert into shops_appliances (shop_id, appliance_id) values (13, 13);
insert into shops_appliances (shop_id, appliance_id) values (13, 31);
insert into shops_appliances (shop_id, appliance_id) values (13, 37);
insert into shops_appliances (shop_id, appliance_id) values (14, 14);
insert into shops_appliances (shop_id, appliance_id) values (14, 32);
insert into shops_appliances (shop_id, appliance_id) values (14, 38);
insert into shops_appliances (shop_id, appliance_id) values (15, 15);
insert into shops_appliances (shop_id, appliance_id) values (15, 26);
insert into shops_appliances (shop_id, appliance_id) values (15, 39);
insert into shops_appliances (shop_id, appliance_id) values (16, 16);
insert into shops_appliances (shop_id, appliance_id) values (16, 27);
insert into shops_appliances (shop_id, appliance_id) values (16, 40);
insert into shops_appliances (shop_id, appliance_id) values (17, 17);
insert into shops_appliances (shop_id, appliance_id) values (17, 28);
insert into shops_appliances (shop_id, appliance_id) values (18, 18);
insert into shops_appliances (shop_id, appliance_id) values (18, 29);

--ALTER OPERATIONS IF I NEED TIMING OF ADDITIONS LATER

ALTER TABLE customers ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;
ALTER TABLE customer_gender ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;
ALTER TABLE customer_address ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;
ALTER TABLE customer_purchases ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;
ALTER TABLE orders_purchases ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;
ALTER TABLE orders_appliances ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;
ALTER TABLE shops_appliances ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;
ALTER TABLE shop_names ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;
ALTER TABLE shop_class ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;
ALTER TABLE shop_locations ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;
ALTER TABLE home_appliances_names ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;
ALTER TABLE home_appliances_size ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;
ALTER TABLE appliance_price_category ADD COLUMN record_ts DATE NOT NULL DEFAULT current_date;


--visualize check some selects, if column "record_ts" was added...
--selects

SELECT * FROM customers;
SELECT * FROM customer_gender;
SELECT * FROM customer_address;
SELECT * FROM home_appliances_size;
SELECT * FROM appliance_price_category;


--4. Create the following functions:
-- Function that UPDATEs data in one of your tables (input arguments: table's primary key value, column name and column value to UPDATE to).
----------------------------------------------------------------------------------------------------------------------------------------------------
-- I think, I don't need column value in the logic of my function. Because, that's enough to have two parameters to update value in the table I need.
--drop function insertNewCustomer;

CREATE OR REPLACE FUNCTION insertNewCustomer(tables_primary_key INT, customer_name TEXT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN
	UPDATE customers
		SET first_name = customer_name
		WHERE customer_id = tables_primary_key;
		
return tables_primary_key;
END;
$$;
--check function:
--select insertNewCustomer(2, 'Ivan');
----------------------------------------------------------------------------------------------------------------------------------------------------

-- Function that adds new transaction to your transaction table. Come up with input arguments and output format yourself. Make sure all transaction attributes can be set with the function (via their natural keys).

CREATE OR REPLACE FUNCTION insertNewPurcahseTransaction(IN icustomerId INT, iamount INT, iapplianceId INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE lastRowPurchaseId int2;
BEGIN
	insert into customer_purchases (amount, payment_date, customer_id) values (iamount, current_date, icustomerId);
	lastRowPurchaseId = (SELECT currval(pg_get_serial_sequence('customer_purchases','purchase_id')));
	insert into orders_purchases (order_id, purchase_id) values (lastRowPurchaseId, lastRowPurchaseId); --they are always equal: one purhase means always only one order!
	insert into orders_appliances (order_id, appliance_id) values (lastRowPurchaseId, iapplianceId);
return lastRowPurchaseId;
END;
$$;
--check for correctness
--drop function insertNewPurcahseTransaction;
--select insertNewPurcahseTransaction(3, 100, 3);
--select * from customer_purchases;
--select * from orders_purchases;

--5. Create view that joins all tables in your database and represents data in denormalized form for the past month. Make sure to omit meaningless fields in the result (e.g. surrogate keys, duplicate fields, etc.).
create view denormalizedAmplienceDT AS
select 
	distinct c.first_name as name, 
	cg.gender_name as gender, 
	ca.address_name as address,
	cp.amount, 
	cp.payment_date,
	han.appliance_name as goods,
	has.home_appliances_size_category as size,
	apc.appliance_price_category_name as category,
	sc.shop_class_name as shopclass,
	sl.district_location_name as location
from customers c
	join customer_address ca ON c.customer_id = ca.customer_id
	join customer_gender cg ON c.customer_id = cg.customer_id
	join customer_purchases cp ON c.customer_id = cp.customer_id
	join orders_purchases op ON cp.purchase_id = op.purchase_id
	join orders_purchases op2 ON cp.purchase_id = op2.purchase_id
	join orders_appliances oa on oa.order_id = op.order_id
	join home_appliances_names han on han.appliance_id = oa.appliance_id
	join home_appliances_size has on han.appliance_id = has.ha_id
	join appliance_price_category apc on han.appliance_id = apc.ha_id
	join shops_appliances sa on sa.appliance_id = han.appliance_id
	join shop_names sn on sa.shop_id = sn.shop_name_id
	join shop_class sc on sc.id = sn.shop_name_id
	join shop_locations sl on sl.shop_id = sn.shop_name_id
	order by  c.first_name, cp.payment_date;
	
select * from denormalizedAmplienceDT;
drop view denormalizedAmplienceDT;
--6. Create manager's read-only role. 
-- Make sure he can only SELECT from tables in your database. 
-- Make sure he can LOGIN as well.
CREATE ROLE manager with LOGIN ENCRYPTED PASSWORD '13';;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO manager;
SELECT * FROM information_schema.table_privileges 
WHERE information_schema.table_privileges.grantee = 'manager';
CREATE USER marina with password '13';
GRANT manager TO maria;
--Make sure you follow database security best practices when creating role(s).
--I am sure in methods of creation of role. I think, that LOGIN ENCRYPTED PASSWORD is enough to have sufficient level of security.



























