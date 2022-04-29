CREATE TABLE [STG].[Production_ProductModel] (
    [ProductModelID]     INT            NULL,
    [Name]               NVARCHAR (50)  NULL,
    [CatalogDescription] NVARCHAR (MAX) NULL,
    [Instructions]       NVARCHAR (MAX) NULL,
    [ModifiedDate]       DATETIME       NULL,
    [Time_Stamp]         DATETIME       CONSTRAINT [DF_Time_Stamp_Production_ProductModel] DEFAULT (getdate()) NULL
);

