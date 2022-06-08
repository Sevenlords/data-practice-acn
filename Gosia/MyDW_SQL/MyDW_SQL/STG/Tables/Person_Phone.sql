CREATE TABLE [STG].[Person_Phone] (
    [ModifiedDate]      DATETIME      NULL,
    [BusinessEntityID]  INT           NULL,
    [PhoneNumber]       NVARCHAR (25) NULL,
    [PhoneNumberTypeID] INT           NULL,
    [timeshtamp]        DATETIME      DEFAULT (getdate()) NULL
);

