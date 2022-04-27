CREATE TABLE [stg].[Production_ProductModel] (
    [Name]               NVARCHAR (50)    NULL,
    [ProductModelID]     INT              NULL,
    [rowguid]            UNIQUEIDENTIFIER NULL,
    [ModifiedDate]       DATETIME         NULL,
    [CatalogDescription] NVARCHAR (MAX)   NULL,
    [Instructions]       NVARCHAR (MAX)   NULL,
    [Timestamp]          DATETIME         DEFAULT (getdate()) NULL
);

