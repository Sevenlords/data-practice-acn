CREATE TABLE [dw].[dim_currency] (
    [CurrencyKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CurrencyAlternateKey] NVARCHAR (3)  NULL,
    [CurrencyName]         NVARCHAR (50) NULL,
    [SourceModifiedDate]   DATETIME      NULL,
    [Timestamp]            DATETIME      DEFAULT (getdate()) NULL
);

