CREATE TABLE [dbo].[DimReseller] (
    [ResellerKey]   INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]    INT           NOT NULL,
    [AccountNumber] VARCHAR (10)  NULL,
    [ResellerName]  NVARCHAR (50) NULL,
    [CreatedDate]   DATETIME      DEFAULT (getdate()) NULL,
    [ModifiedDate]  DATETIME      NULL
);

