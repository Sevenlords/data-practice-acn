CREATE procedure [dbo].[LoadDimCurrency]
as

exec [log].[ProcedureCall] @ProcedureID = @@procid ,@Step = 1, @Comment ='Start proc'

truncate table dbo.DimCurrency

insert into dbo.DimCurrency
([CurrencyAlternateKey]
      ,[CurrencyName]
      ,[SourceModifiedDate])

SELECT   
	CurrencyCode as [CurrencyAlternateKey],
	Name as [CurrencyName],
	ModifiedDate as [SourceModifiedDate]
	from [AdventureWorks2017].[Sales].[Currency]

	exec [log].[ProcedureCall] @ProcedureID = @@procid ,@Step = 999, @Comment ='End proc'