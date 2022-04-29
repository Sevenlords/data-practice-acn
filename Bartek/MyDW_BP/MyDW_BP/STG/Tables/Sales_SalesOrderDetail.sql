CREATE TABLE [STG].[Sales_SalesOrderDetail] (
    [SalesOrderID]          INT             NULL,
    [SalesOrderDetailID]    INT             NULL,
    [CarrierTrackingNumber] NVARCHAR (25)   NULL,
    [OrderQty]              SMALLINT        NULL,
    [ProductID]             INT             NULL,
    [SpecialOfferID]        INT             NULL,
    [UnitPrice]             MONEY           NULL,
    [UnitPriceDiscount]     MONEY           NULL,
    [LineTotal]             NUMERIC (38, 6) NULL,
    [ModifiedDate]          DATETIME        NULL,
    [Time_Stamp]            DATETIME        CONSTRAINT [DF_Time_Stamp_Sales_SalesOrderDetail] DEFAULT (getdate()) NULL
);

