CREATE TABLE [dbo].[DimCurrency] (
    [CurrencyKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CurrencyAlternateKey] NVARCHAR (3)  NOT NULL,
    [CurrencyName]         NVARCHAR (50) NOT NULL,
    [SourceModifiedDate]   DATETIME      NOT NULL,
    [Timeshtamp]           DATETIME      DEFAULT (getdate()) NULL
);

