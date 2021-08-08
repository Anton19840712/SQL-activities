SELECT s.CompanyName, MinPrice = min(p.UnitPrice), MaxPrice = max(p.UnitPrice)
FROM dbo.Products p
INNER JOIN dbo.Suppliers s ON s.SupplierID = p.SupplierID
GROUP BY s.CompanyName
ORDER BY s.CompanyName