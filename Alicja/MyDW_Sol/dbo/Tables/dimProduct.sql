CREATE TABLE [dbo].[dimProduct] (
    [ProductKey]             INT            IDENTITY (1, 1) NOT NULL,
    [ProductID]              INT            NOT NULL,
    [ProductName]            NVARCHAR (50)  NOT NULL,
    [ProductAlternateKey]    NVARCHAR (25)  NOT NULL,
    [StandardCost]           MONEY          NOT NULL,
    [FinishedGoodsFlag]      BIT            NOT NULL,
    [Color]                  NVARCHAR (15)  NOT NULL,
    [ListPrice]              MONEY          NOT NULL,
    [Size]                   NVARCHAR (5)   NOT NULL,
    [SizeUnitMeasureCode]    NCHAR (3)      NOT NULL,
    [Weight]                 DECIMAL (8, 2) NULL,
    [WeightUnitMeasureCode]  NCHAR (3)      NOT NULL,
    [DaysToManufacture]      INT            NOT NULL,
    [ProductLine]            NCHAR (3)      NOT NULL,
    [Class]                  NCHAR (3)      NOT NULL,
    [Style]                  NCHAR (3)      NOT NULL,
    [ProductCategoryID]      INT            NOT NULL,
    [ProductCategoryName]    NVARCHAR (50)  NOT NULL,
    [ProductSubCategoryID]   INT            NOT NULL,
    [ProductSubCategoryName] NVARCHAR (50)  NOT NULL,
    [ProductModelID]         INT            NOT NULL,
    [ProductModelName]       NVARCHAR (50)  NOT NULL,
    [SellStartDate]          DATETIME       NOT NULL,
    [SellEndDate]            DATETIME       NOT NULL,
    [SourceModifiedDate]     DATETIME       NOT NULL,
    [CreatedDate]            DATETIME       DEFAULT (getdate()) NULL,
    [ModifiedDate]           DATETIME       NULL,
    [ManufactoryId]          INT            NULL,
    [ManufactoryName]        NVARCHAR (255) NULL,
    [DateFrom]               DATE           NULL,
    [DateTo]                 DATE           NULL,
    [CurrentRowIndicator]    NVARCHAR (20)  NULL
);





