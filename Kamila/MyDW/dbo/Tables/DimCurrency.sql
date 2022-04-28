CREATE TABLE [dbo].[DimCurrency] (
    [CurrencyKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CurrencyAlternateKey] NVARCHAR (3)  NULL,
    [CurrencyName]         NVARCHAR (50) NULL,
    [SourceModifiedDate]   DATETIME      NULL,
    [CreatedDate]          DATETIME      NULL,
    [ModifiedDate]         DATETIME      NULL
);

