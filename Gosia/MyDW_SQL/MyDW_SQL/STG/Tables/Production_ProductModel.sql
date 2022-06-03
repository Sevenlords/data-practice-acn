CREATE TABLE [STG].[Production_ProductModel] (
    [ModifiedDate]       DATETIME       NULL,
    [ProductModelID]     INT            NULL,
    [Name]               NVARCHAR (50)  NULL,
    [CatalogDescription] NVARCHAR (MAX) NULL,
    [Instructions]       NVARCHAR (MAX) NULL,
    [timeshtamp]         DATETIME       DEFAULT (getdate()) NULL
);

