CREATE TABLE [dw].[dim_reseller] (
    [ResellerKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]           INT           NOT NULL,
    [ResellerAlternateKey] VARCHAR (10)  NOT NULL,
    [ResellerName]         NVARCHAR (50) NOT NULL,
    [CreatedDate]          DATETIME      DEFAULT (getdate()) NULL,
    [ModifiedDate]         DATETIME      DEFAULT (getdate()) NULL
);

