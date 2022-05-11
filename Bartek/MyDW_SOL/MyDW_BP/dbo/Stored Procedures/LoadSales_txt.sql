Create Procedure LoadSales_txt 
AS
Truncate table STG.Sales_txt

Insert into STG.Sales_txt
SELECT 
Cast(Order_number AS int),
Cast(Line_Number AS int),
Convert(datetime,date,104),
Cast(Customer as Varchar(10)),
Country,
Product,
Cast(qty as smallint),
Cast(unit_price as money),
timeshtamp,
filename
FROM STG.Sales_Txt_delta