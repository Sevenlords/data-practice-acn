CREATE procedure [dbo].[LoadDimDate]
as

truncate table [dbo].[DimDate]
DECLARE @StartDate DATETIME = '01/01/2008' --Starting value of Date Range
DECLARE @EndDate DATETIME = '01/01/2030' --End Value of Date Range

DECLARE @CurrentDate AS DATETIME = @StartDate

WHILE @CurrentDate < @EndDate
BEGIN
 
	INSERT INTO [dbo].[DimDate]
	([DateKey],  
		[Date],
		[DayOfMonth],
		[DayName],
		[Month],
		[MonthName],
		[Quarter],
		[QuarterName],
		[Year],
		[YearName],
		[MonthYear],
		[MMYYYY],
		[IsWeekday])
	SELECT
		CONVERT (char(8),@CurrentDate,112) as [DateKey],
		@CurrentDate AS [Date],
		DATEPART(DD, @CurrentDate) AS [DayOfMonth],		
		DATENAME(DW, @CurrentDate) AS [DayName],
		DATEPART(MM, @CurrentDate) AS [Month],
		DATENAME(MM, @CurrentDate) AS [MonthName],
		DATEPART(QQ, @CurrentDate) AS [Quarter],
		CASE DATEPART(QQ, @CurrentDate)
			WHEN 1 THEN 'First'
			WHEN 2 THEN 'Second'
			WHEN 3 THEN 'Third'
			WHEN 4 THEN 'Fourth'
			END AS [QuarterName],
		DATEPART(YEAR, @CurrentDate) AS [Year],
		'CY ' + CONVERT(VARCHAR, DATEPART(YEAR, @CurrentDate)) AS [YearName],
		LEFT(DATENAME(MM, @CurrentDate), 3) + '-' + CONVERT(VARCHAR,
		DATEPART(YY, @CurrentDate)) AS [MonthYear],
		RIGHT('0' + CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)),2) + 
		CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS [MMYYYY],
		CASE DATEPART(DW, @CurrentDate)
			WHEN 1 THEN 0
			WHEN 2 THEN 1
			WHEN 3 THEN 1
			WHEN 4 THEN 1
			WHEN 5 THEN 1
			WHEN 6 THEN 1
			WHEN 7 THEN 0
			END AS [IsWeekday]
			SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
		end