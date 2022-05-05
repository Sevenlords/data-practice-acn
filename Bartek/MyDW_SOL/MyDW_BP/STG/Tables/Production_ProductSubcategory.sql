CREATE TABLE [STG].[Production_ProductSubcategory] (
    [ProductSubcategoryID] INT           NULL,
    [ProductCategoryID]    INT           NULL,
    [Name]                 NVARCHAR (50) NULL,
    [ModifiedDate]         DATETIME      NULL,
    [Time_Stamp]           DATE          CONSTRAINT [DF_Time_Stamp_Production_ProductSubcategory] DEFAULT (getdate()) NULL
);

