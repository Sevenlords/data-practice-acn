CREATE TABLE [STG].[Production_ProductCategory] (
    [ModifiedDate]      DATETIME      NULL,
    [ProductCategoryID] INT           NULL,
    [Name]              NVARCHAR (50) NULL,
    [timeshtamp]        DATETIME      DEFAULT (getdate()) NULL
);

