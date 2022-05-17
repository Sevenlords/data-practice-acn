CREATE procedure [dbo].[LoadDimDate] as

	truncate table [dbo].[dimDate]

	declare @StartDate datetime = '05/31/2011'	
	--declare @EndDate datetime = '06/30/2014'
	declare @EndDate datetime = '04/01/2021'	
	declare @CurrentDate datetime = @StartDate		

	while @CurrentDate <= @EndDate
	begin
		insert into [dbo].[dimDate](
			[DateKey],
			[Date],
			[DayOfMonth],
			[DayName],
			[Month],
			[MonthName],
			[Quater],
			[QuaterName],
			[Year],
			[YearName],
			[MonthYear],
			[MMYYYY],
			[IsWeekday]
		)
		select 
			convert(char(8), @CurrentDate, 112) [DateKey],
			cast(@CurrentDate as datetime) [Date],
			datepart(DD, @CurrentDate) [DayOfMonth],
			datename(DW, @CurrentDate) [DayName],
			datepart(MM, @CurrentDate) [Month],
			datename(MM, @CurrentDate) [MonthName],
			datepart(QQ, @CurrentDate) [Quater],
			case datepart(QQ, @CurrentDate)
				when 1 then 'First'
				when 2 then 'Second'
				when 3 then 'Third'
				when 4 then 'Fourth'
				end as [QuaterName],
			datepart(YEAR, @CurrentDate) [Year],
			'CY ' + convert(varchar, datepart(YEAR, @CurrentDate)) [YearName],
			left(datename(MM,@CurrentDate),3) + '-' + convert(varchar, datepart(YY, @CurrentDate)) [MonthYear],
			right('0' + convert(varchar,datepart(MM, @CurrentDate)),2) + convert(varchar, datepart(YY,@CurrentDate)) [MMYYYY],
			case datepart(DW, @CurrentDate) 
				when 1 then 0
				when 2 then 1
				when 3 then 1
				when 4 then 1
				when 5 then 1
				when 6 then 1
				when 7 then 0
				end as [IsWeekday]

		set @CurrentDate = dateadd(DD, 1, @CurrentDate)
	end
