CREATE TABLE [stg].[prod_manu_v1] (
    [ProductID]           NVARCHAR (255) NULL,
    [ProductAlternateKey] NVARCHAR (255) NULL,
    [ManufactoryId]       NVARCHAR (255) NULL,
    [DateFrom]            NVARCHAR (255) NULL,
    [DateTo]              NVARCHAR (255) NULL,
    [Timestamp]           DATETIME       DEFAULT (getdate()) NULL
);

