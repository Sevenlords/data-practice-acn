CREATE TABLE [STG].[Sales_Currency] (
    [ModifiedDate] DATETIME      NULL,
    [Name]         NVARCHAR (50) NULL,
    [CurrencyCode] NVARCHAR (3)  NULL,
    [timeshtamp]   DATETIME      DEFAULT (getdate()) NULL
);

