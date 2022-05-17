create procedure [dbo].[LoadDimCurrency]
as

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