﻿CREATE TABLE [dbo].[DimProduct] (
    [ProductKey]             INT            IDENTITY (1, 1) NOT NULL,
    [ProductID]              INT            NOT NULL,
    [ProductName]            NVARCHAR (50)  NOT NULL,
    [ProductAlternateKey]    VARCHAR (25)   NOT NULL,
    [StandardCost]           MONEY          NOT NULL,
    [FinishedGoodFlag]       BIT            NOT NULL,
    [Color]                  NVARCHAR (15)  NOT NULL,
    [ListPrice]              MONEY          NOT NULL,
    [Size]                   NVARCHAR (5)   NOT NULL,
    [SizeUnitMeasureCode]    NVARCHAR (3)   NULL,
    [Weight]                 NUMERIC (8, 2) NULL,
    [WeightUnitMeasureCode]  NVARCHAR (3)   NOT NULL,
    [DaysToManufacture]      INT            NOT NULL,
    [ProductLine]            NVARCHAR (3)   NULL,
    [Class]                  NVARCHAR (3)   NULL,
    [Style]                  NVARCHAR (3)   NULL,
    [ProductCategoryID]      INT            NOT NULL,
    [ProductCategoryName]    NVARCHAR (50)  NOT NULL,
    [ProductSubcategoryID]   INT            NOT NULL,
    [ProductSubcategoryName] NVARCHAR (50)  NOT NULL,
    [ProductModelID]         INT            NOT NULL,
    [ProductModelName]       NVARCHAR (50)  NOT NULL,
    [SellStartDate]          DATETIME       NOT NULL,
    [SellEndDate]            DATETIME       NOT NULL,
    [SoureceModifiedDate]    DATETIME       NOT NULL,
    [Timeshtamp]             DATETIME       DEFAULT (getdate()) NULL
);

