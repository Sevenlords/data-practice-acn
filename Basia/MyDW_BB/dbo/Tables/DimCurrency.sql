CREATE TABLE [dbo].[DimCurrency] (
    [CurrencyKey]        INT           IDENTITY (1, 1) NOT NULL,
    [CurrencyCode]       NVARCHAR (3)  NOT NULL,
    [Name]               NVARCHAR (50) NULL,
    [SourceModifiedDate] DATETIME      NULL,
    [CreatedDate]        DATETIME      DEFAULT (getdate()) NULL
);



