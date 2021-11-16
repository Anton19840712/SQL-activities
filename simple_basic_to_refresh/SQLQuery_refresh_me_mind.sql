--SELECT * FROM TableA;
--SELECT * FROM TableB;

--1) INNER JOIN
SELECT 	a.value, b.value FROM TableA a INNER JOIN TableB b ON a.Id = b.Id
-- ������� �� ���������, ������� �����.
--value     value
--A     	A         
--B     	B         
--C     	C         
--D     	D         

--2) LEFT JOIN
SELECT a.value, b.value FROM TableA a LEFT JOIN TableB b ON a.Id = b.Id;
-- ����� ������� ��������������, � ��� ���� ������.
-- ���� �� ������ �� ����������, ��, ��� �� ����� ������ �� ���������� - �� ����������.
-- � ����� ������� ����� ��������� ������, � left join ����� �����������. 
-- � �� ������������� �����.
-- �� ����� ������� ����� �������� ������, �� � ����� �������� b. 

--3) RIGHT JOIN
-- ������ ������� ���������������, � ��� ���� �����.
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
-- �������, ��� ��������� ������ ��� ���������� ����� ���������� �������:
-- ��� ������ ������ ����� ������� ��� ������� ������ ������ ����� ������ �������
SELECT a.value, b.value FROM TableA a CROSS JOIN TableB b;
SELECT b.value, a.value FROM TableB b CROSS JOIN TableA a;

--6) SELF JOIN
-- ����� �����-��:
SELECT 	a.Id, a.value FROM TableA a, TableB b;
SELECT 	b.Id, b.value FROM TableB b, TableB a;
