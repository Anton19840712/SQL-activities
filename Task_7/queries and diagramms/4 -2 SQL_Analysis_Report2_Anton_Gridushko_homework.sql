--2. How does your business generate income?

SELECT
	c.channel_desc,	
	SUM (p.unit_price - p.unit_cost)* p.quantity_sold AS plus
FROM profits p
JOIN channels c ON c.channel_id = p.channel_id
GROUP by 
	p.channel_id, 
	p.quantity_sold, 
	c.channel_desc
ORDER BY plus desc;