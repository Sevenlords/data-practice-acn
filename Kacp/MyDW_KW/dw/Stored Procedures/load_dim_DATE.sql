CREATE procedure [dw].[load_dim_DATE] as

exec log.write_proc_call @ProcedureID = @@procid ,@Step = 1, @Comment ='Start proc'

truncate table dw.dim_date


DECLARE @StartDate DATETIME = '05/30/2011' 
DECLARE @EndDate DATETIME = '12/30/2021' 
DECLARE @CurrentDate AS DATETIME = @StartDate

while @CurrentDate < @EndDate
begin

	insert into dw.dim_date (
		DateKey,
		Date, 
		DayOfMonth, 
		DayName, 
		Month, 
		MonthName, 
		Quarter, 
		QuarterName, 
		Year, 
		YearName, 
		MonthYear, 
		MMYYYY,
		IsWeekday
	)
	select
		CONVERT (char,@CurrentDate,112)		as DateKey,
		cast(@CurrentDate as date)			as Date,
		day(@CurrentDate)					as DayOfMonth,
		datename(weekday,@CurrentDate)		as DayName,
		month(@CurrentDate)					as Month,
		datename(month, @CurrentDate)		as MonthName,
		datename(qq, @CurrentDate)			as quarter,
		case datename(qq, @CurrentDate)
			when 1 then '1st'
			when 2 then '2nd'
			when 3 then '3rd'
			when 4 then '4th'	end		as QuarterName,
		year(@CurrentDate)					as Year,
		'CY ' + CONVERT(VARCHAR, DATEPART(YEAR, @CurrentDate)) AS YearName,
		LEFT(DATENAME(MM, @CurrentDate), 3) + '-' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MonthYear,
		RIGHT('0' + CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)),2) +
			CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MMYYYY,
		case 
			when datepart(weekday, @CurrentDate) in (1,2,3,4,5) then 'WorkDay'
			else 'WeekEnd'
			end	as IsWeekday

	set @CurrentDate = dateadd(DD, 1, @CurrentDate)
	
end

exec log.write_proc_call @ProcedureID = @@procid ,@Step = 999, @Comment ='End proc'