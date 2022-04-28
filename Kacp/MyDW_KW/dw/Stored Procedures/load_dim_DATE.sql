CREATE procedure dw.[load_dim_DATE]
as

truncate table dw.dim_date


insert into dw.dim_date (
	Date, DayOfMonth, DayName, Month, MonthName, 
	Quarter, QuarterName, Year, YearName, MonthYear, MMYYYY,
	IsWeekday, Timestamp
)

select distinct
	cast(OrderDate as date) as Date,
	day(OrderDate) as DayOfMonth,
	datename(weekday,OrderDate) as DayName,
	month(OrderDate) as Month,
	datename(month, OrderDate) MonthName,
	datename(qq, OrderDate) quarter,
	case datename(qq, OrderDate)
		when 1 then '1st'
		when 2 then '2nd'
		when 3 then '3rd'
		when 4 then '4th'
	end as QuarterName,
	year(OrderDate) Year,
	'CY ' + CONVERT(VARCHAR, DATEPART(YEAR, OrderDate)) AS YearName,
	LEFT(DATENAME(MM, OrderDate), 3) + '-' + CONVERT(VARCHAR, DATEPART(YY, OrderDate)) AS MonthYear,
	RIGHT('0' + CONVERT(VARCHAR, DATEPART(MM, OrderDate)),2) +
		CONVERT(VARCHAR, DATEPART(YY, OrderDate)) AS MMYYYY,
	case 
		when datepart(weekday, OrderDate) in (1,2,3,4,5) then 'WorkDay'
		else 'WeekEnd'
		end as IsWeekday,
	Timestamp

from
	stg.sales_sales_orderheader

