CREATE TABLE [stg].[Production_ProductSubcategory] (
    [Name]                 NVARCHAR (50)    NULL,
    [rowguid]              UNIQUEIDENTIFIER NULL,
    [ModifiedDate]         DATETIME         NULL,
    [ProductSubcategoryID] INT              NULL,
    [ProductCategoryID]    INT              NULL,
    [timeshtamp]           DATETIME         DEFAULT (getdate()) NULL
);

