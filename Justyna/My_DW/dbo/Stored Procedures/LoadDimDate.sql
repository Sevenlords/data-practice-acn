
CREATE PROCEDURE [dbo].[LoadDimDate]
AS

EXEC [log].[ProcedureCall] @ProcedureId = @@PROCID, @Step = 1, @Comment = 'Start Proc'

BEGIN TRY
	TRUNCATE TABLE dbo.DimDate

	DECLARE @StartDate DATETIME = '04/30/2008' --Starting value of Date Range
	DECLARE @EndDate DATETIME = '12/30/2022' --End Value of Date Range
	DECLARE @CurrentDate AS DATETIME = @StartDate

	/********************************************************************************************/
	--Proceed only if Start Date(Current date ) is less than End date you specified above

	
	DELETE FROM [dbo].[DimDate]
	WHERE DateKey = -1

	INSERT INTO [dbo].[DimDate]
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
		  ,[IsWeekday])
	SELECT  -1 AS [DateKey]
			,'1900-01-01' AS [Date]
			,'-1' AS [DayOfMonth]
			,'-1' AS [DayName]
			,'-1' AS [Month]
			,'-1' AS [MonthName]
			,'0' AS [Quarter]
			,'-1' AS [QuarterName]
			,'-1' AS [Year]
			,'-1' AS [YearName]
			,'-1' AS [MonthYear]
			,'-1' AS [MMYYYY]
			,0 AS [IsWeekday]
	


	WHILE @CurrentDate <= @EndDate
	BEGIN
	/* Populate Your Dimension Table with values*/
	
		INSERT INTO [dbo].[DimDate]
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
		  ,[IsWeekday])
		SELECT
			CONVERT (char(8),@CurrentDate,112) AS [DateKey],
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
	END
	EXEC [log].[ProcedureCall] @ProcedureId = @@PROCID, @Step = 999, @Comment = 'End Proc'
END TRY
BEGIN CATCH 
	EXEC [log].[ErrorCall]
END CATCH