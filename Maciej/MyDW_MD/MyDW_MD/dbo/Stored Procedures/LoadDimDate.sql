CREATE procedure [dbo].[LoadDimDate]
as

exec [log].[ProcedureCall] @ProcedureID = @@procid ,@Step = 1, @Comment ='Start proc'

truncate table [dbo].[DimDate]
DECLARE @StartDate DATETIME = '01/01/2008' --Starting value of Date Range
DECLARE @EndDate DATETIME = '01/01/2030' --End Value of Date Range

DECLARE @CurrentDate AS DATETIME = @StartDate

delete from dimdate where datekey=19000101

insert into DimDate
([DateKey]
      ,[Date]
      ,[DayOfMonth]
      ,[DayName]
      ,[Month]
      ,[MonthName]
      ,[Quarter]
      ,[QuarterName]
      ,[Year]
      ,[YearName]
      ,[MonthYear]
      ,[MMYYYY]
      ,[IsWeekday]
      ,[CreatedDate])
select 19000101 as [DateKey]
      ,'1900-01-01 00:00:00.000' as [Date]
      ,1 as [DayOfMonth]
      ,'-1'[DayName]
      ,1 as [Month]
      ,'January' as [MonthName]
      ,1 as [Quarter]
      ,'First' as [QuarterName]
      ,1900 as [Year]
      ,'CY1900' as [YearName]
      ,'Jan-1900' as [MonthYear]
      ,0119000 as [MMYYYY]
      ,'-1' as [IsWeekday]
      ,getdate() as [CreateDate]

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

		exec [log].[ProcedureCall] @ProcedureID = @@procid ,@Step = 999, @Comment ='End proc'