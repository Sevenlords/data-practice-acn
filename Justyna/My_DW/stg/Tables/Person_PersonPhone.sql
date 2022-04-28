CREATE TABLE [stg].[Person_PersonPhone] (
    [ModifiedDate]      DATETIME      NULL,
    [BusinessEntityID]  INT           NULL,
    [PhoneNumber]       NVARCHAR (25) NULL,
    [PhoneNumberTypeID] INT           NULL,
    [Timestamp]         DATETIME      DEFAULT (getdate()) NULL
);

