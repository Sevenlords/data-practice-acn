CREATE TABLE [dw].[dim_currency_new] (
    [CurrencyKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CurrencyRateID]       INT           NOT NULL,
    [CurrencyAlternateKey] NVARCHAR (3)  NULL,
    [CurrencyName]         NVARCHAR (50) NULL,
    [AverageRate]          MONEY         NULL,
    [EndOfDayRate]         MONEY         NULL,
    [SourceModifiedDate]   DATETIME      NULL,
    [Timestamp]            DATETIME      DEFAULT (getdate()) NULL
);

