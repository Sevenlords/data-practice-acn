CREATE procedure [dbo].[LoadDimCurrency]
as

truncate table dbo.DimCurrency

INSERT INTO [dbo].[DimCurrency]
           (CurrencyAlternateKey,
			CurrencyName,
			SourceModifiedDate)

			select [CurrencyCode],[Name],[ModifiedDate]from STG.Sales_Currency