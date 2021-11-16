--SELECT * FROM TableA;
--SELECT * FROM TableB;

--1) INNER JOIN
SELECT 	a.value, b.value FROM TableA a INNER JOIN TableB b ON a.Id = b.Id
-- выведет те айдишники, которые мэчат.
--value     value
--A     	A         
--B     	B         
--C     	C         
--D     	D         

--2) LEFT JOIN
SELECT a.value, b.value FROM TableA a LEFT JOIN TableB b ON a.Id = b.Id;
-- левая таблица стабилизирован, к ней едет правая.
-- нули из правой не подъезжают, то, что не мэчит справа по айдишникам - не подъезжает.
-- к левой таблице будет приезжать правая, К left join будет происходить. 
-- А не присоединение левой.
-- на левую таблицу будет мапиться правая, на а будет мапиться b. 

--3) RIGHT JOIN
-- правая таблица стабилизирована, к ней едет левая.
SELECT a.value, b.value FROM TableA a RIGHT JOIN TableB b ON a.Id = b.Id;
SELECT a.value, b.value FROM TableA a RIGHT JOIN TableB b ON a.Id = b.Id WHERE a.value IS NOT NULL;

--4) FULL OUTER JOIN
SELECT a.value, b.value FROM TableA a FULL OUTER JOIN TableB b ON a.Id = b.Id;
--value	value
--A     A         
--B     B         
--C     C         
--D     NULL
--NULL	E         
--NULL	F         
--NULL	H         
--NULL	I         

--5) CROSS JOIN
-- странно, что выведется только для уникальной части наименьшей таблицы:
-- для каждой строки левой таблицы оно выведет полный список строк правой таблицы
SELECT a.value, b.value FROM TableA a CROSS JOIN TableB b;
SELECT b.value, a.value FROM TableB b CROSS JOIN TableA a;

--6) SELF JOIN
-- ересь какая-то:
SELECT 	a.Id, a.value FROM TableA a, TableB b;
SELECT 	b.Id, b.value FROM TableB b, TableB a;
