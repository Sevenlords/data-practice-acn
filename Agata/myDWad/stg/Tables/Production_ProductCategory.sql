CREATE TABLE [stg].[Production_ProductCategory] (
    [Name]              NVARCHAR (50)    NULL,
    [rowguid]           UNIQUEIDENTIFIER NULL,
    [ModifiedDate]      DATETIME         NULL,
    [ProductCategoryID] INT              NULL,
    [timeshtamp]        DATETIME         DEFAULT (getdate()) NULL
);

