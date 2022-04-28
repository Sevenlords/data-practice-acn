﻿CREATE TABLE [stg].[person_BusinessEntityAddress] (
    [rowguid]          UNIQUEIDENTIFIER NULL,
    [ModifiedDate]     DATETIME         NULL,
    [BusinessEntityID] INT              NULL,
    [AddressID]        INT              NULL,
    [AddressTypeID]    INT              NULL,
    [timeshtamp]       DATETIME         DEFAULT (getdate()) NULL
);

