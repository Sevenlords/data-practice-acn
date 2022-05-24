CREATE TABLE [dbo].[DimProduct] (
    [ProductKey]             INT            IDENTITY (1, 1) NOT NULL,
    [ProductID]              INT            NULL,
    [ProductName]            NVARCHAR (50)  NULL,
    [ProductAlternateKey]    NVARCHAR (25)  NULL,
    [StandardCost]           MONEY          NULL,
    [FinishedGoodsFlag]      BIT            NULL,
    [Color]                  NVARCHAR (15)  NULL,
    [ListPrice]              MONEY          NULL,
    [Size]                   NVARCHAR (5)   NULL,
    [SizeUnitMeasureCode]    NVARCHAR (3)   NULL,
    [Weight]                 DECIMAL (8, 2) NULL,
    [WeightUnitMeasureCode]  NVARCHAR (3)   NULL,
    [DaysToManufacture]      INT            NULL,
    [ProductLine]            NVARCHAR (3)   NULL,
    [Class]                  NVARCHAR (3)   NULL,
    [Style]                  NVARCHAR (3)   NULL,
    [ProductCategoryID]      INT            NULL,
    [ProductCategoryName]    NVARCHAR (50)  NULL,
    [ProductSubcategoryID]   INT            NULL,
    [ProductSubcategoryName] NVARCHAR (50)  NULL,
    [ProductModelID]         INT            NULL,
    [ProductModelName]       NVARCHAR (50)  NULL,
    [SellStartDate]          DATETIME       NULL,
    [SellEndDate]            DATETIME       NULL,
    [SourceModifiedDate]     DATETIME       NULL,
    [CreatedDate]            DATETIME       DEFAULT (getdate()) NULL,
    [ModifiedDate]           DATETIME       NULL
);









