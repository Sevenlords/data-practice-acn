CREATE TABLE [stg].[product_manufactory] (
    [ProductID]           NVARCHAR (255) NULL,
    [ProductAlternateKey] NVARCHAR (255) NULL,
    [ManufactoryId]       NVARCHAR (255) NULL,
    [DateFrom]            NVARCHAR (255) NULL,
    [DateTo]              NVARCHAR (255) NULL,
    [timestamp]           DATETIME       DEFAULT (getdate()) NULL
);

