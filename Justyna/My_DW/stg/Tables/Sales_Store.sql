CREATE TABLE [stg].[Sales_Store] (
    [rowguid]          UNIQUEIDENTIFIER NULL,
    [ModifiedDate]     DATETIME         NULL,
    [Name]             NVARCHAR (50)    NULL,
    [BusinessEntityID] INT              NULL,
    [SalesPersonID]    INT              NULL,
    [Demographics]     NVARCHAR (MAX)   NULL,
    [Timestamp]        DATETIME         DEFAULT (getdate()) NULL
);

