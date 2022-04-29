﻿CREATE TABLE [STG].[Production_Product] (
    [ProductID]             INT            NULL,
    [Name]                  NVARCHAR (50)  NULL,
    [ProductNumber]         NVARCHAR (25)  NULL,
    [MakeFlag]              BIT            NULL,
    [FinishedGoodsFlag]     BIT            NULL,
    [Color]                 NVARCHAR (15)  NULL,
    [SafetyStockLevel]      SMALLINT       NULL,
    [ReorderPoint]          SMALLINT       NULL,
    [StandardCost]          MONEY          NULL,
    [ListPrice]             MONEY          NULL,
    [Size]                  NVARCHAR (5)   NULL,
    [SizeUnitMeasureCode]   NVARCHAR (3)   NULL,
    [WeightUnitMeasureCode] NVARCHAR (3)   NULL,
    [Weight]                NUMERIC (8, 2) NULL,
    [DaysToManufacture]     INT            NULL,
    [ProductLine]           NVARCHAR (2)   NULL,
    [Class]                 NVARCHAR (2)   NULL,
    [Style]                 NVARCHAR (2)   NULL,
    [ProductSubcategoryID]  INT            NULL,
    [ProductModelID]        INT            NULL,
    [SellStartDate]         DATETIME       NULL,
    [SellEndDate]           DATETIME       NULL,
    [DiscontinuedDate]      DATETIME       NULL,
    [ModifiedDate]          DATETIME       NULL,
    [Time_Stamp]            DATE           CONSTRAINT [DF_Time_Stamp_Production_Product] DEFAULT (getdate()) NULL
);

