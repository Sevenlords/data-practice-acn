CREATE TABLE [STG].[Sales_Currency] (
    [Name]         NVARCHAR (50) NULL,
    [ModifiedDate] DATETIME      NULL,
    [CurrencyCode] NVARCHAR (3)  NULL,
    [timeshtamp]   DATETIME      DEFAULT (getdate()) NULL
);

