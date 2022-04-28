CREATE TABLE [stg].[sales_currency] (
    [ModifiedDate] DATETIME      NULL,
    [CurrencyCode] NVARCHAR (3)  NULL,
    [Name]         NVARCHAR (50) NULL,
    [Timestamp]    DATETIME      DEFAULT (getdate()) NULL
);

