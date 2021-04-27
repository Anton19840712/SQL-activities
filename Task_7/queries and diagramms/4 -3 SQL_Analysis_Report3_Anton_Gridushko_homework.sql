--3. Which parts of your business are not profitable or less profitable in comparison with the others?

SELECT
	p.prod_subcategory,	
	SUM (pr.unit_price - pr.unit_cost)* pr.quantity_sold AS plus
FROM profits pr
JOIN products p ON p.prod_id = pr.prod_id
GROUP by 
	p.prod_subcategory, 
	pr.quantity_sold
ORDER BY plus desc;
