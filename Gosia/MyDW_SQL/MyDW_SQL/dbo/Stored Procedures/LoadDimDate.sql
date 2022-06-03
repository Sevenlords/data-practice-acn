
CREATE procedure [dbo].[LoadDimDate]
as

EXEC [log].[ProcedureCall]  @ProcedureID = @@PROCID, @Step = 1, @Comment = 'Start proc'

BEGIN TRY

truncate table dbo.DimDate
INSERT INTO dimDate
(DateKey,
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
 IsWeekday,
 Timeshtamp
 )
 SELECT 
'19900101'					AS DateKey,
'2011-06-21 00:00:00.000'	AS Date,
-1							AS DayOfMonth,
'Unknown'					AS DayName,
-1							AS Month,
'Unknown'					AS MonthName,
0							AS Quarter,
'Unknown'					AS QuarterName,
1900						AS Year,
'Unknown'					AS YearName,
'Unknown'					AS MonthYear,
-1	AS MMYYYY,
-1	AS IsWeekday,
0	AS Timeshtamp









DECLARE @StartDate DATETIME = '20110531' --Starting value of Date Range
DECLARE @EndDate DATETIME = '20140630' --End Value of Date Range

DECLARE
	@DayOfWeekInMonth INT,
	@DayOfWeekInYear INT,
	@DayOfQuarter INT,
	@WeekOfMonth INT,
	@CurrentYear INT,
	@CurrentMonth INT,
	@CurrentQuarter INT

DECLARE @DayOfWeek TABLE (DOW INT, MonthCount INT, QuarterCount INT, YearCount INT)

INSERT INTO @DayOfWeek VALUES (1, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (2, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (3, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (4, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (5, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (6, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (7, 0, 0, 0)

DECLARE @CurrentDate AS DATETIME = @StartDate --31/05/2011
SET @CurrentMonth = DATEPART(MM, @CurrentDate) --05
SET @CurrentYear = DATEPART(YY, @CurrentDate) --2011
SET @CurrentQuarter = DATEPART(QQ, @CurrentDate) --2


WHILE @CurrentDate < @EndDate
BEGIN
 
	IF @CurrentMonth != DATEPART(MM, @CurrentDate) -- 05 = 05 
	BEGIN
		UPDATE @DayOfWeek
		SET MonthCount = 0
		SET @CurrentMonth = DATEPART(MM, @CurrentDate)
	END
	
	IF @CurrentQuarter != DATEPART(QQ, @CurrentDate) -- 02 == 02
	BEGIN
		UPDATE @DayOfWeek
		SET QuarterCount = 0
		SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)
	END

	IF @CurrentYear != DATEPART(YY, @CurrentDate) -- 2011 = 2011
	BEGIN
		UPDATE @DayOfWeek
		SET YearCount = 0
		SET @CurrentYear = DATEPART(YY, @CurrentDate)
	END

	UPDATE @DayOfWeek
	SET 
		MonthCount = MonthCount + 1,
		@CurrentMonth = DATEPART(MM, @CurrentDate), 
		QuarterCount = QuarterCount + 1,
		YearCount = YearCount + 1
	WHERE DOW = DATEPART(DW, @CurrentDate) 

	SELECT
		@DayOfWeekInMonth = MonthCount,
		@DayOfQuarter = QuarterCount,
		@DayOfWeekInYear = YearCount
	FROM @DayOfWeek
	WHERE DOW = DATEPART(DW, @CurrentDate)
	
	INSERT INTO [dbo].[DimDate]
	SELECT
		--CONVERT(INT,
		(CONVERT(char(8),@CurrentDate,112))								AS DateKey, --yyyymmdd
		@CurrentDate													AS Date,
		DATEPART(DD, @CurrentDate)										AS DayOfMonth,
		DATENAME(DW, @CurrentDate)										AS DayName,
		DATEPART(MM, @CurrentDate)										AS Month,
		DATENAME(MM, @CurrentDate)										AS MonthName,
		DATEPART(QQ, @CurrentDate)										AS Quarter,
		CASE DATEPART(QQ, @CurrentDate)
			WHEN 1 THEN 'First'
			WHEN 2 THEN 'Second'
			WHEN 3 THEN 'Third'
			WHEN 4 THEN 'Fourth'
			END															AS QuarterName,
		DATEPART(YEAR, @CurrentDate)									AS Year,
		'CY ' + CONVERT(VARCHAR, DATEPART(YEAR, @CurrentDate))			AS YearName,
		LEFT(DATENAME(MM, @CurrentDate), 3) + '-' + CONVERT(VARCHAR,
		DATEPART(YY, @CurrentDate))										AS MonthYear,
		RIGHT('0'+ CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)),2) + 
		CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))					AS MMYYYY,
		CASE DATEPART(DW, @CurrentDate)
			WHEN 1 THEN 0
			WHEN 2 THEN 1
			WHEN 3 THEN 1
			WHEN 4 THEN 1
			WHEN 5 THEN 1
			WHEN 6 THEN 1
			WHEN 7 THEN 0
			END															AS IsWeekday,
		getdate()														AS Timeshtamp

	SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END

EXEC [log].[ProcedureCall]  @ProcedureID = @@PROCID, @Step = 999, @Comment = 'End proc'


END TRY

BEGIN CATCH

EXEC [log].[ErrorCall] 

END CATCH
SELECT * FROM DimDate