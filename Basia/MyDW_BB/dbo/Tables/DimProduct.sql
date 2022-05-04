CREATE TABLE [dbo].[DimProduct] (
    [ProductKey]             INT            IDENTITY (1, 1) NOT NULL,
    [ProductID]              INT            NULL,
    [Name]                   NVARCHAR (50)  NULL,
    [ProductNumber]          NVARCHAR (25)  NULL,
    [FinishedGoodsFlag]      BIT            NULL,
    [Color]                  NVARCHAR (15)  NULL,
    [ListPrice]              MONEY          NULL,
    [Size]                   NVARCHAR (5)   NULL,
    [SizeUnitMeasureCode]    NVARCHAR (3)   NULL,
    [Weight]                 NUMERIC (8, 2) NULL,
    [WeightUnitMeasureCode]  NVARCHAR (3)   NULL,
    [DaysToManufacture]      INT            NULL,
    [ProductLine]            NVARCHAR (2)   NULL,
    [Class]                  NVARCHAR (2)   NULL,
    [Style]                  NVARCHAR (2)   NULL,
    [ProductCategoryID]      INT            NULL,
    [ProductCategoryName]    NVARCHAR (50)  NULL,
    [ProductSubcategoryID]   INT            NULL,
    [ProductSubcategoryName] NVARCHAR (50)  NULL,
    [ProductModelID]         INT            NULL,
    [ProductModelName]       NVARCHAR (50)  NULL,
    [SellStartDate]          DATETIME       NULL,
    [SellEndDate]            DATETIME       NULL,
    [CreatedDate]            DATETIME       DEFAULT (getdate()) NULL
);



