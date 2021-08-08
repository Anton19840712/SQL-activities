select a.CustomerID, sum(Freight) as FreightSum from Orders a join 

(select AVG(Freight) as AvgT,CustomerID from Orders a group by CustomerID) b on a.CustomerID=b.CustomerID

where a.Freight >= b.AvgT and a.ShippedDate > '1996-07-15 00:00:00.000' 

group by a.CustomerID order by FreightSum