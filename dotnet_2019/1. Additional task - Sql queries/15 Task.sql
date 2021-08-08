Select Customers.CompanyName as Customer, (Employees.FirstName + ' ' + Employees.LastName) as Employee
From Customers 
inner join Orders on Customers.CustomerID = Orders.CustomerID
inner join Employees on Orders.EmployeeID = Employees.EmployeeID
inner join Shippers on Orders.ShipVia = Shippers.ShipperID
where Employees.City = 'London' and Shippers.ShipperID = 1
order by Customers.CustomerID 