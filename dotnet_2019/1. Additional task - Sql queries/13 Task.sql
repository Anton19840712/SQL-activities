select Orders.CustomerID, Orders.ShipCountry, UnitPrice*Quantity *(1-Discount) as OrderPrice
from [Order Details]
inner join Orders on [Order Details].OrderID = Orders.OrderID
where Orders.OrderDate >= '1997-09-01 00:00:00.000' and ShipCountry IN ('Venezuela','Argentina','Brazil')
order by OrderPrice desc
OFFSET (0) ROWS FETCH NEXT (3) ROWS ONLY