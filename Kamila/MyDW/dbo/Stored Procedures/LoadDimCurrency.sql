

CREATE PROCEDURE [dbo].[LoadDimCurrency]
as

truncate table dbo.DimCurrency

INSERT INTO dbo.DimCurrency
(
	[CurrencyAlternateKey],
	[CurrencyName],
	[SourceModifiedDate],
	[CreatedDate],
	[ModifiedDate]
)


SELECT
	SC.CurrencyCode AS [CurrencyAlternateKey],
	SC.Name AS [CurrencyName],
	SC.ModifiedDate AS [SourceModifiedDate],
	GETDATE() as [CreatedDate],
	SC.Timestamp as [ModifiedDate]

FROM stg.Sales_Currency AS SC

