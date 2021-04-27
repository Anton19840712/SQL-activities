--CREATE DATABASE workload;

drop table IF EXISTS locations;
drop table IF EXISTS capacity;
drop table IF EXISTS capabilities_institutions;
drop table IF EXISTS institution_staffing;
drop table IF EXISTS capabilities;
drop table IF EXISTS patients_visits;
drop table IF EXISTS staffing;
drop table IF EXISTS institutions;

--1 task part

CREATE TABLE institutions(
    id SERIAL NOT NULL PRIMARY KEY, -- SERIAL, autoincrementing four-byte integer - that's more than enough
    institution_name VARCHAR (150) NOT NULL --VARCHAR - universally, but it could be TEXT also
);
----------------

CREATE TABLE staffing (
    id SERIAL NOT NULL PRIMARY KEY,
    staffing VARCHAR (50) NULL
);
-----------------

CREATE TABLE patients_visits (
    id INT GENERATED ALWAYS AS IDENTITY,
    patients_last_monthes_visits INT NOT NULL CHECK(patients_last_monthes_visits > 0),
    id_staffing INT REFERENCES staffing(id)
);
-----------------
CREATE TABLE locations (
    id SERIAL NOT NULL PRIMARY KEY,
    location_name VARCHAR (150) NULL,
    id_institution INT REFERENCES institutions(id),
	UNIQUE(id_institution)
);
-----------------
CREATE TABLE capacity (
    id SERIAL NOT NULL PRIMARY KEY,
	capacity INT DEFAULT 300 CHECK (capacity < 1000),
    id_institution INT REFERENCES institutions(id),
	UNIQUE(id_institution)
);

CREATE TABLE capabilities (
    id SERIAL NOT NULL PRIMARY KEY,
    capability_name VARCHAR (50) NULL
);
-----------------

CREATE TABLE capabilities_institutions (
    id_institution  INT NOT NULL,
    id_capability INT NOT NULL,
    CONSTRAINT capabilities_institutions_pkey PRIMARY KEY (id_institution, id_capability),
	CONSTRAINT capabilities_institutions_institutions_fkey FOREIGN KEY (id_institution) REFERENCES institutions (id),
    CONSTRAINT capabilities_institutions_capabilities_fkey FOREIGN KEY (id_capability) REFERENCES capabilities(id)
);
-----------------
CREATE TABLE institution_staffing (
    id_institution  INT NOT NULL,
    id_staffing INT NOT NULL,
    CONSTRAINT institution_staffing_pkey PRIMARY KEY (id_institution, id_staffing),
	CONSTRAINT institution_staffing_institutions_fkey FOREIGN KEY (id_institution) REFERENCES institutions (id),
    CONSTRAINT institution_staffing_staffing_fkey FOREIGN KEY (id_staffing) REFERENCES staffing(id)
);
-----------------
--institutions
insert into institutions (institution_name) values ('1st City Clinical Hospital');
insert into institutions (institution_name) values ('2nd City Clinical Hospital');
insert into institutions (institution_name) values ('3rd City Clinical Hospital');
insert into institutions (institution_name) values ('4th City Clinical Hospital');
insert into institutions (institution_name) values ('5th City Clinical Hospital');

--locations
insert into locations (location_name, id_institution) values ('Tsentralny', 1);
insert into locations (location_name, id_institution) values ('Savetski', 2);
insert into locations (location_name, id_institution) values ('Pershamayski ', 3);
insert into locations (location_name, id_institution) values ('Partyzanski', 4);
insert into locations (location_name, id_institution) values ('Zavodski', 5);

--capacity
insert into capacity (id_institution) values (1);
insert into capacity (id_institution) values (2);
insert into capacity (capacity, id_institution) values (500, 3);
insert into capacity (capacity, id_institution) values (600, 4);
insert into capacity (capacity, id_institution) values (700, 5);

--staffing
insert into staffing (staffing) values ('A');
insert into staffing (staffing) values ('B');
insert into staffing (staffing) values ('C');
insert into staffing (staffing) values ('D');
insert into staffing (staffing) values ('E');

--capabilities
insert into capabilities (capability_name) values ('Medical surge');
insert into capabilities (capability_name) values ('Epidemiological surveillance');
insert into capabilities (capability_name) values ('Medical supplies logistics');
insert into capabilities (capability_name) values ('Isolation and quarantine');
insert into capabilities (capability_name) values ('Laboratory testing');

--patients_visits
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (1, 1);
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (2, 1);
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (2, 1);
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (4, 2);
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (5, 2);
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (6, 2);
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (7, 3);
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (8, 3);
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (9, 3);
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (1, 4);
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (2, 4);
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (1, 4);
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (13, 5);
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (14, 5);
insert into patients_visits (patients_last_monthes_visits, id_staffing) values (15, 5);

--capabilities_institutions
insert into capabilities_institutions (id_institution, id_capability) values (1, 1);
insert into capabilities_institutions (id_institution, id_capability) values (2, 1);
insert into capabilities_institutions (id_institution, id_capability) values (3, 2);
insert into capabilities_institutions (id_institution, id_capability) values (4, 2);
insert into capabilities_institutions (id_institution, id_capability) values (5, 3);
insert into capabilities_institutions (id_institution, id_capability) values (1, 3);
insert into capabilities_institutions (id_institution, id_capability) values (2, 4);
insert into capabilities_institutions (id_institution, id_capability) values (3, 4);
insert into capabilities_institutions (id_institution, id_capability) values (4, 5);
insert into capabilities_institutions (id_institution, id_capability) values (5, 5);

--institution_staffing
insert into institution_staffing (id_institution, id_staffing) values (1, 1);
insert into institution_staffing (id_institution, id_staffing) values (2, 1);
insert into institution_staffing (id_institution, id_staffing) values (3, 2);
insert into institution_staffing (id_institution, id_staffing) values (4, 2);
insert into institution_staffing (id_institution, id_staffing) values (5, 3);
insert into institution_staffing (id_institution, id_staffing) values (1, 3);
insert into institution_staffing (id_institution, id_staffing) values (2, 4);
insert into institution_staffing (id_institution, id_staffing) values (3, 4);
insert into institution_staffing (id_institution, id_staffing) values (4, 5);
insert into institution_staffing (id_institution, id_staffing) values (5, 5);

-- select * from institutions;
-- select * from locations;
-- select * from capacity;
-- select * from staffing;
-- select * from capabilities;
-- select * from patients_visits;
-- select * from capabilities_institutions;
-- select * from institution_staffing;

--2 task part

SELECT 
	s.id, 
	SUM(patients_last_monthes_visits) 
FROM staffing s 
	JOIN patients_visits pv ON s.id = pv.id_staffing 
	GROUP BY staffing, s.id 
	HAVING SUM(patients_last_monthes_visits) < 5;


