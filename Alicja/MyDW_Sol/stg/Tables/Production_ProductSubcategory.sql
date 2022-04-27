CREATE TABLE [stg].[Production_ProductSubcategory] (
    [Name]                 NVARCHAR (50)    NULL,
    [ProductSubcategoryID] INT              NULL,
    [rowguid]              UNIQUEIDENTIFIER NULL,
    [ModifiedDate]         DATETIME         NULL,
    [ProductCategoryID]    INT              NULL,
    [Timestamp]            DATETIME         DEFAULT (getdate()) NULL
);

