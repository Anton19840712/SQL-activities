select CustomerID, ROUND(avg(Freight), 0) as FreightAvg from Orders 
where ShipCountry = 'Canada' or ShipCountry = 'UK'  
group by CustomerID 
having avg (Freight) > 99 or avg (Freight) < 11 
order by FreightAvg desc
