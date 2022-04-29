﻿CREATE TABLE [STG].[Sales_SalesOrderHeader] (
    [rowguid]                UNIQUEIDENTIFIER NULL,
    [ModifiedDate]           DATETIME         NULL,
    [SalesOrderID]           INT              NULL,
    [RevisionNumber]         TINYINT          NULL,
    [OrderDate]              DATETIME         NULL,
    [DueDate]                DATETIME         NULL,
    [ShipDate]               DATETIME         NULL,
    [Status]                 TINYINT          NULL,
    [OnlineOrderFlag]        BIT              NULL,
    [SalesOrderNumber]       NVARCHAR (25)    NULL,
    [PurchaseOrderNumber]    NVARCHAR (25)    NULL,
    [AccountNumber]          NVARCHAR (15)    NULL,
    [CustomerID]             INT              NULL,
    [SalesPersonID]          INT              NULL,
    [TerritoryID]            INT              NULL,
    [BillToAddressID]        INT              NULL,
    [ShipToAddressID]        INT              NULL,
    [ShipMethodID]           INT              NULL,
    [CreditCardID]           INT              NULL,
    [CreditCardApprovalCode] VARCHAR (15)     NULL,
    [CurrencyRateID]         INT              NULL,
    [SubTotal]               MONEY            NULL,
    [TaxAmt]                 MONEY            NULL,
    [Freight]                MONEY            NULL,
    [TotalDue]               MONEY            NULL,
    [Comment]                NVARCHAR (128)   NULL,
    [timeshtamp]             DATETIME         DEFAULT (getdate()) NULL
);

