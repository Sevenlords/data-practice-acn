CREATE TABLE [dbo].[dimCurrency] (
    [CurrencyKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CurrencyName]         NVARCHAR (50) NULL,
    [CurrencyALternateKey] NVARCHAR (3)  NULL,
    [SourceModifiedDate]   DATETIME      NULL,
    [timeshtamp]           DATETIME      DEFAULT (getdate()) NULL
);

