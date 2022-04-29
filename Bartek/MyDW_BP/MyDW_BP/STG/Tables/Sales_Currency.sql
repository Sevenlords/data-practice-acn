CREATE TABLE [STG].[Sales_Currency] (
    [CurrencyCode] NVARCHAR (3)  NULL,
    [Name]         NVARCHAR (50) NULL,
    [ModifiedDate] DATETIME      NULL,
    [Time_Stamp]   DATETIME      CONSTRAINT [DF_Time_Stamp_Production_Sales_Currency] DEFAULT (getdate()) NULL
);

