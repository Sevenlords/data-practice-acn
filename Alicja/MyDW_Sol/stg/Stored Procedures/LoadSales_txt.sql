CREATE procedure [stg].[LoadSales_txt] as
	delete a 
	from [stg].[Sales_txt] a
	join [stg].[Sales_txt_delta] b
	on a.order_number = b.order_number
	
	insert into [stg].[Sales_txt]
	select 
		[order_number],
		[line_number],
		[date],
		[customer],
		[country],
		[product],
		[qty],
		[unit_price],
		[Timestamp],		--czy to tez ma byc pobierane?
		[Filename]
	from [stg].[Sales_txt_delta] -- czy dane powinny miec zmieniany typ? np unit_price z varchar na money