CREATE TABLE [stg].[Production_ProductCategory] (
    [rowguid]           UNIQUEIDENTIFIER NULL,
    [ModifiedDate]      DATETIME         NULL,
    [Name]              NVARCHAR (50)    NULL,
    [ProductCategoryID] INT              NULL,
    [Timestamp]         DATETIME         DEFAULT (getdate()) NULL
);

