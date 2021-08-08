select Country, count(CompanyName) as CustomerCount from Customers 
group by Country having count(CompanyName) > 9 
order by CustomerCount desc