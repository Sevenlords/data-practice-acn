﻿CREATE TABLE [dbo].[DimProduct] (
    [ProductKey]             INT            IDENTITY (1, 1) NOT NULL,
    [ProductID]              INT            NOT NULL,
    [ProductName]            NVARCHAR (50)  NOT NULL,
    [ProductAlternateKey]    NVARCHAR (25)  NOT NULL,
    [StandartCost]           MONEY          NOT NULL,
    [FinishedGoodFlag]       BIT            NOT NULL,
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
    [ProductCategoryID]      INT            NULL,
    [ProductCategoryName]    NVARCHAR (50)  NOT NULL,
    [ProductSubcategoryID]   INT            NULL,
    [ProductSubcategoryName] NVARCHAR (50)  NOT NULL,
    [ProductModelID]         INT            NULL,
    [ProductModelName]       NVARCHAR (50)  NOT NULL,
    [SellStartDate]          DATETIME       NOT NULL,
    [SellEndDate]            DATETIME       NULL,
    [SourceModifiedDate]     DATETIME       NOT NULL,
    [Timeshtamp]             DATETIME       DEFAULT (getdate()) NULL
);

