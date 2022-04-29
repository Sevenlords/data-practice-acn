CREATE TABLE [dbo].[DimReseller] (
    [ResellerKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]           INT           NOT NULL,
    [ResellerAlternateKey] NVARCHAR (10) NOT NULL,
    [ResellerName]         NVARCHAR (50) NOT NULL,
    [Timeshtamp]           DATETIME      DEFAULT (getdate()) NULL
);

