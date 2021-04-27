--Explore Sales History Schema’s tables.
--"C:\Program Files\PostgreSQL\12\bin\pg_restore.exe" --verbose --host=localhost --port=5432 --username=postgres --format=c --dbname=postgres "D:\databases\.backup\sh.backup"
--• Find out fact and dimension tables into Sales History and 
-- briefly describe schema (what information is stored into it). 
--• Compose text document (name of the file should be 
-- SQL_Analysis_Description_Name_Surname_homework)
-----------------------------------------------------------------
I think, the aspect of the sales history relates to the sales and times tables.
Thanks to them, we can show who bought, what, when and purchase motivation may be.
By analyze different several basic trends of the sales-influencing aspects presented in the column names:

The sales table describes the objects of the sales system and consists of the next columns:
	prod_id,
	cust_id,
	time_id,
	channel_id,
	promo_id,
	quantity_sold,
	amount_sold
The sales time table describes the timing aspects of individual sale and consists of the next columns:
	time_id,
	day_name,
	day_number_in_week,
	day_number_in_month,
	calendar_week_number,
	fiscal_week_number,
	week_ending_day,
	etc
--Provide description for each table in Sales History.

Base descrition of the purposes of schema tables:
-----------------------------------------------------------------
COUNTRIES contains basic geographic country characteristics
CUSTOMERS contains basic customer identifications
CHANNELS contains primary sales channels
TIMES contains the timing of individual sales
PRODUCTS contains a list of products sold by the organization
PROMOTIONS list of promotional events
COSTS resulting table of the calculated cost per item
SALES contains a summary of who, when, what and for what price
PROPFITS contains summary fields with sales results