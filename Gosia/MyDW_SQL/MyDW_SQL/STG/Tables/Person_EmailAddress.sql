﻿CREATE TABLE [STG].[Person_EmailAddress] (
    [BusinessEntityID] INT           NULL,
    [ModifiedDate]     DATETIME      NULL,
    [EmailAddressID]   INT           NULL,
    [EmailAddress]     NVARCHAR (50) NULL,
    [timeshtamp]       DATETIME      DEFAULT (getdate()) NULL
);

