CREATE TABLE [stg].[Sales_Currency] (
    [ModifiedDate] DATETIME      NULL,
    [Name]         NVARCHAR (50) NULL,
    [CurrencyCode] NVARCHAR (3)  NULL,
    [Timestamp]    DATETIME      DEFAULT (getdate()) NULL
);

