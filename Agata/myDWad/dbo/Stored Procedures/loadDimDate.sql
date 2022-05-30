



/********************************************************************************************/
--Specify Start Date and End date here
--Value of Start Date Must be Less than Your End Date 
CREATE procedure [dbo].[loadDimDate] @StartDate Datetime='01/01/2005',@EndDate DATETIME = '01/01/2025'
as

BEGIN TRY
exec log.[procedurecall] @ProcedureID=@@ProcID, @Step=1, @Comment='Start Proc'
truncate table dbo.dimdate

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
      ,[CreateDate])
select 19000101[DateKey]
      ,'1900-01-01 00:00:00.000'[Date]
      ,0[DayOfMonth]
      ,'-1'[DayName]
      ,1[Month]
      ,'January'[MonthName]
      ,1[Quarter]
      ,'First'[QuarterName]
      ,1900[Year]
      ,'CY1900'[YearName]
      ,'Jan-1900'[MonthYear]
      ,0119000[MMYYYY]
      ,'-1'[IsWeekday]
      ,getdate()[CreateDate]

/********************************************************************************************/
--Proceed only if Start Date(Current date ) is less than End date you specified above

WHILE @CurrentDate < @EndDate
BEGIN
 
	
	INSERT INTO [dbo].[DimDate]
	SELECT
		
		CONVERT (char(8),@CurrentDate,112) as DateKey,

		@CurrentDate AS Date,

		DATEPART(DD, @CurrentDate) AS DayOfMonth,	
		
		DATENAME(DW, @CurrentDate) AS DayName,

		DATEPART(MM, @CurrentDate) AS Month,

		DATENAME(MM, @CurrentDate) AS MonthName,

		DATEPART(QQ, @CurrentDate) AS Quarter,

		CASE DATEPART(QQ, @CurrentDate)
			WHEN 1 THEN 'First'
			WHEN 2 THEN 'Second'
			WHEN 3 THEN 'Third'
			WHEN 4 THEN 'Fourth'
			END AS QuarterName,

		DATEPART(YEAR, @CurrentDate) AS Year,

		'CY ' + CONVERT(VARCHAR, DATEPART(YEAR, @CurrentDate)) AS YearName,

		LEFT(DATENAME(MM, @CurrentDate), 3) + '-' + CONVERT(VARCHAR, 
		DATEPART(YY, @CurrentDate)) AS MonthYear,

		RIGHT('0' + CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)),2) + 
		CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MMYYYY,

		CASE DATEPART(DW, @CurrentDate)
			WHEN 1 THEN 0
			WHEN 2 THEN 1
			WHEN 3 THEN 1
			WHEN 4 THEN 1
			WHEN 5 THEN 1
			WHEN 6 THEN 1
			WHEN 7 THEN 0
			END AS IsWeekday,

		GETDATE() as CreateDate
		SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)


END
exec log.[procedurecall] @ProcedureID=@@ProcID, @Step=999, @Comment='End Proc'
END TRY
BEGIN CATCH

declare @ErrorNumber int = (select ERROR_NUMBER())
declare @ErrorState int = (select ERROR_STATE())
declare @ErrorSeverity int = (select ERROR_SEVERITY())
declare @ErrorLine int = (select ERROR_LINE())
declare @ErrorProcedure varchar(max) = (select ERROR_PROCEDURE())
declare @ErrorMessage varchar(max) = (select ERROR_MESSAGE())

exec log.ErrorCall @ErrorNumber,@ErrorState,@ErrorSeverity,@ErrorLine, @ErrorProcedure,@ErrorMessage


END CATCH

