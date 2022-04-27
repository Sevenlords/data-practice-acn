CREATE TABLE [stg].[Production_ProductSubcategory] (
    [rowguid]              UNIQUEIDENTIFIER NULL,
    [ModifiedDate]         DATETIME         NULL,
    [Name]                 NVARCHAR (50)    NULL,
    [ProductSubcategoryID] INT              NULL,
    [ProductCategoryID]    INT              NULL,
    [Timestamp]            DATETIME         DEFAULT (getdate()) NULL
);

