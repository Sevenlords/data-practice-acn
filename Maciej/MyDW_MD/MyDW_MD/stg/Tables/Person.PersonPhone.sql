CREATE TABLE [stg].[Person.PersonPhone] (
    [ModifiedDate]      DATETIME      NULL,
    [BusinessEntityID]  INT           NULL,
    [PhoneNumber]       NVARCHAR (25) NULL,
    [PhoneNumberTypeID] INT           NULL,
    [timestamp]         DATETIME      DEFAULT (getdate()) NULL
);

