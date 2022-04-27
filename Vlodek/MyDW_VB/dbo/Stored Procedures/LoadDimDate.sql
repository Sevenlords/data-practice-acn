
CREATE PROCEDURE [dbo].[LoadDimDate] 
AS
 
truncate table [dbo].[DimDate]

DECLARE @StartDate DATETIME = '01-01-2008', --Starting value of Date Range
	@EndDate DATETIME = '02-01-2022' --End Value of Date Range

	DECLARE @CurrentDate AS DATETIME = @StartDate

	WHILE @CurrentDate < @EndDate
	BEGIN
		INSERT INTO [dbo].[DimDate] ([DateKey],[Date],[FullDateUK],[DayOfMonth],[DayName]
									  ,[Month],[MonthName],[MonthOfQuarter],[Quarter],[QuarterName]
									  ,[Year],[YearName],[MonthYear],[MMYYYY],[IsWeekday])
		SELECT
			CONVERT(int,CONVERT(char(8),@CurrentDate,112)) as DateKey,
			@CurrentDate AS Date,
			CONVERT(char(10),@CurrentDate,103) as FullDateUK,
			DAY(@CurrentDate) AS DayOfMonth,
			DATENAME(DW, @CurrentDate) AS DayName,
			MONTH(@CurrentDate) AS Month,
			DATENAME(MM, @CurrentDate) AS MonthName,
			CASE
				WHEN MONTH(@CurrentDate) IN (1, 4, 7, 10) THEN 1
				WHEN MONTH(@CurrentDate) IN (2, 5, 8, 11) THEN 2
				WHEN MONTH(@CurrentDate) IN (3, 6, 9, 12) THEN 3
			END AS MonthOfQuarter,
			DATEPART(QQ, @CurrentDate) AS Quarter,
			CASE DATEPART(QQ, @CurrentDate)
				WHEN 1 THEN 'First'
				WHEN 2 THEN 'Second'
				WHEN 3 THEN 'Third'
				WHEN 4 THEN 'Fourth'
			END AS QuarterName,
			YEAR(@CurrentDate) AS Year,
			CONCAT('CY ',YEAR(@CurrentDate)) AS YearName,
			CONCAT(LEFT(DATENAME(MM, @CurrentDate), 3), '-' ,YEAR(@CurrentDate)) AS MonthYear,
			CONCAT(
				RIGHT(CONCAT('0',MONTH(@CurrentDate)),2),
				YEAR(@CurrentDate)
			) AS MMYYYY,
			CASE DATEPART(DW, @CurrentDate)
				WHEN 1 THEN 0
				WHEN 2 THEN 1
				WHEN 3 THEN 1
				WHEN 4 THEN 1
				WHEN 5 THEN 1
				WHEN 6 THEN 1
				WHEN 7 THEN 0
			END AS IsWeekday

		SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
		END

		--select * from dimdate
