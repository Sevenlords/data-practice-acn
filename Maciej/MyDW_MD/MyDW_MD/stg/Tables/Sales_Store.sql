CREATE TABLE [stg].[Sales_Store] (
    [ModifiedDate]     DATETIME         NULL,
    [BusinessEntityID] INT              NULL,
    [rowguid]          UNIQUEIDENTIFIER NULL,
    [Name]             NVARCHAR (50)    NULL,
    [SalesPersonID]    INT              NULL,
    [Demographics]     NVARCHAR (MAX)   NULL,
    [timestamp]        DATETIME         DEFAULT (getdate()) NULL
);

