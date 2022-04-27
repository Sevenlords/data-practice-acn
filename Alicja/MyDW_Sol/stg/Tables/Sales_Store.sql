CREATE TABLE [stg].[Sales_Store] (
    [rowguid]          UNIQUEIDENTIFIER NULL,
    [ModifiedDate]     DATETIME         NULL,
    [BusinessEntityID] INT              NULL,
    [Demographics]     NVARCHAR (MAX)   NULL,
    [Name]             NVARCHAR (50)    NULL,
    [SalesPersonID]    INT              NULL,
    [Timestamp]        DATETIME         DEFAULT (getdate()) NULL
);

