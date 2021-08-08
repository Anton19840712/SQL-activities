select City, count (CompanyName) as CustomerCount  from Customers 
where Country in ('Norway', 'Finland','Sweden')
group by City