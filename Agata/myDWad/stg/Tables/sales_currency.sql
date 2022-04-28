CREATE TABLE [stg].[sales_currency] (
    [Name]         NVARCHAR (50) NULL,
    [ModifiedDate] DATETIME      NULL,
    [CurrencyCode] NVARCHAR (3)  NULL,
    [timeshtamp]   DATETIME      DEFAULT (getdate()) NULL
);

