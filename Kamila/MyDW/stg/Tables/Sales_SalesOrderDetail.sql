CREATE TABLE [stg].[Sales_SalesOrderDetail] (
    [rowguid]               UNIQUEIDENTIFIER NULL,
    [ModifiedDate]          DATETIME         NULL,
    [SalesOrderID]          INT              NULL,
    [SalesOrderDetailID]    INT              NULL,
    [CarrierTrackingNumber] NVARCHAR (25)    NULL,
    [OrderQty]              SMALLINT         NULL,
    [ProductID]             INT              NULL,
    [SpecialOfferID]        INT              NULL,
    [UnitPrice]             MONEY            NULL,
    [UnitPriceDiscount]     MONEY            NULL,
    [LineTotal]             NUMERIC (38, 6)  NULL,
    [Timestamp]             DATETIME         DEFAULT (getdate()) NULL
);

