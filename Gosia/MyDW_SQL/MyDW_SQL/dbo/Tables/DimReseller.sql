CREATE TABLE [dbo].[DimReseller] (
    [ResellerKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]           INT           NULL,
    [ResellerAlternateKey] VARCHAR (10)  NULL,
    [ResellerName]         NVARCHAR (50) NULL,
    [CreatedDate]          DATETIME      NULL,
    [ModifiedDate]         DATETIME      NULL
);

