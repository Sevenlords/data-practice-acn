CREATE TABLE [stg].[product_model] (
    [ProductModelID]     INT            NULL,
    [Name]               NVARCHAR (50)  NULL,
    [CatalogDescription] NVARCHAR (MAX) NULL,
    [Instructions]       NVARCHAR (MAX) NULL,
    [ModifiedDate]       DATETIME       NULL,
    [Timestamp]          DATETIME       DEFAULT (getdate()) NULL
);

