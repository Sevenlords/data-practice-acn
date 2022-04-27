CREATE TABLE [dbo].[DimReseller] (
    [ResellerKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]           INT           NULL,
    [ResellerAlternateKey] NVARCHAR (25) NULL,
    [ResellerName]         NVARCHAR (50) NULL,
    [CreatedDate]          DATETIME      NULL,
    [ModifiedDate]         DATETIME      NULL
);

