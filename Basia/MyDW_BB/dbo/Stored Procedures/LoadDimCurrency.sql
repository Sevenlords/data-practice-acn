create procedure [dbo].[LoadDimCurrency]
as

insert into myDW.dbo.DimCurrency
(	[CurrencyCode],
	[Name],
	[SourceModifiedDate],
	[ModifiedDate]
)
select CurrencyCode, Name, ModifiedDate, getdate() from AdventureWorks2017.Sales.Currency