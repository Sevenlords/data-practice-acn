CREATE TABLE [STG].[Person_PersonPhone] (
    [BusinessEntityID]  INT           NULL,
    [PhoneNumber]       NVARCHAR (25) NULL,
    [PhoneNumberTypeID] INT           NULL,
    [ModifiedDate]      DATETIME      NULL,
    [Time_Stamp]        DATETIME      CONSTRAINT [DF_Time_Stamp_Person_PersonPhone] DEFAULT (getdate()) NULL
);

