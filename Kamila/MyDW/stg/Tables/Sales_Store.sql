CREATE TABLE [stg].[Sales_Store] (
    [rowguid]          UNIQUEIDENTIFIER NULL,
    [ModifiedDate]     DATETIME         NULL,
    [BusinessEntityID] INT              NULL,
    [Name]             NVARCHAR (50)    NULL,
    [SalesPersonID]    INT              NULL,
    [Demographics]     NVARCHAR (MAX)   NULL,
    [Timestamp]        DATETIME         DEFAULT (getdate()) NULL
);

