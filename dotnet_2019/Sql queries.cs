Реляционные базы данных и SQL
Практические задания
Элементарный уровень

Задание 1
Напишите запрос, который выводит список заказчиков в виде таблицы, состоящей из двух столбцов CustomerID и CompanyName.
Строки таблицы должны быть отсортированы по коду заказчика.
Select CustomerID, CompanyName from dbo.Customers order by PostalCode

Задание 2
Напишите запрос, который выводит EmployeeID последнего нанятого компанией сотрудника.
Select TOP 1 EmployeeID from dbo.Employees order by HireDate

Задание 3
Напишите запрос, который выводит список всех стран из колонки dbo.Customers.Country.
Список должен быть отсортирован в алфавитном порядке, должен содержать только уникальные значения и не должен содержать дубликаты.
Select distinct Country from Customers order by Country asc

Задание 4
Напишите запрос, который выводит список названий компаний-заказчиков, расположенных в следущих городах: 
Берлин, Лондон, Мадрид, Брюссель, Париж.Список должен быть отсортирован по коду-идентификатору компании в обратном алфавитном порядке.
Select CompanyName from Customers
where City in ('Berlin', 'London', 'Madrid', 'Bruxelles', 'Paris')
order by CustomerID desc

Задание 5
Напишите запрос, который выводит список идентификаторов компаний, для которых заказы были доставлены(dbo.Orders.RequiredDate) в сентябре 1996 года.
Список должен быть отсортирован в алфавитном порядке.
select CustomerID from Orders
where RequiredDate between '1996-09-01 00:00:00.000' and '1996-09-30 00:00:00.000' 
order by CustomerID asc

Задание 6
Напишите запрос, который выводит имя контактного лица компании-заказчика, 
чей номер телефона начинается с кода "171" и содержит "77", а также номер факса начинается с кода "171" и оканчивается на "50".
select ContactName from Customers
where Phone like '%171%77%' and Fax like '%171%50'

Задание 7
Напишите запрос, который выводит количество компаний-заказчиков, которые находятся в городах, принадлежащих трем скандинавским странам.
Результирующая таблица должна состоять из двух колонок City и CustomerCount.
select City, count (CompanyName) as CustomerCount from Customers
where Country in ('Norway', 'Finland','Sweden')
group by City

Задание 8
Напишите запрос, который выводит количество компаний-заказчиков в странах, в которых есть 10 и более заказчиков.
Результирующая таблица должна иметь колонки Country и CustomerCount, строки которой должны быть отсортированы в обратном порядке по количеству заказчиков в стране.
select Country, count(CompanyName) as CustomerCount from Customers
group by Country having count(CompanyName) > 9 
order by CustomerCount desc

Задание 9
Напишите запрос, который выводит среднюю стоимость фрахта (dbo.Order.Freight) заказов для компаний-заказчиков, которые указывали местом доставки заказа город, принадлежащий Великобритании или Канаде. Дополнительным критерием выборки является значение средней стоимости фрахта заказа - больше или равно 100, или меньше 10. Результирующая таблица должна иметь колонки CustomerID и FreightAvg, значение средней стоимости должно быть округлено до целого значения, строки должны быть отсортированы в обратном порядке по значению среднего значения фрахта.
select CustomerID, ROUND(avg(Freight), 0) as FreightAvg from Orders
where ShipCountry = 'Canada' or ShipCountry = 'UK'
group by CustomerID
having avg(Freight) > 99 or avg(Freight) < 11 
order by FreightAvg desc

Задание 10
Напишите запрос, который выводит EmployeeID предпоследнего нанятого компанией сотрудника.Используйте подзапрос для исключения последнего нанятого сотрудника.
select TOP(1) EmployeeID from Employees where HireDate<(select MAX(HireDate) from Employees) order by HireDate desc

Задание 11
Напишите запрос, который выводит EmployeeID предпоследнего нанятого компанией сотрудника.Используйте ключевые слова OFFSET и FETCH.
select EmployeeID from Employees where HireDate < (select MAX(HireDate) from Employees) order by HireDate desc OFFSET(0) ROWS FETCH NEXT(1) ROWS ONLY

Задание 12
Напишите запрос, который выводит общую сумму фрахтов заказов для компаний-заказчиков для заказов, 
стоимость фрахта которых больше или равна средней величине стоимости фрахта всех заказов,
а также дата отгрузки заказа должна находится во второй половине июля 1996 года.
Результирующая таблица должна иметь колонки CustomerID и FreightSum, строки которой должны быть отсортированы по сумме фрахтов заказов.
select a.CustomerID, sum(Freight) as FreightSum from Orders a join
(select AVG(Freight) as AvgT, CustomerID from Orders a group by CustomerID) b on a.CustomerID=b.CustomerID
 where a.Freight >= b.AvgT and a.ShippedDate > '1996-07-15 00:00:00.000' 
group by a.CustomerID order by FreightSum

Задание 13
Напишите запрос, который выводит 3 заказа с наибольшей стоимостью, которые были созданы после 1 сентября 1997 года включительно и были доставлены в страны Южной Америки.
Общая стоимость рассчитывается как сумма стоимости деталей заказа с учетом дисконта.
Результирующая таблица должна иметь колонки CustomerID, ShipCountry и OrderPrice, строки которой должны быть отсортированы по стоимости заказа в обратном порядке.
select Orders.CustomerID, Orders.ShipCountry, UnitPrice* Quantity *(1-Discount) as OrderPrice
 from[Order Details]
inner join Orders on[Order Details].OrderID = Orders.OrderID
where Orders.OrderDate >= '1997-09-01 00:00:00.000' and ShipCountry IN('Venezuela','Argentina','Brazil')
order by OrderPrice desc
OFFSET(0) ROWS FETCH NEXT(3) ROWS ONLY

Задание 14
Перепишите запрос с использованием группировки:
SELECT DISTINCT s.CompanyName,
(SELECT min(t.UnitPrice) FROM dbo.Products as t WHERE t.SupplierID = p.SupplierID) as MinPrice,
(SELECT max(t.UnitPrice) FROM dbo.Products as t WHERE t.SupplierID = p.SupplierID) as MaxPrice
FROM dbo.Products AS p
INNER JOIN dbo.Suppliers AS s ON p.SupplierID = s.SupplierID
ORDER BY s.CompanyName
Решение:
SELECT s.CompanyName, MinPrice = min(p.UnitPrice), MaxPrice = max(p.UnitPrice)
FROM dbo.Products p
INNER JOIN dbo.Suppliers s ON s.SupplierID = p.SupplierID
GROUP BY s.CompanyName
ORDER BY s.CompanyName

Задание 15
Напишите запрос, который выводит список компаний-заказчиков из Лондона,
которые делали заказы у сотрудников лондонского офиса и заказали доставку через службу Speedy Express. 
Результирующая таблица должна иметь колонки Customer и Employee, колонка Employee должна содержать FirstName и LastName сотрудника.
Select Customers.CompanyName as Customer, (Employees.FirstName + ' ' + Employees.LastName) as Employee
From Customers
inner join Orders on Customers.CustomerID = Orders.CustomerID
inner join Employees on Orders.EmployeeID = Employees.EmployeeID
inner join Shippers on Orders.ShipVia = Shippers.ShipperID
where Employees.City = 'London' and Shippers.ShipperID = 1
order by Customers.CustomerID

Задание 16
Напишите запрос, который выводит список продуктов из категорий Beverages и Seafood, которые можно заказать у поставщиков (Discontinued) и которые остались на складе в количестве меньше 20 штук.Результирующая таблица должна иметь колонки ProductName, UnitsInStock, ContactName и Phone поставщика. Строки таблицы должны быть отсортированы по значению складского запаса.
Select Products.ProductName, Products.UnitsInStock, Suppliers.ContactName, Suppliers.Phone
From Products
inner join Categories on Categories.CategoryID = Products.CategoryID
inner join Suppliers on Products.SupplierID = Suppliers.SupplierID
where Categories.CategoryName in ('Beverages', 'Seafood') and Products.Discontinued = 0 and Products.UnitsInStock< 20
order by Products.UnitsInStock