CREATE TABLE [stg].[Production_ProductModel] (
    [rowguid]            UNIQUEIDENTIFIER NULL,
    [ModifiedDate]       DATETIME         NULL,
    [Name]               NVARCHAR (50)    NULL,
    [ProductModelID]     INT              NULL,
    [CatalogDescription] NVARCHAR (MAX)   NULL,
    [Instructions]       NVARCHAR (MAX)   NULL,
    [Timeptamp]          DATETIME         DEFAULT (getdate()) NULL
);

