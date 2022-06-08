CREATE TABLE [STG].[Production_ProductSubcategoryn] (
    [ModifiedDate]         DATETIME      NULL,
    [ProductSubcategoryID] INT           NULL,
    [ProductCategoryID]    INT           NULL,
    [Name]                 NVARCHAR (50) NULL,
    [timeshtamp]           DATETIME      DEFAULT (getdate()) NULL
);

