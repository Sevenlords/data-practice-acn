CREATE TABLE [stg].[prod_prod_category] (
    [ProductCategoryID] INT              NULL,
    [Name]              NVARCHAR (50)    NULL,
    [rowguid]           UNIQUEIDENTIFIER NULL,
    [ModifiedDate]      DATETIME         NULL,
    [Timestamp]         DATETIME         DEFAULT (getdate()) NULL
);

