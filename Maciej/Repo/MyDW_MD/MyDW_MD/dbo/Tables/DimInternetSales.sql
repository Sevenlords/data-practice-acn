﻿CREATE TABLE [dbo].[DimInternetSales] (
    [SalesOrderID]         INT           NOT NULL,
    [SalesOrderNumber]     NVARCHAR (25) NOT NULL,
    [SalesOrderDetailID]   INT           NOT NULL,
    [DateKey]              INT           NOT NULL,
    [CustomerKey]          INT           NOT NULL,
    [ProductKey]           INT           NOT NULL,
    [CurrencyKey]          INT           NOT NULL,
    [OrderQuantity]        SMALLINT      NOT NULL,
    [UnitPrice]            MONEY         NOT NULL,
    [ExtendedAmount]       INT           NOT NULL,
    [UnitPriceDiscountPct] MONEY         NOT NULL,
    [DiscountAmount]       INT           NOT NULL,
    [ProductStandardCost]  INT           NOT NULL,
    [TotalProductCost]     INT           NOT NULL,
    [SalesAmount]          INT           NOT NULL,
    [CreatedDate]          DATETIME      DEFAULT (getdate()) NULL,
    [ModifiedDate]         DATETIME      NULL
);
