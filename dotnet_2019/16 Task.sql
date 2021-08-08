Select Products.ProductName, Products.UnitsInStock, Suppliers.ContactName, Suppliers.Phone
From Products 
inner join Categories on Categories.CategoryID = Products.CategoryID
inner join Suppliers on Products.SupplierID = Suppliers.SupplierID
where Categories.CategoryName in ('Beverages', 'Seafood') and Products.Discontinued = 0 and Products.UnitsInStock < 20
order by Products.UnitsInStock