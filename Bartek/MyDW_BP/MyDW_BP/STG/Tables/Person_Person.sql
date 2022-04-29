﻿CREATE TABLE [STG].[Person_Person] (
    [BusinessEntityID]      INT            NULL,
    [PersonType]            NVARCHAR (2)   NULL,
    [NameStyle]             BIT            NULL,
    [Title]                 NVARCHAR (8)   NULL,
    [FirstName]             NVARCHAR (50)  NULL,
    [MiddleName]            NVARCHAR (50)  NULL,
    [LastName]              NVARCHAR (50)  NULL,
    [Suffix]                NVARCHAR (10)  NULL,
    [EmailPromotion]        INT            NULL,
    [AdditionalContactInfo] NVARCHAR (MAX) NULL,
    [Demographics]          NVARCHAR (MAX) NULL,
    [ModifiedDate]          DATETIME       NULL,
    [Time_Stamp]            DATE           CONSTRAINT [DF_Time_Stamp_Person_Person] DEFAULT (getdate()) NULL
);

