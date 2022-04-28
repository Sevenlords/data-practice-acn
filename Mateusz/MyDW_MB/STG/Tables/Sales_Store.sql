CREATE TABLE [STG].[Sales_Store] (
    [Name]             NVARCHAR (50)    NULL,
    [rowguid]          UNIQUEIDENTIFIER NULL,
    [ModifiedDate]     DATETIME         NULL,
    [BusinessEntityID] INT              NULL,
    [SalesPersonID]    INT              NULL,
    [Demographics]     NVARCHAR (MAX)   NULL,
    [timeshtamp]       DATETIME         DEFAULT (getdate()) NULL
);

