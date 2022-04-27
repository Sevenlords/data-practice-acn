CREATE TABLE [stg].[prod_prod_subcategory] (
    [ProductSubcategoryID] INT              NULL,
    [ProductCategoryID]    INT              NULL,
    [Name]                 NVARCHAR (50)    NULL,
    [rowguid]              UNIQUEIDENTIFIER NULL,
    [ModifiedDate]         DATETIME         NULL,
    [Timestamp]            DATETIME         DEFAULT (getdate()) NULL
);

