CREATE TABLE [stg].[sales_store] (
    [BusinessEntityID] INT            NULL,
    [Demographics]     NVARCHAR (MAX) NULL,
    [ModifiedDate]     DATETIME       NULL,
    [Name]             NVARCHAR (50)  NULL,
    [SalesPersonID]    INT            NULL,
    [Timestamp]        DATETIME       DEFAULT (getdate()) NULL
);

