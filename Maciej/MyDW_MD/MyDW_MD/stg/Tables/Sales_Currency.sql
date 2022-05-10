CREATE TABLE [stg].[Sales_Currency] (
    [ModifiedDate] DATETIME      NULL,
    [CurrencyCode] NVARCHAR (3)  NULL,
    [Name]         NVARCHAR (50) NULL,
    [timestamp]    DATETIME      DEFAULT (getdate()) NULL
);

