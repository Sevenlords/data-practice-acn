CREATE TABLE [stg].[sales_currency_rate] (
    [ModifiedDate]     DATETIME     NULL,
    [CurrencyRateID]   INT          NULL,
    [CurrencyRateDate] DATETIME     NULL,
    [FromCurrencyCode] NVARCHAR (3) NULL,
    [ToCurrencyCode]   NVARCHAR (3) NULL,
    [AverageRate]      MONEY        NULL,
    [EndOfDayRate]     MONEY        NULL,
    [BusinessEntityID] INT          NULL,
    [AddressID]        INT          NULL,
    [AddressTypeID]    INT          NULL,
    [timestamp]        DATETIME     DEFAULT (getdate()) NULL
);

