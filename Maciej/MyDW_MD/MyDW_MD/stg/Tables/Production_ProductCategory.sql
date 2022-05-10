CREATE TABLE [stg].[Production_ProductCategory] (
    [ModifiedDate]      DATETIME      NULL,
    [Name]              NVARCHAR (50) NULL,
    [ProductCategoryID] INT           NULL,
    [timestamp]         DATETIME      DEFAULT (getdate()) NULL
);

