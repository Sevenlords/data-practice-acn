CREATE TABLE [STG].[Sales_SalesOrderDetail] (
    [ProductID]             INT              NULL,
    [rowguid]               UNIQUEIDENTIFIER NULL,
    [ModifiedDate]          DATETIME         NULL,
    [SalesOrderID]          INT              NULL,
    [SalesOrderDetailID]    INT              NULL,
    [CarrierTrackingNumber] NVARCHAR (25)    NULL,
    [OrderQty]              SMALLINT         NULL,
    [SpecialOfferID]        INT              NULL,
    [UnitPrice]             MONEY            NULL,
    [UnitPriceDiscount]     MONEY            NULL,
    [LineTotal]             NUMERIC (38, 6)  NULL,
    [timeshtamp]            DATETIME         DEFAULT (getdate()) NULL
);

