CREATE procedure [stg].[LoadSales_txt] as

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 1, @Comment = 'Start Proc'

	begin try

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
		[Timestamp],		
		[Filename]
	from [stg].[Sales_txt_delta] 

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 999, @Comment = 'End Proc'

	end try
	begin catch
		declare @ErrorNumber int = ERROR_NUMBER(), 
				@ErrorState int = ERROR_STATE(), 
				@ErrorSeverity int = ERROR_SEVERITY(), 
				@ErrorLine int = ERROR_LINE(), 
				@ErrorProcedure nvarchar(max) = ERROR_PROCEDURE(), 
				@ErrorMessage nvarchar(max) = ERROR_MESSAGE()

		exec [log].[ErrorCall]	@ErrorNumber = @ErrorNumber, @ErrorState = @ErrorState, @ErrorSeverity = @ErrorSeverity, 
								@ErrorLine = @ErrorLine, @ErrorProcedure = @ErrorProcedure, @ErrorMessage = @ErrorMessage
	end catch