CREATE TABLE [STG].[Production_ProductCategory] (
    [ProductCategoryID] INT           NULL,
    [Name]              NVARCHAR (50) NULL,
    [ModifiedDate]      DATETIME      NULL,
    [Time_Stamp]        DATETIME      CONSTRAINT [DF_Time_Stamp_Production_ProductCategory] DEFAULT (getdate()) NULL
);

